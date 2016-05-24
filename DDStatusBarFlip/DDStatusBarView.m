//
//  DDStatusBarView.m
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/22/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import "DDStatusBarView.h"

@implementation DDStatusBarView

- (UILabel *)textLabel;
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor darkGrayColor];
        _textLabel.textColor = [UIColor lightTextColor];
        _textLabel.font = [UIFont systemFontOfSize:12.0];
        _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.clipsToBounds = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

#pragma mark layout

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // label
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
