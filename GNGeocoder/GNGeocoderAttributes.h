//
//  GNGeocoderAttributes.h
//  GNGeocoder
//
//  Created by Jakub Knejzlik on 06/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNGeocoderBaseAttributes.h"

// https://developers.google.com/maps/documentation/geocoding/?csw=1#geocoding

extern NSString *const kGNLocationComponentRoute;
extern NSString *const kGNLocationComponentLocality;
extern NSString *const kGNLocationComponentAdministrativeArea;
extern NSString *const kGNLocationComponentPostalCode;
extern NSString *const kGNLocationComponentCountry;

@interface GNGeocoderAttributes : GNGeocoderBaseAttributes

@property (nonatomic) CLCircularRegion *boundsRegion;

@property (nonatomic,copy) NSString *region;

@property (nonatomic,strong) NSArray *locationTypes;

@property (nonatomic,strong) NSDictionary *components;

-(void)setValue:(NSString *)value forComponent:(NSString *)component;


@end
