//
//  ViewController.m
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/20/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import "ViewController.h"
#import "DDStatusBarNotification.h"
#import "DDTransform3DPerspective.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *notificationBar;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rawImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 取status bar的方法
//    UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
//    self.statusBar = statusBarWindow.subviews[0];
//    NSLog(@"statusBarWindow:%@", NSStringFromCGRect(statusBarWindow.bounds));
//    NSLog(@"%@", statusBarWindow.subviews[0]);
//    NSLog(@"%d", [statusBarWindow.subviews[0] isKindOfClass:[UIView class]]);
    
    // 截屏
//    self.rawImageView.image = [[UIImage alloc] initWithData:[self screenshot]];
//    self.testImageView.image = [[UIImage alloc] initWithData:[self screenshot]];
    
    
//    [self setCubeFlipAngle:-M_PI_2];
//    NSLog(@":%@", NSStringFromCGRect(self.testImageView.frame));
    
    // 打印所有windows
//    NSArray *arr  = statusBarWindow.subviews;
//    for (UIView *view in arr) {
//        NSLog(@"%@", view);
//    }
    
    // 测试各轴transform
//    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 1, 0, 0);
//    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
//    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 0, 0, 1);
//    self.imageView.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);
    
    [NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (IBAction)presentButtonDidClick:(UIButton *)sender {
    
    [DDStatusBarNotification showWithText:@"You've got a new message."];
}

- (IBAction)dismissButtonDidClick:(UIButton *)sender {
    
    [DDStatusBarNotification hide];
}

- (NSData *)screenshot {
    
    UIWindow *window = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(window.bounds), 20), NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(window.bounds), 20));
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imgData = UIImageJPEGRepresentation(image, 0.8);
    if(imgData) {
         [imgData writeToFile:@"screenshot.png" atomically:YES];
        return imgData;
    } else
        NSLog(@"error while taking screenshot");
    return nil;
}

- (UIImage *)snapshot {
    
    UIScreen *screen = [UIScreen mainScreen];
    UIView *snapshotView = [screen snapshotViewAfterScreenUpdates:YES];
    
    UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, NO, [UIScreen mainScreen].scale);
    [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSData *)attempt3 {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
//    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    else
//        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *imageForEmail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageDataForEmail = UIImageJPEGRepresentation(imageForEmail, 1.0);
    
    return imageDataForEmail;
}

- (void)update
{
    static float angle = 0;
    angle += 0.05;
    [self setCubeFlipAngle:angle];
}

- (void)setCubeFlipAngle:(float)angle
{
    CGFloat transZ = [UIScreen mainScreen].bounds.size.width * (8. / 15) * 0.5;
    CATransform3D move = CATransform3DMakeTranslation(0, 0, transZ);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -transZ);
    
    CATransform3D rotate0 = CATransform3DMakeRotation(-angle, 1, 0, 0);
    CATransform3D rotate1 = CATransform3DMakeRotation(M_PI_2-angle, 1, 0, 0);
    CATransform3D rotate2 = CATransform3DMakeRotation(M_PI_2*2-angle, 1, 0, 0);
    CATransform3D rotate3 = CATransform3DMakeRotation(M_PI_2*3-angle, 1, 0, 0);
    
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D mat2 = CATransform3DConcat(CATransform3DConcat(move, rotate2), back);
    CATransform3D mat3 = CATransform3DConcat(CATransform3DConcat(move, rotate3), back);
    
    self.image1.layer.transform = CATransform3DPerspect(mat0, CGPointZero, 500);
    self.image2.layer.transform = CATransform3DPerspect(mat1, CGPointZero, 500);
    self.image3.layer.transform = CATransform3DPerspect(mat2, CGPointZero, 500);
    self.image4.layer.transform = CATransform3DPerspect(mat3, CGPointZero, 500);
}

@end
