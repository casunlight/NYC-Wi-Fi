//
//  ListViewController.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "ListViewController.h"
#import "MBProgressHUD.h"
#import "PopoverViewController.h"
#import "UIBarButtonItem+WEPopover.h"

@implementation ListViewController
@synthesize fetchedLocations = _fetchedLocations;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedLocation = _selectedLocation;
@synthesize searchBar = _searchBar;
@synthesize filteredTableData = _filteredTableData;
@synthesize popoverController, sections, sectionTitles, isFiltered;

- (void)listLocations
{
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Loading locations...";
    
    _fetchedLocations = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    //NSLog(@"%@", _fetchedLocations);
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    self.sections = [[NSMutableArray alloc] init];
    self.sectionTitles = [[NSMutableArray alloc] init];
    
    for (LocationInfo *location in _fetchedLocations) {
        NSMutableArray *section = [self.sections lastObject];
        
        if (!section || ![[[[section lastObject] name] substringToIndex:1] isEqualToString:[location.name substringToIndex:1]]) {
            // Create a new section on change of first character
            
            [self.sections addObject:[[NSMutableArray alloc] init]];
            [self.sectionTitles addObject:[location.name substringToIndex:1]];
        }
        
        [[self.sections lastObject] addObject:location];
    }
    
    popoverClass = [WEPopoverController class];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    _searchBar.placeholder = @"Search location name";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithRed:78.0/255.0f green:143.0/255.0f blue:218.0/255.0f alpha:1.0f];
    _searchBar.translucent = YES;
    //_searchBar.opaque = YES;
    [_searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchBar;
    
    //Hide searchBar initially
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + _searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                            target:self
                                            action:@selector(searchLocations)];
    
    self.navigationItem.rightBarButtonItems = @[searchBarButtonItem];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nyc-nav-bar-logo"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
}

- (void)searchLocations
{
    if ([_searchBar isFirstResponder]) {
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
    } else {
        [self.tableView scrollRectToVisible:[[self.tableView tableHeaderView] bounds] animated:YES];
        _searchBar.showsCancelButton = YES;
        [_searchBar becomeFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
    //_searchBar.text = @"";
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isFiltered)
        return 1;
    else
        return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[self.sections objectAtIndex:section] count];
    int rowCount;
    if (self.isFiltered)
        rowCount = _filteredTableData.count;
    else
        rowCount = [[self.sections objectAtIndex:section] count];
    
    return rowCount;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isFiltered)
        return nil;
    else
        return self.sectionTitles;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    if (self.isFiltered)
        return nil;
    else
        return [self.sectionTitles objectAtIndex:section];
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
    //LocationInfo *location = [_fetchedLocations objectAtIndex:indexPath.row];
    //LocationInfo *location = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    LocationInfo *location;
    
    if(isFiltered)
        location = [_filteredTableData objectAtIndex:indexPath.row];
    else
        location = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = location.address;
    //NSLog(@"!!!%@", cell.detailTextLabel.text);
    //NSLog(@"!!!!!!!%@", location.address);
    
    return cell;
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    _searchBar.showsCancelButton = YES;
    if (text.length == 0) {
        isFiltered = FALSE;
    } else {
        isFiltered = true;
        _filteredTableData = [[NSMutableArray alloc] init];
        
        for (LocationInfo* location in _fetchedLocations) {
            NSRange nameRange = [location.name rangeOfString:text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [_filteredTableData addObject:location];
            }
        }
    }
    
    [self.tableView reloadData];
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

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties alloc];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin;
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Location Detail Segue"])
	{
        //NSLog(@"Setting ListViewController as a delegate of LocationDetailViewController");
        [_searchBar resignFirstResponder];
        LocationDetailTVC *locationDetailTVC = segue.destinationViewController;
        //locationDetailTVC.delegate = self;
        //locationDetailTVC.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //self.selectedLocation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (isFiltered) {
            self.selectedLocation = [_filteredTableData objectAtIndex:indexPath.row];
        } else {
            self.selectedLocation = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        
        //self.selectedLocation = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //NSLog(@"Passing selected location (%@) to LocationDetailTVC", self.selectedLocation.name);
        //NSLog(@"%@", self.selectedLocation);
        locationDetailTVC.selectedLocation = self.selectedLocation;
	}
    else
    { NSLog(@"Unidentified Segue Attempted!"); }
}

#pragma mark -
#pragma mark Actions

- (IBAction)showPopover:(UIBarButtonItem *)sender {
    //[sheet showInView:self.view];
	if (!self.popoverController) {
		
		PopoverViewController *contentViewController = [[PopoverViewController alloc] initWithStyle:UITableViewStylePlain];
        contentViewController.delegate = self;
		self.popoverController = [[popoverClass alloc] initWithContentViewController:contentViewController];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
		[self.popoverController presentPopoverFromBarButtonItem:sender
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
													   animated:YES];
	} else {
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
	}
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark -
#pragma mark PopoverViewControllerDelegate implementation

- (void)theAboutButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller
{
    [self performSegueWithIdentifier:@"About Segue" sender:self];
}

- (void)theTellAFriendButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"NYC Wi-Fi App."];
        [mailViewController setMessageBody:@"Check out this handy new app to help you find wi-fi in New York City!" isHTML:YES];
        
        [self presentModalViewController:mailViewController animated:YES];
    } else {
        UIAlertView *mailFailAlert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support the email composer app window"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [mailFailAlert show];
    }
}

- (void)theSettingsButtonOnThePopoverViewControllerWasTapped:(PopoverViewController *)controller
{
    [self performSegueWithIdentifier:@"Settings Segue" sender:self];
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
