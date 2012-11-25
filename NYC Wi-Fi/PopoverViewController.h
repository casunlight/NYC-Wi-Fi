//
//  PopoverViewController.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/23/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopoverViewController;

@protocol PopoverViewControllerDelegate

- (void)theAboutButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller;

@end

@interface PopoverViewController : UITableViewController

@property (nonatomic, weak) id <PopoverViewControllerDelegate> delegate;

@end
