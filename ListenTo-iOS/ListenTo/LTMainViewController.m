//
//  LTMainViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTMainViewController.h"
#import "LTUtility.h"

@implementation LTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"homescreen-background.png"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%lf %lf", [self.enterButton frame].size.width, [self.enterButton frame].size.height);
    NSLog(@"%lf %lf", [self.recordButton frame].size.width, [self.recordButton frame].size.height);
}

@end
