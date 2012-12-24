//
//  ListViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "LocationInfo.h"
#import "LocationDetails.h"
#import "LocationDetailTVC.h"
#import "WEPopoverController.h"
#import "PopoverViewController.h"

@class ListViewController;

/* @protocol ListViewControllerDelegate

- (void)theMapButtonOnTheListViewControllerWasTapped:(ListViewController *)controller;

@end */

@interface ListViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate, PopoverViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    WEPopoverController *popoverController;
    Class popoverClass;
}

//@property (nonatomic, weak) id <ListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSArray *fetchedLocations;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) LocationInfo *selectedLocation;
@property (strong, nonatomic) NSMutableArray *filteredTableData;
@property (nonatomic, retain) WEPopoverController *popoverController;
- (IBAction)showPopover:(UIBarButtonItem *)sender;
@property IBOutlet UISearchBar *searchBar;

typedef enum
{
    searchScopeAll = 0,
    searchScopeFree = 1,
    searchScopeFeeBased = 2
    
} NYCWiFiSearchScope;

@end
