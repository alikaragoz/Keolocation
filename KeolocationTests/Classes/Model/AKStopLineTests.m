//
//  AKStopLineTests.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;
@import XCTest;

#import "AKStopLine.h"

@interface AKStopLineTests : XCTestCase

@property (nonatomic, strong) NSArray *validStopLines;
@property (nonatomic, strong) NSArray *invalidStopLines;

@end

@implementation AKStopLineTests

#pragma mark - Setup

- (void)setUp {
    [super setUp];
    
    _validStopLines = @[@{
                            @"stop": @1002,
                            @"route": @0001,
                            @"direction": @0,
                            @"departures": @{
                                    @"departure": @[
                                            @{
                                                @"@attributes": @{
                                                        @"accurate": @1,
                                                        @"headsign": @"Chantepie | Rosa Parks",
                                                        @"vehicle": @935,
                                                        @"expected": @"2014-10-25T18:31:00+02:00"
                                                        },
                                                @"content": @"2014-10-25T18:32:07+02:00"},
                                            @{
                                                @"@attributes": @{
                                                        @"accurate": @1,
                                                        @"headsign": @"Chantepie | Rosa Parks",
                                                        @"vehicle": @935,
                                                        @"expected": @"2014-10-25T18:31:00+02:00"
                                                        },
                                                @"content": @"2014-10-25T18:32:07+02:00"}
                                            ]
                                    }
                            },
                        @{
                            @"stop": @1002,
                            @"route": @0001,
                            @"direction": @0,
                            @"departures": @{
                                    @"departure": @[
                                            @{
                                                @"@attributes": @{
                                                        @"accurate": @1,
                                                        @"headsign": @"Chantepie | Rosa Parks",
                                                        @"vehicle": @935,
                                                        @"expected": @"2014-10-25T18:31:00+02:00"
                                                        },
                                                @"content": @"2014-10-25T18:32:07+02:00"},
                                            @{
                                                @"@attributes": @{
                                                        @"accurate": @1,
                                                        @"headsign": @"Chantepie | Rosa Parks",
                                                        @"vehicle": @935,
                                                        @"expected": @"2014-10-25T18:31:00+02:00"
                                                        },
                                                @"content": @"2014-10-25T18:32:07+02:00"}
                                            ]
                                    }
                            }
                        ];
    
    _invalidStopLines = @[@{
                              @"stop": @1002,
                              @"direction": @0,
                              @"departures": @{
                                      @"departure": @[
                                              @{
                                                  @"@attributes": @{
                                                          @"accurate": @1,
                                                          @"headsign": @"Chantepie | Rosa Parks",
                                                          @"vehicle": @935,
                                                          @"expected": @"2014-10-25T18:31:00+02:00"
                                                          },
                                                  @"content": @"2014-10-25T18:32:07+02:00"},
                                              @{
                                                  @"@attributes": @{
                                                          @"accurate": @1,
                                                          @"headsign": @"Chantepie | Rosa Parks",
                                                          @"vehicle": @935,
                                                          @"expected": @"2014-10-25T18:31:00+02:00"
                                                          },
                                                  @"content": @"2014-10-25T18:32:07+02:00"}
                                              ]
                                      }
                              },
                          @{
                              @"stop": @1002,
                              @"route": @0001,
                              @"direction": @0,
                              @"departures": @{}
                              }
                          ];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Tests

- (void)testValidDeparturesCreation {
    XCTAssertTrue([AKStopLine stopLinesWithAttributes:_validStopLines].count == 2, @"Number of created stop lines should be 2");
}

- (void)testInvalidDeparturesCreation {
    XCTAssertTrue([AKStopLine stopLinesWithAttributes:_invalidStopLines].count == 0, @"Number of created stop lines should be 0");
}

@end
