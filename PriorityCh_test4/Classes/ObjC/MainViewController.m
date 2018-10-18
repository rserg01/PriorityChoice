//
//  MainViewController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/8/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "MainViewController.h"
#import "FnaConstants.h"
#import "MainSwitchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Activation.h"
#import "MainTabController.h"
#import "Utility.h"
#import "UIView+Glow.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"

@interface MainViewController ()

@property (nonatomic, retain) NSMutableArray *arrErrors;

@end

@implementation MainViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[Utility getUserDefaultsValue:@"LOCKOUT"] isEqualToString:@"YES"]) {
        
        [_txtUsername_Login setEnabled:FALSE];
        [_txtPassword_Login setEnabled:FALSE];
        [_btnLogin setEnabled:FALSE];
        
        [self sendErrorMessage:kLockoutNotice];
    }
    
    [self checkAppValidity];
    [self setLabels];
    [self disableMainMenu];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [_lbl_Revision setText:kRevision];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark - Custom Methods

- (void) setLabels
{
    NSString * appVersionString = [[NSBundle mainBundle]
                                   objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    [_lbl_Version setText:[NSString stringWithFormat:@"Priority Choice App Version %@", appVersionString]];
    
    [_lbl_Expiration setText:kExpirationDate_Formatted];
}

- (void) checkAppValidity
{
    if ([Activation checkExpiration: kExpirationDateString] == YES) {
        [self sendErrorMessage:kExpiredApp];
        [self disableMainMenu];
    }
    else {
        
        //TODO: add function to detect days before expiration
        
        
        if ([Activation cydiaCheck]) {
            [self sendErrorMessage:kErr_Jailbroken];
            [self disableMainMenu];
            [self switchViews:@""];
        }
        else {
            if ([self checkActivation]) {
                [self setIdentification];
                [self sendReminders];
                [self switchViews:@"Login"];
            }
            else {
                [self switchViews:@"Activation"];
                [self disableMainMenu];
            }
        }
    }
}

- (void) setIdentification
{
    [_lbl_Instruction setText:@"This App has been activated for"];
    [_img_Id setImage:[UIImage imageNamed:kImage_IdCard_Green]];
    
    NSMutableArray *arr = [Activation getAgentInfo];
    NSDictionary *dic = [arr objectAtIndex:0];
    
    [_lbl_AgentCode setText:[dic objectForKey:@"agentCode"]];
    [_lbl_AgentName setText:[dic objectForKey:@"agentFullName"]];
}

- (void) sendReminders
{
    //Reminders
    //20121015 - alertView to replace internetRecheable function call
    if (![self checkActivation]){
    [self sendErrorMessage:kReminder_InternetConnection];
    }
    
    //20130219 - AISO requirement
    [self sendErrorMessage:kReminder_Passcode];
}

- (void) switchViews: (NSString *) viewToShow
{
    CGRect show = CGRectMake(643, 124, 365, 217);
	CGRect hidden = CGRectMake(1025, 101, 365, 217);
    [_btnLogout setHidden:YES];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    
    if ([viewToShow isEqualToString:@"Login"]) {
        [_viewActivation setFrame:hidden];
        [_viewLogin setFrame:show];
    }
    else if ([viewToShow isEqualToString:@"Activation"]) {
        [_viewActivation setFrame:show];
        [_viewLogin setFrame:hidden];
    }
    else {
        [_viewActivation setFrame:hidden];
        [_viewLogin setFrame:hidden];
        [_btnLogout setHidden:NO];
    }
		
	[UIView commitAnimations];
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

- (void) enableMainMenu
{
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    [tabBarItem setEnabled:YES];
}

- (void) disableMainMenu
{
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    [tabBarItem setEnabled:NO];
    
}

- (BOOL) checkActivation
{
    NSString *strUsername = [Utility getUserDefaultsValue:@"USERNAME"];
    return [strUsername length] > 0 ? YES : NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Format Date of Birth YYYY-MM-DD
    if(textField == _txtBirthDate)
    {
        if ((textField.text.length == 5)||(textField.text.length == 2))
            //Handle backspace being pressed
            if (![string isEqualToString:@""])
                textField.text = [textField.text stringByAppendingString:@"/"];
        return !([textField.text length]>9 && [string length] > range.length);
    }
    else if(textField == _txtTin)
    {
        if ((textField.text.length == 3)||(textField.text.length == 7))
            //Handle backspace being pressed
            if (![string isEqualToString:@""])
                textField.text = [textField.text stringByAppendingString:@"-"];
        return !([textField.text length]>10 && [string length] > range.length);
    }
    else
    {
        return YES;
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([_txtAgentCode isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_AgentCode];
    }
    if ([_txtBirthDate isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_Birthdat];
    }
    if ([_txtUsername isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_Username];
    }
    if ([_txtPassword isEqual:textField]) {
        [self sendErrorMessage:kActivationReminder_Password];
    }

    return YES;
}

#pragma mark - Modal

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [FNASession sharedSession].activationErrors = _arrErrors;
}

#pragma mark - IBActions

- (IBAction)ActivateApp:(id)sender
{
    [_txtAgentCode resignFirstResponder];
    [_txtBirthDate resignFirstResponder];
    [_txtTin resignFirstResponder];
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    
    NSString *error = [[[NSString alloc]init]autorelease];
    
    //TODO: Stub data for activation
    
    
    
    _txtAgentCode.text = @"GST001";
    _txtBirthDate.text = @"08/08/1988";
    _txtTin.text = @"111-111-111";
    _txtUsername.text = @"username";
    _txtPassword.text = @"Manulife01";
    _txtConfirmPassword.text = @"Manulife01";
     
    
    
    [self validateActivationFields];
    
    if ([_arrErrors count] == 0){
        

    
        
        error = [Activation activateApp:[_txtAgentCode text]
                              birthDate:[_txtBirthDate text]
                                    tin:[_txtTin text]
                               username:[_txtUsername text]
                               password:[_txtPassword text]];
        
        NSMutableString *s = [NSMutableString stringWithString:error];
        
        NSRange a = [s rangeOfString:@"agentname"];
        
        if (a.location == NSNotFound)  {
            
            [self sendErrorMessage:kActivationFailed];
            
        } else {
            
            if ([error length] > 33) {
                
                NSError *result =  [Activation saveAgentInfo:error
                                                    username:[_txtUsername text]
                                                    password:[_txtPassword text]
                                                   agentCode:[_txtAgentCode text]
                                                         tin:[_txtTin text]
                                                   birthdate:[_txtBirthDate text]];
                
                if (result) {
                    
                    [self sendErrorMessage:[result localizedDescription]];
                }
                else {
                    
                    [_txtAgentCode setText:nil];
                    [_txtBirthDate setText:nil];
                    [_txtTin setText:nil];
                    [_txtUsername setText:nil];
                    [_txtPassword setText:nil];
                    [_txtConfirmPassword setText:nil];
                    [self setIdentification];
                    [self switchViews:@"Login"];
                    [self sendErrorMessage:kActivationSuccess];
                }
            }
            
            else {
                
                [self sendErrorMessage:kActivationFailed];
            }
        }
    }
    
    else {
        
        [self performSegueWithIdentifier:@"toActivationErrors" sender:self];
    }
    
}

- (IBAction)Login:(id)sender
{
    [_txtUsername_Login resignFirstResponder];
    [_txtPassword_Login resignFirstResponder];
    
    if ([self validateFields_Login]) {
        
        if ([Activation loginToApp:_txtUsername_Login.text
                          password:_txtPassword_Login.text]) {
            
            [self switchViews:@""];
            [self sendErrorMessage:kLoginSuccessful];
            [self enableMainMenu];
            [self.tabBarController setSelectedIndex:1];
            [self setAgentSession];
        }
        else {
            
            [self sendErrorMessage:kLoginFailed];
            
            [FNASession sharedSession].loginFailedCount = [self addLoginFailedCount];
            
            if ([[FNASession sharedSession].loginFailedCount isEqualToNumber:[NSNumber numberWithInt:3]]) {
                
                [self lockoutProcedure];
            }
        }
    }
    else {
        
        if ([_txtUsername_Login.text length] == 0) {
            [self sendErrorMessage:kNoUsername];
            [_txtUsername_Login startGlowing];
        }
        else {
            [_txtUsername_Login stopGlowing];
        }
        
        if ([_txtPassword_Login.text length]== 0) {
            [self sendErrorMessage:kNoPassword];
            [_txtPassword_Login startGlowing];
        }
        else {
            [_txtPassword_Login stopGlowing];
        }
        
    }
    
}

//TODO: Password recovery sequence
- (IBAction)passwordRecovery:(id)sender {
    
    [self performSegueWithIdentifier:@"toForgotPassword" sender:self];
}

- (IBAction)Logout:(id)sender {
    [self disableMainMenu];
    [_txtUsername_Login setText:nil];
    [_txtPassword_Login setText:nil];
    [self switchViews:@"Login"];
}


#pragma mark - Activation Custom Methods

- (void) validateActivationFields
{
    
    [_txtAgentCode stopGlowing];
    [_txtBirthDate stopGlowing];
    [_txtTin stopGlowing];
    [_txtUsername stopGlowing];
    [_txtPassword stopGlowing];
    [_txtConfirmPassword stopGlowing];
    
    NSMutableArray *errors = [[[NSMutableArray alloc]init]autorelease];
    
    if (![_txtAgentCode.text length] > 0) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoAgentCode, @"Error", nil]];
        [_txtAgentCode startGlowing];
    }
    if (![_txtBirthDate.text length] > 0) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoBirthdate, @"Error", nil]];
        [_txtBirthDate startGlowing];
    }
    if (![_txtTin.text length] > 0) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoTin, @"Error", nil]];
        [_txtTin startGlowing];
    }
    if (![_txtUsername.text length] > 0) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoUsername_Activation, @"Error", nil]];
        [_txtUsername startGlowing];
    }
    if ([_txtPassword.text length] < 6) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoPassword_Activation, @"Error", nil]];
        [_txtPassword startGlowing];
    }
    
    if ([_txtConfirmPassword.text length] < 5) {
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kNoConfirmPassword, @"Error", nil]];
        [_txtConfirmPassword startGlowing];
    }
    else if ([self confirmPassword]) {
        
        if (![Activation passwordValidation:_txtPassword.text]) {
            
            [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kPasswordComplexity, @"Error", nil]];
            [_txtPassword startGlowing];
        }
    }
    else {
        
        [errors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kConfirmPasswordDidNotMatch, @"Error", nil]];
        [_txtConfirmPassword startGlowing];
    }
    
    [self setArrErrors:errors];
}

