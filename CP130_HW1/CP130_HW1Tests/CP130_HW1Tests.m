//
//  CP130_HW1Tests.m
//  CP130_HW1Tests
//
//  Created by Jared Sorge on 4/5/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JMSAddition.h"

@interface CP130_HW1Tests : XCTestCase
@property (strong, nonatomic)JMSAddition *addition;
@end

@implementation CP130_HW1Tests

- (void)setUp
{
    [super setUp];
    
    self.addition = [[JMSAddition alloc] init];
    self.addition.numA = 11;
    self.addition.numB = 33;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSumOfAAndB
{
    XCTAssertTrue(([self.addition sumOfAAndB] == 44), @"The sums are working correctly");
}
@end
