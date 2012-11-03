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

#define EXPERIEMENTAL_ORIENTATION_SUPPORT 1
#define METERS_PER_MILE 1609.344

@class SidebarViewController;

@protocol MapViewControllerDelegate

//- (void)theListButtonOnTheMapViewControllerWasTapped:(MapViewController *)controller;

@end

@interface MapViewController : UIViewController<NSFetchedResultsControllerDelegate, MKMapViewDelegate, UITableViewDelegate> {
    BOOL _doneInitialZoom;
    SingletonObj * displayToggle;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SidebarViewController *leftSidebarViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender;
- (IBAction)displayList:(UIBarButtonItem *)sender;

@end
