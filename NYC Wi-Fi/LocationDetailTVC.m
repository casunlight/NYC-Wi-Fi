//
//  LocationDetailTVC.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "LocationDetailTVC.h"

@implementation LocationDetailTVC
@synthesize locationName = _locationName;
@synthesize locationAddress = _locationAddress;
@synthesize locationType = _locationType;
@synthesize locationPhone = _locationPhone;
@synthesize locationWebsite = _locationWebsite;
@synthesize selectedLocation = _selectedLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLocationName];
    [self setupLocationAddress];
    NSLog(@"%@", self.selectedLocation.details.url);
    _locationType.detailTextLabel.text = self.selectedLocation.fee_type;
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
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text rangeOfString:@"Call"].location != NSNotFound) {
        [self callLocationPhoneNumber:self.selectedLocation.details.phone];
    } else {
        // Catch something here?
    }
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
    _locationAddress.detailTextLabel.text = [self.selectedLocation.details.city stringByAppendingString:@", NY"];
    if (self.selectedLocation.details.zip > 0) {
        [_locationAddress.detailTextLabel.text stringByAppendingString:@" "];
        [_locationAddress.detailTextLabel.text stringByAppendingString:[self.selectedLocation.details.zip stringValue]];
    }
}

- (void)callLocationPhoneNumber:(NSString *)locationPhone
{
    //NSLog(@"Calling %@", locationPhone);
    NSString *cleanedString = [[locationPhone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] rangeOfString:@"iPhone"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

@end
