//
//  GWUserSession.m
//  GraffitiWalls
//
//  Created by Jakub Knejzlík on 28.06.12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "GNGeocoder.h"

#import <AFNetworking.h>
#import <CWLSynthesizeSingleton.h>

@interface GNGeocoder ()
@property (nonatomic,readonly) AFHTTPRequestOperationManager *operationManager;
@end


@implementation GNGeocoder
CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(GNGeocoder,sharedInstance);
@synthesize operationManager = _operationManager;

-(AFHTTPRequestOperationManager *)operationManager{
    if (!_operationManager) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api"]];
        _operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _operationManager;
}

#pragma mark - Google Location Stuff
//-(AFHTTPRequestOperation *)locationInfoForName:(NSString *)name type:(NSString *)type completionHandler:(void(^)(GNLocationInfo *location,NSError *error))completionHandler{
//    return [self locationsInfoForName:name completionHandler:^(NSArray *locations, NSError *error) {
//        if(!type)return completionHandler([locations firstObject],nil);
//        for (GNLocationInfo *locInfo in locations) {
//            if ([locInfo.types containsObject:type]) {
//                return completionHandler(locInfo,nil);
//            }
//        }
//        completionHandler(nil,error);
//    }];
//}
//-(AFHTTPRequestOperation *)locationsInfoForName:(NSString *)name completionHandler:(void (^)(NSArray *, NSError *))completionHandler{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:CZ&language=cs",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    return [self sendOperationWithURL:url withCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSMutableArray *results = [NSMutableArray array];
//        NSLog(@"%@",responseObject);
//        for (NSDictionary *resultData in [responseObject objectForKey:@"results"]) {
//            [results addObject:[[GNLocationInfo alloc] initWithResultData:resultData]];
//        }
//        completionHandler(results,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completionHandler(nil,error);
//    }];
//}
//-(AFHTTPRequestOperation *)locationInfoForLocation:(CLLocation *)location type:(NSString *)type completionHandler:(void (^)(GNLocationInfo *, NSError *))completionHandler{
//    return [self locationsInfoForLocation:location completionHandler:^(NSArray *locations, NSError *error) {
//        if(!type)return completionHandler([locations firstObject],nil);
//        for (GNLocationInfo *locInfo in locations) {
//            if ([locInfo.types containsObject:type]) {
//                return completionHandler(locInfo,nil);
//            }
//        }
//        completionHandler(nil,error);
//    }];
//}
//-(AFHTTPRequestOperation *)locationsInfoForLocation:(CLLocation *)location completionHandler:(void(^)(NSArray *locations,NSError *error))completionHandler{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&components=country:CZ&language=cs",location.coordinate.latitude,location.coordinate.longitude]];
//    return [self sendOperationWithURL:url withCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSMutableArray *results = [NSMutableArray array];
//        for (NSDictionary *resultData in responseObject[@"results"]) {
//            [results addObject:[[GNLocationInfo alloc] initWithResultData:resultData]];
//        }
//        completionHandler(results,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completionHandler(nil,error);
//    }];
//}
//-(AFHTTPRequestOperation *)geocodeName:(NSString *)name completionHandler:(void (^)(GNLocationInfo *, NSError *))completionHandler{
//    
//}


