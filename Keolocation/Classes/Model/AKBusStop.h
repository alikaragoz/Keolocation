//
//  AKBusStop.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import Foundation;
@import MapKit;

@interface AKBusStop : NSObject <MKAnnotation>

@property (readonly, nonatomic, assign) NSUInteger identifier;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, assign) double latitude;
@property (readonly, nonatomic, assign) double longitude;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (AKBusStop *)busStopWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)busStopsWithArray:(NSArray *)array;

@end
