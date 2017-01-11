//
//  ProfilesTableViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ProfilesTableViewController.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "AESCrypt.h"
#import "FnaConstants.h"

@interface ProfilesTableViewController ()

@property(nonatomic, retain) NSMutableArray *arrProfiles;
@property(nonatomic, retain) NSIndexPath *delIndexPath;
@property(nonatomic, assign) int totalNumberOfClients;

@end

@implementation ProfilesTableViewController

@synthesize rankingDelegate = _rankingDelegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FNASession sharedSession].arrProfiles=[GetPersonalProfile getAllProfileNames];
    
    if ([[FNASession sharedSession].arrProfiles count] > 0 )
    {
        _arrProfiles = [FNASession sharedSession].arrProfiles;
    }
    else {
        
        [self sendErrorMessage:@"No existing profiles to pull out."];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Custom Methods

- (void) sendErrorMessage: (NSString *)errorMessage
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release]; // if you are not using ARC
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != [alertView cancelButtonIndex])
	{
		NSDictionary *item = [_arrProfiles objectAtIndex:_delIndexPath.row];
		NSString *profileId = [item objectForKey:@"profileId"];
		NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM tProfile_Personal WHERE _Id=%@", profileId];
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
			[_arrProfiles removeObjectAtIndex:_delIndexPath.row];
			[_tblView reloadData];
		}
		_delIndexPath = nil;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrProfiles count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *item = [_arrProfiles objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:[item objectForKey:@"title"]];
	[cell.detailTextLabel setNumberOfLines:2];
	[cell.detailTextLabel setText:[item objectForKey:@"details"]];
	[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [FNASession sharedSession].profileId = nil;
    
    [FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i",indexPath.row +1];
    
    [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];

    [_rankingDelegate finishedDoingMyThing:@"success"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btn_Close release];
    [_tblView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtn_Close:nil];
    [self setTblView:nil];
    [super viewDidUnload];
}
- (IBAction)dismissView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
