//
//  ForgotPasswordViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 7/18/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "Activation.h"
#import "FnaConstants.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lbl_Overlay.layer.cornerRadius = 8;
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

#pragma mark - Validations

- (NSString *) validateTextFields: (id)sender
{
    NSString *errorMessage = [[[NSString alloc]init]autorelease];
    
    if([sender isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField *)sender;
        
        if ([textField isEqual:self.txtAgentCode]) {
            
            errorMessage = [_txtAgentCode.text length] > 0 ? @"" : kNoAgentCode;
        }
        
        if ([textField isEqual:_txtBirthdate]) {
            
            errorMessage = [_txtBirthdate.text length] > 0 ? @"" : kNoBirthdate;
        }
        
        if ([textField isEqual:_txtTin]) {
            
            errorMessage = [_txtTin.text length] > 0 ? @"" : kNoTin;
        }
        
        if ([textField isEqual:_txtNewPassword]) {
            
            if ([_txtNewPassword.text length] > 0) {
                
                if ([Activation passwordValidation:[_txtNewPassword text]]) {
                    
                    if ([_txtNewPassword.text isEqualToString:[_txtNewPassword2 text]]) {
                        
                        errorMessage = @"";
                    }
                    else {
                        
                        errorMessage = kConfirmPasswordDidNotMatch;
                    }
                    
                }
                else {
                    
                    errorMessage = kPasswordComplexity;
                }
            }
            else {
                
                errorMessage = kNoPassword_Activation;
            }
        }
    }
    
    
    return errorMessage;
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

- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *validate_AgentCode = [[[NSString alloc]init]autorelease];
    NSString *validate_Birthdate = [[[NSString alloc]init]autorelease];
    NSString *validate_Tin = [[[NSString alloc]init]autorelease];
    NSString *validate_Password = [[[NSString alloc]init]autorelease];
   
    validate_AgentCode = [self validateTextFields:_txtAgentCode];
    validate_Birthdate = [self validateTextFields:_txtBirthdate];
    validate_Tin = [self validateTextFields:_txtTin];
    validate_Password = [self validateTextFields:_txtNewPassword];
    
    NSString *err = [[[NSString alloc]init]autorelease];
    
    NSMutableArray *arrValidationError = [[[NSMutableArray alloc]init]autorelease];
    
    if (![validate_AgentCode isEqualToString:@""]) {
        [arrValidationError addObject:[NSDictionary dictionaryWithObjectsAndKeys:validate_AgentCode, @"Error", nil]];
    }
    
    if (![validate_Birthdate isEqualToString:@""]) {
    [arrValidationError addObject:[NSDictionary dictionaryWithObjectsAndKeys:validate_Birthdate, @"Error", nil]];
    }
    
    if (![validate_Password isEqualToString:@""]) {
    [arrValidationError addObject:[NSDictionary dictionaryWithObjectsAndKeys:validate_Password, @"Error", nil]];
    }
    
    if (![validate_Tin isEqualToString:@""]) {
    [arrValidationError addObject:[NSDictionary dictionaryWithObjectsAndKeys:validate_Tin, @"Error", nil]];
    }
    
    if ([arrValidationError count] == 0)
    {
        err = [Activation activateApp:[_txtAgentCode text]
                            birthDate:[_txtBirthdate text]
                                  tin:[_txtTin text]
                             username:[Utility getUserDefaultsValue:@"USERNAME"]
                             password:[_txtNewPassword2 text]];
        
        NSMutableString *s = [NSMutableString stringWithString:err];
        
        NSRange a = [s rangeOfString:@"agentname"];
        
        if (a.location == NSNotFound)  {
            
            [self sendErrorMessage:kPasswordChangeFailed];
            
        } else {
            
            if ([err length] > 33) {
                
                NSError *result =  [[[NSError alloc]init]autorelease];
                result = [Activation saveNewPassword:[_txtNewPassword2 text]];
                
                if (result) {
                    
                    [self sendErrorMessage:[result localizedDescription]];
                }
                else {
                    
                    [_txtAgentCode setText:nil];
                    [_txtBirthdate setText:nil];
                    [_txtTin setText:nil];
                    [_txtNewPassword setText:nil];
                    [_txtNewPassword2 setText:nil];
                    [self sendErrorMessage:kPasswordChangeSuccess];
                }
                
                [result release];
            }
            
            else {
                
                [self sendErrorMessage:kPasswordChangeFailed];
            }
        }
    }
    else {
        
        NSDictionary *dic = [[[NSDictionary alloc]init]autorelease];
        dic = [arrValidationError objectAtIndex:0];
        
        [self sendErrorMessage:[dic objectForKey:@"Error"]];
    }
    
    
}

- (IBAction)closeModal:(id)sender {
    
    [self setTxtAgentCode:nil];
    [self setTxtBirthdate:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtAgentCode release];
    [_txtBirthdate release];
    [_txtTin release];
    [_txtNewPassword release];
    [_txtNewPassword2 release];
    [_btnSubmit release];
    [_lbl_Overlay release];
    [_navBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtAgentCode:nil];
    [self setTxtBirthdate:nil];
    [self setTxtTin:nil];
    [self setTxtNewPassword:nil];
    [self setTxtNewPassword2:nil];
    [self setBtnSubmit:nil];
    [self setLbl_Overlay:nil];
    [self setNavBtn:nil];
    [super viewDidUnload];
}



@end
