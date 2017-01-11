//
//  FNAAddDependentViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAAddDependentViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import "GetPersonalProfile.h"
#import "FnaConstants.h"

@interface FNAAddDependentViewController()

@property (nonatomic, retain) NSMutableArray *arrDependentInfo;

@end

@implementation FNAAddDependentViewController

@synthesize delegate_AddDependent = _delegate_AddDependent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [self startLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Format Date of Birth YYYY-MM-DD
    if(textField == _txtBirthdate)
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
    if ([_txtBirthdate isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_Birthdat];
    }
    
    return YES;
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

- (void) addTopButtons
{
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(exitModal)];
    
    _navItem.rightBarButtonItems = [NSArray arrayWithObjects:done, nil];
    
    [done release];
}

- (void) exitModal
{
    [_delegate_AddDependent finishedDoingMyThing:@"done"];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -  Class Custom Methods

- (void) loadArrToFields
{
    NSDictionary *dic = [_arrDependentInfo objectAtIndex:0];
    
    [_txtFirstname setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"firstName"]]];
    [_txtLastname setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"lastName"]]];
    [_txtMiddlename setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"middleName"]]];
    [_txtBirthdate setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"dateOfBirth"]]];
    [_txtRelationship setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"relationship"]]];
}

- (void) setRightBarButtonItemSave:(BOOL)save
{
	UIBarButtonSystemItem systemItem = UIBarButtonSystemItemSave;
	SEL _selector = @selector(saveInformation:);
    
	
	if (!save)
	{
		systemItem = UIBarButtonSystemItemEdit;
		_selector = @selector(editDependentInformation:);
		_navItem.hidesBackButton = NO;
		_navItem.leftBarButtonItem = nil;
	}
    
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(exitModal)] autorelease];
	
	UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:_selector] autorelease];
    
    _navItem.rightBarButtonItems= [NSArray arrayWithObjects:button, done, nil];
    
}

- (void) setLeftBarButtonItemCancel:(BOOL)cancel
{
	if (cancel)
	{
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(exitModal)];
		_navItem.leftBarButtonItem = cancel;
		
        [cancel release];
		cancel = nil;
	}
	else
	{
		_navItem.leftBarButtonItem = nil;
	}
}

- (void) startLoading
{
    NSLog(@"%@", [FNASession sharedSession].profileId);
    
    [_arrDependentInfo removeAllObjects];
    
    _arrDependentInfo = [GetPersonalProfile getDependentInfo:[FNASession sharedSession].profileId dependentId:[FNASession sharedSession].dependentId];
    
    if ([_arrDependentInfo count] > 0) {
        
        [self loadArrToFields];
        [self setRightBarButtonItemSave:NO];
        [self setLeftBarButtonItemCancel:NO];
        [self setReadOnly:YES];
    }
    else {
        
        [self setReadOnly:NO];
        [self setRightBarButtonItemSave:YES];
        [self setLeftBarButtonItemCancel:YES];
    }
}

- (void) editDependentInformation:(id)sender
{
	[self setLeftBarButtonItemCancel:YES];
	[self setRightBarButtonItemSave:YES];
	[self setReadOnly:NO];
	[self.txtLastname becomeFirstResponder];
}

- (void) saveInformation:(id)sender
{
	NSString /**title_= @"Error",*/ *message = @"";
	/*if ([self.txtLastname.text isEqualToString:@""])
     {
     message = @"Lastname is required!";
     [self.txtLastname becomeFirstResponder];
     }
     else if ([self.txtFirstname.text isEqualToString:@""])
     {
     message = @"Firstname is required!";
     [self.txtFirstname becomeFirstResponder];
     }
     else if ([self.txtMiddlename.text isEqualToString:@""])
     {
     message = @"Middlename is required!";
     [self.txtMiddlename becomeFirstResponder];
     }
     else if ([self.txtBirthdate.text isEqualToString:@""])
     {
     message = @"Date of birth is required!";
     [self.txtBirthdate becomeFirstResponder];
     }*/
	
	if(![message isEqualToString:@""])
	{
		/*
		 [Utility showAlerViewWithTitle:title_
		 withMessage:message
		 withCancelButtonTitle:@"Ok"
		 withOtherButtonTitle:nil
		 withSpinner:NO
		 withDelegate:nil];
		 */
		return;
	}
	
	[self resignFirstResponders];
	
	UIAlertView *alertView = [Utility showAlerViewWithTitle:@"Saving Information"
												withMessage:@""
									  withCancelButtonTitle:nil
									   withOtherButtonTitle:nil
												withSpinner:YES
											   withDelegate:nil];
	
	
	[self performSelector:@selector(saveInfo:) withObject:alertView afterDelay:0.3];
}


- (void) saveInfo:(UIAlertView *)alertView
{
    
    NSError *error = nil;
    
    if ([[GetPersonalProfile checkExisingDependent:[FNASession sharedSession].dependentId profileId:[FNASession sharedSession].profileId] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
        
        [FNASession sharedSession].dependentId = [GetPersonalProfile generateDependentId];
        NSLog(@"%@", [FNASession sharedSession].dependentId);
        error = [GetPersonalProfile saveDependent:[FNASession sharedSession].profileId
                                      dependentId:[FNASession sharedSession].dependentId
                                        firstName:_txtFirstname.text
                                         lastName:_txtLastname.text
                                       middleName:_txtMiddlename.text
                                      dateOfBirth:_txtBirthdate.text
                                     relationship:_txtRelationship.text];
    }
    else {
        
        error = [GetPersonalProfile updateDependent:[FNASession sharedSession].profileId
                                        dependentId:[FNASession sharedSession].dependentId
                                          firstName:_txtFirstname.text
                                           lastName:_txtLastname.text
                                         middleName:_txtMiddlename.text
                                        dateOfBirth:_txtBirthdate.text
                                       relationship:_txtRelationship.text];
    }
    
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
    NSString *title_= @"", *message = @"";
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        title_ = @"Error";
        message = [error localizedDescription];
    }
    else
    {
        title_ = @"Saved";
        message = @"Dependent information successfully saved!";
        
        [self performSelector:@selector(recordSaved) withObject:nil afterDelay:0.3];
    }
    
    [Utility showAlerViewWithTitle:title_
                       withMessage:message
             withCancelButtonTitle:@"Ok"
              withOtherButtonTitle:nil
                       withSpinner:NO
                      withDelegate:nil];
	
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
		[_txtLastname becomeFirstResponder];
	}
	
	[_txtLastname setUserInteractionEnabled:!readOnly];
	[_txtFirstname setUserInteractionEnabled:!readOnly];
	[_txtMiddlename setUserInteractionEnabled:!readOnly];
	[_txtBirthdate setUserInteractionEnabled:!readOnly];
	[_txtRelationship setUserInteractionEnabled:!readOnly];
	
	[_txtLastname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[_txtFirstname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[_txtMiddlename setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[_txtBirthdate setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[_txtRelationship setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	
}

- (void) resignFirstResponders
{
	[_txtLastname resignFirstResponder];
	[_txtFirstname resignFirstResponder];
	[_txtMiddlename resignFirstResponder];
	[_txtBirthdate resignFirstResponder];
	[_txtRelationship resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setLbl_Overlay:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[_txtLastname release];
	[_txtFirstname release];
	[_txtMiddlename release];
	[_txtBirthdate release];
	[_txtRelationship release];
    [_lbl_Overlay release];
    [_navItem release];
    [super dealloc];
}

@end
