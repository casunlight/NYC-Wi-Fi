//
//  AddressSelectTVC.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 1/2/13.
//  Copyright (c) 2013 Kevin Wolkober. All rights reserved.
//

#import "AddressSelectTVC.h"

@interface AddressSelectTVC ()

@end

@implementation AddressSelectTVC
@synthesize addresses = _addresses;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Did you mean..."];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddressSelectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CLPlacemark *address;
    
    address = [_addresses objectAtIndex:indexPath.row];
    /* NSLog(@"%@", address);
    NSLog(@"name %@", address.name);
    NSLog(@"thoroughfare %@", address.thoroughfare);
    NSLog(@"subThoroughfare %@", address.subThoroughfare);
    NSLog(@"locality %@", address.locality);
    NSLog(@"subLocality %@", address.subLocality);
    NSLog(@"administrativeArea %@", address.administrativeArea);
    NSLog(@"subAdministrativeArea %@", address.subAdministrativeArea);
    NSLog(@"postalCode %@", address.postalCode);
    NSLog(@"ISOcountryCode %@", address.ISOcountryCode);
    NSLog(@"country %@", address.country);
    NSLog(@"inlandWater %@", address.inlandWater);
    NSLog(@"ocean %@", address.ocean);
    NSLog(@"areasOfInterest %@", address.areasOfInterest); */
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", address.subThoroughfare, address.thoroughfare];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ %@", address.subLocality, address.locality, address.postalCode];
    
    return cell;
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
    [self.delegate theSelectButtonOnTheAddressSelectTVCWasTapped:self withAddress:[_addresses objectAtIndex:indexPath.row]];
    //[self dismissModalViewControllerAnimated:YES];
}

/* - (IBAction)cancelAddressSelect:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
} */

@end
