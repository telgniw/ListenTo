//
//  MIMFloatingView.h
//  MIMChartLib
//
//  Created by Mac Mac on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMFloatingView : UIView
{
    UILabel *title_;
    UILabel *subtitle_;
    UILabel *total_;
    UIColor *barColor;
}
@property(nonatomic,retain)UIColor *barColor;


-(void)setLabelsOnView:(NSString *)title total:(NSString *)total subtitle:(NSString *)subtitle;
@end
