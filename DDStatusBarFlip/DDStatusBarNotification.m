//
//  DDStatusBarNotification.m
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/21/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDStatusBarNotification.h"
#import "DDStatusBarNotificationViewController.h"
#import "DDStatusBarView.h"
#import "DDTransform3DPerspective.h"

@interface DDStatusBarNotification ()

@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) DDStatusBarView *topBar;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DDStatusBarNotification
@synthesize overlayWindow = _overlayWindow;
@synthesize topBar = _topBar;
@synthesize imageView = _imageView;

static CGFloat NOTIFICATION_BAR_HEIGHT = 20.0f;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static DDStatusBarNotification *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)showWithText:(NSString *)text {
    
    [[self sharedInstance] showWithText:text];
}

+ (void)hide {
    
    [[self sharedInstance] hide];
}

#pragma mark -

- (void)showWithText:(NSString *)text
{
    // first, check if status bar is visible at all
    if ([UIApplication sharedApplication].statusBarHidden) return ;
    
    // prepare for new style
//    if (style != self.activeStyle) {
//        self.activeStyle = style;
//        if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
//            self.topBar.alpha = 0.0;
//            self.topBar.transform = CGAffineTransformIdentity;
//        } else {
//            self.topBar.alpha = 1.0;
//            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
//        }
//    }
    
    // cancel previous dismissing & remove animations
    [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(dismiss) target:self argument:nil];
    [self.topBar.layer removeAllAnimations];
    
    // create & show window
    [self.overlayWindow setHidden:NO];
    
    // update style
//    self.topBar.backgroundColor = style.barColor;
//    self.topBar.textVerticalPositionAdjustment = style.textVerticalPositionAdjustment;
    UILabel *textLabel = self.topBar.textLabel;
//    textLabel.textColor = style.textColor;
//    textLabel.font = style.font;
//    textLabel.accessibilityLabel = status;
    textLabel.text = text;
    
//    if (style.textShadow) {
//        textLabel.shadowColor = style.textShadow.shadowColor;
//        textLabel.shadowOffset = style.textShadow.shadowOffset;
//    } else {
//        textLabel.shadowColor = nil;
//        textLabel.shadowOffset = CGSizeZero;
//    }
    
    // reset progress & activity
//    self.progress = 0.0;
//    [self showActivityIndicator:NO indicatorStyle:0];
    
    // animate in
//    BOOL animationsEnabled = (style.animationType != JDStatusBarAnimationTypeNone);
//    if (animationsEnabled && style.animationType == JDStatusBarAnimationTypeBounce) {
//        [self animateInWithBounceAnimation];
//    } else {
//        [UIView animateWithDuration:(animationsEnabled ? 0.4 : 0.0) animations:^{
//            self.topBar.alpha = 1.0;
//            self.topBar.transform = CGAffineTransformIdentity;
//        }];
//    }
    
//    return self.topBar;
    
    // 开始执行动画
    if ([self.timer isValid]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector:@selector(timerFired:) userInfo:@YES repeats:YES];
}

- (void)hide {
    
    if ([self.timer isValid]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector:@selector(timerFired:) userInfo:@NO repeats:YES];
}

#pragma mark Lazy views

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), NOTIFICATION_BAR_HEIGHT);
//        CGRect frame = [UIScreen mainScreen].bounds;
        _overlayWindow = [[UIWindow alloc] initWithFrame:frame];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.rootViewController = [[DDStatusBarNotificationViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
        _overlayWindow.rootViewController.wantsFullScreenLayout = YES;
#endif
        [self updateWindowTransform];
        [self updateTopBarFrameWithStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    return _overlayWindow;
}

- (DDStatusBarView *)topBar {
    
    if(_topBar == nil) {
        _topBar = [[DDStatusBarView alloc] init];
        [self.overlayWindow.rootViewController.view addSubview:_topBar];
        
        // init topBar angle
        [self setCubeFlipAngle:-M_PI_2];
    }
    return _topBar;
}

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        UIImage *image = [[UIImage alloc] initWithData:[self screenshot] scale:[UIScreen mainScreen].scale];
        _imageView = [[UIImageView alloc] initWithImage:image];
        
        [self.overlayWindow.rootViewController.view addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark Rotation

- (void)updateWindowTransform;
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _overlayWindow.transform = window.transform;
    _overlayWindow.frame = window.frame;
}

- (void)updateTopBarFrameWithStatusBarFrame:(CGRect)rect;
{
    CGFloat width = MAX(rect.size.width, rect.size.height);
    CGFloat height = MIN(rect.size.width, rect.size.height);
    
    // on ios7 fix position, if statusBar has double height
    CGFloat yPos = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && height > 20.0) {
        yPos = -height/2.0;
    }
    
    _topBar.frame = CGRectMake(0, yPos, width, height);
}

#pragma mark -

- (void)timerFired:(NSTimer *)sender {
    
    BOOL isPresentation = [sender.userInfo boolValue];
    
    static float angle = -M_PI_2;
    if (isPresentation) {
        angle += 0.1f;
        if (angle > 0) {
            angle = 0;
            [self.timer invalidate];
        }
        [self setCubeFlipAngle:angle];
    } else {
        angle -= 0.1f;
        if (angle < -M_PI_2) {
            angle = -M_PI_2;
            [self.timer invalidate];
            self.timer = nil;
//            [self.imageView removeFromSuperview];
            self.imageView = nil;
            self.topBar = nil;
            self.overlayWindow = nil;
        }
        [self setCubeFlipAngle:angle];
    }
}

- (void)setCubeFlipAngle:(float)angle
{
    CATransform3D move = CATransform3DMakeTranslation(0, 0, 10);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -10);
    
    CATransform3D rotate0 = CATransform3DMakeRotation(-angle, 1, 0, 0);
    CATransform3D rotate1 = CATransform3DMakeRotation(M_PI_2-angle, 1, 0, 0);
    CATransform3D rotate2 = CATransform3DMakeRotation(M_PI_2*2-angle, 1, 0, 0);
    CATransform3D rotate3 = CATransform3DMakeRotation(M_PI_2*3-angle, 1, 0, 0);
    
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D mat2 = CATransform3DConcat(CATransform3DConcat(move, rotate2), back);
    CATransform3D mat3 = CATransform3DConcat(CATransform3DConcat(move, rotate3), back);
    
    self.topBar.layer.transform = CATransform3DPerspect(mat0, CGPointZero, 500.0f);
    self.imageView.layer.transform = CATransform3DPerspect(mat3, CGPointZero, 500.0f);
}

- (NSData *)screenshot {
    
    UIWindow *window = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(window.bounds), NOTIFICATION_BAR_HEIGHT), NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(window.bounds), NOTIFICATION_BAR_HEIGHT));
    
    // first, draw keyWindow as background
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // second, draw status bar on top
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSData * imgData = UIImageJPEGRepresentation(image, 1.0f);
    NSData * imgData = UIImagePNGRepresentation(image);
    
    if(imgData) {
        // for debug
//        NSString *path = [NSString stringWithFormat:@"%@screenshot.png",  NSTemporaryDirectory()];
//        [imgData writeToFile:path atomically:YES];
        return imgData;
    } else
        NSLog(@"error while taking screenshot");
    return nil;
}

@end
