//
//  GWUserSession.h
//  GraffitiWalls
//
//  Created by Jakub Knejzlík on 28.06.12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "GNLocationInfo.h"
#import "GNGeocoderAttributes.h"
#import "GNReverseGeocoderAttributes.h"

typedef NS_ENUM(NSUInteger, GNGeocoderStatus) {
    GNGeocoderStatusZeroResultsError,
    GNGeocoderStatusOverQueryLimitError,
    GNGeocoderStatusRequestDeniedError,
    GNGeocoderStatusInvalidRequestError,
    GNGeocoderStatusUnknownError,
};

@interface GNGeocoder : NSObject<CLLocationManagerDelegate>

@property (nonatomic,copy) NSString *apiKey;

+(GNGeocoder *)sharedInstance;

-(NSOperation *)geocodeName:(NSString *)name success:(void(^)(NSArray *locations))success failure:(void(^)(NSError *error))failure;
-(NSOperation *)geocodeName:(NSString *)name attributes:(GNGeocoderAttributes *)attributes success:(void(^)(NSArray *locations))success failure:(void(^)(NSError *error))failure;

-(NSOperation *)reverseGeocodeLocation:(CLLocation *)location success:(void(^)(NSArray *locations))success failure:(void(^)(NSError *error))failure;
-(NSOperation *)reverseGeocodeLocation:(CLLocation *)location attributes:(GNReverseGeocoderAttributes *)attributes success:(void(^)(NSArray *locations))success failure:(void(^)(NSError *error))failure;

//-(AFHTTPRequestOperation *)locationForName:(NSString *)name completionHandler:(void(^)(GNLocationInfo *location,NSError *error))completionHandler;

@end

