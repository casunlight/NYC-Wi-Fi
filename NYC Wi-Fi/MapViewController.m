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
#import "PopoverViewController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "WifiClusterAnnotationView.h"
//#import "CLLocation+Geocodereverse.h"

//mapview starting points
#define kCenterPointLatitude  40.746347
#define kCenterPointLongitude -73.978011
#define kSpanDeltaLatitude    5.5
#define kSpanDeltaLongitude   5.5

#define iphoneScaleFactorLatitude   9.0
#define iphoneScaleFactorLongitude  11.0

#define nycOpenDataWifiLocationsXMLAddress  @"https://data.cityofnewyork.us/api/views/ehc4-fktp/rows.xml"
#define localLocationsXMLAddress  @"http://127.0.0.1/ios/nycwifi/rows.xml"

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchedLocations = _fetchedLocations;
@synthesize selectedLocation = _selectedLocation;
@synthesize popoverController, locationManager;
//@synthesize leftSidebarViewController;

#pragma mark -
#pragma mark Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //static NSString *identifier = @"MapLocation";
    
    if ([annotation isKindOfClass:[MapLocation class]]) {
        
        MapLocation *pin = (MapLocation *)annotation;
        
        MKAnnotationView *annotationView;
        
        if ([pin nodeCount] > 0) {
            pin.name = @"___";
            
            annotationView = (WifiClusterAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            
            if( !annotationView )
                annotationView = (WifiClusterAnnotationView *) [[WifiClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
            
            if ([pin nodeCount] > 50) {
                annotationView.image = [UIImage imageNamed:@"red-cluster.png"];
            } else if ([pin nodeCount] > 25 && [pin nodeCount] < 50) {
                annotationView.image = [UIImage imageNamed:@"orange-cluster.png"];
            } else if ([pin nodeCount] > 10 && [pin nodeCount] < 25) {
                annotationView.image = [UIImage imageNamed:@"yellow-cluster.png"];
            } else {
                annotationView.image = [UIImage imageNamed:@"green-cluster.png"];
            }
        
            [(WifiClusterAnnotationView *)annotationView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
            
            annotationView.canShowCallout = NO;
        } else {
            
            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
            
            if (!annotationView)
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:@"pin"];
            else
                annotationView.annotation = annotation;
            
            if ([pin.location.fee_type isEqualToString:@"Free"])
                annotationView.image = [UIImage imageNamed:@"green-pin.png"];
            else
                annotationView.image = [UIImage imageNamed:@"orange-pin.png"];

            annotationView.backgroundColor = [UIColor clearColor];
            UIButton *goToDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = goToDetail;
            annotationView.draggable = NO;
            annotationView.highlighted = NO;
            annotationView.canShowCallout = YES;
        }
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view isKindOfClass:[WifiClusterAnnotationView class]])
        return;
    
    CLLocationCoordinate2D centerCoordinate = [(MapLocation *)view.annotation coordinate];
    
    MKCoordinateSpan newSpan =
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                         mapView.region.span.longitudeDelta/2.0);
    
    //mapView.region = MKCoordinateRegionMake(centerCoordinate, newSpan);
    
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
              animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    MapLocation *annotationView = view.annotation;
    self.selectedLocation = annotationView.location;
    NSLog(@"Callout tapped. Heading to LocationDetailTVC");
    [self performSegueWithIdentifier:@"Location Detail Segue" sender:self];
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
        locationInfo.fee_type = [self setupLocationType:locationInfo.name:[mapLocation valueWithPath:@"type"]];
        
        LocationDetails *locationDetails = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"LocationDetails"
                                            inManagedObjectContext:self.managedObjectContext];
        
        SMXMLElement *shape = [mapLocation childNamed:@"shape"];
        locationDetails.latitude = [NSNumber numberWithDouble:[[shape attributeNamed:@"latitude"] doubleValue]];
        locationDetails.longitude = [NSNumber numberWithDouble:[[shape attributeNamed:@"longitude"] doubleValue]];
        locationDetails.city = [mapLocation valueWithPath:@"city"];
        locationDetails.zip = [NSNumber numberWithInteger:[[mapLocation valueWithPath:@"zip"] integerValue]];
        //NSLog(@"%i", [locationDetails.zip integerValue]);
        locationDetails.phone = [mapLocation valueWithPath:@"phone"];
        locationDetails.url = [mapLocation valueWithPath:@"url"];
        locationDetails.info = locationInfo;
        locationInfo.details = locationDetails;
        
        [self.managedObjectContext save:nil];
    }
    
    NSLog(@"Importing Core Data Default Values for Locations Completed!");
}

