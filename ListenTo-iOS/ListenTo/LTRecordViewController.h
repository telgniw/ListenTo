//
//  LTRecordViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTRecordCell.h"

@interface LTRecordViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, LTRecordCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *cardIds;
@property (strong, nonatomic) NSDictionary *errorCards;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rangeControl;
@property (strong, nonatomic) NSNumber *selectedID;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

#pragma mark - IBActions

- (IBAction)changeRange:(id)sender;
- (IBAction)openCard:(id)sender;


@end
