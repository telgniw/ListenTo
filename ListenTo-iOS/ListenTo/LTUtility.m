//
//  LTUtility.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/30.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTUtility.h"

@implementation LTUtility

+ (UIImage *)transparentImage
{
    static UIImage *image;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        const float colorMask[6] = {222, 255, 222, 255, 222, 255};
        image = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors([LTUtility emptyImage].CGImage, colorMask)];
    });
    
    return image;
}

+ (UIImage *)emptyImage
{
    static UIImage *image;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        image = [[UIImage alloc] init];
    });
    
    return image;
}

+ (UIColor *)cardBorderColor
{
    static UIColor *color;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        color = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.7];
    });
    
    return color;
}

@end
