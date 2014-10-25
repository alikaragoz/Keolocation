//
//  KeoAPIClient.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;

#import "KZAsserts.h"

#import "AKKeoAPIError.h"
#import "KeoAPIClient.h"
#import "KeolocationConstants.h"

@implementation KeoAPIClient

#pragma mark - Date Fetching

+ (void)getDeparturesWithBusStopIdentifier:(NSUInteger)identifier completion:(void (^)(id, NSError *))completion {
    AssertTrueOrReturn(completion != nil);
    
    NSDictionary *parameters = @{
                                 @"version" : @"2.2",
                                 @"key" : KeoLocationAPIClientKey,
                                 @"cmd" : @"getbusnextdepartures",
                                 @"param[mode]" : @"stop",
                                 @"param[stop][]" : [NSString stringWithFormat:@"%lu", (unsigned long)identifier]
                                 };
    
    [KeoAPIClient getPath:KeoLocationAPIClientPath parameters:parameters completion:completion];
    
}

+ (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    AssertTrueOrReturn(path != nil || [path isKindOfClass:NSString.class]);
    AssertTrueOrReturn(parameters || [parameters isKindOfClass:NSDictionary.class]);
    AssertTrueOrReturn(completion != nil);
    
    [KeoAPIClient setNetworkActivityIndicatorVisible:YES];
    
    // Building the query URL.
    NSMutableString *parametersString = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [parametersString appendFormat:@"%@=%@&", key, obj];
    }];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/", KeoLocationAPIClientURL, path];
    
    if ([parametersString length] > 0) {
        urlString = [urlString stringByAppendingFormat:@"?%@", parametersString];
    }
    
    // Making the request.
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [KeoAPIClient setNetworkActivityIndicatorVisible:NO];
        
        
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        }
        
        else {
            
            // Converting the json payload to exploitable format.
            NSError *err = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            // We need to check if there is an error code.
            if ([json isKindOfClass:NSDictionary.class]) {
                
                NSDictionary *status = [json valueForKeyPath:@"opendata.answer.status"];
                if ([status isKindOfClass:NSDictionary.class]) {
                    
                    AKKeoAPIError *apiError = [AKKeoAPIError errorWithAttributes:status];
                    if (apiError && apiError.code != 0) {
                        err = [NSError errorWithDomain:@"com.alikaragoz.Keolocation"
                                                  code:apiError.code
                                              userInfo:@{ NSLocalizedDescriptionKey : apiError.message}];
                    }
                }
            }
            
            if (err) {
                if (completion) {
                    completion(nil, error);
                }
                return;
            }
            
            // Everything when fine.
            if (completion) {
                completion(json, nil);
            }
        }
    }];
    
    [task resume];
}

#pragma mark - Activity indicator

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSUInteger kNetworkIndicatorCount = 0;
    
    if (setVisible) {
        kNetworkIndicatorCount++;
    } else {
        kNetworkIndicatorCount--;
    }
    
    AssertTrueOrReturn(kNetworkIndicatorCount >= 0);
    
    // Display the indicator as long as our static counter is > 0.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(kNetworkIndicatorCount > 0)];
    });
}

@end