-(NSOperation *)geocodeName:(NSString *)name success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    return [self geocodeName:name attributes:nil success:success failure:failure];
}
-(NSOperation *)geocodeName:(NSString *)name attributes:(GNGeocoderAttributes *)attributes success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [[self geocodingParametersFromAttributes:attributes] mutableCopy];
    [params setObject:name forKey:@"address"];
    AFHTTPRequestOperation *op = [self.operationManager GET:@"geocode/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *results = [NSMutableArray array];
        if([responseObject[@"status"] isEqualToString:@"OK"]){
            for (NSDictionary *resultData in responseObject[@"results"]) {
                [results addObject:[[GNLocationInfo alloc] initWithResultData:resultData]];
            }
            success(results);
        }else{
            [self handleStatusCode:responseObject[@"status"] withFailureHandler:failure];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    NSLog(@"%@",op.request.URL);
    
    return op;
}



-(NSOperation *)reverseGeocodeLocation:(CLLocation *)location success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    return [self reverseGeocodeLocation:location attributes:nil success:success failure:failure];
}
-(NSOperation *)reverseGeocodeLocation:(CLLocation *)location attributes:(GNReverseGeocoderAttributes *)attributes success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [[self reverseGeocodingParametersFromAttributes:attributes] mutableCopy];
    [params setObject:[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude] forKey:@"latlng"];
    AFHTTPRequestOperation *op = [self.operationManager GET:@"geocode/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *results = [NSMutableArray array];
        if([responseObject[@"status"] isEqualToString:@"OK"]){
            for (NSDictionary *resultData in responseObject[@"results"]) {
                [results addObject:[[GNLocationInfo alloc] initWithResultData:resultData]];
            }
            success(results);
        }else{
            [self handleStatusCode:responseObject[@"status"] withFailureHandler:failure];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    NSLog(@"%@",op.request.URL);
    
    return op;
}


-(void)handleStatusCode:(NSString *)statusCode withFailureHandler:(void(^)(NSError *error))failureHandler{
    NSArray *errorStatuses = @[@"ZERO_RESULTS",@"OVER_QUERY_LIMIT",@"REQUEST_DENIED",@"INVALID_REQUEST",@"UNKNOWN_ERROR"];
    NSInteger errorCode = [errorStatuses indexOfObject:statusCode];
    NSError *error = [NSError errorWithDomain:@"GNGeocoder response failure" code:errorCode userInfo:@{@"statusCode":statusCode}];
    failureHandler(error);
}

-(NSMutableDictionary *)parametersFromAttributes:(GNGeocoderBaseAttributes *)attributes{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *lang = (attributes.language?attributes.language:[[NSLocale preferredLanguages] firstObject]);
    if (lang) {
        [dict setObject:lang forKey:@"language"];
    }
    
    if (attributes.apiKey) {
        [dict setObject:attributes.apiKey forKey:@"key"];
    } else if (self.apiKey) {
        [dict setObject:self.apiKey forKey:@"key"];
    }
    
    return dict;
}
-(NSMutableDictionary *)geocodingParametersFromAttributes:(GNGeocoderAttributes *)attributes{
    NSMutableDictionary *dict = [self parametersFromAttributes:attributes];
    
    
    if (attributes.boundsRegion) {
        [dict setObject:[self boundsStringFromRegion:attributes.boundsRegion] forKey:@"bounds"];
    }
    
    if (attributes.components.allValues.count > 0) {
        [dict setObject:[self componentsStringFromDictionary:attributes.components] forKey:@"components"];
    }
    
    if (attributes.region) {
        [dict setObject:attributes.region forKey:@"region"];
    }
    
    return dict;
}
-(NSMutableDictionary *)reverseGeocodingParametersFromAttributes:(GNReverseGeocoderAttributes *)attributes{
    NSMutableDictionary *dict = [self parametersFromAttributes:attributes];
    
    if (attributes.resultTypes.count > 0) {
        [dict setObject:[attributes.resultTypes componentsJoinedByString:@"|"] forKey:@"result_type"];
    }
    
    if (attributes.locationTypes.count > 0) {
        [dict setObject:[attributes.locationTypes componentsJoinedByString:@"|"] forKey:@"location_type"];
    }
    
    return dict;
}

- (NSString*)boundsStringFromRegion:(CLCircularRegion *)region {
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(region.center, region.radius, region.radius);
    
    NSString *bounds = [NSString stringWithFormat:@"%f,%f|%f,%f",
                        coordinateRegion.center.latitude-(coordinateRegion.span.latitudeDelta/2.0),
                        coordinateRegion.center.longitude-(coordinateRegion.span.longitudeDelta/2.0),
                        coordinateRegion.center.latitude+(coordinateRegion.span.latitudeDelta/2.0),
                        coordinateRegion.center.longitude+(coordinateRegion.span.longitudeDelta/2.0)];
    
    return bounds;
}
- (NSString*)componentsStringFromDictionary:(NSDictionary *)components {
    NSMutableArray *preparedComponents = [NSMutableArray new];
    
    [components enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL *stop) {
        NSString *component = [NSString stringWithFormat:@"%@:%@", key, value];
        [preparedComponents addObject:component];
    }];
    
    NSString *componentsValue = [preparedComponents componentsJoinedByString:@"|"];
    
    return componentsValue;
}


@end
