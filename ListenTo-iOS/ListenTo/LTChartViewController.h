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
#import "LTChartTableViewController.h"

@interface LTChartViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *cardName;
@property (strong, nonatomic) NSNumber *cid;
@property (strong, nonatomic) LTChartTableViewController *tableViewController;

- (IBAction)back:(id)sender;

@end
