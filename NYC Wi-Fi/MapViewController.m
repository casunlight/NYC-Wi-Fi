//
//  MapViewController.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 8/28/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "MapViewController.h"
#import "MapLocation.h"
#import "ASIHTTPRequest.h"
#import "SMXMLDocument.h"
#import "MBProgressHUD.h"
//#import "CLLocation+Geocodereverse.h"

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize leftSidebarViewController;

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

- (void)viewWillAppear:(BOOL)animated
{
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
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
	//[self plotMapLocations];
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

// Add new method above refreshTapped
//- (void)plotMapLocations
- (void)plotMapLocations:(NSString *)responseString
{    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    //NSArray *mapLocations = [self loadMapLocations];
    NSData* xmlData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@", xmlData);
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:xmlData error:&error];
    SMXMLElement *mapLocations = [document.root childNamed:@"row"];
    //NSLog(@"%@", [data objectAtIndex:1]);
    //NSArray *dictValues =  [root allValues];
    //NSLog(@"%@", dictValues);
    //NSArray *data = [root objectForKey:@"data"];
    //NSLog(@"%@", data);
    
    //for (NSArray * mapLocation in mapLocations) {
    for (SMXMLElement *mapLocation in [mapLocations childrenNamed:@"row"]) {
        NSString *name = [mapLocation valueWithPath:@"name"];
        NSString *address = [mapLocation valueWithPath:@"address"];
        
        SMXMLElement *shape = [mapLocation childNamed:@"shape"];
        NSString *latitude = [shape attributeNamed:@"latitude"];
        NSString *longitude = [shape attributeNamed:@"longitude"];
        
        //CLLocation *coordinates = [address newGeocodeAddress];
        //NSLog(@"Coordinates - Latitude : %.10f, Longitude : %.10f", coordinates.coordinate.latitude, coordinates.coordinate.longitude);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        
        MapLocation *annotation = [[MapLocation alloc] initWithName:name address:address coordinate:coordinate];
        [_mapView addAnnotation:annotation];
    }
    
}

- (NSArray*)loadMapLocations
{
    NSArray *location1 = [[NSArray alloc] initWithObjects:@"Juan Valdez - Midtown", @"140 East 57 St, 10022", @"40.761236", @"-73.968805", nil];
    NSArray *location2 = [[NSArray alloc] initWithObjects:@"Whole Foods Cafe Tribeca", @"270 Greenwich St, 10007", @"40.715794", @"-74.011484", nil];
    NSArray *location3 = [[NSArray alloc] initWithObjects:@"New York Film Academy Cafe", @"51 Astor Pl, 10003", @"40.730153", @"-73.990799", nil];
    NSArray *location4 = [[NSArray alloc] initWithObjects:@"MANGIA - Chelsea", @"22 West 23rd St, 10023", @"40.742022", @"-73.990756", nil];
    NSArray *location5 = [[NSArray alloc] initWithObjects:@"Orchard House Cafe", @"1064 1st Ave, 10022", @"40.759155", @"-73.962432", nil];
    
    return [[NSArray alloc] initWithObjects:location1, location2, location3, location4, location5, nil];
}

- (IBAction)refreshTapped:(id)sender {
    //NSURL *url = [[NSBundle mainBundle] URLForResource: @"rows" withExtension:@"xml"];
    //NSURL *url = [NSURL URLWithString:@"https://nycopendata.socrata.com/api/views/ehc4-fktp/rows.xml"];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/ios/nycwifi/rows.xml"];
    //NSURL *url = [NSURL URLWithString:@"https://nycopendata.socrata.com/api/views/ehc4-fktp/rows.json?method=index"];
    
    __unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *responseString = [request responseString];
        //NSLog(@"Response: %@", responseString);
        [self plotMapLocations:responseString];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading locations...";
}

- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender {
    NSLog(@"Toggling sidebar");
    [self.slidingViewController anchorTopViewTo:ECRight];
}
@end
