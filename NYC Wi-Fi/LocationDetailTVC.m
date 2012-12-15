//
//  LocationDetailTVC.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "LocationDetailTVC.h"
#import "MapLocation.h"

@implementation LocationDetailTVC
@synthesize locationName = _locationName;
@synthesize locationAddress = _locationAddress;
@synthesize locationType = _locationType;
@synthesize locationMap = _locationMap;
@synthesize locationPhone = _locationPhone;
@synthesize locationWebsite = _locationWebsite;
@synthesize selectedLocation = _selectedLocation;

- (MKAnnotationView *)locationMap:(MKMapView *)locationMap viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapLocation";
    
    if ([annotation isKindOfClass:[MapLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_locationMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"wifi-pin.png"];
        
        return annotationView;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    _locationMap.layer.cornerRadius = 8;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _selectedLocation.details.latitude.doubleValue;
    zoomLocation.longitude = _selectedLocation.details.longitude.doubleValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_locationMap regionThatFits:viewRegion];

    [_locationMap setRegion:adjustedRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLocationName];
    [self setupLocationAddress];
    [self setupLocationType];
    
    //NSLog(@"%@", self.selectedLocation.details);
    [self plotMapLocation];
    
    if (self.selectedLocation.details.phone != nil) {
        _locationPhone.textLabel.text = [@"Call " stringByAppendingString:self.selectedLocation.details.phone];
    }
    _locationWebsite.detailTextLabel.text = self.selectedLocation.details.url;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text rangeOfString:@"Call"].location != NSNotFound) {
        [self callLocationPhoneNumber];
    } else if ([cell.textLabel.text isEqualToString:@"More Information"]) {
        [self launchWebsiteInSafari];
    } else {
        // Catch something here?
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
        return 100;
    else
        return [super tableView:tableView heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSLog(@"viewForFooterInSection: %i", section);
    if (section == 1) {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
        footerView.autoresizesSubviews = YES;
        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        footerView.userInteractionEnabled = YES;
        
        footerView.hidden = NO;
        footerView.multipleTouchEnabled = NO;
        footerView.opaque = NO;
        footerView.contentMode = UIViewContentModeScaleToFill;
        
        // Add the button
        UIButton *callLocationPhoneButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [callLocationPhoneButton setFrame:CGRectMake(20, 300, 100, 44)];
        [callLocationPhoneButton setTitle:[NSString stringWithFormat:@"Call %@", _selectedLocation.details.phone] forState:UIControlStateNormal];
        [callLocationPhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        callLocationPhoneButton.backgroundColor = [UIColor clearColor];
        [callLocationPhoneButton addTarget:self action:@selector(callLocationPhoneNumberAction:) forControlEvents:UIControlEventTouchDown];
        [footerView addSubview:callLocationPhoneButton];
        
        return footerView;
        
        /* CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
        footerView.autoresizesSubviews = YES;
        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        footerView.userInteractionEnabled = YES;
        
        footerView.hidden = NO;
        footerView.multipleTouchEnabled = NO;
        footerView.opaque = NO;
        footerView.contentMode = UIViewContentModeScaleToFill;
        
        // Add the label
        UILabel*    footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, -5.0, 120.0, 45.0)];
        footerLabel.backgroundColor = [UIColor clearColor];
        footerLabel.opaque = NO;
        footerLabel.text = @"Sharing";
        footerLabel.textColor = [UIColor blueColor];
        footerLabel.highlightedTextColor = [UIColor yellowColor];
        footerLabel.font = [UIFont boldSystemFontOfSize:17];
        footerLabel.shadowColor = [UIColor whiteColor];
        footerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        [footerView addSubview: footerLabel];
        
        // Add the switch
        UISwitch* footerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 5, 80.0, 45.0)];
        [footerView addSubview: footerSwitch];
        
        // Return the footerView
        return footerView; */
    }
    
    return nil;
}

- (IBAction) callLocationPhoneNumberAction:(UIButton *)sender
{    
    [self callLocationPhoneNumber];
}

/* - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //if (cell.textLabel.text == @"More Information" && cell.detailTextLabel.text == @"") {
    if (indexPath.row == 0) {
        //NSLog(@"%@", cell.textLabel.text);
        //cell.textLabel.text = nil;
        return 0.0;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
} */

- (void)plotMapLocation
{
    for (id<MKAnnotation> annotation in _locationMap.annotations) {
        [_locationMap removeAnnotation:annotation];
    }
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = _selectedLocation.details.latitude.doubleValue;
    coordinate.longitude = _selectedLocation.details.longitude.doubleValue;
    
    MapLocation *annotation = [[MapLocation alloc] initWithLocation:_selectedLocation coordinate:coordinate];
    [_locationMap addAnnotation:annotation];
}

- (void)viewDidUnload {
    [self setSelectedLocation:nil];
    [self setLocationName:nil];
    [self setLocationType:nil];
    [self setLocationMap:nil];
    [self setLocationAddress:nil];
    [self setLocationPhone:nil];
    [self setLocationWebsite:nil];
    [super viewDidUnload];
}

#pragma mark private methods

- (void)setupLocationName
{
    NSArray *locationNameSplit = [[NSArray alloc] initWithArray:[self.selectedLocation.name componentsSeparatedByString:@" - "]];
    
    _locationName.textLabel.text = [locationNameSplit objectAtIndex:0];
    
    if (locationNameSplit.count > 1) {
        _locationName.detailTextLabel.text = [locationNameSplit objectAtIndex:1];
    } else {
        _locationName.detailTextLabel.text = @"";
    }
}

- (void)setupLocationAddress
{
    _locationAddress.textLabel.text = self.selectedLocation.address;
    NSString *locationCityStateZip = [self.selectedLocation.details.city stringByAppendingString:@", NY"];
    
    if ([self.selectedLocation.details.zip integerValue] > 0) {
        locationCityStateZip = [locationCityStateZip stringByAppendingFormat:@" %@", [self.selectedLocation.details.zip stringValue]];
    }
    
    _locationAddress.detailTextLabel.text = locationCityStateZip;
}

- (void)setupLocationType
{
    _locationType.textLabel.text = self.selectedLocation.fee_type;
    //_locationType.imageView.contentMode = UIViewContentModeLeft;
    if ([self.selectedLocation.fee_type isEqualToString:@"Free"]) {
        _locationType.imageView.image = [UIImage imageNamed:@"wifi-pin.png"];
    } else {
        _locationType.imageView.image = [UIImage imageNamed:@"wifi-pin-fee.png"];
    }
}

- (void)callLocationPhoneNumber
{
    //NSLog(@"Calling %@", locationPhone);
    NSString *cleanedString = [[self.selectedLocation.details.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] rangeOfString:@"iPhone"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (void)launchWebsiteInSafari
{
    NSURL *url = [NSURL URLWithString:self.selectedLocation.details.url];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@", @"Failed to open url:", [url description]);
}

@end
