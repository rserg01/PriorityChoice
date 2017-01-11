//
//  EstatePalnningViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/8/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalProfileViewController.h"
#import "ModalActiveProfileViewController.h"

@interface EstatePalnningViewController : UIViewController <ModalProfileControllerDelegate, ModalActiveProfileControllerDelegate> {
    
}

@property (retain, nonatomic) IBOutlet UITextField *txtFuneral;
@property (retain, nonatomic) IBOutlet UITextField *txtJudicial;
@property (retain, nonatomic) IBOutlet UITextField *txtEstateClaims;
@property (retain, nonatomic) IBOutlet UITextField *txtInsolvency;
@property (retain, nonatomic) IBOutlet UITextField *txtMortgages;
@property (retain, nonatomic) IBOutlet UITextField *txtMedicalExpence;
@property (retain, nonatomic) IBOutlet UITextField *txtRetirement;
@property (retain, nonatomic) IBOutlet UITextField *txtStandardDeduction;
@property (retain, nonatomic) IBOutlet UITextField *txtSpouse;
@property (retain, nonatomic) IBOutlet UITextField *txtBudget;
@property (retain, nonatomic) IBOutlet UITextView *notes;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalPersonalAsset;
@property (retain, nonatomic) IBOutlet UILabel *lbl_GrossEstate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_NetTaxableEstate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_EstateTaxDue;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalRealProperty;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalInsurance;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Business;
@property (retain, nonatomic) IBOutlet UILabel *lbl_AppliedTaxRate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Deductions;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Gap;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIButton *btnSave;
@property (retain, nonatomic) IBOutlet UIButton *btnCompute;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;

- (IBAction)updateLabels:(id)sender;
- (IBAction)saveInfo:(id)sender;
- (IBAction)viewProducts:(id)sender;


@end
