//
//  GNGeocoderAttributes.m
//  GNGeocoder
//
//  Created by Jakub Knejzlik on 06/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNGeocoderAttributes.h"

NSString *const kGNLocationComponentRoute = @"route";
NSString *const kGNLocationComponentLocality = @"locality";
NSString *const kGNLocationComponentAdministrativeArea = @"administrative_area";
NSString *const kGNLocationComponentPostalCode = @"postal_code";
NSString *const kGNLocationComponentCountry = @"country";


@implementation GNGeocoderAttributes

@synthesize components = _components;

-(NSDictionary *)components{
    if (!_components) {
        _components = [NSDictionary dictionary];
    }
    return _components;
}

-(void)setValue:(NSString *)value forComponent:(NSString *)component{
    NSMutableDictionary *dict = [self.components mutableCopy];
    [dict setObject:value forKey:component];
    self.components = [NSDictionary dictionaryWithDictionary:dict];
}

@end
