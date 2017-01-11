//
//  ModalQuestionnaireViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 7/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalQuestionnaireViewController.h"
#import "RiskCapacityViewController.h"
#import "RiskAttitudeViewController.h"
#import "Session_Manucare.h"
#import "Support_Manucare.h"
#import "FNASession.h"

@interface ModalQuestionnaireViewController ()

@property (nonatomic, retain) NSMutableArray *arr;

@end

@implementation ModalQuestionnaireViewController

@synthesize delegate_Questions = _delegate_Questions;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_arr removeAllObjects];
    
    [self setArr:[Session_Manucare sharedSession].arr_Answers];
}

#pragma mark - Custom Methods

- (void) updateScores: (NSString *) question score:(NSNumber *) score
{
    //Risk Capacity
    if ([question isEqualToString:@"TimeFrame"]) {
        [Session_Manucare sharedSession].timeFrame = score;
    }
    if ([question isEqualToString:@"Retirement"]) {
        [Session_Manucare sharedSession].retirementPlan = score;
    }
    if ([question isEqualToString:@"CashFlow"]) {
        [Session_Manucare sharedSession].cashFlowNeeds = score;
    }
    if ([question isEqualToString:@"NeedForInvestment"]) {
        [Session_Manucare sharedSession].needForInvestment = score;
        NSLog(@"need for investment score = %@", score);
    }
    if ([question isEqualToString:@"InvestmentDrop"]) {
        [Session_Manucare sharedSession].investmentDrop = score;
    }
    if ([question isEqualToString:@"InterestValue"]) {
        [Session_Manucare sharedSession].interestValue = score;
    }
    if ([question isEqualToString:@"Returns"]) {
        [Session_Manucare sharedSession].returns = score;
    }
    if ([question isEqualToString:@"RiskDegree"]) {
        [Session_Manucare sharedSession].riskDegree = score;
    }
    if ([question isEqualToString:@"Review"]) {
        [Session_Manucare sharedSession].reviewFrequency = score;
    }
    if ([question isEqualToString:@"Overall"]) {
        [Session_Manucare sharedSession].overallAttitude = score;
    }
    
    [Support_Manucare updateManucare:[FNASession sharedSession].profileId];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arr count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *item = [_arr objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setNumberOfLines:5];
	[cell.textLabel setText:[item objectForKey:@"option"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row: %i", indexPath.row);
    
    NSDictionary *item = [_arr objectAtIndex:3];
    
    NSString *question = [[[NSString alloc]init]autorelease];
    question = [item objectForKey:@"question"];
    
    [self updateScores:question score:[NSNumber numberWithInt:(indexPath.row + 1)]];
}



#pragma mark - IBAction

- (IBAction)done:(id)sender {
    
    [_delegate_Questions finishedDoingMyThing:@""];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_navBtn release];
    [_arr release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblView:nil];
    [self setNavBtn:nil];
    [self setArr:nil];
    [super viewDidUnload];
}

@end
