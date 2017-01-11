//
//  EducationViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 9/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "EducationViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import "GetPersonalProfile.h"
#import "FnaConstants.h"
#import "EmailSender.h"
#import "Support_Education.h"
#import "Session_Education.h"

@interface EducationViewController ()

@property (nonatomic, retain) NSMutableArray *arrDependentInfo;
@property (retain, nonatomic) NSMutableArray *arrDependentProfile;
@property (nonatomic, retain) NSNumber *totalPersonalAsset;
@property (nonatomic, retain) NSNumber *futureCost;
@property (nonatomic, retain) NSNumber *savingsGoal;
@property (nonatomic, retain) NSNumber *currentSavings;

@end

@implementation EducationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkSessions];
    
    [self initScrollView];
    [self setNavigationTitle];
    [self addTopButtons];
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [self loadPersonalAssets];
    
    
}

#pragma mark - Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(1430, 320)];
    //_scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    //_scrollView.layer.borderWidth = 2;
    
    [self.view addSubview:_scrollView];
}

- (void) checkSessions
{
    NSString *profileId = [[[NSString alloc]init]autorelease];
    NSString *dependentId = [[[NSString alloc]init]autorelease];
    
    profileId = [FNASession sharedSession].profileId;
    dependentId = [FNASession sharedSession].dependentId;
    
    if ([profileId length] > 0) {
        
        if ([[GetPersonalProfile getDependents:profileId] count] == 0) {
            [self sendErrorMessage:kProfile_ErrNoDependents];
        }
        else {
            if ([dependentId length] == 0) {
                [self sendErrorMessage:kProfile_SelectDependent];
            }
            else {
                [self loadEducProfile];
            }
        }
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
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

#pragma mark - Navigation

- (void) setNavigationTitle
{
    if (![[FNASession sharedSession].name length] == 0) {
        [_navItem setTitle:[NSString stringWithFormat:@"Education - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"Education - Unknown Profile"];
    }
}

- (void) addTopButtons
{
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(setActiveProfile)];
    
    UIBarButtonItem *setDependent = [[UIBarButtonItem alloc] initWithTitle:@"Dependents" style:UIBarButtonItemStylePlain target:self action:@selector(setDependent)];
    
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(newProfile)];
    
    //UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send to Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendData)];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: setProfile, setDependent, newProfile, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: homeButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) sendData
{
    if ([[FNASession sharedSession].profileId length] > 0) {
        
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_Education dataSet:kDataset_Education];
        
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

#pragma mark - Data Models

- (void) loadEducProfile
{
    _arrDependentProfile = [self getEducProfile];
    
    if ([_arrDependentProfile count] == 0) {
        
        NSError *err = [self insertNewRecord];
        
        if (err) {
            
            [self sendErrorMessage:[err localizedDescription]];
        }
        else {
            
            _arrDependentProfile = [self getEducProfile];
            [self assignSessionToFields:_arrDependentProfile];
        }
        
        [err release];
    }
    else {
        
        [self assignSessionToFields:_arrDependentProfile];
    }
}

- (NSMutableArray *) getEducProfile
{
    NSString *profileId = [[[NSString alloc]init]autorelease];
    NSString *dependentId = [[[NSString alloc]init]autorelease];
    
    profileId = [FNASession sharedSession].profileId;
    dependentId = [FNASession sharedSession].dependentId;
    
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    
    arr = [Support_Education getEducFunding:profileId dependentId:dependentId];
    
    return arr;
}

- (NSError *) insertNewRecord
{
    NSString *profileId = [[[NSString alloc]init]autorelease];
    NSString *dependentId = [[[NSString alloc]init]autorelease];
    
    profileId = [FNASession sharedSession].profileId;
    dependentId = [FNASession sharedSession].dependentId;
    
    NSError * err = [[[NSError alloc]init]autorelease];
    
    err = [Support_Education newEducFunding:profileId dependentId:dependentId];
    
    return err;
}

- (void) loadPersonalAssets
{
    NSString *profileId = [[[NSString alloc]init]autorelease];
    profileId = [FNASession sharedSession].profileId;
    
    [self setTotalPersonalAsset:[GetPersonalProfile getTotalPersonalAssets:profileId]];
    
    NSString *totalAssetString = [[[NSString alloc]init]autorelease];
    
    totalAssetString = [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.2f", [_totalPersonalAsset doubleValue]] withCurrencySymbol:kPhilippineCurrency];
    
    [_lbl_TotalPersonalAsset setText:[NSString stringWithFormat:@"Total Personal Asset: %@", totalAssetString]];
    
}

- (void) assignSessionToFields: (NSMutableArray *) arr
{
    NSDictionary *dic = [[[NSDictionary alloc]init]autorelease];
    dic = [arr objectAtIndex:0];
    
    _savingsGoal = [dic objectForKey:@"educSavingsGoal"];
    
    [_txtPresentAnnualCost setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"presentAnnualCost"]] ];
    [_txtYearOfEntry setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"yearOfEntry"]]];
    [_txtPersonalAssetAllocated setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"allocatedPersonalAsset"]]];
    [_txtCurrentEducationalPlan setText: 0];
    [_txtBudget setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"budget"]]];
    
    [_segInsuranceMaintenance setSelectedSegmentIndex:[[dic objectForKey:@"insuranceImportance"] isEqualToString:@"Y"] ? 0 : 1];
    
    [_lbl_SavingsGoal setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.2f", [_savingsGoal doubleValue]] withCurrencySymbol:kPhilippineCurrency]];
    
    [_txt_Notes setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"notes"]]];
    
    [self compute:self];
}

