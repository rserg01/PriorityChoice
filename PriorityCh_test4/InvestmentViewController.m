//
//  InvestmentViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "InvestmentViewController.h"
#import "FNASession.h"
#import "Session_Investment.h"
#import "Support_Investment.h"
#import "GetPersonalProfile.h"
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"
#import "ModalPersonalAssetsViewController.h"
#import "Utility.h"
#import "FnaConstants.h"
#import "EmailSender.h"
#import "Support_Manucare.h"
#import "Session_Manucare.h"

@interface InvestmentViewController ()

@property (nonatomic, retain) NSMutableArray *arrInvestment;
@property (nonatomic, retain) NSNumber *totalSavingsPlan;
@property (nonatomic, retain) NSNumber *currentAmtInvestments;
@property (nonatomic, retain) NSNumber *investmentRequired;

@end

@implementation InvestmentViewController

@synthesize btnSave = _btnSave;
@synthesize lbl_TotalCostOfSavingsPlan = _lbl_TotalCostOfSavingsPlan;

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScrollView];
    [self setNavigationTitle];
    [self addTopButtons];
    
    [_txtEmergencyFund becomeFirstResponder];
    
    [self initSlider];
    
    [self startLoading];
    
    if ([_arrInvestment count] > 0) {
        [self assignSessionToFields];
    }
    
    [self loadManucare];
}

#pragma mark -
#pragma mark Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Investment - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Investment - Unknown Profile"];
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
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_Investment dataSet:kDataset_Investment];
        
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

- (void) toModal
{
    [self performSegueWithIdentifier:@"toNewProfile_Investment" sender:self];
}

- (void) toActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Investment" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Investment"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Investment"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toAssets_Investment"]) {
        [[segue destinationViewController] setDelegate2:self];
        ModalPersonalAssetsViewController *modal = [[[ModalPersonalAssetsViewController alloc]init]autorelease];
        modal.delegate2 = self;
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(2330, 320)];
    //_scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    //_scrollView.layer.borderWidth = 2;
    
    [self.view addSubview:_scrollView];
    
}

- (void) initSlider
{
    [_slide_TimeFrame setMaximumValue:100];
    [_slide_TimeFrame setMinimumValue:0];
}

- (void) updateSlider: (NSNumber *) slideValue
{
    if ([slideValue compare:[NSNumber numberWithFloat:0]]== NSOrderedDescending) {
        
        [_slide_TimeFrame setValue:[slideValue floatValue] animated:YES];
        [_lbl_TimeFrame setText:[NSString stringWithFormat:@"%.0f Year(s)", roundf([slideValue intValue])]];
    }
}

- (BOOL) checkProfileIdLength
{
    return [[FNASession sharedSession].profileId length]==0 ? NO : YES;
}

- (void) startLoading
{
    if ([self checkProfileIdLength]) {
        
        // check if there is exsiting entry
        if ([[Support_Investment checkExisingEntry:[FNASession sharedSession].profileId] compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
            
            [Support_Investment getInvestment:[FNASession sharedSession].profileId];
            
            [self assignSessionToFields];
            [self updateLabels];
            [self loadManucare];
            [self sendErrorMessage:@"Successfully loaded data"];
        }
        else {
            
            //insert default data
            NSError *error = [Support_Investment newInvestment:[FNASession sharedSession].profileId];
            if (error) {
                [self sendErrorMessage:[error localizedDescription]];
            }
            else {
                [self sendErrorMessage:@"Loading success"];
            }
        }
        
    }
    else {
        
        //disable save button
        [self sendErrorMessage:@"Please create a profile to proceed.\n Click the button at the top-right corner."];
    }
  
}

- (void) assignSessionToFields
{
    [_txtEmergencyFund setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prEmergencyFund doubleValue]]];
    [_txtRetirement setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prRetirement doubleValue]]];
    [_txtNewHome setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prNewHome doubleValue]]];
    [_txtNewCar setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prNewCar doubleValue]]];
    [_txtHoliday setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prHoliday doubleValue]]];
    [_txtBusiness setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prBusiness doubleValue]]];
    [_txtLegacy setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prLegacy doubleValue]]];
    [_txtBudget setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].budget doubleValue]]];
    [_txtEstateTax setText:[NSString stringWithFormat:@"%.1f", [[Session_Investment sharedSession].prEstateTax doubleValue]]];

    [_seg_Investment setSelectedSegmentIndex:[[Session_Investment sharedSession].workingInvestment isEqualToString:@"1"] ? 1 : 2];
    [_seg_PersonCategory setSelectedSegmentIndex:[[Session_Investment sharedSession].savingCategory isEqualToString:@"Y"] ? 1 : 2];
    
    //this item is not being captured in the database and is not part of any computation. deliberate adjustments.
    [self updateSlider:[NSNumber numberWithFloat:1]];
}

