//
//  ListViewController.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "ListViewController.h"
#import "MBProgressHUD.h"

@implementation ListViewController
@synthesize fetchedLocations = _fetchedLocations;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedLocation = _selectedLocation;

- (void)listLocations
{
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Loading locations...";
    
    _fetchedLocations = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    NSLog(@"%@", _fetchedLocations);
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", @"Appeared!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        [self listLocations];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"!!!%u", _fetchedLocations.count);
    return _fetchedLocations.count;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    LocationInfo *location = [_fetchedLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = location.address;
    //NSLog(@"!!!%@", cell.detailTextLabel.text);
    //NSLog(@"!!!!!!!%@", location.address);
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Location Detail Segue"])
	{
        //NSLog(@"Setting ListViewController as a delegate of LocationDetailViewController");
        
        LocationDetailViewController *locationDetailViewController = segue.destinationViewController;
        //locationDetailViewController.delegate = self;
        locationDetailViewController.managedObjectContext = self.managedObjectContext;
        
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedLocation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected location (%@) to LocationDetailViewController", self.selectedLocation.name);
        locationDetailViewController.location = self.selectedLocation;
	}
    else
    { NSLog(@"Unidentified Segue Attempted!"); }
}

- (IBAction)revealLeftSidebar:(UIBarButtonItem *)sender {
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"LocationInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //[fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    
    NSLog(@"%@", theFetchedResultsController);
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // Do nothing
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

@end
