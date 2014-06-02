//
//  NSDate+Today.h
//  ImHereStudent
//
//  Created by Jared Sorge on 6/1/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Today)
/**
 *  Creates an NSDate whos value is the current date. Useful for operations that don't require time data.
 *
 *  @return Date object set to the current date.
 */
+ (NSDate *)today;
@end
