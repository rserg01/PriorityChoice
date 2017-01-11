    //
//  FNADependentsViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNADependentsViewController.h"
#import "FNAAddDependentViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNAAddDependentViewController.h"
#import "GetPersonalProfile.h"

@interface FNADependentsViewController()
@property(nonatomic, retain) NSMutableArray *arrDependents;
@property(nonatomic, retain) NSIndexPath *delIndexPath;
- (void) loadDependents;
@end

@implementation FNADependentsViewController
@synthesize imgTemplate;
@synthesize tblDependents, arrDependents, delIndexPath;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Add Dependents";
	self.navigationController.navigationBarHidden = NO;
	self.arrDependents = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *addDependent = [[UIBarButtonItem alloc] initWithTitle:@"Add Dependent" style:UIBarButtonItemStylePlain target:self action:@selector(addDependent:)];
	self.navigationItem.rightBarButtonItem = addDependent;
	[addDependent release];
	addDependent = nil;
	
	[self loadDependents];
    
}

#pragma mark -
#pragma mark Methods

-(void)finishedDoingMyThing:(NSString *)labelString
{
    [self loadDependents];
}

- (void) loadDependents
{
    self.arrDependents = [GetPersonalProfile getDependents:[FNASession sharedSession].profileId];
    
    if ([self.arrDependents count] > 0) {
        [self.tblDependents reloadData];
    }
}

- (void) addDependent:(id)sender
{
    [self.arrDependents addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"user.png",@"image",
                                   @"", @"cellBackgroundImage",
                                   [NSString stringWithFormat:@"Dependent %i", [self.arrDependents count] + 1], @"title",
                                   @"", @"dependentId",
                                   @"", @"details", nil]];
    [self.tblDependents reloadData];
}

#pragma mark -
#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != [alertView cancelButtonIndex])
	{
		NSDictionary *item = [self.arrDependents objectAtIndex:self.delIndexPath.row];
		NSString *dependentId = [item objectForKey:@"dependentId"];
		NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM tProfile_Dependent WHERE _Id=%@", dependentId];
		NSError *error = nil;
		[SQLiteManager sqliteExec:sqlDelete error:&error];
		if (error) 
		{
			[Utility showAlerViewWithTitle:@"Error" 
							   withMessage:[error localizedDescription] 
					 withCancelButtonTitle:@"Ok" 
					  withOtherButtonTitle:nil 
							   withSpinner:NO 
							  withDelegate:nil];
		}
		else 
		{
			[self.arrDependents removeObjectAtIndex:self.delIndexPath.row];
			[self.tblDependents reloadData];
		}				
		self.delIndexPath = nil;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrDependents count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSDictionary *item = [self.arrDependents objectAtIndex:indexPath.row];
	//TODO: Set the cell background image here - [item objectForKey:@"cellBackgroundImage"]
	
	[cell.textLabel setText:[item objectForKey:@"title"]];
	//[cell.detailTextLabel setNumberOfLines:2];
	//[cell.detailTextLabel setText:[item objectForKey:@"details"]];
	
	[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];
    //cell.showsReorderControl = YES;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}


 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
 
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		// Delete the row from the data source.
		//[self.arrDependents removeObjectAtIndex:indexPath.row];
		//[self.tblDependents reloadData];
		[Utility showAlerViewWithTitle:@"Confirm" 
						   withMessage:@"Are you sure you want to delete this dependnet?" 
				 withCancelButtonTitle:@"No" 
				  withOtherButtonTitle:@"Yes" 
						   withSpinner:NO 
						  withDelegate:self];
		self.delIndexPath = indexPath;
		
		//[tableView deleteRowsAtIndexPaths:[self.arrDependents arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) 
	{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}   
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.arrDependents objectAtIndex:indexPath.row];
    
    [FNASession sharedSession].dependentId = [item objectForKey:@"dependentId"];
    
    [self performSegueWithIdentifier:@"segueToAddDependent" sender:item];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToAddDependent"]) {
        [[segue destinationViewController] setDelegate_AddDependent:self];
        FNAAddDependentViewController *modal = [[[FNAAddDependentViewController alloc]init]autorelease];
        modal.delegate_AddDependent = self;
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setImgTemplate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.tblDependents release];
	[self.arrDependents release];
	[delIndexPath release];
    [imgTemplate release];
    [super dealloc];
}


@end
