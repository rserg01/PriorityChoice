//
//  MainViewController.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/8/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate>{
    
}

@property (retain, nonatomic) IBOutlet UIView *viewActivation;
@property (retain, nonatomic) IBOutlet UIView *viewLogin;

@property (retain, nonatomic) IBOutlet UITextField *txtAgentCode;
@property (retain, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (retain, nonatomic) IBOutlet UITextField *txtTin;
@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (retain, nonatomic) IBOutlet UITextField *txtUsername_Login;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword_Login;

@property (retain, nonatomic) IBOutlet UIButton *btnActivate;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnPasswordRecovery;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;
@property (retain, nonatomic) IBOutlet UIButton *btnLogout;

@property (retain, nonatomic) IBOutlet UILabel *lbl_AgentCode;
@property (retain, nonatomic) IBOutlet UILabel *lbl_AgentName;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Expiration;
@property (retain, nonatomic) IBOutlet UILabel *lbl_LastSynch;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Version;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Instruction;

@property (retain, nonatomic) IBOutlet UIImageView *img_Id;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Revision;


- (IBAction)ActivateApp:(id)sender;
- (IBAction)Login:(id)sender;
- (IBAction)passwordRecovery:(id)sender;
- (IBAction)Logout:(id)sender;


@end
