//
//  SettingsTVC.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/13/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTVC : UITableViewController {
    IBOutlet UITextField *currentZipCode;
    IBOutlet UISwitch *freeSwitch;
    IBOutlet UISwitch *feeSwitch;
}

- (IBAction)textFieldReturn:(id)sender;
- (void)backgroundTouched;
- (IBAction)doneButton:(UIBarButtonItem *)sender;

@end
