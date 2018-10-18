//
//  ForgotPasswordViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 7/18/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UITextField *txtAgentCode;
@property (retain, nonatomic) IBOutlet UITextField *txtBirthdate;
@property (retain, nonatomic) IBOutlet UITextField *txtTin;
@property (retain, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtNewPassword2;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UIButton *btnSubmit;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *navBtn;


- (IBAction)submit:(id)sender;
- (IBAction)closeModal:(id)sender;

@end
