//
//  IncomeProtectionViewController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/18/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "IncomeProtectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FNASession.h"
#import "FnaConstants.h"
#import "PriorityCalcNavController.h"
#import "Session_IncomeProtection.h"
#import "Support_IncomeProtection.h"
#import "MainSwitchViewController.h"
#import "Utility.h"
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"
#import "GetPersonalProfile.h"
#import "EmailSender.h"

@interface IncomeProtectionViewController ()

- (void) assignSessionValues;
- (void) updateValues;
- (void) initScrollView;

@end

@implementation IncomeProtectionViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self addTopButtons];
    [self setNavigationTitle];
    [self initOthers];
    
    [self startLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Income Protection - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Income Protection - Unknown Profile"];
    }
}

- (void) addTopButtons
{
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toActiveProfile)];
    
    //UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send to Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendData)];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toModal)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:newProfile, setProfile, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:homeButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) sendData
{
    if ([[FNASession sharedSession].profileId length] > 0) {
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_Income dataSet:kDataset_IncomeProtection];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
}

- (void) gotoHome {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

//TODO: refresh navigation title upon save
- (void) toModal
{
    [self performSegueWithIdentifier:@"toNewProfile_Income" sender:self];
}

//TODO: Refresh navigation title upon setting active profile
- (void) toActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Income" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Income"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Income"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
    }
}

#pragma mark - Custom Methods

- (void) initScrollView

{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(2917, 320)];
    
    [self.view addSubview:_scrollView];
    
}

- (void) initOthers
{
    _lbl_Overlay.layer.cornerRadius = 8;
	
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:self.imgTitle.layer.bounds].CGPath;
    [self.imgTitle.layer setShadowPath:shadowPath];
}

