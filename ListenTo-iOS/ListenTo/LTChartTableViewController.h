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
#import "DataManager.h"

@interface LTChartTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, WallGraphDelegate>
{
    MIMWallGraph *mWallGraph;
    
    NSArray *yValuesArray;
    NSArray *xValuesArray;
    NSArray *xTitlesArray;
    NSArray *wallPropertiesArray;
    
    NSDictionary *xProperty;
    NSDictionary *yProperty;
    
    NSDictionary *horizontalLinesProperties;
    NSDictionary *verticalLinesProperties;
    
    DataManager *dataManager_;
}

@property (strong, nonatomic) NSNumber *cid;

@end
