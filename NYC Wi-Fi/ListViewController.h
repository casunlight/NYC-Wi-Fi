//
//  ListViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "SingletonObj.h"
#import "LocationInfo.h"
#import "LocationDetails.h"

// Orientation changing is not an officially completed feature,
// The main thing to fix is the rotation animation and the
// necessarity of the container created in AppDelegate. Please let
// me know if you've got any elegant solution and send me a pull request!
// You can change EXPERIEMENTAL_ORIENTATION_SUPPORT to 1 for testing purpose
#define EXPERIEMENTAL_ORIENTATION_SUPPORT 1

@class ListViewController;

@protocol ListViewControllerDelegate

- (void)theMapButtonOnTheListViewControllerWasTapped:(ListViewController *)controller;

@end

@interface ListViewController : UIViewController<UITableViewDelegate> {
    SingletonObj * displayToggle;
}

@property (nonatomic, weak) id <ListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) SidebarViewController *leftSidebarViewController;

- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender;

@end