- (void) startLoading
{
    if ([self checkSession]) {
        
        if ( [[Support_IncomeProtection checkExisingEntry:[FNASession sharedSession].profileId]
              compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
            
            //load profile
            [Support_IncomeProtection getIncomeProtection];
            [self assignSessionValues];
            [self sendErrorMessage:kLoadSuccessful];
        }
        else {
            
            //new income protection
            [self initIncomeData];
        }
    }
    else {
        
      
        [self sendErrorMessage:kNoProfileActive];
    }
    
    [_txtHousing becomeFirstResponder];
}

- (BOOL) checkSession
{
    return [[FNASession sharedSession].profileId length]  == 0 ? NO : YES;
}

- (void) initIncomeData
{
    NSError *error =
    [Support_IncomeProtection
     newIncomeProtection:[FNASession sharedSession].profileId
     housing:[NSNumber numberWithDouble:0]
     food:[NSNumber numberWithDouble:0]
     utilities:[NSNumber numberWithDouble:0]
     transpo:[NSNumber numberWithDouble:0]
     clothing:[NSNumber numberWithDouble:0]
     entertainment:[NSNumber numberWithDouble:0]
     savings:[NSNumber numberWithDouble:0]
     medical:[NSNumber numberWithDouble:0]
     education:[NSNumber numberWithDouble:0]
     contribution:[NSNumber numberWithDouble:0]
     householdHelp:[NSNumber numberWithDouble:0]
     others:[NSNumber numberWithDouble:0]
     interestRate:[NSNumber numberWithDouble:1]
     insuranceNeed:@"Y"
     disabilityNeed:@"Y"
     protectionGoal:[NSNumber numberWithDouble:0]
     budget:[NSNumber numberWithDouble:0]
     notes:@"none"];
    
    if (error)
    {
        [self sendErrorMessage:[error localizedDescription]];
    }
    else {
        [self assignSessionValues];
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

- (void) assignSessionValues
{
    
    [_txtHousing setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].housing doubleValue]]];
    [_txtFood setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].food doubleValue]]];
    [_txtUtilities setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].utilities doubleValue]]];
    [_txtTransportation setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].transportation doubleValue]]];
    [_txtEntertainment setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].entertainment doubleValue]]];
    [_txtClothing setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].clothing doubleValue]]];
    [_txtSavings setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].savings doubleValue]]];
    [_txtEducation setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].education doubleValue]]];
    [_txtContribution setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].contribution doubleValue]]];
    [_txtHouseholdHelp setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].householdHelp doubleValue]]];
    [_txtOthers setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].others doubleValue]]];
    
    NSNumber *interestRateValue = [NSNumber numberWithFloat:([[Session_IncomeProtection sharedSession].interestRate floatValue] / 100)];
    
    NSNumber *monthlyExpense = [Support_IncomeProtection getMonthlyExpense];
    [_lbl_TotalMonthlyExpense setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@",monthlyExpense] withCurrencySymbol:@"P "]];
    
    NSNumber *annualExpense = [Support_IncomeProtection getAnnualExpense:monthlyExpense];
   
    
    [_lbl_TotalAnnualExpense setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", annualExpense] withCurrencySymbol:@"P "]];
    
    
    [_lbl_InsurancePolicies setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@",
                                                                         [FNASession sharedSession].totalInsurance] withCurrencySymbol:@"P "]];
    
    
    [_lbl_PersonalAssets setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].totalPersonalAssets] withCurrencySymbol:@"P "]];
    
    NSNumber *capitalRequired = [Support_IncomeProtection capitalRequired:[NSNumber numberWithDouble:[annualExpense doubleValue]] assumedInterestRate:interestRateValue] ;
    
    
    [_lbl_CapitalRequired setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", capitalRequired] withCurrencySymbol:@"P "]];
    
    NSNumber *protectionGoal = [Support_IncomeProtection getProtectionGoal:capitalRequired totalInsurance:[FNASession sharedSession].totalInsurance totalAssets:[FNASession sharedSession].totalPersonalAssets];
   
    [_lbl_ProtectionGoal setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", protectionGoal] withCurrencySymbol:@"P "]];
    
    [_sliderAnnualInterestRate setValue:[[Session_IncomeProtection sharedSession].interestRate floatValue] animated:YES];
    [_lbl_InterestRate setText:[NSString stringWithFormat:@"%.0f%%",_sliderAnnualInterestRate.value]];
    
    _segAccidentProtection.selectedSegmentIndex = [[Session_IncomeProtection sharedSession].disabilityNeed isEqualToString:@"Y"] ? 0 : 1;
    _segInsuranceMaintenance.selectedSegmentIndex = [[Session_IncomeProtection sharedSession].insuranceNeed isEqualToString:@"Y"] ? 0 : 1;
    
    [_txtArea_Notes setText:[Session_IncomeProtection sharedSession].notes];
    [_txtBudget setText:[NSString stringWithFormat:@"%.0f", [[Session_IncomeProtection sharedSession].budget doubleValue]]];
}

- (void) updateValues
{
    [Session_IncomeProtection sharedSession].housing = [NSNumber numberWithDouble:[_txtHousing.text doubleValue]];
    [Session_IncomeProtection sharedSession].food = [NSNumber numberWithDouble:[_txtFood.text doubleValue]];
    [Session_IncomeProtection sharedSession].utilities = [NSNumber numberWithDouble:[_txtUtilities.text doubleValue]];
    [Session_IncomeProtection sharedSession].transportation = [NSNumber numberWithDouble:[_txtTransportation.text doubleValue]];
    [Session_IncomeProtection sharedSession].entertainment = [NSNumber numberWithDouble:[_txtEntertainment.text doubleValue]];
    [Session_IncomeProtection sharedSession].clothing = [NSNumber numberWithDouble:[_txtClothing.text doubleValue]];
    [Session_IncomeProtection sharedSession].savings = [NSNumber numberWithDouble:[_txtSavings.text doubleValue]];
    [Session_IncomeProtection sharedSession].education = [NSNumber numberWithDouble:[_txtEducation.text doubleValue]];
    [Session_IncomeProtection sharedSession].contribution = [NSNumber numberWithDouble:[_txtContribution.text doubleValue]];
    [Session_IncomeProtection sharedSession].householdHelp = [NSNumber numberWithDouble:[_txtHouseholdHelp.text doubleValue]];
    [Session_IncomeProtection sharedSession].others = [NSNumber numberWithDouble:[_txtOthers.text doubleValue]];
    
    [Session_IncomeProtection sharedSession].interestRate = [NSNumber numberWithFloat:_sliderAnnualInterestRate.value];
    
    [Session_IncomeProtection sharedSession].insuranceNeed = _segInsuranceMaintenance.selectedSegmentIndex == 0 ? @"Y" : @"N";
    
    [Session_IncomeProtection sharedSession].disabilityNeed = _segAccidentProtection.selectedSegmentIndex == 0 ? @"Y" : @"N";
    
    [Session_IncomeProtection sharedSession].notes = _txtArea_Notes.text;
    
    [Session_IncomeProtection sharedSession].budget = [NSNumber numberWithDouble:[_txtBudget.text doubleValue]];
}

- (void) saveIncomeProtection
{
    [self updateValues];
    
    NSError *error =  [Support_IncomeProtection updateIncomeProtection];
    
    if (error)
    {
        [self sendErrorMessage:[error localizedDescription]];
    }
    else {
        [self sendErrorMessage:kLoadSuccessful];
    }
}

- (void) resetFields
{
    [_txtHousing setText:nil];
    [_txtFood setText:nil];
    [_txtUtilities setText:nil];
    [_txtTransportation setText:nil];
    [_txtEntertainment setText:nil];
    [_txtClothing setText:nil];
    [_txtSavings setText:nil];
    [_txtEducation setText:nil];
    [_txtContribution setText:nil];
    [_txtHouseholdHelp setText:nil];
    [_txtOthers setText:nil];
    [_txtBudget setText:nil];
    [_txtArea_Notes setText:nil];
    
    [_sliderAnnualInterestRate setValue:0 animated:YES];
    
    [_segAccidentProtection setSelectedSegmentIndex:0];
    [_segInsuranceMaintenance setSelectedSegmentIndex:0];
}

#pragma mark -
#pragma mark Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([labelString isEqualToString:@"success"]) {
        [self setNavigationTitle];
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self resetFields];
        [self startLoading];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        NSLog(@"%@", [FNASession sharedSession].profileId);
        NSLog(@"%@", [FNASession sharedSession].clientDob);
        [self setNavigationTitle];
        [self resetFields];
        [self startLoading];
    }
}



