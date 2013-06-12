//
//  LTChartTableViewController.m
//  ListenTo
//
//  Created by Johnny Bee on 13/6/11.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTChartTableViewController.h"

@implementation LTChartTableViewController

- (void)initializeDataWithCid:(NSNumber *)cid;
{
    [self setCid:cid];
    
    // Initialize data.
    [self setDb:[LTDatabase instance]];
    
    NSArray *stats = [self.db statisticsForCard:self.cid withNumberOfDays:7];
    
    // Handle empty data.
    if([stats count] == 0) {
        stats = @[@{
            LT_DB_STAT_KEY_COUNT: @0,
            LT_DB_STAT_KEY_ERROR: @0,
            LT_DB_STAT_KEY_DATE: [NSDate today]
        }];
    }
    
    // Generate x-axis data.
    [self setXValues:[stats valueForKey:LT_DB_STAT_KEY_DATE]];
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[stats count]];
    for(NSDate *date in self.xValues) {
        [titles addObject:[date stringWithAbbrFormat]];
    }
    
    [self setXTitles:[NSArray arrayWithArray:titles]];
    
    // Generate y-axis data.
    [self setYCounts:[stats valueForKey:LT_DB_STAT_KEY_COUNT]];
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[stats count]];
    for(NSDictionary *record in stats) {
        float error = [[record objectForKey:LT_DB_STAT_KEY_ERROR] floatValue];
        float count = [[record objectForKey:LT_DB_STAT_KEY_COUNT] floatValue];
        float rate = (count > 0)? (1.0f - error / count) * 100.0f : 0.0f;
        [values addObject:[NSString stringWithFormat:@"%.0f", rate]];//[NSNumber numberWithFloat:rate]];
    }
    
    [self setYValues:[NSArray arrayWithArray:values]];
    
    [self.tableView reloadData];
}

#pragma mark - TABLE View


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    wallPropertiesArray=@[@{@"edgecolor": @"100,170,150", @"wallcolor": @"100,170,150,50"}];
    
    mWallGraph=[[MIMWallGraph alloc]initWithFrame:CGRectMake(5, 20, self.tableView.frame.size.width - 50, self.tableView.frame.size.height)];
    mWallGraph.delegate = self;
    mWallGraph.titleLabel = nil;
    
    mWallGraph.displayMeterline = TRUE;
    mWallGraph.meterLineYOffset = 0;
    
    mWallGraph.yValCounts = self.yCounts;
    
    [mWallGraph drawMIMWallGraph];
    [cell.contentView addSubview:mWallGraph];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Keep this to have a working meter line.
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"])
        return 500;
    
    return 200;
}

#pragma mark - Delegate Methods

- (NSArray *)valuesForGraph:(id)graph
{
    return self.yValues;
}

- (NSArray *)valuesForXAxis:(id)graph
{
    return self.xTitles;
}

- (NSArray *)titlesForXAxis:(id)graph
{
    return self.xTitles;
}

- (NSArray *)WallProperties:(id)graph
{
    return wallPropertiesArray;
}

- (NSDictionary *)xAxisProperties:(id)graph
{
    return nil;
}

- (NSDictionary *)yAxisProperties:(id)graph
{
    return nil;
}

- (NSDictionary *)horizontalLinesProperties:(id)graph
{
    return nil;
}

- (NSDictionary *)verticalLinesProperties:(id)graph
{
    return nil;
}

-(UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(5, self.tableView.frame.size.width * 0.5 + 20, 310, 20)];
    [a setBackgroundColor:[UIColor clearColor]];
    [a setText:text];
    a.numberOfLines=5;
    [a setTextAlignment:NSTextAlignmentCenter];
    [a setTextColor:[UIColor blackColor]];
    [a setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [a setMinimumScaleFactor:8];
    return a;
}

@end
