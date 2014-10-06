//
//  MineCreateTransactionLocation'ViewController.m
//  Mine
//
//  Created by Zhi Li on 7/29/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineCreateTransactionLocationViewController.h"
#import "UIView+FindFirstResponder.h"
#import "MKMapView+Mine.h"
#import "MineCenterViewProtocal.h"

@interface MineCreateTransactionLocationViewController ()

@property (strong, nonatomic) UIViewController <MineCenterViewProtocal> *centerViewController;

@property (strong, nonatomic) NSString *addressFromMap;
@property (strong, nonatomic) NSString *addressInTextField;
@property (assign, nonatomic) BOOL addressSelectedFromMap;

@property (assign, nonatomic) BOOL shouldUpdateUserLocation;

@property (assign, nonatomic) BOOL keyboardOnScreen;
@property (assign, nonatomic) NSInteger keyboardHeight;
@property (strong, nonatomic) NSMutableArray *matchingItems;

@property (strong, nonatomic) UIDatePicker *datePickerInput;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerInput1;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationSearchBtn;
@property (weak, nonatomic) IBOutlet UITextField *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)locationSearchBtnTapped:(id)sender;
- (IBAction)datePickerInputDateChanged:(id)sender;

@end

@implementation MineCreateTransactionLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
    _addressFromMap = @"";
    _addressInTextField = @"";
    _addressSelectedFromMap = NO;
    
    _shouldUpdateUserLocation = YES;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.mapView.showsUserLocation = YES;
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 200000, 200000);
    [_mapView setRegion:region animated:NO];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    _locationTextField.delegate = self;
    _datePicker.delegate = self;
    
    [self updateLocationSearchBtnWithStatus:NO];

    [self.datePicker setInputView:self.datePickerInput1];
    [self updateDatePickerTextField];
    
    [self addGestures];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTransaction) name:MineNotificationDownViewDidHide object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addGestures
{
    /**
     add guesture to dismiss keyboard
     */
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    /**
     add gesture to go to center view controller
     */
    UISwipeGestureRecognizer *swipeDownGusturRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGusturRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGusturRecognizer];
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer *)recognizer
{
    [self hideKeyboard];
    [self.centerViewController hideDownView];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardOnScreen = YES;
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKeyPath:UIKeyboardFrameBeginUserInfoKey];
    self.keyboardHeight = [keyboardFrameBegin CGRectValue].size.height;
    
    [self adjustScrollView];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyboardOnScreen = NO;
    [self adjustScrollView];
}

- (void)adjustScrollView
{
    if (self.keyboardOnScreen == YES) {
        NSInteger maxOffsetInVerticalDirection = NSIntegerMax;
        UIView *activeTextField = [self.view findFirstResponder];
        
        maxOffsetInVerticalDirection = [activeTextField convertRect:activeTextField.bounds toView:activeTextField.superview].origin.y;
        if (self.navigationController && self.navigationController.navigationBar.hidden == NO) {
            UINavigationBar *bar = self.navigationController.navigationBar;
            
            maxOffsetInVerticalDirection = maxOffsetInVerticalDirection - [bar convertRect:bar.bounds toView:bar.superview].size.height - [bar convertRect:bar.bounds toView:bar.superview].origin.y - 60;
        }
        
        CGPoint offset = CGPointMake(0, maxOffsetInVerticalDirection < self.keyboardHeight ? maxOffsetInVerticalDirection : self.keyboardHeight);
        
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)hideKeyboard
{
    if (self.keyboardOnScreen) {
        [self.view endEditing:YES];
        self.keyboardOnScreen = NO;
    }
}

- (void)updateLocationSearchBtnWithStatus:(BOOL)status
{
    if (!status) {
        self.locationSearchBtn.enabled = NO;
        [self.locationSearchBtn setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
        self.locationSearchBtn.enabled = YES;
        [self.locationSearchBtn setBackgroundColor:[UIColor blueColor]];
    }
}

- (IBAction)locationSearchBtnTapped:(id)sender {

    [self.mapView removeAllAnnotationsButUserLocation];
    
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.locationTextField.text;
    request.region = _mapView.region;
    
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else {
            int i = 0;
            for (MKMapItem *item in response.mapItems) {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = item.placemark.coordinate;

                NSString *address;
                if (![item.placemark.addressDictionary objectForKey:@"Thoroughfare"])
                    address = [NSString stringWithFormat:@"%@, %@, %@", [item.placemark.addressDictionary objectForKey:@"City"], [item.placemark.addressDictionary objectForKey:@"State"], [item.placemark.addressDictionary objectForKey:@"CountryCode"]];
                else
                    address = [NSString stringWithFormat:@"%@\n@ %@ in %@, %@, %@", [item.placemark.addressDictionary objectForKey:@"Name"], [item.placemark.addressDictionary objectForKey:@"Thoroughfare"], [item.placemark.addressDictionary objectForKey:@"SubLocality"], [item.placemark.addressDictionary objectForKey:@"State"], [item.placemark.addressDictionary objectForKey:@"CountryCode"]];
                
                annotation.title = address;

                [_mapView addAnnotation:annotation];
                
                if (i++ == 0)
                    _mapView.centerCoordinate = annotation.coordinate;

            }
        }
    }];
    
    [self hideKeyboard];
    
    self.addressInTextField = self.locationTextField.text;
    self.shouldUpdateUserLocation = NO;
}

- (IBAction)datePickerInputDateChanged:(id)sender
{
    [self updateDatePickerTextField];
}

- (void)updateDatePickerTextField
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.datePicker.text = [formatter stringFromDate:self.datePickerInput1.date];
}

#pragma mark - side view delegate -

- (void)setCenterViewController:(UIViewController *)controller
{
//    _centerViewController = controller;
}

#pragma mark - map view delegate -

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.shouldUpdateUserLocation)
        _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.locationTextField.text = @"Selected from map";
    UIFont* italicFont = [UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
    [self.locationTextField setFont:italicFont];
    
    self.addressFromMap = view.annotation.title;
    self.addressSelectedFromMap = YES;
    
    self.locationTextField.enabled = NO;
    self.locationSearchBtn.enabled = NO;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    self.locationTextField.text = self.addressInTextField;
    UIFont* italicFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self.locationTextField setFont:italicFont];
    
    self.addressSelectedFromMap = NO;
    
    self.locationTextField.enabled = YES;
    self.locationSearchBtn.enabled = YES;
}

#pragma mark - text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.datePicker])
        return NO;
    
    BOOL locationSearchBtnStatus;
    
    if (self.locationTextField.text.length == 0 && ![textField isEqual:self.locationTextField])
        locationSearchBtnStatus = NO;
    else if (self.locationTextField.text.length == 1 && [textField isEqual:self.locationTextField] && [string isEqualToString:@""]) {
        locationSearchBtnStatus = NO;
    }
    else
        locationSearchBtnStatus = YES;
    [self updateLocationSearchBtnWithStatus:locationSearchBtnStatus];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustScrollView];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([textField isEqual:self.datePicker])
        return NO;
    
    [self updateLocationSearchBtnWithStatus:NO];
    return YES;
}

@end
