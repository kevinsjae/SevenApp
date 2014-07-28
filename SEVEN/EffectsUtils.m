//
//  EffectsUtils.m
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "EffectsUtils.h"

@implementation EffectsUtils

+(void)gradientFadeInForView:(UIView *)view duration:(float)duration{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    int w = view.frame.size.width;
    gradient.frame = CGRectMake(-w*2, 0, w*3, view.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, [UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.locations = @[@0, @0.33, @0.66, @1];
    [view.layer setMask:gradient];

    [CATransaction begin];
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    frameAnimation.duration = duration;
    CATransform3D transform = CATransform3DMakeTranslation(w*2, 0, 0);
    frameAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    [CATransaction setCompletionBlock:^{
        view.layer.mask = nil;
    }];
    [view.layer.mask addAnimation:frameAnimation forKey:@"translate"];
    [CATransaction commit];
}

@end
