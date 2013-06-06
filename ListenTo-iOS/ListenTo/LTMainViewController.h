//
//  LTMainViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OBShapedButton/OBShapedButton.h>

@interface LTMainViewController : UIViewController <UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet OBShapedButton *enterButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *recordButton;

@end
