//
//  Demo_BlockTests.m
//  Demo_BlockTests
//
//  Created by wangpanpan on 16/7/21.
//  Copyright © 2016年 wangpanpan. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Demo_BlockTests : XCTestCase

@end

@implementation Demo_BlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
