//
//  HealthViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "HealthViewController.h"
#import "FnaConstants.h"
#import "FNASession.h"
#import "Session_Health.h"
#import "Support_Health.h"
#import <QuartzCore/QuartzCore.h>
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"
#import "GetPersonalProfile.h"
#import "EmailSender.h"


@interface HealthViewController ()

@end

@implementation HealthViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self setNavigationTitle];
    [self addTopButtons];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [self loadHealth];
       
    [_txtEmployeeCoverage becomeFirstResponder];
	
}

#pragma mark -
#pragma mark Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(3169, 320)];
    //_scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    //_scrollView.layer.borderWidth = 2;
    
    [self.view addSubview:_scrollView];
    
}

- (void) loadHealth
{
    if (![[FNASession sharedSession].profileId length] == 0 ) {
        
        NSNumber *exsitingEntry = [Support_Health checkExisingEntry:[FNASession sharedSession].profileId];
        NSLog(@"existingEntry = %@", exsitingEntry);
        
        if ([exsitingEntry intValue] > 0) {
            
            NSError *err_getEstatePlanning = [Support_Health getImpariedHealth:[FNASession sharedSession].profileId];
            
            if (err_getEstatePlanning) {
                [self sendErrorMessage:err_getEstatePlanning.localizedDescription];
            }
            else {
                [self assignValuesToFields];
                [self updateLabels];
                [self sendErrorMessage:kLoadSuccessful];
            }
        }
        else {
            
            NSError *err_newImpairedHealth = [Support_Health newImpairedHealth:[FNASession sharedSession].profileId];
            
            if (err_newImpairedHealth) {
                [self sendErrorMessage:err_newImpairedHealth.localizedDescription];
            }
            else {
                
                NSError *err_getImpairedHealth = [Support_Health getImpariedHealth:[FNASession sharedSession].profileId];
                
                if (err_getImpairedHealth) {
                    
                    [self sendErrorMessage:err_getImpairedHealth.localizedDescription];
                }
                else {
                    [self assignValuesToFields];
                }
            }
        }
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }

}

#pragma mark -
#pragma mark Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Health - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Health - Unknown Profile"];
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
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_Health dataSet:kDataset_Health];
        
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
    [self performSegueWithIdentifier:@"toNewProfile_Health" sender:self];
}

//TODO: Refresh navigation title upon setting active profile
- (void) toActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Health" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Health"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Health"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
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

- (void) assignValuesToFields
{
    [_txtEmployeeCoverage setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].employeeCoverage]];
    [_txtHealthProtection setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].healthProtection]];
    [_txtSemiPrivate setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].semiPrivate]];
    [_txtSmallPrivate setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].smallPrivate]];
    [_txtPrivate setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].privateDeluxe]];
    [_txtSuite setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].suite]];
    [_txtNursingExpenses setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].medAndNursingCare]];
    [_txtCriticallIllnessCoverage setText:[NSString stringWithFormat:@"%@", [Session_Health sharedSession].criticalIllnessCoverage]];
    
    [_segInclusionToHealthPlan setSelectedSegmentIndex:[[Session_Health sharedSession].healthPlan isEqualToString:@"Y"] ? 0 : 1 ];
    [_segAccidentProtection setSelectedSegmentIndex:[[Session_Health sharedSession].accidentProtection isEqualToString:@"Y"] ? 0 : 1 ];
    [_segCriticalIllness setSelectedSegmentIndex:[[Session_Health sharedSession].criticalIllnessNeed isEqualToString:@"Y"] ? 0 : 1 ];
    
    [_txtArea_Notes setText:[Session_Health sharedSession].notes];
    
}

- (void) getValuesFromInput
{
    [Session_Health sharedSession].employeeCoverage = [NSNumber numberWithFloat:[_txtEmployeeCoverage.text floatValue]];
    [Session_Health sharedSession].hospitalRoom = [NSNumber numberWithFloat:[_txtHealthProtection.text floatValue]];
    [Session_Health sharedSession].semiPrivate = [NSNumber numberWithFloat:[_txtSemiPrivate.text floatValue]];
    [Session_Health sharedSession].smallPrivate = [NSNumber numberWithFloat:[_txtSmallPrivate.text floatValue]];
    [Session_Health sharedSession].privateDeluxe = [NSNumber numberWithFloat:[_txtPrivate.text floatValue]];
    [Session_Health sharedSession].suite = [NSNumber numberWithFloat:[_txtSuite.text floatValue]];
    [Session_Health sharedSession].medAndNursingCare = [NSNumber numberWithFloat:[_txtNursingExpenses.text floatValue]];
    [Session_Health sharedSession].criticalIllnessCoverage = [NSNumber numberWithFloat:[_txtCriticallIllnessCoverage.text floatValue]];
    [Session_Health sharedSession].budget = [NSNumber numberWithFloat:[_txtBudget.text floatValue]];
    
    [Session_Health sharedSession].healthProtection = [NSNumber numberWithFloat:[_txtHealthProtection.text floatValue]];
    [Session_Health sharedSession].accidentProtection = [_segAccidentProtection selectedSegmentIndex] == 0 ? @"Y" : @"N";
    [Session_Health sharedSession].criticalIllnessNeed = [_segCriticalIllness selectedSegmentIndex] == 0 ? @"Y" : @"N";
    
    [Session_Health sharedSession].notes = _txtArea_Notes.text;
}

