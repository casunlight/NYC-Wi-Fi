//
//  LocationDetailTVC.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/17/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfo.h"
#import "LocationDetails.h"

@interface LocationDetailTVC : UITableViewController

@property (strong, nonatomic) LocationInfo *selectedLocation;
@property (strong, nonatomic) IBOutlet UILabel *locationName;
@property (strong, nonatomic) IBOutlet UILabel *locationAddress1;
@property (strong, nonatomic) IBOutlet UILabel *locationAddress2;
@property (strong, nonatomic) IBOutlet UILabel *locationType;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationPhone;

@end
