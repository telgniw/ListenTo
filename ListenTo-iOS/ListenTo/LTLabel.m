//
//  LTLabel.m
//  ListenTo
//
//  Created by Yi Huang on 13/6/12.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTLabel.h"

@implementation LTLabel

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
}

@end
