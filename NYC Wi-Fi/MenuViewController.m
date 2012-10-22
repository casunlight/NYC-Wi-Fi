//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;

- (void)awakeFromNib
{
  self.menuItems = [NSArray arrayWithObjects:@"Near Me", @"View All", @"Find by Borough", @"Navigation", nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.slidingViewController setAnchorRightRevealAmount:260.0f];
  self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"MenuItemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
  }
  
  NSLog(@"%@", [self.menuItems objectAtIndex:indexPath.row]);
    
  cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.menuItems objectAtIndex:indexPath.row];
    NSLog(@"%@", identifier);
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    
    if (identifier == @"Near Me") {
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
        [newTopViewController performSegueWithIdentifier:@"Near Me Segue" sender:self];
    } else if (identifier == @"View All") {
        
    } else if (identifier == @"Find by Borough") {
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoroughView"];
    }
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end
