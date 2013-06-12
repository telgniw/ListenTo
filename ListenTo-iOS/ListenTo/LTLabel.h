//
//  LTLabel.h
//  ListenTo
//
//  Created by Yi Huang on 13/6/12.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTLabel : UILabel {
    UIEdgeInsets _insets;
}

- (void)setInsets:(UIEdgeInsets)insets;

@end
