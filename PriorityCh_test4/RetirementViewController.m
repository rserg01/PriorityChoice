//
//  RetirementViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/5/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "RetirementViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FNASession.h"
#import "Utility.h"
#import "Session_Retirement.h"
#import "Support_Retirement.h"
#import "GetPersonalProfile.h"
#import "FnaConstants.h"
#import "EmailSender.h"


@interface RetirementViewController ()

@property (nonatomic, retain) NSNumber *currentAge;
@property (nonatomic, retain) NSString *profileId;

- (NSNumber *) age: (NSString *)birthdate;
- (void) loadRetirement;
- (void) sendErrorMessage:(NSString *)errorMessage;
@end

@implementation RetirementViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self initSegments];
    [self initSliders];
    [self addTopButtons];

    _lbl_Overlay.layer.cornerRadius = 8;
    
    [self setNavigationTitle];
    
    _profileId = [FNASession sharedSession].profileId;
    
    if ([_profileId length] > 0) {
        [GetPersonalProfile GetPersonalProfile:_profileId];
        [self startLoading];
    }
    else {
        [self sendErrorMessage:kNoProfileActive];
    }
    
    [_txtMonthlyIncome becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Retirement - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Retirement - Unknown Profile"];
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
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_Retirement dataSet:kDataset_Retirement];
        
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
    [self performSegueWithIdentifier:@"toNewProfile_Retirement" sender:self];
}

//TODO: Refresh navigation title upon setting active profile
- (void) toActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Retirement" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Retirement"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Retirement"]) {
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
    [_scrollView setContentSize:CGSizeMake(3293, 320)];
    //_scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    //_scrollView.layer.borderWidth = 2;
    
    [self.view addSubview:_scrollView];
    
}

- (void) initSliders
{
    
    [_slide_RetirementAge setMinimumValue:[_currentAge floatValue]];
    [_slide_RetirementAge setMaximumValue:70];
    
    [_slider_InflationFactor setMinimumValue:0];
    [_slider_InflationFactor setMaximumValue:15];
    
    [_slide_RateOfReturn setMinimumValue:0];
    [_slide_RateOfReturn setMaximumValue:15];
    
    [_slide_ServiceYears setMinimumValue:0];
    [_slide_ServiceYears setMaximumValue:47];
    
    [_slide_AnnualIncrease setMinimumValue:0];
    [_slide_AnnualIncrease setMaximumValue:15];
}

- (void) initSegments
{
    if ([Session_Retirement sharedSession].retirementBenefitFactor == 0) {
        [Session_Retirement sharedSession].retirementBenefitFactor = [Support_Retirement getRetirementBenefitFactor:0];
    }
    else {
        _seg_RetirementBenefitFactor.selectedSegmentIndex = [[Session_Retirement sharedSession].retirementBenefitFactor intValue];
    }
}

- (void) setUpCurrentAge
{
    //set up current age
    if ([[FNASession sharedSession].clientDob length] > 0){
        _currentAge = [self age:[FNASession sharedSession].clientDob];
        [_lblCurrentAge setText:[NSString stringWithFormat:@"%@", _currentAge]];
    }
    else {
        _currentAge = 0;
        [_lblCurrentAge setText:@"0"];
    }
}

- (NSNumber *) age: (NSString *)birthdate
{    
    NSDate *date = [Support_Retirement getBirthdate:birthdate];
    NSNumber *ageInt = [Support_Retirement getCurrentAge:date];
    return ageInt;
}

#pragma mark -
#pragma mark Loading Methods

