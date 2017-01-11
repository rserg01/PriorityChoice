//
//  FNAGeneralInformationViewController.m
//  FNA
//
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAGeneralInformationViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "AESCrypt.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>
#import "FnaConstants.h"

@interface FNAGeneralInformationViewController()
- (void) setRightBarButtonItemSave:(BOOL)save;
- (void) setLeftBarButtonItemCancel:(BOOL)cancel;
- (void) editInformation:(id)sender;
- (void) setReadOnly:(BOOL)readOnly;
- (void) resignFirstResponders;
- (void) assignTextFieldValues;
@end

@implementation FNAGeneralInformationViewController

@synthesize imgTemplate;
@synthesize txtOfcAddress2;
@synthesize txtOfcAddress3;
@synthesize txtAddress2;
@synthesize txtAddress3;
@synthesize txtLastname, txtFirstname, txtMiddlename;
@synthesize txtBirthdate, txtAddress, txtOccupation;
@synthesize txtOfficeAddress, txtLandline, txtMobileNo;
@synthesize txtOfficeNo, txtEmail, sdrRetirementAge, segGender, lblGender;


- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self setUI:[FNASession sharedSession].profileId];
    
    _lbl_Overlay.layer.cornerRadius = 8;
}

- (void) initNavigationBar {
    self.navigationItem.title = @"General Information";
	self.navigationController.navigationBarHidden = NO;
}

- (void) setUI: (NSString *) profileId {

    NSLog(@"profileId = %@", profileId);
    
    if ([profileId length] > 0)
	{
        [self assignTextFieldValues];
        [self setRightBarButtonItemSave:NO];
        [self setReadOnly:YES];
    }
	else
	{
		[self setRightBarButtonItemSave:YES];
		[self setReadOnly:NO];
	}
    
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (![[FNASession sharedSession].profileId isEqualToString:[Utility getUserDefaultsValue:@"tProfile_Personal_Id"]]
		&& [[self.txtLastname text] isEqualToString:@""])
	{
		[FNASession sharedSession].profileId = nil;
	}
}

#pragma mark - Navigation

- (void) setRightBarButtonItemSave:(BOOL)save
{
	UIBarButtonSystemItem systemItem = UIBarButtonSystemItemSave;
	SEL _selector = @selector(saveInformation:);
    
	if (!save)
	{
		systemItem = UIBarButtonSystemItemEdit;
		_selector = @selector(editInformation:);
		self.navigationItem.hidesBackButton = NO;
		self.navigationItem.leftBarButtonItem = nil;
	}
    
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
																			target:self
																			action:_selector];
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	button = nil;
	
}

- (void) setLeftBarButtonItemCancel:(BOOL)cancel
{
	if (cancel)
	{
		self.navigationItem.hidesBackButton = YES;
		UIBarButtonItem *cancel =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(assignTextFieldValues)];
		self.navigationItem.leftBarButtonItem = cancel;
		[cancel release];
		cancel = nil;
	}
	else
	{
		self.navigationItem.hidesBackButton = NO;
		self.navigationItem.leftBarButtonItem = nil;
	}
}

#pragma mark - Class Custom Methods

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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Format Date of Birth YYYY-MM-DD
    if(textField == txtBirthdate)
    {
        if ((textField.text.length == 5)||(textField.text.length == 2))
            //Handle backspace being pressed
            if (![string isEqualToString:@""])
                textField.text = [textField.text stringByAppendingString:@"/"];
        return !([textField.text length]>9 && [string length] > range.length);
    }
    else
    {
        return YES;
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.txtBirthdate isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_Birthdat];
    }
    return YES;
}

- (void) assignTextFieldValues
{
    
    [txtLastname setText:[FNASession sharedSession].clientLastName];
    [txtFirstname setText:[FNASession sharedSession].clientFirstName];
    [txtMiddlename setText:[FNASession sharedSession].clientMiddleName];
    [txtBirthdate setText:[FNASession sharedSession].clientDob];
    [segGender setSelectedSegmentIndex:[[[FNASession sharedSession].clientGender lowercaseString] isEqualToString:@"male"] ? 0 : 1];
    [txtLandline setText:[FNASession sharedSession].clientLandLine];
    [txtMobileNo setText:[FNASession sharedSession].clientMobile];
    [txtEmail setText:[FNASession sharedSession].clientEmail];
    [txtOccupation setText:[FNASession sharedSession].clientOccupation];
    [txtAddress setText:[FNASession sharedSession].clientAddress1];
    [txtAddress2 setText:[FNASession sharedSession].clientAddress2];
    [txtAddress3 setText:[FNASession sharedSession].clientAddress3];
    [txtOfficeAddress setText:[FNASession sharedSession].clientOfficeAdd1];
    [txtOfcAddress2 setText:[FNASession sharedSession].clientOfficeAdd2];
    [txtOfcAddress3 setText:[FNASession sharedSession].clientOfficeAdd3];
    [txtOfficeNo setText:[FNASession sharedSession].clientOfficeTelNum];
    
}

