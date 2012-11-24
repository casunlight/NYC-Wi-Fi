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
#import "LocationDetailTVC.h"
#import "WEPopoverController.h"

@class ListViewController;

/* @protocol ListViewControllerDelegate

- (void)theMapButtonOnTheListViewControllerWasTapped:(ListViewController *)controller;

@end */

@interface ListViewController : UITableViewController<NSFetchedResultsControllerDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate> {
    WEPopoverController *popoverController;
    Class popoverClass;
}

//@property (nonatomic, weak) id <ListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) LocationInfo *selectedLocation;
@property (nonatomic, retain) WEPopoverController *popoverController;
- (IBAction)showPopover:(UIBarButtonItem *)sender;

@end
