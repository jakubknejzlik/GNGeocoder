//
//  GNReverseGeocoderAttributes.h
//  GNGeocoder
//
//  Created by Jakub Knejzlik on 06/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "GNGeocoderBaseAttributes.h"

// https://developers.google.com/maps/documentation/geocoding/?csw=1#ReverseGeocoding

extern NSString *const kGNReverseLocationTypeRooftop;
extern NSString *const kGNReverseLocationTypeRangeInterpolated;
extern NSString *const kGNReverseLocationTypeGeometricCenter;
extern NSString *const kGNReverseLocationTypeApproximate;

@interface GNReverseGeocoderAttributes : GNGeocoderBaseAttributes

@property (nonatomic,strong) NSArray *resultTypes; // kGNLocationType...

@property (nonatomic,strong) NSArray *locationTypes; //kGNReverseLocationType...

@end
