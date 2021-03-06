//
//  MineCreateTransactionLocation'ViewController.h
//  Mine
//
//  Created by Zhi Li on 7/29/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MineSideViewProtocal.h"
#import "MineTransactionInfo.h"

@interface MineCreateTransactionLocationViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, MineSideViewProtocal>

@property (strong, nonatomic) MineTransactionInfo *transaction;

@end
