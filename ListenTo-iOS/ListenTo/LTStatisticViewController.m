//
//  LTStatisticViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/30.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTStatisticViewController.h"
#import "LTUtility.h"

@implementation LTStatisticViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background of toolbar transparent.
    [self.toolbar setTranslucent:YES];
    [self.toolbar setBackgroundImage:[LTUtility transparentImage] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[LTUtility emptyImage] forToolbarPosition:UIToolbarPositionAny];
}

#pragma mark - IBActions

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