- (void) getInvestmentValuesFromInput
{
    [Session_Investment sharedSession].prEmergencyFund = [NSNumber numberWithDouble:[_txtEmergencyFund.text doubleValue]];
    [Session_Investment sharedSession].prRetirement = [NSNumber numberWithDouble:[_txtRetirement.text doubleValue]] ;
    [Session_Investment sharedSession].prNewHome = [NSNumber numberWithDouble:[_txtNewHome.text doubleValue]] ;
    [Session_Investment sharedSession].prNewCar = [NSNumber numberWithDouble:[_txtNewCar.text doubleValue]] ;
    [Session_Investment sharedSession].prHoliday = [NSNumber numberWithDouble:[_txtHoliday.text doubleValue]] ;
    [Session_Investment sharedSession].prBusiness = [NSNumber numberWithDouble:[_txtBusiness.text doubleValue]] ;
    [Session_Investment sharedSession].prLegacy = [NSNumber numberWithDouble:[_txtLegacy.text doubleValue]] ;
    [Session_Investment sharedSession].prEstateTax = [NSNumber numberWithDouble:[_txtEstateTax.text doubleValue]] ;
    [Session_Investment sharedSession].budget = [NSNumber numberWithDouble:[_txtBudget.text doubleValue]] ;
    
    [Session_Investment sharedSession].investmentNeeded = [_seg_Investment selectedSegmentIndex]== 1 ? @"Y" : @"N";
    [Session_Investment sharedSession].savingCategory = [_seg_PersonCategory selectedSegmentIndex]== 1 ? @"Y" : @"N";
}

