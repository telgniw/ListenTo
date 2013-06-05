/*
 Copyright (C) 2011- 2012  Reetu Raj (reetu.raj@gmail.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 and associated documentation files (the “Software”), to deal in the Software without 
 restriction, including without limitation the rights to use, copy, modify, merge, publish, 
 distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom
 the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or 
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *///
//  WallTestClass.m
//  MIMChartLib
//
//  Created by Reetu Raj on 13/08/11.
//  Copyright (c) 2012 __MIM 2D__. All rights reserved.
//

#import "WallTestClass.h"
#import "LTDatabase.h"


@implementation WallTestClass


- (void)dealloc
{
    ////[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataManager_=[DataManager new];
    [myTableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
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
//#pragma mark - Utility Methods
//
//- (void)fetchDataSetAfter:(NSDate *)date {
//    LTDatabase *db = [LTDatabase instance];
//    NSArray *unsortedIds = [db arrayWithCardAfterDate:date];
//    
//    int nCards = [unsortedIds count];
//    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithCapacity:nCards];
//    NSMutableDictionary *errorRates = [NSMutableDictionary dictionaryWithCapacity:nCards];
//    
//    for(NSNumber *cid in unsortedIds) {
//        NSArray *ids = [db arrayWithErrorCardsForCard:cid afterDate:date];
//        NSMutableArray *errors = [NSMutableArray arrayWithCapacity:[ids count]];
//        for(NSNumber *errorCid in ids) {
//            [errors addObject:[NSNumber numberWithInt:[db errorForCard:cid withErrorCard:errorCid afterDate:date]]];
//        }
//        
//        [mappings setObject:@{@"ids": ids, @"errors": [NSArray arrayWithArray:errors]} forKey:cid];
//        
//        int count = [db errorForCard:cid afterDate:date],
//        error = [db errorForCard:cid afterDate:date];
//        [errorRates setObject:[NSNumber numberWithDouble:((double)error / count)] forKey:cid];
//    }
//    
//    // Reload data immediately after data set is updated.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.errorCards = [NSDictionary dictionaryWithDictionary:mappings];
//        self.cardIds = [unsortedIds sortedArrayUsingComparator:^NSComparisonResult(id cid1, id cid2) {
//            NSNumber *rate1 = errorRates[cid1], *rate2 = errorRates[cid2];
//            
//            // Sorted with descending order.
//            return [rate2 compare:rate1];
//        }];
//        
//        [self.tableView reloadData];
//    });
//}



@end
