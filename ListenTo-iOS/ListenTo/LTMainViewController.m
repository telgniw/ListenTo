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
    [self.navigationController.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
}

@end
