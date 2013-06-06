//
//  LTChartViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallGraphDelegate.h"
#import "MIMColor.h"
#import "MIMWallGraph.h"
#import "DataManager.h"

@interface LTChartViewController : UITableViewController <UITableViewDataSource,UITabBarDelegate,WallGraphDelegate>{
   
    IBOutlet UITableView *myTableView;
    MIMWallGraph *mWallGraph;
    
    NSMutableArray *dataArrayFromCSV;
    NSMutableArray *xDataArrayFromCSV;
    
    
    NSArray *yValuesArray;
    NSArray *xValuesArray;
    NSArray *xTitlesArray;
    NSArray *wallPropertiesArray;
    
    NSDictionary *xProperty;
    NSDictionary *yProperty;
    
    NSDictionary *horizontalLinesProperties;
    NSDictionary *verticalLinesProperties;
    
    NSDictionary *data;
    
    DataManager *dataManager_;

}

@end
