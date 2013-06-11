//
//  LTChartTableViewController.m
//  ListenTo
//
//  Created by Johnny Bee on 13/6/11.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTChartTableViewController.h"

@interface LTChartTableViewController ()

@end

@implementation LTChartTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataManager_=[DataManager new];
    [myTableView reloadData];

}

#pragma mark - TABLE View


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"])
        return 500;
    
    
    return 200;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return  1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Basic Wall Charts";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    xProperty=nil;
    yProperty=nil;
    horizontalLinesProperties=nil;
    verticalLinesProperties=nil;
    wallPropertiesArray=nil;
    
    
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    wallPropertiesArray=[NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"0,255,0",@"edgecolor",@"0,255,0,50",@"wallcolor", nil]
                         ,nil];
    
    [dataManager_ createCustomWallData];
    
    
    mWallGraph=[[MIMWallGraph alloc]initWithFrame:CGRectMake(5, 20, myTableView.frame.size.width - 50, myTableView.frame.size.width * 0.5)];
    mWallGraph.delegate=self;
    
    mWallGraph.titleLabel = nil;
    
    mWallGraph.displayMeterline=TRUE;
    mWallGraph.meterLineYOffset=40; //Set the offset as per your need so that it doesnt appear stuck to far left with x-axis.
    [mWallGraph drawMIMWallGraph];
    [cell.contentView addSubview:mWallGraph];
    
    
    return cell;
    
    
}



#pragma mark - DELEGATE METHODS
-(NSArray *)valuesForGraph:(id)graph
{
    return dataManager_.yValuesArray;
}

-(NSArray *)valuesForXAxis:(id)graph
{
    return dataManager_.xValuesArray;
}

-(NSArray *)titlesForXAxis:(id)graph
{
    
    return dataManager_.xTitlesArray;
}


-(NSDictionary *)xAxisProperties:(id)graph
{
    return xProperty;
}
-(NSDictionary *)yAxisProperties:(id)graph
{
    return yProperty;
}

-(NSDictionary *)horizontalLinesProperties:(id)graph
{
    return horizontalLinesProperties;
    
}

-(NSDictionary*)verticalLinesProperties:(id)graph
{
    return verticalLinesProperties;
}

-(NSArray *)WallProperties:(id)graph; //hide,borderwidth (of wall border),patternStyle,gradient,color
{
    return wallPropertiesArray;
}

-(UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(5, myTableView.frame.size.width * 0.5 + 20, 310, 20)];
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
