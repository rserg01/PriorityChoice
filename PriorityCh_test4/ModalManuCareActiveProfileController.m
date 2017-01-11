//
//  ModalManuCareActiveProfileController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalManuCareActiveProfileController.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import "FnaConstants.h"
#import "Session_Manucare.h"

@interface ModalManuCareActiveProfileController ()

@property(nonatomic, retain) NSMutableArray *arrProfiles;
@property(nonatomic, retain) NSIndexPath *delIndexPath;
@property(nonatomic, assign) int totalNumberOfClients;

@end

@implementation ModalManuCareActiveProfileController

@synthesize delegate_ActiveProfile = _delegate_ActiveProfile;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FNASession sharedSession].arrProfiles = [GetPersonalProfile getAllProfileNames];
    
    if ([[FNASession sharedSession].arrProfiles count] > 0 )
    {
        _arrProfiles = [FNASession sharedSession].arrProfiles;
    }
    else {
        
        [self sendErrorMessage:kProfile_NoProfile];
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
    //clear sessions
    [FNASession sharedSession].profileId = nil;
    [Session_Manucare sharedSession].riskCapacityScore = nil;
    [Session_Manucare sharedSession].riskAttitudeScore = nil;
    
    [Session_Manucare sharedSession].timeFrame = nil;
    [Session_Manucare sharedSession].retirementPlan = nil;
    [Session_Manucare sharedSession].needForInvestment= nil;
    [Session_Manucare sharedSession].cashFlowNeeds = nil;
    [Session_Manucare sharedSession].ageScore = nil;
    
    [Session_Manucare sharedSession].ageScore = nil;
    [Session_Manucare sharedSession].interestValue = nil;
    [Session_Manucare sharedSession].returns = nil;
    [Session_Manucare sharedSession].riskDegree = nil;
    [Session_Manucare sharedSession].reviewFrequency = nil;
    [Session_Manucare sharedSession].overallAttitude = nil;

    
    NSLog(@"selected row: %i", indexPath.row);
    
    [FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i",indexPath.row +1];
    
    NSLog(@"ProfileId= %@", [FNASession sharedSession].profileId);
    
    [_delegate_ActiveProfile finishedDoingMyThing:@"success_activeProfile"];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_btn_Close release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblView:nil];
    [self setBtn_Close:nil];
    [super viewDidUnload];
}
- (IBAction)closeModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
