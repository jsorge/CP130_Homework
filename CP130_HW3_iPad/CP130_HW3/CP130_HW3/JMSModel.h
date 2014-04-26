//
//  JMSModel.h
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSModel : NSObject
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *subtitle;

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
@end
