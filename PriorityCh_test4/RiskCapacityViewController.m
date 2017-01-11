//
//  RiskCapacityViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "RiskCapacityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Session_Manucare.h"
#import "Support_Manucare.h"
#import "FNASession.h"
#import "FnaConstants.h"

@interface RiskCapacityViewController ()

@property (nonatomic, retain) NSString *profileId;
@property (nonatomic, retain) NSString *profileName;

@end

@implementation RiskCapacityViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self addTopButtons];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initNavItems];
    [self initButtonImage];
    
    if ([[FNASession sharedSession].profileId length] > 0) {
        
        _profileId = [FNASession sharedSession].profileId;
        NSLog(@"%@", _profileId);
        
        _profileName = [FNASession sharedSession].name;
        [self initManucareData];
        [self updateButtonImage];
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
    
    [self initBgLabels];
    [self getRiskCapacityScore];
}

#pragma mark - Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(1500, 320)];
    [self.view addSubview:_scrollView];
}

- (void) initBgLabels
{
    _lbl_Overlay.layer.cornerRadius = 8;
    
    _lbl_Title.layer.shadowOpacity = 0.5;
    _lbl_Title.layer.shadowRadius = 8;
    _lbl_Title.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
}

- (void) initNavItems
{
    if (![[FNASession sharedSession].name length] == 0)
    {
        [_navItem setTitle:[NSString stringWithFormat:@"ManuCare Assessment - %@", [FNASession sharedSession].name]];
    }
    else {
        
        [_navItem setTitle:@"ManuCare Assessment - Unknown Profile"];
    }
}

