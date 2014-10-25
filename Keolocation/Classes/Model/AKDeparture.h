//
//  AKDeparture.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import Foundation;

@interface AKDeparture : NSObject

@property (readonly, nonatomic, assign) NSInteger vehicle;
@property (readonly, nonatomic, strong) NSDate *time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (AKDeparture *)departureWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)departuresWithArray:(NSArray *)array;

@end