- (void) updateLabels
{
    [_lbl_FutureCost setText: [Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.0f", [_futureCost doubleValue]] withCurrencySymbol:kPhilippineCurrency]];
    
    [_lblCurrentSavings setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.0f", [_currentSavings doubleValue]] withCurrencySymbol:kPhilippineCurrency]];
    
    [_lbl_SavingsGoal setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.0f", [_savingsGoal doubleValue]] withCurrencySymbol:kPhilippineCurrency]];
}

- (void) resetFields
{
    [_lbl_FutureCost setText: @""];
    [_lblCurrentSavings setText:@""];
    [_lbl_SavingsGoal setText:@""];
    
    [_txtPresentAnnualCost setText:@""];
    [_txtPresentAnnualCost setPlaceholder:@"0"];
    [_txtYearOfEntry setText:@""];
    [_txtYearOfEntry setPlaceholder:@"0"];
    [_txtPersonalAssetAllocated setText:@""];
    [_txtPersonalAssetAllocated setPlaceholder:@"0"];
    [_txtCurrentEducationalPlan setText: 0];
    [_txtBudget setText:@""];
    [_txtBudget setPlaceholder:@"0"];
    
    [_segInsuranceMaintenance setSelectedSegmentIndex:0];
    
    [_txt_Notes setText:@""];
}



#pragma mark - Segue

- (void) newProfile
{
    [self performSegueWithIdentifier:@"toNewProfile_Education" sender:self];
}

- (void) setActiveProfile
{
    [self performSegueWithIdentifier:@"toActiveProfile_Education" sender:self];
}

- (void) setDependent
{
    [self performSegueWithIdentifier:@"toDependents" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toNewProfile_Education"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toActiveProfile_Education"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toPersonalAssets_Education"]) {
        [[segue destinationViewController] setDelegate2:self];
        ModalPersonalAssetsViewController *modal = [[[ModalPersonalAssetsViewController alloc]init]autorelease];
        modal.delegate2 = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toDependents"]) {
        [[segue destinationViewController] setDelegate_Dependent:self];
        DependentViewController *modal = [[[DependentViewController alloc]init]autorelease];
        modal.delegate_Dependent = self;
    }
}


#pragma mark - IBActions

- (IBAction)compute:(id)sender
{
    NSString *profileId = [[[NSString alloc]init]autorelease];
    NSString *dependentId = [[[NSString alloc]init]autorelease];
    
    profileId = [FNASession sharedSession].profileId;
    dependentId = [FNASession sharedSession].dependentId;
    
    if (![profileId length] == 0 && ![dependentId length] == 0) {
        
        NSNumber *presentCost = [[[NSNumber alloc]initWithFloat:[_txtPresentAnnualCost.text floatValue]]autorelease];
        NSNumber *yearOfEntry = [[[NSNumber alloc]initWithInteger:[_txtYearOfEntry.text integerValue]]autorelease];
        NSNumber *educPlan = [[[NSNumber alloc]initWithFloat:[_txtCurrentEducationalPlan.text floatValue]]autorelease];
        NSNumber *allocatedAsset = [[[NSNumber alloc]initWithFloat:[_txtPersonalAssetAllocated.text floatValue]]autorelease];
        
        _currentSavings = [[[NSNumber alloc]initWithDouble:([educPlan doubleValue] + [allocatedAsset doubleValue])]autorelease];
        
        _futureCost = [Support_Education getFutureCost:presentCost
                                           yearOfEntry:yearOfEntry
                                           currentYear:[Support_Education getCurrentYear]];
        
        _savingsGoal = [Support_Education computeSavingsGoal:_futureCost
                                                     savings:_currentSavings];
        
        [self updateLabels];
        
        [self.view endEditing:YES];
    }
}

- (IBAction)saveInfo:(id)sender
{
    [self compute:self];
    
    NSString *profileId = [[[NSString alloc]init]autorelease];
    NSString *dependentId = [[[NSString alloc]init]autorelease];
    
    NSNumber *presentAnnualCost = [[[NSNumber alloc]init]autorelease];
    NSNumber *yearOfEntry = [[[NSNumber alloc]init]autorelease];
    NSNumber *budget = [[[NSNumber alloc]init]autorelease];
    NSNumber *allocatedPersonalAsset = [[[NSNumber alloc]init]autorelease];
    NSString *insImportance = [[[NSString alloc]init]autorelease];
    NSString *notes = [[[NSString alloc]init]autorelease];
    
    
    profileId = [FNASession sharedSession].profileId;
    dependentId = [FNASession sharedSession].dependentId;
    
    if ([profileId length] == 0 && [dependentId length] == 0) {
        [self sendErrorMessage:kNoProfileActive];
    }
    else {
        
        [self compute:self];
        
        presentAnnualCost = [NSNumber numberWithDouble:[_txtPresentAnnualCost.text doubleValue]];
        yearOfEntry = [NSNumber numberWithInt:[_txtYearOfEntry.text intValue]];
        budget = [NSNumber numberWithDouble:[_txtBudget.text doubleValue]];
        
        
        allocatedPersonalAsset = [NSNumber numberWithFloat:[_txtPersonalAssetAllocated.text floatValue]];
        insImportance = _segInsuranceMaintenance.selectedSegmentIndex == 0 ? @"Y" : @"N";
        notes = _txt_Notes.text;
        
        [Support_Education updateEducFunding:profileId
                                 dependentId:dependentId
                           presentAnnualCost:presentAnnualCost
                                 yearOfEntry:yearOfEntry
                                      budget:budget
                               insImportance:insImportance
                             educSavingsGoal:_savingsGoal
                                       notes:notes
                      allocatedPersonalAsset:allocatedPersonalAsset];
    }
}

- (IBAction)viewProducts:(id)sender
{
    [FNASession sharedSession].selectedController = kSelectedController_Education;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProductsStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProductsStoryboard"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)updateAssets:(id)sender
{
    
    [self performSegueWithIdentifier:@"toPersonalAssets_Education" sender:self];
}


#pragma mark - Delegate Methods

- (void)finishedDoingMyThing:(NSString *)labelString
{
    if ([labelString isEqualToString:@"success"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setNavigationTitle];
    }
    
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [self setNavigationTitle];
        [self checkSessions];
        [self loadPersonalAssets];
        [self resetFields];
    }
    
    if ([labelString isEqualToString:@"dependentSelected"]) {
        
        NSString *profileId = [[[NSString alloc]init]autorelease];
        NSString *dependentId = [[[NSString alloc]init]autorelease];
        
        profileId = [FNASession sharedSession].profileId;
        dependentId = [FNASession sharedSession].dependentId;
        
        _arrDependentInfo = [GetPersonalProfile getDependentInfo:profileId dependentId:dependentId];
        
        NSLog(@"%i", [_arrDependentInfo count]);
        
        if ([_arrDependentInfo count] > 0) {
            
            NSDictionary *dic = [[[NSDictionary alloc]init]autorelease];
            dic = [_arrDependentInfo objectAtIndex:0];
            
            [FNASession sharedSession].dependentName = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"firstName"], [dic objectForKey:@"lastName"]];
            
            [FNASession sharedSession].dependentDob = [dic objectForKey:@"dateOfBirth"];
            
            [FNASession sharedSession].dependentRelationship = [dic objectForKey:@"relationship"];
            
            [_lbl_DependentName setText:[NSString stringWithFormat:@"Educational Funding for %@", [FNASession sharedSession].dependentName]];
            
            [self loadEducProfile];
        }
        else {
            
            [self sendErrorMessage:@"Error: No info pulled out for dependentId"];
        }
    }
    
    if ([labelString isEqualToString:@"assets"]) {
        
        [self loadPersonalAssets];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveUpdates
{
    NSError *err = [[[NSError alloc]init]autorelease];
    
    err = [GetPersonalProfile UpdatePersonalAssets:[FNASession sharedSession].profileId
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
        [self sendErrorMessage:kLoadSuccessful];
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
    [_txtPresentAnnualCost release];
    [_txtCurrentEducationalPlan release];
    [_txtPersonalAssetAllocated release];
    [_txtYearOfEntry release];
    [_segInsuranceMaintenance release];
    [_txtBudget release];
    [_btn_Calculate release];
    [_btn_Save release];
    [_txt_Notes release];
    [_btn_UpdateAssets release];
    [_scrollView release];
    [_lbl_Overlay release];
    [_lblCurrentSavings release];
    [_lbl_FutureCost release];
    [_lbl_SavingsGoal release];
    [_lbl_DependentName release];
    [_btn_viewProducts release];
    [_navItem release];
    [_lbl_TotalPersonalAsset release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTxtPresentAnnualCost:nil];
    [self setTxtCurrentEducationalPlan:nil];
    [self setTxtPersonalAssetAllocated:nil];
    [self setTxtYearOfEntry:nil];
    [self setSegInsuranceMaintenance:nil];
    [self setTxtBudget:nil];
    [self setBtn_Calculate:nil];
    [self setBtn_Save:nil];
    [self setTxt_Notes:nil];
    [self setBtn_UpdateAssets:nil];
    [self setScrollView:nil];
    [self setLbl_Overlay:nil];
    [self setLblCurrentSavings:nil];
    [self setLbl_FutureCost:nil];
    [self setLbl_SavingsGoal:nil];
    [self setLbl_DependentName:nil];
    [self setBtn_viewProducts:nil];
    [self setNavItem:nil];
    [self setLbl_TotalPersonalAsset:nil];
    [super viewDidUnload];
}
@end
