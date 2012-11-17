//
//  LocationDetailViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/16/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfo.h"

@interface LocationDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) LocationInfo *location;

@end
