//
//  LTRecordViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/6/8.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OBShapedButton/OBShapedButton.h>
#import "LTRecordViewTableController.h"

@interface LTRecordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) LTRecordViewTableController *tableViewController;

@property (strong, nonatomic) OBShapedButton *selectedButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *todayButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *thisweekButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *alltimeButton;

#pragma mark - IBActions

- (IBAction)home:(id)sender;
- (IBAction)changeRange:(id)sender;

@end