#pragma mark -
#pragma mark IBActions

- (IBAction)sliderInterestRate:(id)sender
{
    
    UISlider *slide = (UISlider*)sender;
    NSNumber *o = [NSNumber numberWithFloat:slide.value];
    
    [Session_IncomeProtection sharedSession].interestRate = o;
    [_lbl_InterestRate setText:[NSString stringWithFormat:@"%.0f%%",[o doubleValue]]];
}

- (IBAction)saveData:(id)sender {
    
    [self.view endEditing:YES];
    
    [self updateValues];
    [self assignSessionValues];
    [self saveIncomeProtection];
    
}

- (IBAction)calculateData:(id)sender {
    
    [self.view endEditing:YES];
    
    [self updateValues];
    [self assignSessionValues];
    
    [self resignFirstResponder];
}

- (IBAction)viewProducts:(id)sender {
    
    [FNASession sharedSession].selectedController = kSelectedController_Income;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) clearFields
{
    
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
    [_imgTitle release];
    [_scrollView release];
    [_txtHousing release];
    [_txtFood release];
    [_txtUtilities release];
    [_txtTransportation release];
    [_txtEntertainment release];
    [_txtClothing release];
    [_txtSavings release];
    [_txtEducation release];
    [_txtContribution release];
    [_txtHouseholdHelp release];
    [_txtOthers release];
    [_sliderAnnualInterestRate release];
    [_segInsuranceMaintenance release];
    [_segAccidentProtection release];
    [_txtBudget release];
    [_modalView release];
    [_lbl_Overlay release];
    [_lbl_InterestRate release];
    [_lbl_TotalMonthlyExpense release];
    [_lbl_TotalAnnualExpense release];
    [_lbl_CapitalRequired release];
    [_lbl_InsurancePolicies release];
    [_lbl_PersonalAssets release];
    [_lbl_ProtectionGoal release];
    [_btnCalculate release];
    [_navItem release];
    [_btn_viewProducts release];
    [_txtArea_Notes release];
    [_btnSaveData release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setImgTitle:nil];
    [self setScrollView:nil];
    [self setTxtHousing:nil];
    [self setTxtFood:nil];
    [self setTxtUtilities:nil];
    [self setTxtTransportation:nil];
    [self setTxtEntertainment:nil];
    [self setTxtClothing:nil];
    [self setTxtSavings:nil];
    [self setTxtEducation:nil];
    [self setTxtContribution:nil];
    [self setTxtHouseholdHelp:nil];
    [self setTxtOthers:nil];
    [self setSliderAnnualInterestRate:nil];
    [self setSegInsuranceMaintenance:nil];
    [self setSegAccidentProtection:nil];
    [self setTxtBudget:nil];
    [self setModalView:nil];
    [self setLbl_Overlay:nil];
    [self setLbl_InterestRate:nil];
    [self setLbl_TotalMonthlyExpense:nil];
    [self setLbl_TotalAnnualExpense:nil];
    [self setLbl_CapitalRequired:nil];
    [self setLbl_InsurancePolicies:nil];
    [self setLbl_PersonalAssets:nil];
    [self setLbl_ProtectionGoal:nil];
    [self setBtnCalculate:nil];
    [self setNavItem:nil];
    [self setBtn_viewProducts:nil];
    [self setTxtArea_Notes:nil];
    [self setBtnSaveData:nil];
    [super viewDidUnload];
}

@end
