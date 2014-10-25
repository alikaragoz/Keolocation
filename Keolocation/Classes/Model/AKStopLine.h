//
//  AKStopLine.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import <Foundation/Foundation.h>

@interface AKStopLine : NSObject

@property (readonly, nonatomic, assign) NSInteger route;
@property (readonly, nonatomic, strong) NSArray *departures;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (AKStopLine *)stopLineWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)stopLinesWithAttributes:(id)attributes;

@end
