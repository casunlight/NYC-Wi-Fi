//
//  LocationDetailTVC.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "LocationDetailTVC.h"

@implementation LocationDetailTVC
@synthesize locationName = _locationName;
@synthesize locationAddress1 = _locationAddress1;
@synthesize locationAddress2 = _locationAddress2;
@synthesize locationType = _locationType;
@synthesize locationPhone = _locationPhone;
@synthesize selectedLocation = _selectedLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationName.text = self.selectedLocation.name;
    //_locationName.numberOfLines = 2;
    _locationAddress1.text = self.selectedLocation.address;
    //_locationAddress2.text = @"%@, %@", self.selectedLocation.city
    _locationType.text = self.selectedLocation.fee_type;
    _locationPhone.textLabel.text = self.selectedLocation.details.phone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLocationName:nil];
    [self setLocationAddress1:nil];
    [self setLocationAddress2:nil];
    [self setLocationType:nil];
    [self setLocationPhone:nil];
    [super viewDidUnload];
}
@end
