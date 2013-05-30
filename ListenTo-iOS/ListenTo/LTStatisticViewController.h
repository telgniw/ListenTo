//
//  LTStatisticViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/30.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTStatisticViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;

#pragma mark - IBActions

- (IBAction)close:(id)sender;

@end
