//
//  ModalActiveProfileViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalActiveProfileViewController.h"
#import "FNASession.h"
#import "FnaConstants.h"
#import "GetPersonalProfile.h"

@interface ModalActiveProfileViewController ()

@property(nonatomic, retain) NSMutableArray *arrProfiles;
@property(nonatomic, retain) NSIndexPath *delIndexPath;
@property(nonatomic, assign) int totalNumberOfClients;

@end

@implementation ModalActiveProfileViewController

@synthesize delegate1 = _delegate1;

#pragma mark -
#pragma mark Life Cycle

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
    
    [self addTopButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Custom Methods

- (void) addTopButtons
{
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(exitModal)]autorelease];
    
    UINavigationItem *item = [[[UINavigationItem alloc] init]autorelease];
    item.rightBarButtonItem = cancelButton;
    item.hidesBackButton = YES;
    
    [_navBar pushNavigationItem:item animated:NO];
    
}

- (void) sendErrorMessage: (NSString *)errorMessage
{
    
    UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]autorelease];
    [alert show];
}

- (void) exitModal
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    
    NSDictionary *item = [[[NSDictionary alloc]init]autorelease];
    item = [_arrProfiles objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
    NSString *profileId = [[[NSString alloc]init]autorelease];
    
    [FNASession sharedSession].profileId = nil;
    [FNASession sharedSession].dependentId = nil;
    
    profileId = [NSString stringWithFormat:@"%i",indexPath.row +1];
    
    [GetPersonalProfile GetPersonalProfile:profileId];
    
    [FNASession sharedSession].profileId = profileId;
    
    [_delegate1 finishedDoingMyThing:@"success_activeProfile"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_navBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblView:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
