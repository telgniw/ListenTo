//
//  MIMFloatingView.m
//  MIMChartLib
//
//  Created by Mac Mac on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIMFloatingView.h"

@implementation MIMFloatingView
@synthesize barColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        
        
        title_=[[UILabel alloc]initWithFrame:CGRectMake(15, 2, CGRectGetWidth(self.frame)-20, 20)];
        [title_ setBackgroundColor:[UIColor clearColor]];
        [title_ setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [title_ setTextColor:[UIColor blackColor]];
        [self addSubview:title_];
        
        
        total_=[[UILabel alloc]initWithFrame:CGRectMake(15, 22, CGRectGetWidth(self.frame)-20, 40)];
        [total_ setBackgroundColor:[UIColor clearColor]];
        [total_ setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [total_ setTextColor:[UIColor blackColor]];
        [total_ setNumberOfLines:3];
        [total_ setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:total_];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    

    CGContextSetFillColorWithColor(ctx, barColor.CGColor);
    CGContextAddRect(ctx, CGRectMake(3, 8, 8, 8));     
    CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), 2, [UIColor grayColor].CGColor);
    CGContextFillPath(ctx);
     
}

-(void)setLabelsOnView:(NSString *)title total:(NSString *)total
{
 
    [title_ setText:title];
    [total_ setText:total];

}



@end
