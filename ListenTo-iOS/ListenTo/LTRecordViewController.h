//
//  LTRecordViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTRecordViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *cardIds;
@property (strong, nonatomic) NSDictionary *recordsByCardId;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rangeControl;

#pragma mark - IBActions

- (IBAction)changeRange:(id)sender;

@end
