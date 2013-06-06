//
//  LTViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/13.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTNavigationController.h"
#import "LTUtility.h"

@implementation LTNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the background of navigation bar transparent.
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setBackgroundImage:[LTUtility transparentImage] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[LTUtility emptyImage]];
}

@end