- (BOOL) confirmPassword
{
    return [_txtPassword.text isEqualToString:_txtConfirmPassword.text] ? YES : NO;
}

#pragma mark - Login Custom Methods

- (BOOL) validateFields_Login
{
    BOOL retval = NO;
    
    if (([_txtUsername_Login.text length] > 0) &&
        ([_txtPassword_Login.text length] > 0)) {
        
        retval = YES;
    }
    
    return retval;
}

- (void) setAgentSession
{
    NSMutableArray *arrAgent = [Activation getAgentInfo];
    NSDictionary *dicAgent =[arrAgent objectAtIndex:0];
    
    [FNASession sharedSession].agentCode = [dicAgent objectForKey:@"agentCode"];
    [FNASession sharedSession].agentEmail = [dicAgent objectForKey:@"agentEmail"];
    [FNASession sharedSession].agentFullName = [dicAgent objectForKey:@"agentFullName"];
}

- (NSNumber *) addLoginFailedCount
{
    NSNumber *var1 = [NSNumber numberWithInt:1];
    return [NSNumber numberWithInt:([[FNASession sharedSession].loginFailedCount intValue] + [var1 intValue])];
}

- (void) lockoutProcedure
{
    [_txtUsername_Login setEnabled:FALSE];
    [_txtPassword_Login setEnabled:FALSE];
    [_btnLogin setEnabled:FALSE];
    
    [Utility saveToUserDefaults:@"LOCKOUT" value:@"YES"];
    
    [self sendErrorMessage:kLockout];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtAgentCode release];
    [_txtBirthDate release];
    [_txtTin release];
    [_txtUsername release];
    [_txtPassword release];
    [_txtConfirmPassword release];
    [_txtUsername_Login release];
    [_txtPassword_Login release];
    [_btnActivate release];
    [_btnLogin release];
    [_btnPasswordRecovery release];
    [_lbl_Overlay release];
    [_viewActivation release];
    [_viewLogin release];
    [_lbl_AgentCode release];
    [_lbl_AgentName release];
    [_lbl_Expiration release];
    [_lbl_LastSynch release];
    [_lbl_Version release];
    [_img_Id release];
    [_lbl_Instruction release];
    [_btnLogout release];
    [_arrErrors release];
    [_lbl_Revision release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTxtAgentCode:nil];
    [self setTxtBirthDate:nil];
    [self setTxtTin:nil];
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
    [self setTxtUsername_Login:nil];
    [self setTxtPassword_Login:nil];
    [self setBtnActivate:nil];
    [self setBtnLogin:nil];
    [self setBtnPasswordRecovery:nil];
    [self setLbl_Overlay:nil];
    [self setViewActivation:nil];
    [self setViewLogin:nil];
    [self setLbl_AgentCode:nil];
    [self setLbl_AgentName:nil];
    [self setLbl_Expiration:nil];
    [self setLbl_LastSynch:nil];
    [self setLbl_Version:nil];
    [self setImg_Id:nil];
    [self setLbl_Instruction:nil];
    [self setBtnLogout:nil];
    [self setArrErrors:nil];
    [self setLbl_Revision:nil];
    [super viewDidUnload];
}

@end
