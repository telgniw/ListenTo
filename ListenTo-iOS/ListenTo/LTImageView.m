//
//  LTImageView.m
//  ListenTo
//
//  Created by Yi Huang on 13/6/12.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LTImageView.h"
#import "LTUtility.h"

@implementation LTImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setRoundCornered];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setRoundCornered];
    }
    return self;
}

- (void)setRoundCornered
{
    float width = [self frame].size.width;
    [self.layer setBorderColor:[[LTUtility cardBorderColor] CGColor]];
    [self.layer setBorderWidth:CARD_BORDER_WIDTH];
    [self.layer setCornerRadius:width * 0.10f];
    [self.layer setMasksToBounds:YES];
}

@end
