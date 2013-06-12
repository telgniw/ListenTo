//
//  LTGameEndView.h
//  ListenTo
//
//  Created by Yi Huang on 13/6/12.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTGameEndView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *carrot1;
@property (strong, nonatomic) IBOutlet UIImageView *carrot2;
@property (strong, nonatomic) IBOutlet UIImageView *carrot3;

- (void)showCarrots:(int)carrots;

@end
