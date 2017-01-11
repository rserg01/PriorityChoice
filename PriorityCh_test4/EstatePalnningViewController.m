//
//  EstatePalnningViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/8/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "EstatePalnningViewController.h"
#import "FNASession.h"
#import "Session_EstatePlanning.h"
#import "Support_EstatePlanning.h"
#import <QuartzCore/QuartzCore.h>
#import "FnaConstants.h"
#import "GetPersonalProfile.h"
#import "EmailSender.h"
#import "Utility.h"

@interface EstatePalnningViewController ()

@end

@implementation EstatePalnningViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self setNavigationTitle];
    [self addTopButtons];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [self loadEstatePlanning];
   
    [_txtFuneral becomeFirstResponder];
}

#pragma mark -
#pragma mark Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Estate Planning - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Estate Planning - Unknown Profile"];
    }
}

- (void) addTopButtons
{
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toActiveProfile)];
    
    //UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send to Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendData:)];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(toModal)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:newProfile, setProfile, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:homeButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) sendData
{
    if ([[FNASession sharedSession].profileId length] > 0) {
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_EstatePlanning dataSet:kDataset_Estate];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
}

- (void) gotoHome
{
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

//TODO: refresh navigation title upon save
- (void) toModal
{
    [self performSegueWithIdentifier:@"toNewProfile_Estate" sender:self];
}

//TODO: Refresh navigation title upon setting active profile
- (void) toActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Estate" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Estate"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Estate"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
    }
}


#pragma mark -
#pragma mark Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(1498, 320)];
    //_scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    //_scrollView.layer.borderWidth = 2;
    
    [self.view addSubview:_scrollView];
    
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

- (void) loadEstatePlanning
{
    if (![[FNASession sharedSession].profileId length] == 0 ) {
        
        NSNumber *exsitingEntry = [Support_EstatePlanning checkExisingEntry:[FNASession sharedSession].profileId];
        NSLog(@"existingEntry = %@", exsitingEntry);
        
        if ([exsitingEntry intValue] > 0) {
            
            NSError *err_getEstatePlanning = [Support_EstatePlanning getEstatePlanning:[FNASession sharedSession].profileId];
            
            if (err_getEstatePlanning) {
                [self sendErrorMessage:err_getEstatePlanning.localizedDescription];
            }
            else {
                [self assignToFields];
                [self sendErrorMessage:kLoadSuccessful];
            }
        }
        else {
            
            NSError *err_newEstatePlanning = [Support_EstatePlanning newEstatePlanning:[FNASession sharedSession].profileId];
            
            if (err_newEstatePlanning) {
                [self sendErrorMessage:err_newEstatePlanning.localizedDescription];
            }
            else {
                
                NSError *err_getEstatePlanning = [Support_EstatePlanning getEstatePlanning:[FNASession sharedSession].profileId];
                
                if (err_getEstatePlanning) {
                    
                    [self sendErrorMessage:err_newEstatePlanning.localizedDescription];
                }
                else {
                    [self assignToFields];
                }
            }
        }
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }

}

- (void) assignToFields
{
    [_txtFuneral setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_funeral]];
    [_txtJudicial setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_judicial]];
    [_txtEstateClaims setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_estateClaims]];
    [_txtInsolvency setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_insolvency]];
    [_txtMortgages setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_unpaidMortgage]];
    [_txtMedicalExpence setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_medical]];
    [_txtRetirement setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_retirement]];
    [_txtStandardDeduction setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_standardDedudction]];
    [_txtSpouse setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].exp_spouseInterest]];
    [_txtBudget setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].budget]];
    [_notes setText:[NSString stringWithFormat:@"%@", [Session_EstatePlanning sharedSession].notes]];
}

