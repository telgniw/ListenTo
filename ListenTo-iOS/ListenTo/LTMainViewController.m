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
    
    NSArray *gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"homescreen-rabbit-1.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-2.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-3.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-4.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-3.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-2.png"],
                         [UIImage imageNamed:@"homescreen-rabbit-1.png"],
                         nil];
    [self.rabbitImgView setAnimationImages:gifArray];
    [self.rabbitImgView setAnimationDuration:3];
    [self.rabbitImgView setAnimationRepeatCount:-1];
    [self.rabbitImgView startAnimating];
}

@end
