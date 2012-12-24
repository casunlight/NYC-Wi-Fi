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
#import "LocationInfo+Extensions.h"

@implementation ListViewController
@synthesize fetchedLocations = _fetchedLocations;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedLocation = _selectedLocation;
@synthesize searchBar = _searchBar;
@synthesize filteredTableData = _filteredTableData;
@synthesize popoverController, sections, sectionTitles;

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
    
    /* _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    _searchBar.placeholder = @"Search location name";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithRed:78.0/255.0f green:143.0/255.0f blue:218.0/255.0f alpha:1.0f];
    _searchBar.translucent = YES;
    //_searchBar.opaque = YES;
    [_searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchBar; */
    
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
    [_searchBar becomeFirstResponder];
}

/* - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
} */

// called when cancel button pressed
/* - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + 44.0f;
    self.tableView.bounds = newBounds;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + 44.0f;
    self.tableView.bounds = newBounds;
} */

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

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationInfo" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else
        return [self.sections count]; */
    
    if (tableView == self.tableView)
        return [[self.fetchedResultsController sections] count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[self.sections objectAtIndex:section] count];
    /* if (tableView == self.searchDisplayController.searchResultsTableView)
        return _filteredTableData.count;
    else
        return [[self.sections objectAtIndex:section] count]; */
    
    if (tableView == self.tableView) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return [_filteredTableData count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    /* if (tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    else
        return self.sectionTitles; */
    
    if (tableView == self.tableView) {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
        [index addObjectsFromArray:initials];
        return index;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.tableView) {
        if (index > 0) {
            // The index is offset by one to allow for the extra search icon inserted at the front
            // of the index
            
            return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
        } else {
            // The first entry in the index is for the search icon so we return section not found
            // and force the table to scroll to the top.
            
            self.tableView.contentOffset = CGPointZero;
            return NSNotFound;
        }
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    /* if (tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    else
        return [self.sectionTitles objectAtIndex:section]; */
    
    if (tableView == self.tableView) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
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
    
    /* if (tableView == self.searchDisplayController.searchResultsTableView)
        location = [_filteredTableData objectAtIndex:indexPath.row];
    else
        location = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; */
    
    if (tableView == self.tableView)
        location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    else
        location = [_filteredTableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = location.address;
    //NSLog(@"!!!%@", cell.detailTextLabel.text);
    //NSLog(@"!!!!!!!%@", location.address);
    
    return cell;
}

/* #pragma mark - Table view delegate

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
} */

/* #pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[_filteredTableData removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [_fetchedLocations filteredArrayUsingPredicate:predicate];
    
    if(![scope isEqualToString:@"All"]) {
        // Further filter the array with the scope
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.fee_type contains[c] %@",scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
    _filteredTableData = [NSMutableArray arrayWithArray:tempArray];
} */


/* #pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
} */

#pragma mark -
#pragma mark === UISearchDisplayDelegate ===
#pragma mark -

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NYCWiFiSearchScope scopeKey = controller.searchBar.selectedScopeButtonIndex;
    [self searchForText:searchString scope:scopeKey];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = controller.searchBar.text;
    [self searchForText:searchString scope:searchOption];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 64;
}

- (void)searchForText:(NSString *)searchText scope:(NYCWiFiSearchScope)scopeOption
{
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"name";
        
        if (scopeOption == searchScopeCapital)
        {
            searchAttribute = @"capital";
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        _filteredTableData = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        if (error) {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
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
        
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //self.selectedLocation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        /* if(sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            self.selectedLocation = [_filteredTableData objectAtIndex:indexPath.row];
        } else {
            self.selectedLocation = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        } */
        
        if (self.searchDisplayController.isActive) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            self.selectedLocation = [_filteredTableData objectAtIndex:indexPath.row];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            self.selectedLocation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        
        //self.selectedLocation = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //NSLog(@"Passing selected location (%@) to LocationDetailTVC", self.selectedLocation.name);
        //NSLog(@"%@", self.selectedLocation);
        locationDetailTVC.selectedLocation = self.selectedLocation;
	}
    else
    { NSLog(@"Unidentified Segue Attempted!"); }
}

- (void)didReceiveMemoryWarning
{
    self.searchFetchRequest = nil;
    [super didReceiveMemoryWarning];
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
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:@"sectionTitle"
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
