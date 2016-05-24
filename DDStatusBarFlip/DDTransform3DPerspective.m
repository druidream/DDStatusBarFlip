//
//  DDTransform3DPerspective.m
//  DDStatusBarFlip
//
//  Created by Gu Jun on 5/23/16.
//  Copyright © 2016 druidream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTransform3DPerspective.h"

@implementation DDTransform3DPerspective

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

@end
