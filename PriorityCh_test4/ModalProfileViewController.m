//
//  ModalProfileViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/5/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalProfileViewController.h"
#import "FnaConstants.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>

@interface ModalProfileViewController ()

@property (nonatomic, retain) NSString *birthdateString;

@end

@implementation ModalProfileViewController

@synthesize profile_delegate = _profile_delegate;

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	_lbl_BirthDateValue.text = [NSString stringWithFormat:@"%@",
                          [df stringFromDate:[NSDate date]]];
    
    //_datePicker.hidden = YES;
    //_btnDone.hidden = YES;
    _viewDatePicker.hidden = YES;
    
    [df release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



#pragma mark -
#pragma mark Custom Methods

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
    
    UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]autorelease];
    [alert show];
}

- (BOOL) validateEntries

{
    BOOL retVal = YES;
    
    if ([_txtLastName.text length]== 0){
        [self sendErrorMessage:kProfile_NoLastName];
        retVal = NO;
    }
    
    if ([self checkBirthdate]) {
        [self sendErrorMessage:kProfile_NoDob];
        retVal = NO;
    }
    
    return retVal;
}

- (BOOL) checkBirthdate
{
    NSCalendar *cal = [[NSCalendar alloc]autorelease];
    cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[[NSDateComponents alloc]init]autorelease];
    components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    NSDate *today = [[[NSDate alloc]init]autorelease];
    today = [cal dateByAddingComponents:components toDate:[[[NSDate alloc]init] autorelease] options:0];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
   
    
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
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
     _birthdateString = [formatter stringFromDate:birthdate];
    
    return _birthdateString;
}

- (void) triggerSave
{
    NSError *error = [[[NSError alloc]init]autorelease];
    error = nil;
    
    NSString *newProfileId = [[[NSString alloc]init]autorelease];
    
    if ([self validateEntries])
    {
       
        newProfileId = [GetPersonalProfile getNewProfileIdNumber];
        
        error = [GetPersonalProfile InsertNewPersonalProfile:newProfileId
                                                    lastName:_txtLastName.text
                                                   firstName:_txtFirstName.text
                                                  middleName:@""
                                                 dateOfBirth:[self birthdateForInsert:_datePicker.date]
                                                      gender:[NSNumber numberWithInt:(_segGender.selectedSegmentIndex)]
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
            
            [FNASession sharedSession].profileId = newProfileId;
            
            [self sendErrorMessage:kLoadSuccessful];
            [self setReadOnly:YES];
        }

    }
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewDatePicker release];
    [_datePicker release];
    [_btn_DatePickerDone release];
    [_lbl_Overlay release];
    [_txtFirstName release];
    [_txtLastName release];
    [_segGender release];
    [_lbl_BirthDateValue release];
    [_btn_ShowDatePicker release];
    [_txtEmail release];
    [_navBarItem release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setViewDatePicker:nil];
    [self setDatePicker:nil];
    [self setBtn_DatePickerDone:nil];
    [self setLbl_Overlay:nil];
    [self setTxtFirstName:nil];
    [self setTxtLastName:nil];
    [self setSegGender:nil];
    [self setLbl_BirthDateValue:nil];
    [self setBtn_ShowDatePicker:nil];
    [self setTxtEmail:nil];
    [self setNavBarItem:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)showPicker:(id)sender {
    _viewDatePicker.hidden = NO;
    [self initDatePicker];
}

- (IBAction)exitView:(id)sender
{
    [self triggerSave];
    [_profile_delegate finishedDoingMyThing:@"success"];
}

- (IBAction)exitCalendar:(id)sender
{
    [self.view sendSubviewToBack:_viewDatePicker];
}

@end