- (void) updateLabels
{
    NSNumber *totalCurrentBenefit = [Support_Health computeTotalCurrentBenefit:[Session_Health sharedSession].hospitalRoom
                                                                 healthBenefit:[Session_Health sharedSession].employeeCoverage];
    
    NSNumber *hospitalization =
    [Support_Health hospitalizationBen:[Session_Health sharedSession].semiPrivate
                          smallPrivate:[Session_Health sharedSession].smallPrivate
                         privateDeLuxe:[Session_Health sharedSession].privateDeluxe
                                 suite:[Session_Health sharedSession].suite];
    
    NSNumber *benefitsRequired = [Support_Health additionalBenReq:hospitalization
                                                 employeeCoverage:[Session_Health sharedSession].employeeCoverage
                                                 personalCoverage:[Session_Health sharedSession].healthProtection];
    
    NSNumber *capitalRequired = [Support_Health capitalRequired:[Session_Health sharedSession].medAndNursingCare criticalIllness:[Session_Health sharedSession].criticalIllnessCoverage];
    
    [_lbl_CurrentTotalBenefit setText:[NSString stringWithFormat:@"%@", totalCurrentBenefit]];
    [_lbl_AdditionalBenefitsReq setText:[NSString stringWithFormat:@"%@", benefitsRequired]];
    [_lbl_CapitalRequired setText:[NSString stringWithFormat:@"%@", capitalRequired]];
    
}

- (void) clearLabels
{
    [_lbl_CurrentTotalBenefit setText:@"0"];
    [_lbl_AdditionalBenefitsReq setText:@"0"];
    [_lbl_CapitalRequired setText:@"0"];
}

#pragma mark -
#pragma mark Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString {
    
    if ([labelString isEqualToString:@"success"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self loadHealth];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
        [self loadHealth];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)computeHealth:(id)sender {
    
    [self.view endEditing:YES];
    [self getValuesFromInput];
    [self updateLabels];
}

- (IBAction)saveHealth:(id)sender {
    
    [self.view endEditing:YES];
    [self getValuesFromInput];
    [Support_Health updateImpairedHealth:[FNASession sharedSession].profileId];
}

- (IBAction)viewProducts:(id)sender {
    
    [FNASession sharedSession].selectedController = kSelectedController_Health;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark Memrory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtEmployeeCoverage release];
    [_txtHealthProtection release];
    [_segInclusionToHealthPlan release];
    [_txtSemiPrivate release];
    [_txtSmallPrivate release];
    [_txtPrivate release];
    [_txtSuite release];
    [_segAccidentProtection release];
    [_segCriticalIllness release];
    [_txtNursingExpenses release];
    [_txtCriticallIllnessCoverage release];
    [_btnCompute release];
    [_btnSave release];
    [_lbl_CurrentTotalBenefit release];
    [_lbl_AdditionalBenefitsReq release];
    [_lbl_CapitalRequired release];
    [_scrollView release];
    [_lbl_Overlay release];
    [_navItem release];
    [_btn_viewProducts release];
    [_txtArea_Notes release];
    [_txtBudget release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtEmployeeCoverage:nil];
    [self setTxtHealthProtection:nil];
    [self setSegInclusionToHealthPlan:nil];
    [self setTxtSemiPrivate:nil];
    [self setTxtSmallPrivate:nil];
    [self setTxtPrivate:nil];
    [self setTxtSuite:nil];
    [self setSegAccidentProtection:nil];
    [self setSegCriticalIllness:nil];
    [self setTxtNursingExpenses:nil];
    [self setTxtCriticallIllnessCoverage:nil];
    [self setBtnCompute:nil];
    [self setBtnSave:nil];
    [self setLbl_CurrentTotalBenefit:nil];
    [self setLbl_AdditionalBenefitsReq:nil];
    [self setLbl_CapitalRequired:nil];
    [self setScrollView:nil];
    [self setLbl_Overlay:nil];
    [self setNavItem:nil];
    [self setBtn_viewProducts:nil];
    [self setTxtArea_Notes:nil];
    [self setTxtBudget:nil];
    [super viewDidUnload];
}

@end
