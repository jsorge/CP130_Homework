//
//  JMSBackgroundTask.m
//  CP130_HW4
//
//  Created by Jared Sorge on 4/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSBackgroundTask.h"
#import "JMSCosbyImage.h"

@interface JMSBackgroundTask ()
@property (readwrite, nonatomic)UIImageView *cosbyImageView;
@end

@implementation JMSBackgroundTask

- (instancetype)initWithCosbyImageView:(UIImageView *)cosbyImageView
{
    self = [super init];
    if (self) {
        self.cosbyImageView = cosbyImageView;
    }
    return self;
}

- (void)main
{
    srand48(time(0));
    while (YES) {
        if (self.isCancelled) {
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.cosbyImageView.image = nil;
            self.cosbyImageView.image = [JMSCosbyImage randomCosbyImage];
        }];
        
        double randomSleep = (drand48() * 10);
        [NSThread sleepForTimeInterval:randomSleep];
    }
}
@end
