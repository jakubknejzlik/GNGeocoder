//
//  GNLocationSearchAttributes.h
//  GNLocationManager
//
//  Created by Jakub Knejzlik on 05/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface GNGeocoderBaseAttributes : NSObject

@property (nonatomic,strong) NSString *language;

@property (nonatomic,strong) NSString *apiKey; // if not specified the [[GNGeocoder sharedInstance] apiKey] is used

@end
