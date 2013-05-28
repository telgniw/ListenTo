//
//  LTViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/13.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTNavigationController.h"

@interface LTNavigationController ()

@end

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
}

@end
