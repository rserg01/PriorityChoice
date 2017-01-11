//
//  ManucareViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ManucareViewController.h"
#import "MainSwitchViewController.h"
#import "Session_Manucare.h"
#import "Support_Manucare.h"
#import "FNASession.h"
#import "ModalManuCareActiveProfileController.h"
#import "ModalManucareNewProfileController.h"
#import "GetPersonalProfile.h"
#import "FnaConstants.h"

@interface ManucareViewController ()

@end

@implementation ManucareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle];
    [self addTopButtons];
    [self disableTabsForNoProfile];
    
    _lblBg.layer.cornerRadius = 8;
    _lbl_Overlay_RiskAttitude.layer.cornerRadius = 8;
    _lbl_Overlay_RiskCapacity.layer.cornerRadius = 8;

}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"profileId= %@", [FNASession sharedSession].profileId);
    
    if ([[FNASession sharedSession].profileId  length] != 0) {
        
        [Support_Manucare getManucare:[FNASession sharedSession].profileId];
        
        if ([Session_Manucare sharedSession].ageScore == 0) {
            
            NSNumber *ageScore = [Support_Manucare getAgeScore];
            [Session_Manucare sharedSession].ageScore = ageScore;
            [Support_Manucare newManucare:[FNASession sharedSession].profileId ageScore:ageScore];
            [Support_Manucare getManucare:[FNASession sharedSession].profileId];
        }
        
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
    
    [self updateScoreLabels];
    
}

#pragma mark - Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"ManuCARE - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"ManuCARE - Unknown Profile"];
    }
}

- (void) addTopButtons
{
    
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toModalActiveProfile)];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome:)];
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toModalNewProfile)];
    
    [_navItem setRightBarButtonItems:[NSArray arrayWithObjects:newProfile, setProfile, nil] animated:YES];
    [_navItem setLeftBarButtonItems:[NSArray arrayWithObjects:homeButton, nil] animated:YES];
    
}

- (void) disableTabsForNoProfile
{
    UITabBarItem *tabBar_RiskCapacity = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBar_RiskAttitude = [self.tabBarController.tabBar.items objectAtIndex:2];
    
    if ([[FNASession sharedSession].profileId length] == 0) {
        
        [tabBar_RiskCapacity setEnabled:NO];
        [tabBar_RiskAttitude setEnabled:NO];
    }
    else {
        
        [tabBar_RiskCapacity setEnabled:YES];
        [tabBar_RiskAttitude setEnabled:YES];
    }
}

- (void) toModalActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile" sender:self];
}

- (void) toModalNewProfile
{
    [self performSegueWithIdentifier:@"toNewProfile" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toActiveProfile"]) {
        [[segue destinationViewController] setDelegate_ActiveProfile:self];
        ModalManuCareActiveProfileController *modal = [[[ModalManuCareActiveProfileController alloc]init]autorelease];
        modal.delegate_ActiveProfile = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toNewProfile"]) {
        [[segue destinationViewController] setDelegate_NewProfile:self];
        ModalManucareNewProfileController *modal = [[[ModalManucareNewProfileController alloc]init]autorelease];
        modal.delegate_NewProfile = self;
    }
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

#pragma mark - Custom Methods

- (void) updateScoreLabels
{
    NSLog(@"riskAttitudeScore = %@", [Session_Manucare sharedSession].riskCapacityScore);
    NSLog(@"riskCapacityScore = %@", [Session_Manucare sharedSession].riskAttitudeScore);

    
    NSString *riskCapacityScoreInterpretation = [Support_Manucare riskCapacitytScoreInterpretation:[Session_Manucare sharedSession].riskCapacityScore];
    NSString *riskAttitudeScoreInterpretation = [Support_Manucare riskAttitudeScoreInterpretation:[Session_Manucare sharedSession].riskAttitudeScore];
    
    NSLog(@"riskAttitudeInterpretation = %@", riskAttitudeScoreInterpretation);
    NSLog(@"riskCapacityInterpretation = %@", riskCapacityScoreInterpretation);
    
    [_lbl_RiskCapacity_WriteUp setText:riskCapacityScoreInterpretation];
    [_lbl_RiskAttitude_WriteUp setText:riskAttitudeScoreInterpretation];
    
}

- (void) clearLabels
{
    [_lbl_RiskCapacity_WriteUp setText:@""];
    [_lbl_RiskAttitude_WriteUp setText:@""];
}

#pragma mark - IBActions

- (IBAction)gotoHome:(id)sender {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoFunds:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FundsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FundsStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString
{
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self disableTabsForNoProfile];
        [self clearLabels];
        [Support_Manucare clearValues];
        
        [Support_Manucare getManucare:[FNASession sharedSession].profileId];
        
        NSLog(@"ageScore = %@", [Session_Manucare sharedSession].ageScore);
        
        if ([[Session_Manucare sharedSession].ageScore isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            NSNumber *ageScore = [Support_Manucare getAgeScore];
            [Support_Manucare newManucare:[FNASession sharedSession].profileId ageScore:ageScore];
            
            [Support_Manucare getManucare:[FNASession sharedSession].profileId];
        }
        
        [self updateScoreLabels];

    }
    
    if ([labelString isEqualToString:@"success_NewProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self disableTabsForNoProfile];
        [self clearLabels];
        
        NSNumber *ageScore = [Support_Manucare getAgeScore];
        [Support_Manucare newManucare:[FNASession sharedSession].profileId ageScore:ageScore];
        [Support_Manucare getManucare:[FNASession sharedSession].profileId];
        
        [self updateScoreLabels];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblWriteUp release];
    [_lblBg release];
    [_lbl_Overlay_RiskCapacity release];
    [_lbl_Overlay_RiskAttitude release];
    [_lbl_RiskCapacity_WriteUp release];
    [_lbl_RiskAttitude_WriteUp release];
    [_navItem release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblWriteUp:nil];
    [self setLblBg:nil];
    [self setLbl_Overlay_RiskCapacity:nil];
    [self setLbl_Overlay_RiskAttitude:nil];
    [self setLbl_RiskCapacity_WriteUp:nil];
    [self setLbl_RiskAttitude_WriteUp:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
}

@end
