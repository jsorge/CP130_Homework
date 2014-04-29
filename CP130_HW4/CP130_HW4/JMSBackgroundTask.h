//
//  JMSBackgroundTask.h
//  CP130_HW4
//
//  Created by Jared Sorge on 4/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSBackgroundTask : NSOperation
@property (readonly, nonatomic)UIImageView *cosbyImageView;

- (instancetype)initWithCosbyImageView:(UIImageView *)cosbyImageView;
@end