- (void) editInformation:(id)sender
{
	[self setLeftBarButtonItemCancel:YES];
	[self setRightBarButtonItemSave:YES];	
	[self setReadOnly:NO];
	[self.txtLastname becomeFirstResponder];
}

- (void) saveInformation:(id)sender
{
    BOOL isValid = YES;
    
	if ([self.txtLastname.text isEqualToString:@""]) 
	{
		isValid = NO;
        [self sendErrorMessage:@"Last name is required"];
		[self.txtLastname becomeFirstResponder];
	}
	else if ([self.txtBirthdate.text isEqualToString:@""]) 
	{
        isValid = NO;
        [self sendErrorMessage:@"Date of birth is required"];
		[self.txtBirthdate becomeFirstResponder];
	}
    
    //TODO: INsert validation of birthdate values
	
	if (![[self.txtEmail text] isEqualToString:@""]) 
	{
		if(![Utility validateEmail:self.txtEmail.text])
		{
            isValid = NO;
            [self sendErrorMessage:@"Please enter valid email address"];
			[self.txtEmail becomeFirstResponder];
			return;
		}
	}
	
    NSString *alertTitle = @"Priority Choice";
    NSString *message = @"Saving profile...";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:alertTitle
                          message:message
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:nil];
    
    if (isValid) {
        
        [self resignFirstResponders];
        [alert show];
        [self performSelector:@selector(saveInfo:) withObject:alert afterDelay:0.3];
    }
    
    [alert release];
}

