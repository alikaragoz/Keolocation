//
//  AKBusStop.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "KZAsserts.h"

#import "AKBusStop.h"

@implementation AKBusStop

#pragma mark - Init

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    AssertTrueOrReturnNil([attributes isKindOfClass:NSDictionary.class]);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    id componement;
    
    // Id
    componement = attributes[@"stop_id"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _identifier = [componement integerValue];
    } else {
        return nil;
    }
    
    // Name
    componement = attributes[@"stop_name"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _name = componement;
    } else {
        return nil;
    }
    
    // Latitude
    componement = attributes[@"stop_lat"];
    if ([componement respondsToSelector:@selector(doubleValue)]) {
        _latitude = [componement doubleValue];
    } else {
        return nil;
    }
    
    // Longitude
    componement = attributes[@"stop_lon"];
    if ([componement respondsToSelector:@selector(doubleValue)]) {
        _longitude = [componement doubleValue];
    } else {
        return nil;
    }
    
    return self;
}


#pragma mark - Factory Methods

+ (AKBusStop *)busStopWithAttributes:(NSDictionary *)attributes {
    return [[AKBusStop alloc] initWithAttributes:attributes];
}

+ (NSArray *)busStopsWithArray:(NSArray *)array {
    AssertTrueOrReturnNil([array isKindOfClass:NSArray.class]);
    
    NSMutableArray *busStops = [NSMutableArray array];
    
    for (id busStopAttributes in array) {
        if (![busStopAttributes isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        AKBusStop *busStop = [AKBusStop busStopWithAttributes:busStopAttributes];
        if (!busStop) {
            continue;
        }
        
        [busStops addObject:busStop];
    }
    
    return busStops;
}

#pragma mark - <MKAnnotation>

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (NSString *)title {
    return self.name;
}

@end
