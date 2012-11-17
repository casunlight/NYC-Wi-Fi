//
//  MapViewController.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 8/28/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "MapViewController.h"
//#import "ListViewController.h"
#import "MapLocation.h"
#import "LocationInfo.h"
#import "LocationDetails.h"
#import "ASIHTTPRequest.h"
#import "SMXMLDocument.h"
#import "MBProgressHUD.h"
//#import "CLLocation+Geocodereverse.h"

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchedLocations = _fetchedLocations;
//@synthesize leftSidebarViewController;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapLocation";
    if ([annotation isKindOfClass:[MapLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //annotationView.image = [UIImage imageNamed:@"wifi-pin.png"];
        
        return annotationView;
    }
    return nil;
}

- (void)importCoreDataDefaultLocations:(NSString *)responseString {
    
    NSLog(@"Importing Core Data Default Values for Locations...");
    
    NSData* xmlData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:xmlData error:&error];
    SMXMLElement *mapLocations = [document.root childNamed:@"row"];
    
    for (SMXMLElement *mapLocation in [mapLocations childrenNamed:@"row"]) {
        LocationInfo *locationInfo = [NSEntityDescription insertNewObjectForEntityForName:@"LocationInfo"
                                                                   inManagedObjectContext:self.managedObjectContext];
        
        locationInfo.name = [mapLocation valueWithPath:@"name"];
        locationInfo.address = [mapLocation valueWithPath:@"address"];
        locationInfo.fee_type = [mapLocation valueWithPath:@"type"];
        
        LocationDetails *locationDetails = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"LocationDetails"
                                            inManagedObjectContext:self.managedObjectContext];
        
        SMXMLElement *shape = [mapLocation childNamed:@"shape"];
        locationDetails.latitude = [NSNumber numberWithDouble:[[shape attributeNamed:@"latitude"] doubleValue]];
        locationDetails.longitude = [NSNumber numberWithDouble:[[shape attributeNamed:@"longitude"] doubleValue]];
        locationDetails.city = [mapLocation valueWithPath:@"city"];
        locationDetails.zip = [NSNumber numberWithInteger:[[shape attributeNamed:@"zip"] integerValue]];
        locationDetails.phone = [mapLocation valueWithPath:@"phone"];
        locationDetails.info = locationInfo;
        locationInfo.details = locationDetails;
        
        [self.managedObjectContext save:nil];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Importing Core Data Default Values for Locations Completed!");
}

- (void)loadLocationsFromXML
{
    //NSURL *url = [NSURL URLWithString:@"https://nycopendata.socrata.com/api/views/ehc4-fktp/rows.xml"];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/ios/nycwifi/rows.xml"];
    
    __unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        [self importCoreDataDefaultLocations:responseString];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    [request startAsynchronous];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Refreshing locations...";
}

- (void)viewWillAppear:(BOOL)animated
{
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 40.746347;
    zoomLocation.longitude = -73.978011;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5.5*METERS_PER_MILE, 5.5*METERS_PER_MILE);
    
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //displayToggle = [SingletonObj singleObj];
    //displayToggle.gblStr = @"map";
    
    /* if (_managedObjectContext == nil) {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    } */
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    if (![[self.fetchedResultsController fetchedObjects] count] > 0) {
        NSLog(@"!!!!! --> There's nothing in the database so defaults will be inserted");
        [self loadLocationsFromXML];
    }
    else {
        NSLog(@"There's stuff in the database so skipping the import of default data");
    }
    
    [self plotMapLocations];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)plotMapLocations
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading locations...";
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    _fetchedLocations = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    
    for (LocationInfo *location in _fetchedLocations) {
        //NSLog(@"%@", location.name);
        LocationDetails *locationDetails = location.details;
        
        //CLLocation *coordinates = [address newGeocodeAddress];
        //NSLog(@"Coordinates - Latitude : %.10f, Longitude : %.10f", coordinates.coordinate.latitude, coordinates.coordinate.longitude);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = locationDetails.latitude.doubleValue;
        coordinate.longitude = locationDetails.longitude.doubleValue;
        //NSLog(@"%f, %f", locationDetails.latitude.doubleValue, locationDetails.longitude.doubleValue);
        
        MapLocation *annotation = [[MapLocation alloc] initWithName:location.name address:location.address coordinate:coordinate];
        /* SBPinAnnotation *annotation = [[SBPinAnnotation alloc] initWithCoordinate:coordinate
                                                                            title:localObject.objectName
                                                                        objecttId:localObject.objectId]; */
        [_mapView addAnnotation:annotation];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/* - (NSArray*)loadMapLocations
{
    NSArray *location1 = [[NSArray alloc] initWithObjects:@"Juan Valdez - Midtown", @"140 East 57 St, 10022", @"40.761236", @"-73.968805", nil];
    NSArray *location2 = [[NSArray alloc] initWithObjects:@"Whole Foods Cafe Tribeca", @"270 Greenwich St, 10007", @"40.715794", @"-74.011484", nil];
    NSArray *location3 = [[NSArray alloc] initWithObjects:@"New York Film Academy Cafe", @"51 Astor Pl, 10003", @"40.730153", @"-73.990799", nil];
    NSArray *location4 = [[NSArray alloc] initWithObjects:@"MANGIA - Chelsea", @"22 West 23rd St, 10023", @"40.742022", @"-73.990756", nil];
    NSArray *location5 = [[NSArray alloc] initWithObjects:@"Orchard House Cafe", @"1064 1st Ave, 10022", @"40.759155", @"-73.962432", nil];
    
    return [[NSArray alloc] initWithObjects:location1, location2, location3, location4, location5, nil];
} */

- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender {
}

/* - (void)theMapButtonOnTheListViewControllerWasTapped:(ListViewController *)controller
{
    // do something here like refreshing the table or whatever
    
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
} */

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"LocationInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //[fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

/* - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    //[self.tableView beginUpdates];
} */


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self fetchedResultsChangeInsert:anObject];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self fetchedResultsChangeDelete:anObject];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsChangeUpdate:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            // Do nothing
            break;
    }
}


/* - (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
} */

- (void)fetchedResultsChangeInsert:(NSObject*)anObject {
    LocationInfo *location = (LocationInfo*)anObject;
    LocationDetails *locationDetails = location.details;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = locationDetails.latitude.doubleValue;
    coordinate.longitude = locationDetails.longitude.doubleValue;
    
    MapLocation *annotation = [[MapLocation alloc] initWithName:location.name address:location.address coordinate:coordinate];
    [_mapView addAnnotation:annotation];
}

- (void)fetchedResultsChangeDelete:(NSObject*)anObject  {
    LocationInfo *location = (LocationInfo*)anObject;
    LocationDetails *locationDetails = location.details;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = locationDetails.latitude.doubleValue;
    coordinate.longitude = locationDetails.longitude.doubleValue;
    
    //In case we have more then one match for whatever reason
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:1];
    for (id annotation in _mapView.annotations) {
        
        if (annotation != _mapView.userLocation) {
            MapLocation *pinAnnotation = annotation;
            
            // THIS NEEDS TO BE CHANGED TO OBJECTID IN THE NEXT VERSION FOR LOCATION MANAGEMENT
            if ([[pinAnnotation address] isEqualToString:location.address]) {
                [toRemove addObject:annotation];
            }
        }
    }
    [_mapView removeAnnotations:toRemove];
}

- (void)fetchedResultsChangeUpdate:(NSObject*)anObject  {
    //Takes a little bit of overheard but it is simple
    [self fetchedResultsChangeDelete:anObject];
    [self fetchedResultsChangeInsert:anObject];
    
}

/* - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
} */

@end
