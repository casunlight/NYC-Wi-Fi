//
//  LocationDetailTVC.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationInfo.h"
#import "LocationDetails.h"

@interface LocationDetailTVC : UITableViewController

- (void)setupLocationName;
- (void)setupLocationAddress;

@property (weak, nonatomic) LocationInfo *selectedLocation;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationName;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationType;
@property (strong, nonatomic) IBOutlet MKMapView *locationMap;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationAddress;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationPhone;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationWebsite;

@end