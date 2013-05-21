//
//  LTGameResultViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTGameResultViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIButton *replayButton;

- (IBAction)toHome:(id)sender;
- (IBAction)replay:(id)sender;

@end
