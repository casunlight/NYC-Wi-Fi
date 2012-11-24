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
#import <CoreData/CoreData.h> // necessary?
#import "ListViewController.h"
#import "WEPopoverController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController : UIViewController<MKMapViewDelegate, UITableViewDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate> {
    BOOL _doneInitialZoom;
    WEPopoverController *popoverController;
    Class popoverClass;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (strong, nonatomic) LocationInfo *selectedLocation;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) WEPopoverController *popoverController;
- (IBAction)showPopover:(UIBarButtonItem *)sender;

@end
