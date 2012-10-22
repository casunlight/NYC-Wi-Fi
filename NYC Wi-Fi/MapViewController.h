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
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "SingletonObj.h"

// Orientation changing is not an officially completed feature,
// The main thing to fix is the rotation animation and the
// necessarity of the container created in AppDelegate. Please let
// me know if you've got any elegant solution and send me a pull request!
// You can change EXPERIEMENTAL_ORIENTATION_SUPPORT to 1 for testing purpose
#define EXPERIEMENTAL_ORIENTATION_SUPPORT 1
#define METERS_PER_MILE 1609.344

@class SidebarViewController;

@interface MapViewController : UIViewController<NSFetchedResultsControllerDelegate, MKMapViewDelegate, UITableViewDelegate> {
    BOOL _doneInitialZoom;
    SingletonObj * displayToggle;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SidebarViewController *leftSidebarViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, weak) id <ListViewControllerDelegate> delegate;
- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender;
- (IBAction)displayList:(UIBarButtonItem *)sender;

@end
