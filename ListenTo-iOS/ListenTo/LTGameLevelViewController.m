//
//  LTGameLevelViewController.m
//  ListenTo
//
//  Created by 林 奇賦 on 13/6/6.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTGameLevelViewController.h"
#import "LTGameViewController.h"

@interface LTGameLevelViewController ()

@end

@implementation LTGameLevelViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSNumber *level;
    if ([[segue identifier] isEqualToString:@"level1"]) {
        level=[NSNumber numberWithInt:1];
    }
    if ([[segue identifier] isEqualToString:@"level2"]) {
        level=[NSNumber numberWithInt:2];
    }
    LTGameViewController *gvc = (LTGameViewController *)[segue destinationViewController];
    gvc.level=level;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
