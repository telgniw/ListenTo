//
//  LTFlipcardEntryViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTFlipcardEntryViewController.h"
#import "LTFlipcardViewController.h"

@interface LTFlipcardEntryViewController ()

@end

@implementation LTFlipcardEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UIButton class]]) {
        LTFlipcardViewController *controller = [segue destinationViewController];
        UIButton *button = (UIButton *)sender;
        controller.nCardPairs = [[[button titleLabel] text] intValue];
    }
}

@end
