//
//  SettingsTVC.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/13/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    /* if ([[NSUserDefaults standardUserDefaults] boolForKey:@"currentZipCode"] != nil) {
        
    } */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    //[self.view endEditing:YES];
}

- (void)backgroundTouched
{
    [currentZipCode resignFirstResponder];
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    // Hide the keyboard
    [currentZipCode resignFirstResponder];
    [freeSwitch resignFirstResponder];
    [feeSwitch resignFirstResponder];
    
    // Create strings and integer to store the text info
    NSNumber *zipCode = [NSNumber numberWithInteger:[[currentZipCode text] integerValue]];
    BOOL free  = freeSwitch.on;
    BOOL fee = feeSwitch.on;
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[zipCode integerValue] forKey:@"currentZipCode"];
    [defaults setBool:free forKey:@"free"];
    [defaults setBool:fee forKey:@"fee"];
    [defaults synchronize];
    NSLog(@"Settings saved");
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    currentZipCode = nil;
    freeSwitch = nil;
    feeSwitch = nil;
    [super viewDidUnload];
}
@end
