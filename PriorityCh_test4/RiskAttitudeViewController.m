//
//  RiskAttitudeViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "RiskAttitudeViewController.h"
#import "Session_Manucare.h"
#import "Support_Manucare.h"
#import <QuartzCore/QuartzCore.h>
#import "FnaConstants.h"
#import "FNASession.h"


@interface RiskAttitudeViewController ()

@end

@implementation RiskAttitudeViewController

#pragma mark - 
#pragma Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
 }

- (void)viewWillAppear:(BOOL)animated
{
    [self initNavItems];
    [self initButtonImage];
    [self initBgLabels];
    [self initManucareData];
    [self updateButtonImage];
    [self getRiskAttitudeScore];

}

#pragma mark -
#pragma Custom Methods

- (void) initScrollView
{
    // define the area that is initially visable
    _scrollView.frame = CGRectMake(0, 62, 1024, 320);
    // then define how much they can scroll it
    [_scrollView setContentSize:CGSizeMake(2292, 320)];
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
    
    //add home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    self.navigationItem.leftBarButtonItem = homeButton;
    [homeButton release];
    homeButton = nil;
}

- (void) initManucareData
{
    if (![[FNASession sharedSession].profileId isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].timeFrame == 0) {
        
        NSLog(@"checkExistingRiskAttitude = %@", [Support_Manucare checkExistingRiskAttitude:[FNASession sharedSession].profileId]);
        
        if ([[Support_Manucare checkExistingRiskAttitude:[FNASession sharedSession].profileId] compare:[NSNumber numberWithInt:0]] == NSOrderedDescending ) {
            
            NSError *error = [Support_Manucare getManucare:[FNASession sharedSession].profileId];
            
            if (error) {
                [self sendErrorMessage:[error localizedDescription]];
            }
            
            [self updateButtonImage];
            [self getRiskAttitudeScore];
        }
    }
    else {
        
        [self sendErrorMessage:kNoProfileActive];
    }
    
}

- (void) initButtonImage
{
    
    _btn_InterestValue = [self formatButton:_btn_InterestValue];
    [_btn_InterestValue setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_InterestValue setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_InvestDrop = [self formatButton:_btn_InvestDrop];
    [_btn_InvestDrop setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_InvestDrop setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_Overall = [self formatButton:_btn_Overall];
    [_btn_Overall setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_Overall setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_Returns = [self formatButton:_btn_Returns];
    [_btn_Returns setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_Returns setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_Review = [self formatButton:_btn_Review];
    [_btn_Review setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_Review setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
    _btn_Risk = [self formatButton:_btn_Risk];
    [_btn_Risk setTitle:[Support_Manucare getBtnString:@"" score:nil] forState:UIControlStateNormal];
    [_btn_Risk setImage:[UIImage imageNamed:kQuestionMark_Image] forState:UIControlStateNormal];
    
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



- (void) getRiskAttitudeScore
{
    NSNumber *score =
    [Support_Manucare getRiskAttitudeScore:[Session_Manucare sharedSession].investmentDrop
                             interestValue:[Session_Manucare sharedSession].interestValue
                                   returns:[Session_Manucare sharedSession].returns
                                riskDegree:[Session_Manucare sharedSession].riskDegree
                                    review:[Session_Manucare sharedSession].reviewFrequency
                                   overall:[Session_Manucare sharedSession].overallAttitude];
    
    [_lbl_Score setText:[NSString stringWithFormat:@"%@", score]];
    
    NSString *scoreInterpretation = [Support_Manucare riskAttitudeScoreInterpretation:score];
    
    [_lbl_ScoreInterpretation setText:scoreInterpretation];
}

- (void) updateButtonImage
{
    if ([[Session_Manucare sharedSession].investmentDrop compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_InvestDrop = [self formatButton:_btn_InvestDrop];
        [_btn_InvestDrop setTitle:[Support_Manucare getBtnString:kQuestion_InvestmentDrop score:[Session_Manucare sharedSession].investmentDrop] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].interestValue compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_InterestValue = [self formatButton:_btn_InterestValue];
        [_btn_InterestValue setTitle:[Support_Manucare getBtnString:kQuestion_InterestValue score:[Session_Manucare sharedSession].interestValue] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].returns compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_Returns = [self formatButton:_btn_Returns];
        [_btn_Returns setTitle:[Support_Manucare getBtnString:kQuestion_Returns score:[Session_Manucare sharedSession].returns] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].riskDegree compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_Risk = [self formatButton:_btn_Risk];
        [_btn_Risk setTitle:[Support_Manucare getBtnString:kQuestion_RiskDegree score:[Session_Manucare sharedSession].riskDegree] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].reviewFrequency compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_Review = [self formatButton:_btn_Review];
        [_btn_Review setTitle:[Support_Manucare getBtnString:kQuestion_ReviewFrequency score:[Session_Manucare sharedSession].reviewFrequency] forState:UIControlStateNormal];
    }
    
    if ([[Session_Manucare sharedSession].overallAttitude compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
        
        _btn_Overall = [self formatButton:_btn_Overall];
        [_btn_Overall setTitle:[Support_Manucare getBtnString:kQuestion_Overall score:[Session_Manucare sharedSession].overallAttitude] forState:UIControlStateNormal];
    }
    
}

- (void) resetButtonImage
{
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableArray *_arr_Answers = [[NSMutableArray alloc]init];
    
    if([sender isEqual:_btn_InvestDrop])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInvestmentDrop_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInvestmentDrop_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInvestmentDrop_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"InvestmentDrop", @"question", nil]];
    }
    
    if([sender isEqual:_btn_InterestValue])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInterestValue_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInterestValue_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kInterestValue_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"InterestValue", @"question", nil]];
    }
    
    if([sender isEqual:_btn_Returns])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReturns_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReturns_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReturns_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Returns", @"question", nil]];
    }
    
    if([sender isEqual:_btn_Risk])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRiskDegree_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRiskDegree_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kRiskDegree_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"RiskDegree", @"question", nil]];
    }
    
    if([sender isEqual:_btn_Review])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReview_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReview_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kReview_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Review", @"question", nil]];
    }
    
    if([sender isEqual:_btn_Overall])
    {
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kOverall_Ans1, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kOverall_Ans2, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:kOverall_Ans3, @"option", nil]];
        [_arr_Answers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Overall", @"question", nil]];
    }
    
    [[Session_Manucare sharedSession].arr_Answers removeAllObjects];
    [Session_Manucare sharedSession].arr_Answers = _arr_Answers;
    
    [_arr_Answers release];
    
    if ([[segue identifier] isEqualToString:@"toModalQuestions2"]) {
        [[segue destinationViewController] setDelegate_Questions:self];
        ModalQuestionnaireViewController *modal = [[[ModalQuestionnaireViewController alloc]init]autorelease];
        modal.delegate_Questions = self;
    }
}

