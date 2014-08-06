//
//  MineCreateTransactionAmountViewController.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineCreateTransactionItemsViewController.h"
#import "MineTransactionInfo.h"
#import "MineTransactionItem.h"
#import "MineTransactionItemCellTableViewCell.h"
#import "UIView+FindFirstResponder.h"
#import "UITableView+Mine.h"
#import "MineCreateTransactionLocationViewController.h"

@interface MineCreateTransactionItemsViewController ()

@property (strong, nonatomic) UIViewController <MineCenterViewProtocal> *centerViewController;

@property (nonatomic, assign) BOOL keyboardOnScreen;
@property (nonatomic, assign) NSInteger keyboardHeight;

@property (nonatomic, strong) MineTransactionInfo *transaction;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *transactionItemDescription;
@property (weak, nonatomic) IBOutlet UITextField *transactionItemPrice;
@property (weak, nonatomic) IBOutlet UITableView *transactionItemsTableView;
@property (weak, nonatomic) IBOutlet UILabel *transactionItemsPlaceHolder;

- (IBAction)addNewTransactionItemBtnTapped:(id)sender;
- (IBAction)nextBtnTapped:(id)sender;

@end

@implementation MineCreateTransactionItemsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTransaction];
    
    self.transactionItemsTableView.delegate = self;
    self.transactionItemsTableView.dataSource = self;
    self.transactionItemDescription.delegate = self;
    self.transactionItemPrice.delegate = self;
    
    [self.transactionItemPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    
    [self addGestures];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTransaction) name:MineNotificationDownViewDidHide object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.keyboardOnScreen = NO;
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

- (void)hideKeyboard
{
    if (self.keyboardOnScreen) {
        [self.view endEditing:YES];
        self.keyboardOnScreen = NO;
    }
}

- (void)initTransaction
{
    self.transaction = [[MineTransactionInfo alloc] init];
    [self updateUI];
    [self clearTextFields];
}

- (void)resetTransaction
{
    [self initTransaction];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)updateUI
{
    self.transactionItemsTableView.hidden = [self.transaction itemCount] == 0 ? YES : NO;
    self.transactionItemsPlaceHolder.hidden = !self.transactionItemsTableView.hidden;
    
    [self adjustTransactionItemsTableView];
}

- (void)clearTextFields
{
    self.transactionItemDescription.text = @"";
    self.transactionItemPrice.text = @"";
}

- (void)adjustTransactionItemsTableView
{
    [self.transactionItemsTableView reloadData];

    if ([self.transaction itemCount] > 0) {
        NSArray *visibleCells = [self.transactionItemsTableView visibleCells];
        if (visibleCells.count < [self.transaction itemCount])
            [self.transactionItemsTableView scrollToBottomAnimated:YES];
        else
            for (UITableViewCell* cell in visibleCells) {
                if (cell.frame.origin.y + cell.frame.size.height > self.transactionItemsTableView.frame.size.height) {
                    [self.transactionItemsTableView scrollToBottomAnimated:YES];
                    break;
                }
            }
    }
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

- (IBAction)addNewTransactionItemBtnTapped:(id)sender {
    
    NSString *description = [self.transactionItemDescription.text isEqualToString:@""] ? [NSString stringWithFormat:@"Item %d", [self.transaction itemCount] + 1] : self.transactionItemDescription.text;
    
    double price = [self.transactionItemPrice.text isEqualToString:@""] ? PRICE_UNKNOWN : [self.transactionItemPrice.text doubleValue];
    
    MineTransactionItem *newItem = [[MineTransactionItem alloc] initWithDescription:description price:price];
    [self.transaction addTransactionItem:newItem];
    
    [self updateUI];
    [self clearTextFields];
}

- (IBAction)nextBtnTapped:(id)sender {
    [self hideKeyboard];
    
    MineCreateTransactionLocationViewController <MineSideViewProtocal> *viewController = [[MineCreateTransactionLocationViewController alloc] init];
    [viewController setCenterViewController:self.centerViewController];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.transaction = self.transaction;
}


- (IBAction)transactionItemPrice:(id)sender {
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

#pragma mark - side view delegate -

- (void)setCenterViewController:(UIViewController *)controller
{
    _centerViewController = controller;
}

#pragma mark - table view delegate -

#pragma mark - table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transaction itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTransactionItem *item = [self.transaction.transactionItems objectAtIndex:indexPath.row];
    NSString *description = item.description;
    double price = item.price;
    
    static NSString *CellIdentifier = @"MineTransactionItemCellTableViewCell";
    MineTransactionItemCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [MineTransactionItemCellTableViewCell generateCell];
    }
    
    cell.cellDescription.text = [NSString stringWithString:description];
    cell.cellPrice.text = price == PRICE_UNKNOWN ? @"Unknown price" : [NSString stringWithFormat:@"$ %.2f", price];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustScrollView];
}


@end
