    //
//  FNASpouseViewController.m
//  FNA
//
//  Created by Justin Limjap on 2/29/12.
//  Copyright 2012 iGen Dev Center, Inc. All rights reserved.
//

#import "FNASpouseViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import "FnaConstants.h"

@interface FNASpouseViewController()
- (void) setRightBarButtonItemSave:(BOOL)save;
- (void) setLeftBarButtonItemCancel:(BOOL)cancel;
- (void) loadSpouseInformation;
- (void) setReadOnly:(BOOL)readOnly;
- (void) resignFirstResponders;
@end

@implementation FNASpouseViewController
@synthesize imgTemplate;
@synthesize txtLastname, txtFirstname, txtMiddlename, txtBirthdate, segGender,lblGender, txtOccupation, txtOfficeNo, txtOfficeAddress;

#pragma mark -
#pragma mark View Delegates

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title = @"Spouse";
	self.navigationController.navigationBarHidden = NO;
	
	[self loadSpouseInformation];
    
    _lbl_Overlay.layer.cornerRadius = 8;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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

- (void)viewWillAppear:(BOOL)animated
{
    NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    UIImage *mcblTemplate = [UIImage imageNamed: @"LifeCompass5_templateWithMcbl.png"];
    
    //change images per sales channel
    if ([strChannel isEqualToString:@"MCBL"])
    {
        [imgTemplate setImage:mcblTemplate];
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

#pragma mark -
#pragma mark Class Custom Methods
- (void) setRightBarButtonItemSave:(BOOL)save
{
	UIBarButtonSystemItem systemItem = UIBarButtonSystemItemSave;
	SEL _selector = @selector(saveInformation:);
	
	if (!save) 
	{
		systemItem = UIBarButtonSystemItemEdit;
		_selector = @selector(editInformation:);
		[self setLeftBarButtonItemCancel:NO];
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
		UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																				target:self 
																				action:@selector(loadSpouseInformation)];
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

- (void) loadSpouseInformation
{
	sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (profileId && ![profileId isEqualToString:@""]) 
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"LastName, FirstName, MiddleName, DateOfBirth, Gender, "
								   @"Occupation, Office, AddressOfc1 "
								   @"FROM tProfile_Spouse WHERE ClientId=%@", profileId];
			
			sqlite3_stmt *sqliteStatement;
			BOOL recordExists = NO; 
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{				
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
					recordExists = YES;
					[txtLastname setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)]];
					[txtFirstname setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)]];
					[txtMiddlename setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)]];
					[txtBirthdate setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)]];
					[lblGender setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)]];
					[segGender setSelectedSegmentIndex:[[lblGender.text lowercaseString] isEqualToString:@"male"] ? 0 : 1];
					[txtOccupation setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)]];
					[txtOfficeNo setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 6)]];
					[txtOfficeAddress setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 7)]];					
					
				}
			}
                    
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);	
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
			
			[self setReadOnly:recordExists];
			[self setRightBarButtonItemSave:!recordExists];
		}
		else 
		{			
			[self setRightBarButtonItemSave:YES];
		}
		[self setLeftBarButtonItemCancel:NO];
	}
	else 
	{		
		self.navigationItem.rightBarButtonItem.enabled = NO;
		
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
		[self setReadOnly:NO];
		[self setRightBarButtonItemSave:YES];
	}
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
    
    NSString *sqlInsert = [NSString stringWithFormat:@"REPLACE INTO tProfile_Spouse ("
                           @"_Id, ClientId, LastName, FirstName, MiddleName, DateOfBirth, Gender, "
                           @"Occupation, Office, AddressOfc1) "
                           @"VALUES (%@, %@, \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\")",
                           @"(SELECT COUNT(*)+1 from tProfile_Spouse)",
                           [FNASession sharedSession].profileId,
                           [self.txtLastname text],
                           [self.txtFirstname text],
                           [self.txtMiddlename text],
                           [self.txtBirthdate text],
                           [self.segGender selectedSegmentIndex]==1 ? @"M":@"F",
                           [self.txtOccupation.text length]==0 ? @"":[self.txtOccupation text],
                           [self.txtOfficeNo.text length]== 0 ? @"":[self.txtOfficeNo text],
                           [self.txtOfficeAddress.text length]==0 ? @"":[self.txtOfficeAddress text]];
    
    NSError *error = nil;
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
    NSString *title_= @"", *message = @"";
    if (error)
    {
        title_ = @"Error";
        message = [error localizedDescription];
    }
    else
    {
        title_ = @"Saved";
        message = @"Spouse information successfully saved!";
        
        [self performSelector:@selector(recordSaved) withObject:nil afterDelay:0.3];
        //[self setRightBarButtonItemSave:NO];
        //[self setReadOnly:YES];
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

- (void) editInformation:(id)sender
{
	[self setLeftBarButtonItemCancel:YES];
	[self setRightBarButtonItemSave:YES];	
	[self setReadOnly:NO];
	[self.txtLastname becomeFirstResponder];
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
	[self.txtOccupation setUserInteractionEnabled:!readOnly];
	[self.txtOfficeAddress setUserInteractionEnabled:!readOnly];
	[self.txtOfficeNo setUserInteractionEnabled:!readOnly];
	
	[self.txtLastname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtFirstname setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtMiddlename setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtBirthdate setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOccupation setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOfficeAddress setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.txtOfficeNo setBorderStyle:readOnly ? UITextBorderStyleNone : UITextBorderStyleRoundedRect];
	[self.lblGender setText: [self.segGender titleForSegmentAtIndex:self.segGender.selectedSegmentIndex]];
	[self.segGender setHidden:readOnly ? YES: NO];
	[self.lblGender setHidden:readOnly ? NO : YES];
	
}

- (void) resignFirstResponders
{
	[txtLastname resignFirstResponder];
	[txtFirstname resignFirstResponder];
	[txtMiddlename resignFirstResponder];
	[txtBirthdate resignFirstResponder];
	[txtOccupation resignFirstResponder];
	[txtOfficeAddress resignFirstResponder];
	[txtOfficeNo resignFirstResponder];
}


#pragma mark -
#pragma mark dealloc

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setImgTemplate:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[txtLastname release];
	[txtFirstname release];
	[txtMiddlename release];
	[txtBirthdate release];
	[segGender release];
	[lblGender release]; 
	[txtOccupation release]; 
	[txtOfficeNo release]; 
	[txtOfficeAddress release];
    [imgTemplate release];
    [_lbl_Overlay release];
    [super dealloc];
}

@end
