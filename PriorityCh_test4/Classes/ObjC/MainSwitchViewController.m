//
//  MainSwitchViewController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "MainSwitchViewController.h"
#import "AppDelegate.h"
#import "FNAPriorityCompassViewController.h"
#import "FNASession.h"
#import <QuartzCore/QuartzCore.h>
#import "Reacheability.h"
#import "FnaConstants.h"
#import "GetPersonalProfile.h"
#import "Synch.h"

@interface MainSwitchViewController ()

@end

@implementation MainSwitchViewController

@synthesize viewPopup= _viewPopup;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //FOR DEBUG PURPOSES
    //[FNASession sharedSession].agentCode = @"123";
    //[FNASession sharedSession].profileId = @"1";
    
    _btnManucare.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnManucare.layer.shadowOpacity = 0.5;
    _btnManucare.layer.shadowRadius = 8;
    _btnManucare.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    //[self sendErrorMessage:kReminder_IdleTime];
    
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



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_nav release];
    [_btnProfileManager release];
    [_btnPriorityCompass release];
    [_btnPriorityRanking release];
    [_btnProducts release];
    [_btnAboutManulife release];
    [_btnManucare release];
    [_viewPopup release];
    [_btn_FinCalc release];
    [_btnSync release];
    [super dealloc];
    
}
- (void)viewDidUnload {
    [self setNav:nil];
    [self setBtnProfileManager:nil];
    [self setBtnPriorityCompass:nil];
    [self setBtnPriorityRanking:nil];
    [self setBtnProducts:nil];
    [self setBtnAboutManulife:nil];
    [self setBtnManucare:nil];
    [self setViewPopup:nil];
    [self setBtn_FinCalc:nil];
    [self setBtnSync:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)gotoProducts:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoCompass:(id)sender {
    
    FNAPriorityCompassViewController *sampleView = [[[FNAPriorityCompassViewController alloc] init] autorelease];
    [sampleView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:sampleView animated:YES completion:NULL];
    
}

- (IBAction)gotoRankings:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RankingStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RankingStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoProfileManager:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProfileManagerStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProfileManagerStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoManucare:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ManucareStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ManucareStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoFinCalc:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FinancialCalcStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FinancialCalcStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)gotoAbout:(id)sender {
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AboutStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AboutStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void) initPopUpView {
//    _viewPopup.alpha = 1;
//    _viewPopup.frame = CGRectMake (160, 240, 0, 0);
//    _viewPopup.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_viewPopup];
}

- (void) animatePopUpShow {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(initPopUpView)];
    
    _viewPopup.alpha = 1;
    _viewPopup.frame = CGRectMake (20, 40, 300, 400);
    
    [UIView commitAnimations];
}

@end
