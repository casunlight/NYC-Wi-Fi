//
//  AboutViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/25/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate

- (void)theDoneButtonOnTheAboutViewControllerWasTapped:(AboutViewController *)controller;

@end

@interface AboutViewController : UITableViewController

@property (nonatomic, weak) id <AboutViewControllerDelegate> delegate;

- (IBAction)doneButton:(UIBarButtonItem *)sender;

@end
