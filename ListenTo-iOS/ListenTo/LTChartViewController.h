//
//  LTChartViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/10.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMColor.h"
#import "MIMWallGraph.h"
#import "DataManager.h"
#import "LTChartTableViewController.h"

@interface LTChartViewController : UIViewController <WallGraphDelegate>
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
    
    DataManager *dataManager;
    IBOutlet UIView *chartView;

}

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) NSNumber *cid;
@property (strong, nonatomic) LTChartTableViewController *tableViewController;


@end
