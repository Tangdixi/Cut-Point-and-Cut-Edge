//
//  FirstViewController.h
//  AppForPointsAndLines
//
//  Created by Developer C on 12/11/12.
//  Copyright (c) 2012 Developer C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController : UIViewController{
    BOOL isPoint;
    BOOL isLine;
    BOOL runPress;
    
    NSInteger count;
    NSInteger lCount;
    NSInteger begin;
    UIButton *lastTouch;
}

- (IBAction)point:(id)sender;
- (IBAction)line:(id)sender;

@end
