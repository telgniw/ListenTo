//
//  LTGameLevelViewController.m
//  ListenTo
//
//  Created by 林 奇賦 on 13/6/6.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTGameCDLevelViewController.h"
#import "LTGameCDViewController.h"

@interface LTGameCDLevelViewController ()

@end

@implementation LTGameCDLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"connectdots-background.png"]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSNumber *level;
    if ([[segue identifier] isEqualToString:@"level1"]) {
        level=[NSNumber numberWithInt:1];
    }
    if ([[segue identifier] isEqualToString:@"level2"]) {
        level=[NSNumber numberWithInt:2];
    }
    LTGameCDViewController *gvc = (LTGameCDViewController *)[segue destinationViewController];
    gvc.level=level;
    
}

@end
