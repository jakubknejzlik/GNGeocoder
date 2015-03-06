//
//  GNLocationSearchResult.m
//
//  Created by Jakub Knejzlik on 09/08/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "GNLocationInfo.h"

NSString *const kGNLocationTypeStreetAddress = @"streed_address";
NSString *const kGNLocationTypeRoute = @"route";
NSString *const kGNLocationTypeIntersection = @"intersection";
NSString *const kGNLocationTypePolitical = @"political";
NSString *const kGNLocationTypeCountry = @"country";
NSString *const kGNLocationTypeAdministrativeAreaLevel1 = @"administrative_area_level_1";
NSString *const kGNLocationTypeAdministrativeAreaLevel2 = @"administrative_area_level_2";
NSString *const kGNLocationTypeAdministrativeAreaLevel3 = @"administrative_area_level_3";
NSString *const kGNLocationTypeAdministrativeAreaLevel4 = @"administrative_area_level_4";
NSString *const kGNLocationTypeAdministrativeAreaLevel5 = @"administrative_area_level_5";
NSString *const kGNLocationTypeColloquialArea = @"colloquial_area";
NSString *const kGNLocationTypeLocality = @"locality";
NSString *const kGNLocationTypeWard = @"ward";
NSString *const kGNLocationTypeSublocality = @"sublocality";
NSString *const kGNLocationTypeSublocalityLevel1 = @"sublocality_level_1";
NSString *const kGNLocationTypeSublocalityLevel2 = @"sublocality_level_2";
NSString *const kGNLocationTypeSublocalityLevel3 = @"sublocality_level_3";
NSString *const kGNLocationTypeSublocalityLevel4 = @"sublocality_level_4";
NSString *const kGNLocationTypeSublocalityLevel5 = @"sublocality_level_5";
NSString *const kGNLocationTypeNeighborhood = @"neighborhood";
NSString *const kGNLocationTypePremise = @"premise";
NSString *const kGNLocationTypeSubpremise = @"subpremise";
NSString *const kGNLocationTypePostalCode = @"postal_code";
NSString *const kGNLocationTypeNaturalFeature = @"natural_feature";
NSString *const kGNLocationTypeAirport = @"airport";
NSString *const kGNLocationTypePark = @"park";
NSString *const kGNLocationTypePointOfInterest = @"point_of_interest";
NSString *const kGNLocationTypeFloor = @"floor";
NSString *const kGNLocationTypeEstablishment = @"stablishment";
NSString *const kGNLocationTypeParking = @"parking";
NSString *const kGNLocationTypePostBox = @"post_box";
NSString *const kGNLocationTypePostalTown = @"postal_town";
NSString *const kGNLocationTypeRoom = @"room";
NSString *const kGNLocationTypeStreetNumber = @"street_number";
NSString *const kGNLocationTypeBusStation = @"bus_station";
NSString *const kGNLocationTypeTrainStation = @"train_station";
NSString *const kGNLocationTypeTransitStation = @"transit_station"; 


@interface GNLocationInfo ()
@property (nonatomic,strong) NSDictionary *resultData;
@end

@implementation GNLocationInfo

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.resultData = [aDecoder decodeObjectForKey:@"resultData"];
    }
    return self;
}
-(id)initWithResultData:(NSDictionary *)resultData{
    self = [super init];
    if (self) {
        self.resultData = resultData;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.resultData forKey:@"resultData"];
}

-(CLLocation *)location{
    return [[CLLocation alloc] initWithLatitude:[[[[self.resultData objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue] longitude:[[[[self.resultData objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]];
}
-(MKCoordinateRegion)bounds{
    return [self regionWithData:[[self.resultData objectForKey:@"geometry"] objectForKey:@"bounds"]];
}
-(MKCoordinateRegion)viewport{
    return [self regionWithData:[[self.resultData objectForKey:@"geometry"] objectForKey:@"viewport"]];
}

-(MKCoordinateRegion)regionWithData:(NSDictionary *)data{
    double nelat = [data[@"northeast"][@"lat"] doubleValue];
    double nelng = [data[@"northeast"][@"lng"] doubleValue];
    double swlat = [data[@"southwest"][@"lat"] doubleValue];
    double swlng = [data[@"southwest"][@"lng"] doubleValue];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((nelat+swlat)/2.0, (nelng+swlng)/2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(ABS(nelat-swlat), ABS(nelng-swlng));
    return MKCoordinateRegionMake(center, span);
}


-(NSString *)formattedAddress{
    return [self.resultData objectForKey:@"formatted_address"];
}
-(NSArray *)types{
    return [self.resultData objectForKey:@"types"];
}

-(NSString *)longAddressComponentWithType:(NSString *)type{
    return [self longAddressComponentWithTypes:@[type]];
}
-(NSString *)longAddressComponentWithTypes:(NSArray *)types{
    return [self addressComponentWithTypes:types long:YES];
}
-(NSString *)shortAddressComponentWithType:(NSString *)type{
    return [self shortAddressComponentWithTypes:@[type]];
}
-(NSString *)shortAddressComponentWithTypes:(NSArray *)types{
    return [self addressComponentWithTypes:types long:NO];
}
-(NSString *)addressComponentWithTypes:(NSArray *)types long:(BOOL)isLong{
    for (NSString *type in types) {
        for (NSDictionary *component in [self.resultData objectForKey:@"address_components"]) {
            if ([[component objectForKey:@"types"] containsObject:type]) {
                if (isLong)return [component objectForKey:@"long_name"];
                else return [component objectForKey:@"short_name"];
            }
        }
    }
    return nil;
}

@end
