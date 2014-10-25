//
//  KeoAPIClient.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import Foundation;

@interface KeoAPIClient : NSObject

+ (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion;
+ (void)getDeparturesWithBusStopIdentifier:(NSUInteger)identifier completion:(void (^)(id, NSError *))completion;
+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end
