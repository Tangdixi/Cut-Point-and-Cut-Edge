//
//  PointButton.m
//  AppForPointsAndLines
//
//  Created by Developer C on 12/11/12.
//  Copyright (c) 2012 Developer C. All rights reserved.
//

#import "PointButton.h"

@implementation PointButton

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font andFontColor:(UIColor *)fontColor atLoaction:(CGPoint)location{
    self=[UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame=CGRectMake(location.x-15, location.y-15, 30, 30);
        self.titleLabel.font=font;
        self.titleLabel.textColor=fontColor;
        [self setTitle:title forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
        [self setShowsTouchWhenHighlighted:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
