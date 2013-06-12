//
//  LTGameEndView.m
//  ListenTo
//
//  Created by Yi Huang on 13/6/12.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTGameEndView.h"

@implementation LTGameEndView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [[[NSBundle mainBundle] loadNibNamed:@"LTLevelCompleteView" owner:self options:nil] objectAtIndex:0]) != nil) {
    }
    
    return self;
}

- (void)showCarrots:(int)carrots
{
    if(carrots > 0)
        [UIView animateWithDuration:0.5f animations:^{
            [self.carrot1 setAlpha:1.0f];
        } completion:^(BOOL finished) {
            if(carrots > 1)
                [UIView animateWithDuration:0.5f animations:^{
                    [self.carrot2 setAlpha:1.0f];
                } completion:^(BOOL finished) {
                    if(carrots > 2)
                        [UIView animateWithDuration:0.5f animations:^{
                            [self.carrot3 setAlpha:1.0f];
                        }];
                }];
        }];
}

@end
