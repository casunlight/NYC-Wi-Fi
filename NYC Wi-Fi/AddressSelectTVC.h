//
//  AddressSelectTVC.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 1/2/13.
//  Copyright (c) 2013 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class AddressSelectTVC;

@protocol AddressSelectTVCDelegate

- (void)theSelectButtonOnTheAddressSelectTVCWasTapped:(AddressSelectTVC *)controller withAddress:(CLPlacemark *)placemark;

@end

@interface AddressSelectTVC : UITableViewController

@property (strong, nonatomic) NSArray *addresses;
@property (nonatomic, weak) id <AddressSelectTVCDelegate> delegate;
- (IBAction)cancelAddressSelect:(UIBarButtonItem *)sender;

@end
