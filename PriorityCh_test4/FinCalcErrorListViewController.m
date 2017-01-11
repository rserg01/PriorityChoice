//
//  FinCalcErrorListViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/7/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalcErrorListViewController.h"
#import "FinCalcMpViewController.h"
#import "Support_FinCalc.h"
#import "FNASession.h"


@interface FinCalcErrorListViewController ()

@property (nonatomic, copy) NSMutableArray *arrErrors;

@end

@implementation FinCalcErrorListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [_navBarItem initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeTheModal)];
    
    [self setArrErrors:[FNASession sharedSession].finCalcErrors];
    
    NSLog(@"arrErrors count = %i", [_arrErrors count]);
    
    [_tblView reloadData];
}

- (void) closeTheModal
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [_arrErrors count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *item = [_arrErrors objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:[item objectForKey:@"Error"]];
    [cell.textLabel setNumberOfLines:3];
	//[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Memory Management


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_tblView release];
    [_navBarItem release];
    [super dealloc];
}

- (void) viewDidUnload
{
    [self setNavBarItem:nil];
    [self setTblView:nil];
}

@end
