//
//  AKKeoAPIError.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "KZAsserts.h"

#import "AKKeoAPIError.h"

@implementation AKKeoAPIError

#pragma mark - Init

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    AssertTrueOrReturnNil([attributes isKindOfClass:NSDictionary.class]);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary *attr;
    id componement;
    
    // Attributes
    attr = attributes[@"@attributes"];
    if (![attr isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    // Code
    componement = attr[@"code"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _code = [componement integerValue];
    } else {
        return nil;
    }
    
    // Message
    componement = attr[@"message"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _message = componement;
    } else {
        return nil;
    }
    
    return self;
}

#pragma mark - Factory Methods

+ (AKKeoAPIError *)errorWithAttributes:(NSDictionary *)attributes {
    return [[AKKeoAPIError alloc] initWithAttributes:attributes];
}

@end
