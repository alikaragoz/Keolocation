//
//  AKKeoAPIErrorTests.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;
@import XCTest;

#import "AKKeoAPIError.h"

@interface AKKeoAPIErrorTests : XCTestCase

@property (nonatomic, strong) NSDictionary *validError;
@property (nonatomic, strong) NSDictionary *invalidError;

@end

@implementation AKKeoAPIErrorTests

#pragma mark - Setup

- (void)setUp {
    [super setUp];
    
    _validError = @{@"@attributes": @{ @"code": @0, @"message": @"OK"}};
    _invalidError = @{@"@attributes": @{ @"code": @{}, @"message": @0}};
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Tests

- (void)testValidErrorCreation {
    XCTAssertTrue([AKKeoAPIError errorWithAttributes:_validError] != nil);
}

- (void)testInvalidErrorCreation {
    XCTAssertTrue([AKKeoAPIError errorWithAttributes:_invalidError] == nil);
}

@end
