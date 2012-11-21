//
//  LocationDetailTVC.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationInfo.h"
#import "LocationDetails.h"

#define METERS_PER_MILE 1609.344

@interface LocationDetailTVC : UITableViewController {
    BOOL _doneInitialZoom;
}

@property (weak, nonatomic) LocationInfo *selectedLocation;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationName;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationType;
@property (strong, nonatomic) IBOutlet MKMapView *locationMap;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationAddress;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationPhone;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationWebsite;

- (void)setupLocationName;
- (void)setupLocationAddress;
- (void)setupLocationType;
- (void)callLocationPhoneNumber;
- (void)launchWebsiteInSafari;

@end