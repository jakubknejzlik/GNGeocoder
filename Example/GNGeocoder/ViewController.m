//
//  ViewController.m
//  GNGeocoder
//
//  Created by Jakub Knejzlik on 06/03/15.
//  Copyright (c) 2015 Jakub Knejzlik. All rights reserved.
//

#import "ViewController.h"

#import "GNGeocoder.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSArray *locations;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"test";
    
    [[GNGeocoder sharedInstance] reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:37.332057 longitude:-122.029658] attributes:nil success:^(NSArray *locations) {
        GNLocationInfo *location = [locations firstObject];
        NSLog(@"%@",[location formattedAddress]);
    } failure:^(NSError *error) {
        NSLog(@"reverse lookup failed %@",error);
    }];
}



#pragma mark - TableView Stuff
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.locations count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    GNLocationInfo *info = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = info.formattedAddress;
    
    return cell;
}

#pragma mark - TextField Delegate Stuff
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    GNGeocoderAttributes *attrs = [[GNGeocoderAttributes alloc] init];
    attrs.language = @"cs";
    attrs.locationTypes = @[kGNLocationTypeLocality];
//    attrs.viewport = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(49.927691, 15.576536) radius:1000 identifier:@"cz"];
    [attrs setValue:@"CZ" forComponent:kGNLocationComponentCountry];
    [[GNGeocoder sharedInstance] geocodeName:textField.text attributes:attrs success:^(NSArray *locations) {
        self.locations = locations;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"geocoding error %@",error);
    }];
    return YES;
}

@end
