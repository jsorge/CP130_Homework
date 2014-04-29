//
//  JMSCosbyImage.m
//  CP130_HW4
//
//  Created by Jared Sorge on 4/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSCosbyImage.h"
#import "UIImage+animatedGIF.h"

@implementation JMSCosbyImage
+ (UIImage *)randomCosbyImage
{
    UIImage *cosbyImage;
    while (cosbyImage == nil) {
        NSUInteger randomInt = arc4random_uniform(60) + 1;
        NSInteger substringIndex = randomInt >= 10 ? 1 : 0;
        NSString *cosbyNumber = [[NSString stringWithFormat:@"00%d", randomInt] substringFromIndex:substringIndex];
        id cosbyGif = [[NSBundle mainBundle] pathForResource:cosbyNumber ofType:@"gif"];
        NSData *cosbyData = [NSData dataWithContentsOfFile:cosbyGif];
        cosbyImage = [UIImage animatedImageWithAnimatedGIFData:cosbyData];
    }
    
    return cosbyImage;
}
@end
