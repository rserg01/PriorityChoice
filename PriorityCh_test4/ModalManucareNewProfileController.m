//
//  ModalManucareNewProfileController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalManucareNewProfileController.h"
#import "FnaConstants.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import "Session_Manucare.h"

@interface ModalManucareNewProfileController ()

@property (nonatomic, retain) NSString *birthdateString;

@end

@implementation ModalManucareNewProfileController

@synthesize delegate_NewProfile = _delegate_NewProfile;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	_lbl_BirthDateValue.text = [NSString stringWithFormat:@"%@",
                                [df stringFromDate:[NSDate date]]];
	[df release];
    
    //_datePicker.hidden = YES;
    //_btnDone.hidden = YES;
    _viewDatePicker.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Custom Methods

- (void) changeDateInLabel: (id)sender
{
    
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	_lbl_BirthDateValue.text = [NSString stringWithFormat:@"%@",
                                [df stringFromDate:_datePicker.date]];
	[df release];
}

- (void) initDatePicker
{
    // Initialization code
	_datePicker.datePickerMode = UIDatePickerModeDate;
	_datePicker.hidden = NO;
    _btn_DatePickerDone.hidden = NO;
	_datePicker.date = [NSDate date];
    [_datePicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
	[_viewDatePicker addSubview:_datePicker];
    [_viewDatePicker addSubview:_btn_DatePickerDone];
    [self.view bringSubviewToFront:_viewDatePicker];
}

- (void) initNavigation
{
    [_navBarItem initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exitView)];
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

- (NSString *) validateEntries

{
    NSString *errMessage = @"";
    
    if ([_txtLastName.text length]== 0){
        [self sendErrorMessage:kProfile_NoLastName];
        errMessage = kProfile_NoLastName;
    }
    
    if ([self checkBirthdate]) {
        [self sendErrorMessage:kProfile_ErrDob];
        errMessage = kProfile_ErrDob;
    }
    
    return errMessage;
}

- (BOOL) checkBirthdate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    if ([today compare:_datePicker.date]==NSOrderedAscending) {
        
        return YES;
        
    } else {
        
        return NO;
    }
    
    
}

- (void) setReadOnly:(BOOL) setReadonly

{
    [_txtLastName setBorderStyle:setReadonly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [_txtFirstName setBorderStyle:setReadonly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [_txtEmail setBorderStyle:setReadonly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    
    [_txtLastName resignFirstResponder];
    [_txtFirstName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_btn_DatePickerDone setEnabled:NO];
}

- (NSString *) birthdateForInsert: (NSDate *) birthdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    _birthdateString = [formatter stringFromDate:birthdate];
    
    return _birthdateString;
}

- (BOOL) triggerSave
{
    BOOL retVal = YES;
    NSError *error = nil;
    
    if ([[self validateEntries] isEqualToString:@""])
    {
        [FNASession sharedSession].profileId = [GetPersonalProfile getNewProfileIdNumber];
        
        error = [GetPersonalProfile InsertNewPersonalProfile:[FNASession sharedSession].profileId
                                                    lastName:_txtLastName.text
                                                   firstName:_txtFirstName.text
                                                  middleName:@""
                                                 dateOfBirth:[self birthdateForInsert:_datePicker.date]
                                                      gender:[NSNumber numberWithInt:(_seg_Gender.selectedSegmentIndex)]
                                                    address1:@""
                                                    address2:@""
                                                    address3:@""
                                                  occupation:@""
                                                     ofcAdd1:@""
                                                     ofcAdd2:@""
                                                     ofcAdd3:@""
                                                    landline:@""
                                                      mobile:@""
                                                   ofcTelNum:@""
                                                       email:_txtEmail.text];
        
        
        if (error) {
            [self sendErrorMessage:[error localizedDescription]];
        }
        else {
            [self sendErrorMessage:kLoadSuccessful];
            [self setReadOnly:YES];
        }
    }
    else {
        retVal = NO;
    }
    
    return retVal;
}

#pragma mark - IBAction

- (IBAction)showPicker:(id)sender {
    _viewDatePicker.hidden = NO;
    [self initDatePicker];
}

- (IBAction)exitView:(id)sender
{
    if ([self triggerSave]) {
        [_delegate_NewProfile finishedDoingMyThing:@"success_NewProfile"];
        
        [Session_Manucare sharedSession].riskCapacityScore = nil;
        [Session_Manucare sharedSession].riskAttitudeScore = nil;
        
        [Session_Manucare sharedSession].timeFrame = nil;
        [Session_Manucare sharedSession].retirementPlan = nil;
        [Session_Manucare sharedSession].needForInvestment= nil;
        [Session_Manucare sharedSession].cashFlowNeeds = nil;
        [Session_Manucare sharedSession].ageScore = nil;
        
        [Session_Manucare sharedSession].ageScore = nil;
        [Session_Manucare sharedSession].interestValue = nil;
        [Session_Manucare sharedSession].returns = nil;
        [Session_Manucare sharedSession].riskDegree = nil;
        [Session_Manucare sharedSession].reviewFrequency = nil;
        [Session_Manucare sharedSession].overallAttitude = nil;

    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)exitCalendar:(id)sender
{
    [self.view sendSubviewToBack:_viewDatePicker];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Memory Management

- (void)dealloc {
    [_txtFirstName release];
    [_txtLastName release];
    [_txtEmail release];
    [_seg_Gender release];
    [_btn_ShowPicker release];
    [_btn_DatePickerDone release];
    [_datePicker release];
    [_viewDatePicker release];
    [_lbl_BirthDateValue release];
    [_lbl_Overlay release];
    [_navBarItem release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtFirstName:nil];
    [self setTxtLastName:nil];
    [self setTxtEmail:nil];
    [self setSeg_Gender:nil];
    [self setBtn_ShowPicker:nil];
    [self setBtn_DatePickerDone:nil];
    [self setDatePicker:nil];
    [self setViewDatePicker:nil];
    [self setLbl_BirthDateValue:nil];
    [self setLbl_Overlay:nil];
    [self setNavBarItem:nil];
    [super viewDidUnload];
}
@end
