//
//  LocationDetailViewController.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 11/16/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize location = _location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
