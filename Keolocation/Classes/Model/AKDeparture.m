//
//  AKDeparture.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "KZAsserts.h"

#import "AKDeparture.h"

@interface AKDeparture ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AKDeparture

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
    
    // Vehicle
    componement = attr[@"vehicle"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _vehicle = [componement integerValue];
    } else {
        return nil;
    }
    
    // Time
    componement = attr[@"expected"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        
        // Converting the string to a date.
        NSDate *date;
        NSError *error;
        [self.dateFormatter getObjectValue:&date forString:componement range:nil error:&error];
        
        if (error) {
            return nil;
        }
        
        _time = date;
    } else {
        return nil;
    }
    
    return self;
}

#pragma mark - Factory Methods

+ (AKDeparture *)departureWithAttributes:(NSDictionary *)attributes {
    return [[AKDeparture alloc] initWithAttributes:attributes];
}

+ (NSArray *)departuresWithArray:(NSArray *)array {
    AssertTrueOrReturnNil([array isKindOfClass:NSArray.class]);
    
    NSMutableArray *departures = [NSMutableArray array];
    
    for (id departureAttributes in array) {
        if (![departureAttributes isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        AKDeparture *departure = [AKDeparture departureWithAttributes:departureAttributes];
        if (!departure) {
            continue;
        }
        
        [departures addObject:departure];
    }
    
    return departures;
}

#pragma mark - Date Formatting

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss''ZZZZZ'"];
        _dateFormatter = dateFormatter;
    }
    
    return _dateFormatter;
}

@end
