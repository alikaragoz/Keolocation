//
//  AKDepartureTests.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;
@import XCTest;

#import "AKDeparture.h"

@interface AKDepartureTests : XCTestCase

@property (nonatomic, strong) NSArray *validDepartures;
@property (nonatomic, strong) NSArray *invalidDepartures;

@end

@implementation AKDepartureTests

#pragma mark - Setup

- (void)setUp {
    [super setUp];
    
    _validDepartures = @[
                         @{@"@attributes": @{
                                   @"accurate": @1,
                                   @"headsign": @"Chantepie | Rosa Parks",
                                   @"vehicle": @935,
                                   @"expected": @"2014-10-25T18:31:00+02:00"
                                   },
                           @"content": @"2014-10-25T18:32:07+02:00"},
                         @{@"@attributes": @{
                                   @"accurate": @1,
                                   @"headsign": @"Chantepie | Rosa Parks",
                                   @"vehicle": @935,
                                   @"expected": @"2014-10-25T18:31:00+02:00"
                                   },
                           @"content": @"2014-10-25T18:32:07+02:00"}];
    
    _invalidDepartures = @[
                           @{@"@attribute": @{
                                     @"accurate": @1,
                                     @"headsign": @"Chantepie | Rosa Parks",
                                     @"vehicle": @935,
                                     @"expected": @"2014-10-25T18:31:00+02:00"
                                     },
                             @"content": @"2014-10-25T18:32:07+02:00"},
                           @{@"@attributes": @{
                                     @"accurate": @1,
                                     @"headsign": @1,
                                     @"vehicle": @{},
                                     @"expected": @"2014-10-25T18:31:00+02:00"
                                     },
                             @"content": @"2014-10-25T18:32:07+02:00"}];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Tests

- (void)testValidDeparturesCreation {
    XCTAssertTrue([AKDeparture departuresWithArray:_validDepartures].count == 2, @"Number of created departures should be 2");
}

- (void)testInvalidDeparturesCreation {
    XCTAssertTrue([AKDeparture departuresWithArray:_invalidDepartures].count == 0, @"Number of created departures should be 0");
}

@end
