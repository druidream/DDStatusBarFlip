//
//  DDStatusBarNotification.h
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/21/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDStatusBarNotification : NSObject

+ (void)showWithText:(NSString *)text;
+ (void)hide;

@end