#pragma mark - Delegate Methods

-(void)finishedDoingMyThing:(NSString *)labelString
{
    [self updateButtonImage];
    [self getRiskAttitudeScore];
}

#pragma mark - IBAction

- (IBAction)btnAction:(id)sender {
    
    if([sender isKindOfClass:[UIButton class]])
    {
        [self performSegueWithIdentifier:@"toModalQuestions2" sender:sender];
    }
    
    if ((![[Session_Manucare sharedSession].investmentDrop isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].investmentDrop == 0) &&
        (![[Session_Manucare sharedSession].interestValue isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].interestValue == 0) &&
        (![[Session_Manucare sharedSession].returns isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].returns == 0) &&
        (![[Session_Manucare sharedSession].riskDegree isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].riskDegree == 0) &&
        (![[Session_Manucare sharedSession].returns isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].reviewFrequency == 0) &&
        (![[Session_Manucare sharedSession].returns isEqual:(id)[NSNull null]] || [Session_Manucare sharedSession].overallAttitude == 0))
    {
        [self getRiskAttitudeScore];
    }
    
}

- (IBAction)saveInfo:(id)sender {
    
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
}

- (void)dealloc {
    [_scrollView release];
    [_lbl_Overlay release];
    [_lbl_Title release];
    [_btn_InvestDrop release];
    [_btn_InterestValue release];
    [_btn_Returns release];
    [_btn_Risk release];
    [_btn_Review release];
    [_btn_Overall release];
    [_lbl_Score release];
    [_lbl_ScoreInterpretation release];
    [_navItem release];
    [_btn_save release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLbl_Overlay:nil];
    [self setLbl_Title:nil];
    [self setBtn_InvestDrop:nil];
    [self setBtn_InterestValue:nil];
    [self setBtn_Returns:nil];
    [self setBtn_Risk:nil];
    [self setBtn_Review:nil];
    [self setBtn_Overall:nil];
    [self setLbl_Score:nil];
    [self setLbl_ScoreInterpretation:nil];
    [self setNavItem:nil];
    [self setBtn_save:nil];
    [super viewDidUnload];
}

@end