- (NSString *)setupLocationType:(NSString *)locationName:(NSString *)locationType
{
    if ([locationName isEqualToString:@"Starbucks"] ||
        [locationName isEqualToString:@"McDonalds"] ||
        [locationName isEqualToString:@"McDonald's"]) {
        return @"Free";
    } else {
        return locationType;
    }
}

- (void)loadLocationsFromXML
{
    NSURL *url = [NSURL URLWithString:nycOpenDataWifiLocationsXMLAddress];
    
    __unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        [self importCoreDataDefaultLocations:responseString];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
        UIAlertView *locationImportFailedAlert = [[UIAlertView alloc] initWithTitle:@"Location Load Failed" message:@"NYC Open Data is currently unreachable. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [locationImportFailedAlert show];
    }];
    
    [request startAsynchronous];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Downloading locations...";
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = kCenterPointLatitude;
    zoomLocation.longitude = kCenterPointLongitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, kSpanDeltaLatitude*METERS_PER_MILE, kSpanDeltaLongitude*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    _mapView.delegate = self;
    [_mapView setRegion:adjustedRegion animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];    // Call the super class implementation.
    // Usually calling super class implementation is done before self class implementation, but it's up to your application.
    
    _mapView.showsUserLocation = NO;
    //[self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    popoverClass = [WEPopoverController class];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)plotMapLocations
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading locations...";
    
    /* for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    } */
    
    _fetchedLocations = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    NSMutableArray *pins = [NSMutableArray array];
    
    for (LocationInfo *location in _fetchedLocations) {
        LocationDetails *locationDetails = location.details;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = locationDetails.latitude.doubleValue;
        coordinate.longitude = locationDetails.longitude.doubleValue;
        //NSLog(@"%f, %f", locationDetails.latitude.doubleValue, locationDetails.longitude.doubleValue);
        
        MapLocation *annotation = [[MapLocation alloc] initWithLocation:location coordinate:coordinate];
        [pins addObject:annotation];
    }
    
    [_mapView addAnnotations:pins];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/* - (void)mapView:(MKMapView *)myMapView didUpdateToUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateToUserLocation");
    [self zoomToUserLocation:userLocation.location];
} */

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [self zoomToUserLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    UIAlertView *locationUpdateFailed = [[UIAlertView alloc] initWithTitle:@"Location Unavailable" message:@"Please try again and ensure Location Services are enabled for NYC Wi-Fi." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [locationUpdateFailed show];
}

- (void)zoomToUserLocation:(CLLocation *)userLocation
{
    if (!userLocation)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
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

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties alloc];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin;
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Location Detail Segue"])
	{
        LocationDetailTVC *locationDetailTVC = segue.destinationViewController;
        //locationDetailTVC.delegate = self;
        //locationDetailTVC.managedObjectContext = self.managedObjectContext;
        
        NSLog(@"Passing selected location (%@) to LocationDetailTVC", self.selectedLocation.name);
        //NSLog(@"%@", self.selectedLocation);
        locationDetailTVC.selectedLocation = self.selectedLocation;
	}
    /* else
    { NSLog(@"Unidentified Segue Attempted!"); } */
}

#pragma mark -
#pragma mark Actions

- (IBAction)showPopover:(UIBarButtonItem *)sender {
	if (!self.popoverController) {
		
		PopoverViewController *contentViewController = [[PopoverViewController alloc] initWithStyle:UITableViewStylePlain];
        contentViewController.delegate = self;
		self.popoverController = [[popoverClass alloc] initWithContentViewController:contentViewController];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
		[self.popoverController presentPopoverFromBarButtonItem:sender
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
													   animated:YES];
	} else {
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
	}
}

- (IBAction)showUserLocation:(UIBarButtonItem *)sender {
    _mapView.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark -
#pragma mark PopoverViewControllerDelegate implementation

- (void)theAboutButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller
{
    [self performSegueWithIdentifier:@"About Segue" sender:self];
}

- (void)theTellAFriendButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"NYC Wi-Fi App."];
        [mailViewController setMessageBody:@"Check out this handy new app to help you find wi-fi in New York City!" isHTML:YES];
      
        [self presentModalViewController:mailViewController animated:YES];
    } else {
        UIAlertView *mailFailAlert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the email composer app window"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [mailFailAlert show];
    }
}

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
    
    MapLocation *annotation = [[MapLocation alloc] initWithLocation:location coordinate:coordinate];
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
