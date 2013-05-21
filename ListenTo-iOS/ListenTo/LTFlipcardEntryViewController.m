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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create and add navigation bar buttons.
    self.pauseButton = [[UIBarButtonItem alloc] initWithTitle:@"Pause" style:UIBarButtonItemStylePlain target:self action:@selector(pause:)];
    self.retryButton = [[UIBarButtonItem alloc] initWithTitle:@"Retry" style:UIBarButtonItemStylePlain target:self action:@selector(retry:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.retryButton, self.pauseButton, nil]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UIButton class]]) {
        LTFlipcardViewController *controller = [segue destinationViewController];
        UIButton *button = (UIButton *)sender;
        controller.nCardPairs = [[[button titleLabel] text] intValue];
    }
}

#pragma mark - Navigation Bar Button Action

- (IBAction)pause:(id)sender
{
    
}

- (IBAction)retry:(id)sender
{
    
}

@end
