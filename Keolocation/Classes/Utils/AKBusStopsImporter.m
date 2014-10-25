//
//  AKBusStopsImporter.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "AKBusStopsImporter.h"

@implementation AKBusStopsImporter

+ (NSArray *)busStopsWithError:(NSError **)error {
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stops" ofType:@"json"]];
    
    if (![data isKindOfClass:NSData.class]) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
}

@end
