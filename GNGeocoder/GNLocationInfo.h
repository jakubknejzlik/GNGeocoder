//
//  GNLocationSearchResult.h
//
//  Created by Jakub Knejzlik on 09/08/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

extern NSString *const kGNLocationTypeStreetAddress;
extern NSString *const kGNLocationTypeRoute;
extern NSString *const kGNLocationTypeIntersection;
extern NSString *const kGNLocationTypePolitical;
extern NSString *const kGNLocationTypeCountry;
extern NSString *const kGNLocationTypeAdministrativeAreaLevel1;
extern NSString *const kGNLocationTypeAdministrativeAreaLevel2;
extern NSString *const kGNLocationTypeAdministrativeAreaLevel3;
extern NSString *const kGNLocationTypeAdministrativeAreaLevel4;
extern NSString *const kGNLocationTypeAdministrativeAreaLevel5;
extern NSString *const kGNLocationTypeColloquialArea;
extern NSString *const kGNLocationTypeLocality;
extern NSString *const kGNLocationTypeWard;
extern NSString *const kGNLocationTypeSublocality;
extern NSString *const kGNLocationTypeSublocalityLevel1;
extern NSString *const kGNLocationTypeSublocalityLevel2;
extern NSString *const kGNLocationTypeSublocalityLevel3;
extern NSString *const kGNLocationTypeSublocalityLevel4;
extern NSString *const kGNLocationTypeSublocalityLevel5;
extern NSString *const kGNLocationTypeNeighborhood;
extern NSString *const kGNLocationTypePremise;
extern NSString *const kGNLocationTypeSubpremise;
extern NSString *const kGNLocationTypePostalCode;
extern NSString *const kGNLocationTypeNaturalFeature;
extern NSString *const kGNLocationTypeAirport;
extern NSString *const kGNLocationTypePark;
extern NSString *const kGNLocationTypePointOfInterest;
extern NSString *const kGNLocationTypeFloor;
extern NSString *const kGNLocationTypeEstablishment;
extern NSString *const kGNLocationTypeParking;
extern NSString *const kGNLocationTypePostBox;
extern NSString *const kGNLocationTypePostalTown;
extern NSString *const kGNLocationTypeRoom;
extern NSString *const kGNLocationTypeStreetNumber;
extern NSString *const kGNLocationTypeBusStation;
extern NSString *const kGNLocationTypeTrainStation;
extern NSString *const kGNLocationTypeTransitStation;

@interface GNLocationInfo : NSObject <NSCoding>
@property (nonatomic,readonly) CLLocation *location;
@property (nonatomic,readonly) MKCoordinateRegion bounds;
@property (nonatomic,readonly) MKCoordinateRegion viewport;

@property (nonatomic,readonly) NSString *formattedAddress;
@property (nonatomic,readonly) NSArray *types;

-(NSString *)longAddressComponentWithType:(NSString *)type;
-(NSString *)longAddressComponentWithTypes:(NSArray *)types;
-(NSString *)shortAddressComponentWithType:(NSString *)type;
-(NSString *)shortAddressComponentWithTypes:(NSArray *)types;

-(id)initWithResultData:(NSDictionary *)resultData;

@end