- (void) initButtonImage
{
    
    _btn_TimeFrame = [self formatButton:_btn_TimeFrame];
    [_btn_TimeFrame setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_TimeFrame setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_Retirement = [self formatButton:_btn_Retirement];
    [_btn_Retirement setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_Retirement setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_CashFlow = [self formatButton:_btn_CashFlow];
    [_btn_CashFlow setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_CashFlow setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btnNeedForInvestment = [self formatButton:_btnNeedForInvestment];
    [_btnNeedForInvestment setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btnNeedForInvestment setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
}

- (void) initManucareData
{
    NSLog(@"checkExistingRiskCapacity = %@", [Support_Manucare checkExistingRiskCapacity:_profileId]);
    
    if ([[Support_Manucare checkExistingRiskCapacity:_profileId] compare:[NSNumber numberWithInt:0]] == NSOrderedDescending ) {
        
        NSError *error = [Support_Manucare getManucare:_profileId];
        
        if (!error) {
            
            [self loadManucareData];
            [self updateButtonImage];
        }
        else {
            
            [self sendErrorMessage:[error localizedDescription]];
        }
    }
}

- (void) addTopButtons
{
    //add home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    self.navigationItem.leftBarButtonItem = homeButton;
    [homeButton release];
    homeButton = nil;
}

- (void) gotoHome
{
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
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

- (void) loadManucareData
{
    [Support_Manucare getManucare:_profileId];
    
    NSNumber *ageScore = [Support_Manucare getAgeScore];
    [Session_Manucare sharedSession].ageScore = ageScore;
    [_lbl_AgeScore setText:[NSString stringWithFormat:@"%@", ageScore]];
    
}

- (void) updateButtonImage
{
    if ([[Session_Manucare sharedSession].timeFrame compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_TimeFrame = [self formatButton:_btn_TimeFrame];
        [_btn_TimeFrame setTitle:[Support_Manucare getBtnString:kQuestion_TimeFrame score:[Session_Manucare sharedSession].timeFrame] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].retirementPlan compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_Retirement = [self formatButton:_btn_Retirement];
        [_btn_Retirement setTitle:[Support_Manucare getBtnString:kQuestion_RetirementPlan score:[Session_Manucare sharedSession].retirementPlan] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].cashFlowNeeds compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_CashFlow = [self formatButton:_btn_CashFlow];
        [_btn_CashFlow setTitle:[Support_Manucare getBtnString:kQuestion_CashFlowNeeds score:[Session_Manucare sharedSession].cashFlowNeeds] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].needForInvestment compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btnNeedForInvestment = [self formatButton:_btnNeedForInvestment];
        [_btnNeedForInvestment setTitle:[Support_Manucare getBtnString:kQuestion_NeedforInvestment score:[Session_Manucare sharedSession].needForInvestment] forState:UIControlStateNormal];
    }
    
    [Support_Manucare getManucare:[FNASession sharedSession].profileId];
       
}

- (UIButton *) formatButton: (UIButton *) button
{
    [button setImage:nil forState:UIControlStateNormal];
    [button.titleLabel setNumberOfLines:10];
    [button.titleLabel setMinimumScaleFactor:10];
    [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    
    return button;
}


- (void) getRiskCapacityScore
{
    NSLog(@"%@", [Session_Manucare sharedSession].riskCapacityScore);
    
    [_lbl_RiskCapacityScore setText:[NSString stringWithFormat:@"%@", [Session_Manucare sharedSession].riskCapacityScore]];
    
    NSString *scoreInterpretation = [Support_Manucare riskCapacitytScoreInterpretation:[Session_Manucare sharedSession].riskCapacityScore];
    
    [_lbl_ScoreInterpretation setText:scoreInterpretation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableArray *_arr_Answers = [[NSMutableArray alloc]init];
    
    if([sender isEqual:_btn_TimeFrame])
    {
        //create answers array
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kTimeFrame_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kTimeFrame_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kTimeFrame_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"TimeFrame", @"question", nil]];
    }
    
    if([sender isEqual:_btn_Retirement])
    {
        //create answers array
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRetirementPlan_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRetirementPlan_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRetirementPlan_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Retirement", @"question", nil]];
    }
    
    if([sender isEqual:_btn_CashFlow])
    {
        //create answers array
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kCashFlowNeeds_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kCashFlowNeeds_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kCashFlowNeeds_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CashFlow", @"question", nil]];
    }
    
    if([sender isEqual:_btnNeedForInvestment])
    {
        //create answers array
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNeedForInvestment_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNeedForInvestment_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNeedForInvestment_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"NeedForInvestment", @"question", nil]];
    }
    
    [Session_Manucare sharedSession].arr_Answers = _arr_Answers;
    [_arr_Answers release];
    
    if ([[segue identifier] isEqualToString:@"toModalQuestions"]) {
        [[segue destinationViewController] setDelegate_Questions:self];
        ModalQuestionnaireViewController *modal = [[[ModalQuestionnaireViewController alloc]init]autorelease];
        modal.delegate_Questions = self;
    }
}

#pragma mark - Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString
{
    [self updateButtonImage];
    [self getRiskCapacityScore];
}

#pragma mark - IBActions

- (IBAction)btnAction:(id)sender
{
    [self performSegueWithIdentifier:@"toModalQuestions" sender:sender];
}

- (IBAction)saveManucare:(id)sender
{
    
    NSError *error = [Support_Manucare updateManucare:[FNASession sharedSession].profileId];
    
    if (error) {
        [self sendErrorMessage:[error localizedDescription]];
    }
    
}

#pragma mark -
#pragma Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_lbl_Overlay release];
    [_lbl_Title release];
    [_btnSave release];
    [_lbl_RiskCapacityScore release];
    [_lbl_ScoreInterpretation release];
    [_lbl_AgeScore release];
    [_navItem release];
    [_btn_TimeFrame release];
    [_btnNeedForInvestment release];
    [_btn_CashFlow release];
    [_btn_Retirement release];
    [_profileId release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLbl_Overlay:nil];
    [self setLbl_Title:nil];
    [self setBtnSave:nil];
    [self setLbl_RiskCapacityScore:nil];
    [self setLbl_ScoreInterpretation:nil];
    [self setLbl_AgeScore:nil];
    [self setNavItem:nil];
    [self setBtn_TimeFrame:nil];
    [self setBtnNeedForInvestment:nil];
    [self setBtn_CashFlow:nil];
    [self setBtn_Retirement:nil];
    [self setProfileId:nil];
    [super viewDidUnload];
}


@end
