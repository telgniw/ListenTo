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
    
    //UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSArray *gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"rabbit-1"],
                         [UIImage imageNamed:@"rabbit-2"],
                         [UIImage imageNamed:@"rabbit-3"],
                         [UIImage imageNamed:@"rabbit-4"],
                         [UIImage imageNamed:@"rabbit-3"],
                         [UIImage imageNamed:@"rabbit-2"],
                         [UIImage imageNamed:@"rabbit-1"],
                         nil];
    self.rabbitImgView.animationImages = gifArray;
    self.rabbitImgView.animationDuration = 3;
    self.rabbitImgView.animationRepeatCount = -1;
    [self.rabbitImgView startAnimating];

}

@end
