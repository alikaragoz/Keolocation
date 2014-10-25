//
//  AKBusStopTests.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;
@import XCTest;

#import "AKBusStop.h"

@interface AKBusStopTests : XCTestCase

@property (nonatomic, strong) NSArray *validBusStops;
@property (nonatomic, strong) NSArray *invalidBusStops;

@end

@implementation AKBusStopTests

#pragma mark - Setup

- (void)setUp {
    [super setUp];
    
    _validBusStops = @[@{
                           @"stop_id": @(1001),
                           @"stop_name": @"Longs Champs",
                           @"stop_lat": @(48.12903716),
                           @"stop_lon": @(-1.6325079)
                           },
                       @{
                           @"stop_id": @(1001),
                           @"stop_name": @"Longs Champs",
                           @"stop_lat": @(48.12903716),
                           @"stop_lon": @(-1.6325079)
                           }];
    
    _invalidBusStops = @[@{
                             @"stop_id": @(1001),
                             @"stop_lat": @(48.12903716),
                             @"stop_lon": @(-1.6325079)
                             },
                         @[]];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Tests

- (void)testValidBusStopsCreation {
    XCTAssertTrue([AKBusStop busStopsWithArray:_validBusStops].count == 2, @"Number of created bus stops should be 2");
}

- (void)testInvalidBusStopsCreation {
    XCTAssertTrue([AKBusStop busStopsWithArray:_invalidBusStops].count == 0, @"Number of created bus stops should be 0");
}

@end
