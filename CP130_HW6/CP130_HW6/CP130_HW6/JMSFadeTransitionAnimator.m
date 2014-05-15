//
//  JMSFadeTransitionAnimator.m
//  CP130_HW6
//
//  Created by Jared Sorge on 5/14/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSFadeTransitionAnimator.h"

static NSTimeInterval duration = 0.2;

@implementation JMSFadeTransitionAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *sourceView = source.view;
    UIView *sourceSnaphot = [sourceView snapshotViewAfterScreenUpdates:NO];
    
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *destinationView = destination.view;
    UIView *destinationSnapshot = [destinationView snapshotViewAfterScreenUpdates:YES];
    
    UIView *containerView = [transitionContext containerView];
    
    [UIView performWithoutAnimation:^{
        destinationSnapshot.alpha = 0.0;
        destinationSnapshot.opaque = NO;
        [containerView addSubview:destinationSnapshot];
        
        [containerView addSubview:sourceSnaphot];
        [sourceSnaphot removeFromSuperview];
    }];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         destinationSnapshot.alpha = 1.0;
                         destinationSnapshot.opaque = YES;
                     } completion:^(BOOL finished) {
                         [destinationSnapshot removeFromSuperview];
                         
                         [containerView addSubview:destinationView];
                         
                         [transitionContext completeTransition:YES];
                     }];
}

@end
