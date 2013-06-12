//
//  LTChartTableViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/11.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMColor.h"
#import "MIMWallGraph.h"
#import "LTDatabase.h"

@interface LTChartTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, WallGraphDelegate>
{
    MIMWallGraph *mWallGraph;
    
    NSArray *wallPropertiesArray;
}

@property (strong, nonatomic) NSNumber *cid;

@property (strong, nonatomic) LTDatabase *db;
@property (strong, nonatomic) NSArray *xTitles;
@property (strong, nonatomic) NSArray *xValues;
@property (strong, nonatomic) NSArray *yValues;
@property (strong, nonatomic) NSArray *yCounts;
@property (strong, nonatomic) NSArray *yErrors;

- (void)initializeDataWithCid:(NSNumber *)cid;

@end
