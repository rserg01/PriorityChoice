//
//  DependentViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "DependentViewController.h"
#import "FNASession.h"
#import "FnaConstants.h"
#import "Support_Education.h"
#import "EducationViewController.h"
#import "GetPersonalProfile.h"

@interface DependentViewController ()

@end

@implementation DependentViewController

@synthesize delegate_Dependent = _delegate_Dependent;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tblView setDataSource:self];
    [_tblView setDelegate:self];
    
    if ([[FNASession sharedSession].profileId length] > 0) {
        
        [FNASession sharedSession].arrDependents = [GetPersonalProfile getDependents:[FNASession sharedSession].profileId];
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [alert release]; // if you are not using ARC
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[FNASession sharedSession].arrDependents count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *item = [[FNASession sharedSession].arrDependents objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@", [item objectForKey:@"title"]]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell.textLabel setText:[NSString stringWithFormat:@"%@", [item objectForKey:@"title"]]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [[FNASession sharedSession].arrDependents objectAtIndex:indexPath.row];
    
    [FNASession sharedSession].dependentId = [dic objectForKey:@"dependentId"];
    NSLog(@"%@", [FNASession sharedSession].dependentId);
    
    [_delegate_Dependent finishedDoingMyThing:@"dependentSelected"];
}

#pragma mark - Memory Management

- (void)dealloc {
    [_tblView release];
    [_navBtn_Done release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblView:nil];
    [self setNavBtn_Done:nil];
    [super viewDidUnload];
}
- (IBAction)closeModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