- (void) getValuesFromInput
{
    [Session_EstatePlanning sharedSession].exp_funeral = [NSNumber numberWithFloat:[_txtFuneral.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_judicial = [NSNumber numberWithFloat:[_txtJudicial.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_estateClaims = [NSNumber numberWithFloat:[_txtEstateClaims.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_insolvency = [NSNumber numberWithFloat:[_txtInsolvency.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_unpaidMortgage = [NSNumber numberWithFloat:[_txtMortgages.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_medical = [NSNumber numberWithFloat:[_txtMedicalExpence.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_retirement = [NSNumber numberWithFloat:[_txtRetirement.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_standardDedudction = [NSNumber numberWithFloat:[_txtStandardDeduction.text floatValue]];
    [Session_EstatePlanning sharedSession].exp_spouseInterest = [NSNumber numberWithFloat:[_txtSpouse.text floatValue]];
    [Session_EstatePlanning sharedSession].budget = [NSNumber numberWithFloat:[_txtFuneral.text floatValue]];
    [Session_EstatePlanning sharedSession].notes = [NSString stringWithFormat:@"%@",_notes.text];
    
    NSLog(@"exp_funeral = %@", [Session_EstatePlanning sharedSession].exp_funeral);
}

- (void) updateLabels
{
    NSString *profileId = [[[NSString alloc]initWithString:[FNASession sharedSession].profileId]autorelease];
    
    NSNumber *deductions = [Support_EstatePlanning computeTotalExpenses];
    NSNumber *grossEstate =[Support_EstatePlanning computeGrossEstate:
                            [GetPersonalProfile getTotalPersonalAssets:profileId]
                                                             business:[GetPersonalProfile getTotalBusiness:profileId]
                                                         realProperty:[GetPersonalProfile getTotalRealProperty:profileId]
                                                            insurance:[GetPersonalProfile getTotalInsurance:profileId]];
    NSNumber *netEstate = [Support_EstatePlanning computeNetEstate:grossEstate
                                                        deductions:deductions];
    NSNumber *estateTaxDue = [Support_EstatePlanning computeEstateTax:grossEstate
                                                           deductions:deductions
                                                            netEstate:netEstate
                                                           appliedTax:[Support_EstatePlanning computeAppliedTax:netEstate]
                                                           percentage:[Support_EstatePlanning computePercentage:netEstate]
                                                         excessAmount:[Support_EstatePlanning computeExcessAmount:netEstate]];
    NSNumber *appliedtaxRate = [Support_EstatePlanning computeAppliedTax:netEstate];
    NSNumber *gap = [Support_EstatePlanning computeGap:grossEstate deductions:deductions estateTaxDue:estateTaxDue];
    
    NSNumber *personalAsset = [GetPersonalProfile getTotalPersonalAssets:profileId];
    NSNumber *insurance = [GetPersonalProfile getTotalInsurance:profileId];
    NSNumber *realProperty = [GetPersonalProfile getTotalRealProperty:profileId];
    NSNumber *business = [GetPersonalProfile getTotalBusiness:profileId];
    
    
    NSString *deductionString = [Utility fortmatNumberCurrencyStyle:
                                 [NSString stringWithFormat:@"%.2f", [deductions doubleValue]]
                                                 withCurrencySymbol:kPhilippineCurrency];
    NSString *grossEstateString = [Utility fortmatNumberCurrencyStyle:
                                   [NSString stringWithFormat:@"%.2f", [grossEstate doubleValue]]
                                                   withCurrencySymbol:kPhilippineCurrency];
    NSString *netEstateString = [Utility fortmatNumberCurrencyStyle:
                                 [NSString stringWithFormat:@"%.2f", [netEstate doubleValue]]
                                                 withCurrencySymbol:kPhilippineCurrency];
    NSString *estateTaxDueString = [Utility fortmatNumberCurrencyStyle:
                                    [NSString stringWithFormat:@"%.2f", [estateTaxDue doubleValue]]
                                                    withCurrencySymbol:kPhilippineCurrency];
    NSString *appliedTaxRateString = [Utility fortmatNumberCurrencyStyle:
                                      [NSString stringWithFormat:@"%.2f", [appliedtaxRate doubleValue]]
                                                      withCurrencySymbol:kPhilippineCurrency];
    NSString *gapString = [Utility fortmatNumberCurrencyStyle:
                           [NSString stringWithFormat:@"%.2f", [gap doubleValue]]
                                           withCurrencySymbol:kPhilippineCurrency];
    NSString *personalAssetString = [Utility fortmatNumberCurrencyStyle:
                                      [NSString stringWithFormat:@"%.2f", [personalAsset doubleValue]]
                                                      withCurrencySymbol:kPhilippineCurrency];
    NSString *insuranceString = [Utility fortmatNumberCurrencyStyle:
                                      [NSString stringWithFormat:@"%.2f", [insurance doubleValue]]
                                                      withCurrencySymbol:kPhilippineCurrency];
    NSString *realPropertyString = [Utility fortmatNumberCurrencyStyle:
                                      [NSString stringWithFormat:@"%.2f", [realProperty doubleValue]]
                                                      withCurrencySymbol:kPhilippineCurrency];
    NSString *businessString = [Utility fortmatNumberCurrencyStyle:
                                      [NSString stringWithFormat:@"%.2f", [business doubleValue]]
                                                      withCurrencySymbol:kPhilippineCurrency];
    
    
    [_lbl_Deductions setText:[NSString stringWithFormat:@"%@", deductionString]];
    [_lbl_GrossEstate setText:[NSString stringWithFormat:@"%@", grossEstateString]];
    [_lbl_NetTaxableEstate setText:[NSString stringWithFormat:@"%@", netEstateString]];
    [_lbl_AppliedTaxRate setText:[NSString stringWithFormat:@"%@", appliedTaxRateString]];
    [_lbl_EstateTaxDue setText:[NSString stringWithFormat:@"%@", estateTaxDueString]];
    [_lbl_Gap setText:[NSString stringWithFormat:@"%@", gapString]];
    
    [_lbl_TotalPersonalAsset setText:[NSString stringWithFormat:@"%@", personalAssetString]];
    [_lbl_TotalInsurance setText:[NSString stringWithFormat:@"%@", insuranceString]];
    [_lbl_TotalRealProperty setText:[NSString stringWithFormat:@"%@", realPropertyString]];
    [_lbl_Business setText:[NSString stringWithFormat:@"%@", businessString]];
}

- (void) clearLabels
{
    [_lbl_Deductions setText:@"0"];
    [_lbl_GrossEstate setText:@"0"];
    [_lbl_NetTaxableEstate setText:@"0"];
    [_lbl_AppliedTaxRate setText:@"0"];
    [_lbl_EstateTaxDue setText:@"0"];
    
    [_lbl_TotalPersonalAsset setText:@"0"];
    [_lbl_TotalRealProperty setText:@"0"];
    [_lbl_TotalInsurance setText:@"0"];
}

#pragma mark -
#pragma mark Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([labelString isEqualToString:@"success"]) {
        [self setNavigationTitle];
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self clearLabels];
        [self loadEstatePlanning];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self clearLabels];
        [self loadEstatePlanning];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)updateLabels:(id)sender {
    [self.view endEditing:YES];
    [self getValuesFromInput];
    [self updateLabels];
}

- (IBAction)saveInfo:(id)sender {
    [self.view endEditing:YES];
    [self getValuesFromInput];
    [self updateLabels];
    [Support_EstatePlanning updateEstatePlanning:[FNASession sharedSession].profileId];
}

- (IBAction)viewProducts:(id)sender {
    
    [FNASession sharedSession].selectedController = kSelectedController_Estate;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtFuneral release];
    [_txtJudicial release];
    [_txtEstateClaims release];
    [_txtInsolvency release];
    [_txtMortgages release];
    [_txtMedicalExpence release];
    [_txtRetirement release];
    [_txtStandardDeduction release];
    [_txtSpouse release];
    [_txtBudget release];
    [_notes release];
    [_lbl_Overlay release];
    [_lbl_TotalPersonalAsset release];
    [_lbl_GrossEstate release];
    [_lbl_NetTaxableEstate release];
    [_lbl_EstateTaxDue release];
    [_lbl_TotalRealProperty release];
    [_lbl_TotalInsurance release];
    [_lbl_Business release];
    [_scrollView release];
    [_lbl_NetTaxableEstate release];
    [_lbl_AppliedTaxRate release];
    [_lbl_GrossEstate release];
    [_lbl_Deductions release];
    [_lbl_Gap release];
    [_btnSave release];
    [_btnCompute release];
    [_navItem release];
    [_btn_viewProducts release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtFuneral:nil];
    [self setTxtJudicial:nil];
    [self setTxtEstateClaims:nil];
    [self setTxtInsolvency:nil];
    [self setTxtMortgages:nil];
    [self setTxtMedicalExpence:nil];
    [self setTxtRetirement:nil];
    [self setTxtStandardDeduction:nil];
    [self setTxtSpouse:nil];
    [self setTxtBudget:nil];
    [self setNotes:nil];
    [self setLbl_Overlay:nil];
    [self setLbl_TotalPersonalAsset:nil];
    [self setLbl_GrossEstate:nil];
    [self setLbl_NetTaxableEstate:nil];
    [self setLbl_EstateTaxDue:nil];
    [self setLbl_TotalRealProperty:nil];
    [self setLbl_TotalInsurance:nil];
    [self setLbl_Business:nil];
    [self setScrollView:nil];
    [self setLbl_NetTaxableEstate:nil];
    [self setLbl_AppliedTaxRate:nil];
    [self setLbl_GrossEstate:nil];
    [self setLbl_Deductions:nil];
    [self setLbl_Gap:nil];
    [self setBtnSave:nil];
    [self setBtnCompute:nil];
    [self setNavItem:nil];
    [self setBtn_viewProducts:nil];
    [super viewDidUnload];
}

@end
