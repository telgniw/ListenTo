//
//  LTRecordViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTRecordCell.h"

@interface LTRecordViewTableController : UITableViewController <UITableViewDataSource, UITableViewDelegate, LTRecordCellDelegate>

@property (strong, nonatomic) UIColor *oddRowBackground;
@property (strong, nonatomic) UIColor *evenRowBackground;

@property (strong, nonatomic) NSArray *cardIds;
@property (strong, nonatomic) NSDictionary *errorCards;
@property (strong, nonatomic) NSNumber *selectedID;
@property (strong, nonatomic) NSDate *selectedRange;


#pragma mark - RecordCell Delegate

- (void)cellSelectedWithIdentity:(NSNumber*)theID;

#pragma mark - IBActions

- (IBAction)openChart:(id)sender;
- (IBAction)openCard:(id)sender;

@end