- (void) updateLabels
{
    [self getInvestmentValuesFromInput];
    
    _totalSavingsPlan =[Support_Investment
                        getTotalSavingsPlan:[Session_Investment sharedSession].prEmergencyFund
                        retirement:[Session_Investment sharedSession].prRetirement
                        newHome:[Session_Investment sharedSession].prNewHome
                        newCar:[Session_Investment sharedSession].prNewCar
                        holiday:[Session_Investment sharedSession].prHoliday
                        business:[Session_Investment sharedSession].prBusiness
                        legacy:[Session_Investment sharedSession].prLegacy
                        estateTax:[Session_Investment sharedSession].prEstateTax];
    
    _currentAmtInvestments = [Support_Investment getTotalInvestments];
    
    _investmentRequired = [Support_Investment getInvestmentRequired:_totalSavingsPlan currentInvestments:_currentAmtInvestments];
    
    NSString *formatted_costOfSavings = [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.1f", [_totalSavingsPlan doubleValue]] withCurrencySymbol:kPhilippineCurrency];
    
    NSString *formatted_AmtOfInvestments = [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.1f", [_currentAmtInvestments doubleValue]] withCurrencySymbol:kPhilippineCurrency];
    
    NSString *formatted_InvestmentRequired = [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.1f", [_investmentRequired doubleValue]] withCurrencySymbol:kPhilippineCurrency];
    
    [_lbl_TotalCostOfSavingsPlan setText:formatted_costOfSavings];
    [_lbl_CurrentAmtOfInvestments setText:formatted_AmtOfInvestments];
    [_lbl_InvestmentRequired setText:formatted_InvestmentRequired];
}

- (void) clearLabels
{
    [_lbl_TotalCostOfSavingsPlan setText:@"0"];
    [_lbl_CurrentAmtOfInvestments setText:@"0"];
    [_lbl_InvestmentRequired setText:@"0"];
    
    [self clearManucare];
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

#pragma mark - Manucare

- (void) loadManucare
{
    NSError * err = [[[NSError alloc]init]autorelease];
    
    err = [Support_Manucare getManucare:[FNASession sharedSession].profileId];
    
    if (!err) {
        
        [_lbl_RiskAttitudeScore setText:[NSString stringWithFormat:@"%i", [[Session_Manucare sharedSession].riskAttitudeScore intValue]]];
        [_lbl_RiskCapacityScore setText:[NSString stringWithFormat:@"%i", [[Session_Manucare sharedSession].riskCapacityScore intValue]]];
    }
    else {
        
        [self sendErrorMessage:[err localizedDescription]];
    }
}

- (void) clearManucare
{
    [_lbl_RiskAttitudeScore setText:@"0"];
    [_lbl_RiskCapacityScore setText:@"0"];
}



#pragma mark -
#pragma mark IBActions

- (IBAction)gotoManuCareTool:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ManucareStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ManucareStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)saveInvestment:(id)sender
{
    [self.view endEditing:YES];
    
    [self getInvestmentValuesFromInput];
    [self updateLabels];
    
    NSError *error =[Support_Investment updateInvestment:[FNASession sharedSession].profileId];
    if (error) {
        [self sendErrorMessage:[error localizedDescription]];
    }
    else {
        [self sendErrorMessage:@"Update successful"];
    }
}

- (IBAction)calculate:(id)sender {
    
    [self.view endEditing:YES];
    
    [FNASession sharedSession].totalPersonalAssets = [GetPersonalProfile getTotalPersonalAssets:[FNASession sharedSession].profileId];
    [self getInvestmentValuesFromInput];
    [self updateLabels];
}

- (IBAction)updateAssets:(id)sender {
    
    [self performSegueWithIdentifier:@"toAssets_Investment" sender:self];
}

- (IBAction)viewProducts:(id)sender {
    
    [FNASession sharedSession].selectedController = kSelectedController_Investment;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)updateTimeFrame:(id)sender {
    
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slide = (UISlider*)sender;
        [self updateSlider:[NSNumber numberWithFloat:[slide value]]];
    }
}

#pragma mark -
#pragma mark Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString
{
    [self clearLabels];
    
    if ([labelString isEqualToString:@"success"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [_arrInvestment removeAllObjects];
        [self startLoading];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [_arrInvestment removeAllObjects];
        [self startLoading];
        [self assignSessionToFields];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) saveUpdates
{
    NSError *err = [GetPersonalProfile
                    UpdatePersonalAssets:[FNASession sharedSession].profileId
                    savings:[FNASession sharedSession].clientSavings
                    current:[FNASession sharedSession].clientCurrent
                    bonds:[FNASession sharedSession].clientBonds
                    stocks:[FNASession sharedSession].clientStocks
                    mutual:[FNASession sharedSession].clientMutual
                    collectibles:[FNASession sharedSession].clientCollectibles];
    if (err) {
        [self sendErrorMessage:[err localizedDescription]];
    }
    else {
        [self sendErrorMessage:@"Update Successul"];
    }
    
    [FNASession sharedSession].totalPersonalAssets = [GetPersonalProfile getTotalPersonalAssets:[FNASession sharedSession].profileId];
    
    [err release];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtEmergencyFund release];
    [_txtRetirement release];
    [_txtNewHome release];
    [_txtNewCar release];
    [_txtHoliday release];
    [_txtBusiness release];
    [_txtLegacy release];
    [_txtEstateTax release];
    [_seg_Investment release];
    [_seg_PersonCategory release];
    [_slide_TimeFrame release];
    [_txtBudget release];
    [_btnManucareTool release];
    [_scrollView release];
    [_navItem release];
    [_btnSave release];
    [_lbl_TotalCostOfSavingsPlan release];
    [_lbl_CurrentAmtOfInvestments release];
    [_lbl_InvestmentRequired release];
    [_lbl_ProtectionGoal release];
    [_lbl_TimeFrame release];
    [_btnCalculate release];
    [_lbl_TotalInvestments release];
    [_txtOtherInvestments release];
    [_btnUpdateAssets release];
    [_totalSavingsPlan release];
    [_investmentRequired release];
    [_currentAmtInvestments release];
    [_btn_viewProducts release];
    [_lbl_RiskCapacityScore release];
    [_lbl_RiskAttitudeScore release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtEmergencyFund:nil];
    [self setTxtRetirement:nil];
    [self setTxtNewHome:nil];
    [self setTxtNewCar:nil];
    [self setTxtHoliday:nil];
    [self setTxtBusiness:nil];
    [self setTxtLegacy:nil];
    [self setTxtEstateTax:nil];
    [self setSeg_Investment:nil];
    [self setSeg_PersonCategory:nil];
    [self setSlide_TimeFrame:nil];
    [self setTxtBudget:nil];
    [self setBtnManucareTool:nil];
    [self setScrollView:nil];
    [self setNavItem:nil];
    [self setBtnSave:nil];
    [self setLbl_TotalCostOfSavingsPlan:nil];
    [self setLbl_CurrentAmtOfInvestments:nil];
    [self setLbl_InvestmentRequired:nil];
    [self setLbl_ProtectionGoal:nil];
    [self setLbl_TimeFrame:nil];
    [self setBtnCalculate:nil];
    [self setLbl_TotalInvestments:nil];
    [self setTxtOtherInvestments:nil];
    [self setBtnUpdateAssets:nil];
    [self setTotalSavingsPlan:nil];
    [self setCurrentAmtInvestments:nil];
    [self setInvestmentRequired:nil];
    [self setBtn_viewProducts:nil];
    [self setLbl_RiskCapacityScore:nil];
    [self setLbl_RiskAttitudeScore:nil];
    [super viewDidUnload];
}

@end
