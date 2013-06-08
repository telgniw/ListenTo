//
//  LTGameLevelViewController.m
//  ListenTo
//
//  Created by 林 奇賦 on 13/6/6.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTGameCDLevelViewController.h"
#import "LTGameCDViewController.h"

@interface LTGameCDLevelViewController ()

@end

@implementation LTGameCDLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"connectdots-background.png"]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifier = [segue identifier];
    if([identifier hasPrefix:@"CDLevel"]) {
        LTGameCDViewController *controller = (LTGameCDViewController *)[segue destinationViewController];
        [controller setLevel:[NSNumber numberWithInt:[[identifier substringFromIndex:7] intValue]]];
    }
    
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
