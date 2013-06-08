//
//  LTRecordViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OBShapedButton/OBShapedButton.h>
#import "LTRecordCell.h"

@interface LTRecordViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, LTRecordCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *cardIds;
@property (strong, nonatomic) NSDictionary *errorCards;
@property (strong, nonatomic) NSNumber *selectedID;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) OBShapedButton *selectedButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *todayButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *thisweekButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *alltimeButton;

#pragma mark - IBActions

- (IBAction)home:(id)sender;
- (IBAction)changeRange:(id)sender;
- (IBAction)openCard:(id)sender;


@end
