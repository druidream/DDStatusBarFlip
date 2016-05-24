//
//  DDTransform3DPerspective.h
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/23/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDTransform3DPerspective : NSObject

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ);
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ);

@end
