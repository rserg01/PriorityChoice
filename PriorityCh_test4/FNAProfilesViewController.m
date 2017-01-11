	//
//  FNAProfilesViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAProfilesViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "SBJSON.h"
#import "Reacheability.h"
#import "AESCrypt.h"
#import "FNAProfileManagerViewController.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>
#import "Synch.h"
#import "FnaConstants.h"

@interface FNAProfilesViewController() {
      NSTimer *myTimer;
}
@property(nonatomic, retain) NSMutableArray *arrProfiles;
@property(nonatomic, retain) NSIndexPath *delIndexPath;
@property(nonatomic, assign) NSUInteger totalNumberOfClients;
- (void) showProfileTotal;

@end

@implementation FNAProfilesViewController

#pragma mark - 
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    
    _lbl_Overlay.layer.cornerRadius = 8;
}

- (void) viewWillAppear:(BOOL)animated
{ 
	[super viewWillAppear:animated];
    
    //Synch reminder
    [self sendErrorMessage:kReminder_PurgeReminder];
    
    //Notify deletion of records
    NSMutableArray *arrForPurge = [[GetPersonalProfile getProfilesForPurge]autorelease];
    
    if ([arrForPurge count] > 0) {
        
        [self sendErrorMessage:kReminder_RecordsPruged];
    }
    
    //Delete expired records
    [GetPersonalProfile checkDataStoreValidity];
    

    [FNASession sharedSession].arrProfiles=[GetPersonalProfile getAllProfileNames];
    
    if ([[FNASession sharedSession].arrProfiles count] > 0 )
    {
        _arrProfiles = [FNASession sharedSession].arrProfiles;
    }
    else {
        
        [self sendErrorMessage:kProfile_NoProfile];
    }
    
    
    [self showProfileTotal];
    [_tblProfiles reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Custom Methods

- (void) initNavigationBar
{
    self.navigationItem.title = @"Profiles";
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"Add New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(addAccount)];
    
    self.navigationItem.rightBarButtonItem = newProfile;
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    self.navigationItem.leftBarButtonItem = homeButton;
    
    [newProfile release];
    newProfile = nil;
    [homeButton release];
    homeButton = nil;
}

- (void) gotoHome
{
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void) loadProfiles
{
    _arrProfiles = [GetPersonalProfile getAllProfileNames];
}

- (void) getNumberOfClients
{
    _totalNumberOfClients = [_arrProfiles count];
}

- (void) sendErrorMessage: (NSString *)errorMessage
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) addAccount
{
    [FNASession sharedSession].profileId = nil;
    [FNASession sharedSession].name = nil;
    [self performSegueWithIdentifier:@"segueToFnaProfileManager" sender:self];
}

- (void) showProfileTotal
{
	[_lblTotal setText:[NSString stringWithFormat:@"%lu profile/s found", (unsigned long)[_arrProfiles count]]];
}

- (void) internetReachable
{
    [self sendErrorMessage:[GetPersonalProfile internetReachable]];
}


#pragma mark -
#pragma mark IBActions

-(IBAction)syncProfiles:(id)sender

{
    //get number of clients
    [self getNumberOfClients];
    _totalNumberOfClients = _totalNumberOfClients +1;
    
    NSString *successIndicator;
    
    if (_totalNumberOfClients != 0) {
        
        for (int i = 1; i < _totalNumberOfClients; i++)
        {
            NSString *clientId = [NSString stringWithFormat:@"%i",i];
            
            NSLog(@"count = %i", i);
            
            if([[Synch syncPersonal:clientId] isEqualToString:@"1"])
            {
                NSArray *tableArray = [NSArray arrayWithObjects:@"tProfile_Dependent", @"tProfile_Spouse", @"tPriorityRank", @"tEducFunding", @"tIncomeProtection", @"tRetirementPlanning", @"tFundAccumulation", @"tImpairedHealth", @"tEstatePlanning" , nil];
                
                NSArray *datasetArray = [NSArray arrayWithObjects:@"dependent", @"spouse", @"priorityDataSet", @"educDataSet", @"incomeDataSet", @"retirementDataSet", @"investmentDataSet", @"healthDataSet", @"estateDataSet" , nil];
                
                for (int i = 0; i < [tableArray count]; i++) {
                    
                    if([[Synch syncOtherTables:[tableArray objectAtIndex:i] withDataSet:[datasetArray objectAtIndex:i] withClientId:clientId] isEqualToString:@"1"])
                    {
                        successIndicator = @"1";
                        
                    }
                }
                
            }
            
        }
        
        [self sendErrorMessage:@"Synchronization successful"];
    }
    
    [GetPersonalProfile purgeSequence];
    
    [self gotoHome];
}


#pragma mark -
#pragma mark Table view data source

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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    
    NSLog(@"selected row: %li", (long)indexPath.row);
    
    [FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i",indexPath.row +1];
    
    NSLog(@"ProfileId= %@", [FNASession sharedSession].profileId);
    
    [self performSegueWithIdentifier:@"segueToFnaProfileManager" sender:self];
    
}



- (void)viewDidUnload {
    [self setBtnSync:nil];
    [self setImgTemplate:nil];
    [self setLbl_Overlay:nil];
    [self setArrProfiles:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_tblProfiles release];
	[_lblTotal release];
	[_arrProfiles release];
	[_delIndexPath release];
    [_btnSync release];
    [_imgTemplate release];
    [_lbl_Overlay release];
    [super dealloc];
}


@end
