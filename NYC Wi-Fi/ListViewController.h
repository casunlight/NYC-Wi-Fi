//
//  ListViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> // necessary?
#import "LocationInfo.h"
#import "LocationDetails.h"
#import "LocationDetailViewController.h"

@class ListViewController;

/* @protocol ListViewControllerDelegate

- (void)theMapButtonOnTheListViewControllerWasTapped:(ListViewController *)controller;

@end */

@interface ListViewController : UITableViewController<NSFetchedResultsControllerDelegate>//UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, weak) id <ListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) LocationInfo *selectedLocation;

- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender;

@end
