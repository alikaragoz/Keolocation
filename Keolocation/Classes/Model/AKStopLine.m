//
//  AKStopLine.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "KZAsserts.h"

#import "AKDeparture.h"
#import "AKStopLine.h"

@implementation AKStopLine

#pragma mark - Init

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    AssertTrueOrReturnNil([attributes isKindOfClass:NSDictionary.class]);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    id departures, componement;
    
    // Route
    componement = attributes[@"route"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _route = [componement integerValue];
    } else {
        return nil;
    }
    
    // Directions
    departures = attributes[@"departures"];
    if([departures isKindOfClass:NSDictionary.class]) {
        
        componement = departures[@"departure"];
        
        // When there are several results, `departure` is an array.
        if ([componement isKindOfClass:NSArray.class] && [(NSArray *)componement count] > 0) {
            _departures = [AKDeparture departuresWithArray:componement];
        }
        
        // When there is only on result, `departure` is a dictionary.
        else if([componement isKindOfClass:NSDictionary.class]) {
            AKDeparture *departure = [AKDeparture departureWithAttributes:componement];
            if (departure) {
                _departures = @[departure];
            }
        }
        
        else {
            return nil;
        }
        
    } else {
        return nil;
    }
    
    return self;
}

#pragma mark - Factory Methods

+ (AKStopLine *)stopLineWithAttributes:(NSDictionary *)attributes {
    return [[AKStopLine alloc] initWithAttributes:attributes];
}

+ (NSArray *)stopLinesWithAttributes:(id)attributes {
    
    NSMutableArray *stopLines = [NSMutableArray array];
    
    if ([attributes isKindOfClass:NSArray.class] && [(NSArray *)attributes count] > 0) {
        
        for (id stopLineAttributes in attributes) {
            
            if (![stopLineAttributes isKindOfClass:NSDictionary.class]) {
                continue;
            }
            
            AKStopLine *stopLine = [AKStopLine stopLineWithAttributes:stopLineAttributes];
            if (!stopLine) {
                continue;
            }
            
            [stopLines addObject:stopLine];
        }
        
    }
    
    else if([attributes isKindOfClass:NSDictionary.class]) {
        
        AKStopLine *stopLine = [AKStopLine stopLineWithAttributes:attributes];
        if (stopLine) {
            [stopLines addObject:stopLine];
        }
    }
    
    return stopLines;
}

@end
