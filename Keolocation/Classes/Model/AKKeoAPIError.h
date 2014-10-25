//
//  AKKeoAPIError.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import <Foundation/Foundation.h>

@interface AKKeoAPIError : NSObject

@property (readonly, nonatomic, assign) NSInteger code;
@property (readonly, nonatomic, copy) NSString *message;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (AKKeoAPIError *)errorWithAttributes:(NSDictionary *)attributes;

@end
