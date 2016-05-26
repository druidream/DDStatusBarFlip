//
//  ViewController.m
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/20/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import "ViewController.h"
#import "DDStatusBarNotification.h"

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
}

- (IBAction)presentButtonDidClick:(UIButton *)sender {
    
    [DDStatusBarNotification showWithText:@"You've got a new message."];
}

- (IBAction)dismissButtonDidClick:(UIButton *)sender {
    
    [DDStatusBarNotification hide];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
