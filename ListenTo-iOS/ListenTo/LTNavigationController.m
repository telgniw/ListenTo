//
//  LTViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/13.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTNavigationController.h"

#import "NSDate+Beginning.h"
#import "LTDatabase.h"

@implementation LTNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the background of navigation bar transparent.
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *transparentImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];

    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setBackgroundImage:transparentImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    LTDatabase *db = [LTDatabase instance];
    NSLog(@"card 1: %@", [db cardForId:1]);
    NSLog(@"record 1: %@", [db recordForId:1]);
    NSLog(@"record today: %@", [db arrayWithRecordIdsAfterDate:[NSDate today]]);
}

@end
