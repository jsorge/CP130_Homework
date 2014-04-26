//
//  JMSModel.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSModel.h"

@implementation JMSModel
+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    JMSModel *model = [[JMSModel alloc] init];
    if (model) {
        model.title = [title copy];
        model.subtitle = [subtitle copy];
    }
    return model;
}
@end