- (void) startLoading
{
    
    if ([[Support_Retirement checkExisingEntry:_profileId] compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        [self setUpCurrentAge];
        [Support_Retirement getRetirement:_profileId];
        [self loadRetirement];
        [self computeRetirement];
        [self sendErrorMessage:kLoadSuccessful];
    }
    else {
       
        NSError *error = [[[NSError alloc]init]autorelease];
        error = [Support_Retirement newRetirement:[FNASession sharedSession].profileId];
        if (error) {
            [self sendErrorMessage:[error localizedDescription]];
        }
        else {
            [self setUpCurrentAge];
            [Support_Retirement getRetirement:_profileId];
            [self loadRetirement];
            [self sendErrorMessage:kLoadSuccessful];
        }
    }
        
        
}

- (void) loadRetirement
{
    //update sliders
    [self updateSliders:_slide_RetirementAge value:[[Session_Retirement sharedSession].retirementAge floatValue]];
    [self updateSliders:_slider_InflationFactor value:[[Session_Retirement sharedSession].inflationRate floatValue] * 100];
    [self updateSliders:_slide_RateOfReturn value:[[Session_Retirement sharedSession].marketRate floatValue] * 100];
    [self updateSliders:_slide_ServiceYears value:[[Session_Retirement sharedSession].serviceYearsFrDateHired intValue]];
    [self updateSliders:_slide_AnnualIncrease value:[[Session_Retirement sharedSession].expectedAnnualIncrease floatValue]];
    
    //update textfields
    [_txtMonthlyIncome setText:[NSString stringWithFormat:@"%.2f", [[Session_Retirement sharedSession].monthlyIncomeNeeded floatValue]]];
    [_txtCurrentMonthlyEarnings setText:[NSString stringWithFormat:@"%.2f", [[Session_Retirement sharedSession].currentMonthlyEarning floatValue]]];
    [_txtRetirementPlan setText:[Session_Retirement sharedSession].notes];
    [_txtBudget setText:[NSString stringWithFormat:@"%.2f", [[Session_Retirement sharedSession].budget floatValue]]];
    
    [self updateSegments:_seg_RetirementBenefitFactor value:[[Session_Retirement sharedSession].retirementBenefitFactor intValue]];
}

- (void) updateSliders: (UISlider *) slider value:(float) slideValue
{
    if ([slider isEqual:_slide_RetirementAge]) {
        
        [_slide_RetirementAge setValue:slideValue];
        [self sliderChanged_RetirementAge:self];
    }
    
    if ([slider isEqual:_slider_InflationFactor]) {
        
        [_slider_InflationFactor setValue:slideValue];
        [self sliderChanged_InflationFactor:self];
    }
    
    if ([slider isEqual:_slide_ServiceYears]) {
        
        [_slide_ServiceYears setValue:slideValue];
        [self sliderChanged_ServiceYears:self];
    }
    
    if ([slider isEqual:_slide_AnnualIncrease]) {
        
        [_slide_AnnualIncrease setValue:slideValue];
        [self sliderChanged_AnnualIncrease:self];
    }
    
    if ([slider isEqual:_slide_RateOfReturn]) {
        
        [_slide_RateOfReturn setValue:slideValue];
        [self sliderChanged_RateOfReturn:self];
    }
}

- (void) updateSegments: (UISegmentedControl *) segment value: (int) value
{
    NSLog(@"retBenFactor = %d", value);
    
    [_seg_RetirementBenefitFactor setSelectedSegmentIndex:value];
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

- (void) saveRetirement
{
    NSError *error =  [Support_Retirement updateRetirement:[FNASession sharedSession].profileId];
    
    if (error) {
        [self sendErrorMessage:[error localizedDescription]];
    }
    else {
        [self sendErrorMessage:@"Update successful"];
    }
}

- (void) getRetirementValuesFromInput
{
    //Textfields
    [Session_Retirement sharedSession].monthlyIncomeNeeded = 0;
    [Session_Retirement sharedSession].currentMonthlyEarning = 0;
    [Session_Retirement sharedSession].monthlyIncomeNeeded = [NSNumber numberWithDouble:[_txtMonthlyIncome.text doubleValue]];
    [Session_Retirement sharedSession].currentMonthlyEarning = [NSNumber numberWithFloat:[_txtCurrentMonthlyEarnings.text floatValue]];
    [Session_Retirement sharedSession].notes = [_txtRetirementPlan text];
    
    //Segmented controls
    [Session_Retirement sharedSession].retirementBenefitFactor = [NSNumber numberWithInt:_seg_RetirementBenefitFactor.selectedSegmentIndex];
    [Session_Retirement sharedSession].needForInsurance = _seg_InsuranceMaintenance.selectedSegmentIndex == 0 ? @"Y" : @"N";
    [Session_Retirement sharedSession].disability = _seg_Disability.selectedSegmentIndex == 0 ? @"Y" : @"N";
    
    //Sliders
    [Session_Retirement sharedSession].retirementAge = 0;
    [Session_Retirement sharedSession].inflationRate = 0;
    [Session_Retirement sharedSession].marketRate = 0;
    [Session_Retirement sharedSession].serviceYearsFrDateHired = 0;
    
    [Session_Retirement sharedSession].retirementAge = [NSNumber numberWithFloat:roundf(_slide_RetirementAge.value)];
    [Session_Retirement sharedSession].inflationRate = [NSNumber numberWithFloat:(roundf( _slider_InflationFactor.value) / 100)];
    [Session_Retirement sharedSession].marketRate = [NSNumber numberWithFloat:(roundf(_slide_RateOfReturn.value) / 100)];
    [Session_Retirement sharedSession].serviceYearsFrDateHired = [NSNumber numberWithFloat:roundf( _slide_ServiceYears.value)];
    
    NSLog(@"retirementBenefitFactor =%@", [Session_Retirement sharedSession].retirementBenefitFactor);
    
    [Session_Retirement sharedSession].expectedAnnualIncrease = [NSNumber numberWithFloat:roundf(_slide_AnnualIncrease.value)];
}

- (void) computeRetirement
{
    [self setUpCurrentAge];
    
    //Desired annual income
    NSNumber *desiredAnnualIncome = [[[NSNumber alloc]init]autorelease];
    NSNumber *desiredAnnualIncomeAtRetirement = [[[NSNumber alloc]init]autorelease];
    NSNumber *capitalRequired = [[[NSNumber alloc]init]autorelease];
    NSNumber *expectedRetirementBenefit = [[[NSNumber alloc]init]autorelease];
    NSNumber *retirementGap = [[[NSNumber alloc]init]autorelease];
    
    NSNumber *monthlyIncomeNeeded = [[[NSNumber alloc]initWithDouble:[[Session_Retirement sharedSession].monthlyIncomeNeeded doubleValue]]autorelease];
    NSNumber *inflationRate = [[[NSNumber alloc]initWithDouble:[[Session_Retirement sharedSession].inflationRate doubleValue]]autorelease];
    NSNumber *retirementAge = [[[NSNumber alloc]initWithInt:[[Session_Retirement sharedSession].retirementAge intValue]]autorelease];
    NSNumber *retirementYears = [[[NSNumber alloc]init]autorelease];
    NSNumber *retirementBenFactor = [[[NSNumber alloc]init]autorelease];
    retirementBenFactor =[Session_Retirement sharedSession].retirementBenefitFactor;
    
    retirementYears = [Support_Retirement getYearsBeforeRetirement:_currentAge retirementAge:retirementAge];
    
    desiredAnnualIncome = [Support_Retirement getDesiredAnnualIncome:monthlyIncomeNeeded];
    
    [_lbl_DesiredAnnualIncome setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", desiredAnnualIncome] withCurrencySymbol:kPhilippineCurrency]];
    
    //Desdired annual income at retirement
    desiredAnnualIncomeAtRetirement =
    [Support_Retirement getAnnualIncomeAtRetirement:[NSNumber numberWithFloat:([inflationRate floatValue])]
                                    retirementYears:retirementYears
                            desiredIncomeRetirement:[NSNumber numberWithFloat:[desiredAnnualIncome floatValue]]];
    
    [_lbl_DesiredAnnualIncomeAtRetirement setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@",desiredAnnualIncomeAtRetirement]withCurrencySymbol:kPhilippineCurrency]];
    
    //capital required
    capitalRequired = [Support_Retirement getCapitalRequired:
                       [NSNumber numberWithFloat:([[Session_Retirement sharedSession].marketRate floatValue])]
                                               retirementAge:
                       [NSNumber numberWithFloat:(roundf([[Session_Retirement sharedSession].retirementAge floatValue]))]
                                       annIncomeAtRetirement:
                       [NSNumber numberWithFloat:[desiredAnnualIncomeAtRetirement floatValue]]];
    
    [_lbl_CapitalRequired setText:
     [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", capitalRequired]
                      withCurrencySymbol:kPhilippineCurrency]];
    
    
    //Expected retirement benefit
    expectedRetirementBenefit = [Support_Retirement getExpectedRetirementBenefit:[Session_Retirement sharedSession].currentMonthlyEarning
                                                                 retirementYears:[Support_Retirement getYearsBeforeRetirement:_currentAge retirementAge:retirementAge]
                                                             servYearsFrHireDate:[Session_Retirement sharedSession].serviceYearsFrDateHired
                                                             retirementBenFactor:[Support_Retirement getRetirementBenefitFactor:retirementBenFactor]
                                                             expectedAnnIncrease:[Session_Retirement sharedSession].expectedAnnualIncrease];
    
    [_lbl_ExpectedRetirementBenefit setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", expectedRetirementBenefit] withCurrencySymbol:kPhilippineCurrency]];
    
    //Retirement gap
    retirementGap = [Support_Retirement getRetirementgap:capitalRequired
                                             expectedRetirementBen:expectedRetirementBenefit];
    
    [_lbl_RetirementGap setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", retirementGap] withCurrencySymbol:kPhilippineCurrency]];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)calculateRetirement:(id)sender {
    
    [self.view endEditing:YES];
    [self getRetirementValuesFromInput];
    [self computeRetirement];
}

- (IBAction)save:(id)sender
{
    [self calculateRetirement:sender];
    
    //Update database
    [self saveRetirement];
}

- (IBAction)sliderChanged_RetirementAge:(id)sender
{
    [_lblRetirementAge setText:[NSString stringWithFormat:@"%.0f", _slide_RetirementAge.value]];
    
    NSNumber *desiredRetireAge = [NSNumber numberWithFloat:_slide_RetirementAge.value];
    
    NSNumber *yearsToRetire = [NSNumber numberWithDouble:(round([desiredRetireAge doubleValue] - [_lblCurrentAge.text doubleValue]))];
    
    [_lblYearsToRetirement setText:[NSString stringWithFormat:@"%@", yearsToRetire]];
}

- (IBAction)sliderChanged_InflationFactor:(id)sender
{
    [_lblInflationFactor setText:[NSString stringWithFormat:@"%.0f%%", _slider_InflationFactor.value]];
}

- (IBAction)sliderChanged_RateOfReturn:(id)sender
{
    [_lblRateOfReturn setText:[NSString stringWithFormat:@"%.0f%%", _slide_RateOfReturn.value]];
}

- (IBAction)sliderChanged_ServiceYears:(id)sender
{
    [_lblServiceYears setText:[NSString stringWithFormat:@"%.0f", round(_slide_ServiceYears.value)]];
    NSLog(@"serviceYears = %@", _lblServiceYears.text);
}

- (IBAction)sliderChanged_AnnualIncrease:(id)sender
{
    [_lblAnnualIncrease setText:[NSString stringWithFormat:@"%.0f%%", _slide_AnnualIncrease.value]];
}

- (IBAction)segChanged_Retirementfactor:(id)sender
{
    [Session_Retirement sharedSession].retirementBenefitFactor = [Support_Retirement getRetirementBenefitFactor:[NSNumber numberWithInt:_seg_RetirementBenefitFactor.selectedSegmentIndex]];
}

- (IBAction)segChanged_InsuranceMaintenance:(id)sender
{
    [Session_Retirement sharedSession].needForInsurance = _seg_InsuranceMaintenance.selectedSegmentIndex == 0 ? @"Y" : @"N";
}

- (IBAction)segChanged_Disability:(id)sender
{
    [Session_Retirement sharedSession].disability = _seg_Disability.selectedSegmentIndex == 0 ? @"Y" : @"N";
}

- (IBAction)textFieldChanged:(id)sender
{
    [Session_Retirement sharedSession].monthlyIncomeNeeded = [NSNumber numberWithFloat:[_txtMonthlyIncome.text floatValue]];
    [Session_Retirement sharedSession].currentMonthlyEarning = [NSNumber numberWithFloat:[_txtCurrentMonthlyEarnings.text floatValue]];
}

- (IBAction)viewProducts:(id)sender {
    
    [FNASession sharedSession].selectedController = kSelectedController_Retirement;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString {
   
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([labelString isEqualToString:@"success"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self setUpCurrentAge];
        [self initSliders];
        [self startLoading];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self setUpCurrentAge];
        [self initSliders];
        [self startLoading];
    }
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc
{
    //[_currentAge release];
    //[_profileId release];
    
    [_lblCurrentAge release];
    [_lblRetirementAge release];
    [_lblYearsToRetirement release];
    [_lblInflationFactor release];
    [_lblRateOfReturn release];
    [_slide_RetirementAge release];
    
    [_txtMonthlyIncome release];
    [_slider_InflationFactor release];
    
    [_slide_RateOfReturn release];
    [_txtCurrentMonthlyEarnings release];
    [_slide_ServiceYears release];
    [_lblServiceYears release];
    [_slide_AnnualIncrease release];
    [_lblAnnualIncrease release];
    [_seg_RetirementBenefitFactor release];
    [_txtRetirementPlan release];
    [_seg_InsuranceMaintenance release];
    [_seg_Disability release];
    [_btnSave release];
    [_scrollView release];
    [_navItem release];
    [_lbl_Overlay release];
    [_lbl_DesiredAnnualIncome release];
    [_lbl_DesiredAnnualIncomeAtRetirement release];
    [_lbl_CapitalRequired release];
    [_lbl_ExpectedRetirementBenefit release];
    [_lbl_RetirementGap release];
    [_btnCalculate release];
    [_btn_viewProducts release];
    [_txtBudget release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCurrentAge:nil];
    [self setLblCurrentAge:nil];
    [self setLblRetirementAge:nil];
    [self setLblYearsToRetirement:nil];
    [self setSlide_RetirementAge:nil];
    [self setLblInflationFactor:nil];
    [self setTxtMonthlyIncome:nil];
    [self setSlider_InflationFactor:nil];
    [self setLblRateOfReturn:nil];
    [self setSlide_RateOfReturn:nil];
    [self setTxtCurrentMonthlyEarnings:nil];
    [self setSlide_ServiceYears:nil];
    [self setLblServiceYears:nil];
    [self setSlide_AnnualIncrease:nil];
    [self setLblAnnualIncrease:nil];
    [self setSeg_RetirementBenefitFactor:nil];
    [self setTxtRetirementPlan:nil];
    [self setSeg_InsuranceMaintenance:nil];
    [self setSeg_Disability:nil];
    [self setBtnSave:nil];
    [self setScrollView:nil];
    [self setNavItem:nil];
    [self setLbl_Overlay:nil];
    [self setLbl_DesiredAnnualIncome:nil];
    [self setLbl_DesiredAnnualIncomeAtRetirement:nil];
    [self setLbl_CapitalRequired:nil];
    [self setLbl_ExpectedRetirementBenefit:nil];
    [self setLbl_RetirementGap:nil];
    [self setProfileId:nil];
    [self setBtnCalculate:nil];
    [self setBtn_viewProducts:nil];
    [self setTxtBudget:nil];
    [super viewDidUnload];
}

@end