- (void) saveInfo:(UIAlertView *)alertView
{
    if ([[FNASession sharedSession].profileId length] == 0)
    {
        [FNASession sharedSession].profileId = [GetPersonalProfile getNewProfileIdNumber];
        
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        
        NSError *error = [GetPersonalProfile InsertNewPersonalProfile:[FNASession sharedSession].profileId
                                                             lastName:[txtLastname text]
                                                            firstName:[txtFirstname text]
                                                           middleName:[txtMiddlename text]
                                                          dateOfBirth:[txtBirthdate text]
                                                               gender:[NSNumber numberWithInt:segGender.selectedSegmentIndex]
                                                             address1:[txtAddress text]
                                                             address2:[txtAddress2 text]
                                                             address3:[txtAddress3 text]
                                                           occupation:[txtOccupation text]
                                                              ofcAdd1:[txtOfficeAddress text]
                                                              ofcAdd2:[txtOfcAddress2 text]
                                                              ofcAdd3:[txtOfcAddress3 text]
                                                             landline:[txtLandline text]
                                                               mobile:[txtMobileNo text]
                                                            ofcTelNum:[txtOfficeNo text]
                                                                email:[txtEmail text]];
        
        NSString *title_= @"", *message = @"";
        
        if (error)
        {
            title_ = @"Priority Choice";
            message = [error localizedDescription];
        }
        else
        {
            title_ = @"Priority Choice";
            message = @"Profile information successfully saved!";
            
            [Utility saveToUserDefaults:@"tProfile_Personal_Id" value:[FNASession sharedSession].profileId];
            
            [self performSelector:@selector(recordSaved) withObject:nil afterDelay:0.3];
            //[self setRightBarButtonItemSave:NO];
            [self setReadOnly:YES];
        }
        
        [self sendErrorMessage:@"New profile saved"];
        
    }
    else
    {
        
        //update existing profile
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
        
        NSError *error = [GetPersonalProfile UpdatePersonalProfile:[FNASession sharedSession].profileId
                                                             lastName:[txtLastname text]
                                                            firstName:[txtFirstname text]
                                                           middleName:[txtMiddlename text]
                                                          dateOfBirth:[txtBirthdate text]
                                                               gender:[NSNumber numberWithInt:segGender.selectedSegmentIndex]
                                                             address1:[txtAddress text]
                                                             address2:[txtAddress2 text]
                                                             address3:[txtAddress3 text]
                                                           occupation:[txtOccupation text]
                                                              ofcAdd1:[txtOfficeAddress text]
                                                              ofcAdd2:[txtOfcAddress2 text]
                                                              ofcAdd3:[txtOfcAddress3 text]
                                                             landline:[txtLandline text]
                                                               mobile:[txtMobileNo text]
                                                            ofcTelNum:[txtOfficeNo text]
                                                                email:[txtEmail text]];
        
        NSString *title_= @"", *message = @"";
        
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            title_ = @"Priority Choice";
            message = [error localizedDescription];
        }
        else
        {
            title_ = @"Priority Choice";
            message = @"Profile information successfully saved!";
            
            [Utility saveToUserDefaults:@"tProfile_Personal_Id" value:[FNASession sharedSession].profileId];
            
            [self performSelector:@selector(recordSaved) withObject:nil afterDelay:0.3];
            //[self setRightBarButtonItemSave:NO];
            [self setReadOnly:YES];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Priority Choice"
                              message:@"Profile information successfully saved!"
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}

- (void) recordSaved
{
	[self setLeftBarButtonItemCancel:NO];
	[self setRightBarButtonItemSave:NO];
	[self setReadOnly:YES];
}

- (void) setReadOnly:(BOOL)readOnly
{
	if (!readOnly)
	{
		[self.txtLastname becomeFirstResponder];
	}
	[self.txtLastname setUserInteractionEnabled:!readOnly];
	[self.txtFirstname setUserInteractionEnabled:!readOnly];
	[self.txtMiddlename setUserInteractionEnabled:!readOnly];
	[self.txtBirthdate setUserInteractionEnabled:!readOnly];
	[self.txtAddress setUserInteractionEnabled:!readOnly];
    [self.txtAddress2 setUserInteractionEnabled:!readOnly];
    [self.txtAddress3 setUserInteractionEnabled:!readOnly];
	[self.txtOccupation setUserInteractionEnabled:!readOnly];
	[self.txtOfficeAddress setUserInteractionEnabled:!readOnly];
    [self.txtOfcAddress2 setUserInteractionEnabled:!readOnly];
    [self.txtOfcAddress2 setUserInteractionEnabled:!readOnly];
	[self.txtLandline setUserInteractionEnabled:!readOnly];
	[self.txtMobileNo setUserInteractionEnabled:!readOnly];
	[self.txtOfficeNo setUserInteractionEnabled:!readOnly];
	[self.txtEmail setUserInteractionEnabled:!readOnly];
	
	[self.txtLastname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtFirstname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtMiddlename setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtBirthdate setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtAddress setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [self.txtAddress2 setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [self.txtAddress3 setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOccupation setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOfficeAddress setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [self.txtOfcAddress2 setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
    [self.txtOfcAddress3 setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtLandline setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtMobileNo setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOfficeNo setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtEmail setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.lblGender setText: [self.segGender titleForSegmentAtIndex:self.segGender.selectedSegmentIndex]];
	[self.segGender setHidden:readOnly ? YES: NO];
	[self.lblGender setHidden:readOnly ? NO : YES];
	
}

- (void) resignFirstResponders
{
	[self.txtLastname resignFirstResponder];
	[self.txtFirstname resignFirstResponder];
	[self.txtMiddlename resignFirstResponder];
	[self.txtBirthdate resignFirstResponder];
	[self.txtAddress resignFirstResponder];
	[self.txtOccupation resignFirstResponder];
	[self.txtOfficeAddress resignFirstResponder];
	[self.txtLandline resignFirstResponder];
	[self.txtMobileNo resignFirstResponder];
	[self.txtOfficeNo resignFirstResponder];
	[self.txtEmail resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setTxtAddress2:nil];
    [self setTxtAddress3:nil];
    [self setTxtOfcAddress2:nil];
    [self setTxtOfcAddress3:nil];
    [self setImgTemplate:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[self.txtLastname release];
	[self.txtFirstname release];
	[self.txtMiddlename release];
	[self.txtBirthdate release];
	[self.txtAddress release];
	[self.txtOccupation release];
	[self.txtOfficeAddress release];
	[self.txtLandline release];
	[self.txtMobileNo release];
	[self.txtOfficeNo release];
	[self.txtEmail release];
	[self.sdrRetirementAge release];
	[self.segGender release];
	[self.lblGender release];
    [txtAddress2 release];
    [txtAddress3 release];
    [txtOfcAddress2 release];
    [txtOfcAddress3 release];
    [imgTemplate release];
    [_lbl_Overlay release];
    [super dealloc];
}
@end
