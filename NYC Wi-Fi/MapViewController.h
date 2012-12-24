//
//  MapViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 8/28/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ListViewController.h"
#import "WEPopoverController.h"
#import "PopoverViewController.h"
#import "AboutViewController.h"
#import "SettingsTVC.h"
#import "WifiClusterMapView.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController : UIViewController<MKMapViewDelegate, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UISearchBarDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate, CLLocationManagerDelegate, PopoverViewControllerDelegate, MFMailComposeViewControllerDelegate, AboutViewControllerDelegate, SettingsTVCDelegate> {
    BOOL _doneInitialZoom;
    //CLLocationDegrees zoomLevel;
    CLLocationManager *locationManager;
    WEPopoverController *popoverController;
    Class popoverClass;
    //WifiClusterMapView *_mapView;
}

@property (strong, nonatomic) IBOutlet WifiClusterMapView *mapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (strong, nonatomic) LocationInfo *selectedLocation;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSPredicate *filterPredicate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
//- (void)filterAnnotations:(NSArray *)placesToFilter;
- (void)setupFilterPredicate;
- (IBAction)showPopover:(UIBarButtonItem *)sender;
- (void)searchLocations;
- (void)geolocateAddressAndZoomOnMap:(NSString *)address;
- (void)showUserLocation;

@end
