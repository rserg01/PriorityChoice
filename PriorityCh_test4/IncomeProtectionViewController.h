//
//  IncomeProtectionViewController.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/18/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"

@interface IncomeProtectionViewController : UIViewController <UITextFieldDelegate, ModalActiveProfileControllerDelegate, ModalProfileControllerDelegate>  {
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imgTitle;
@property (retain, nonatomic) IBOutlet UIView *modalView;

@property (retain, nonatomic) IBOutlet UITextField *txtHousing;
@property (retain, nonatomic) IBOutlet UITextField *txtFood;
@property (retain, nonatomic) IBOutlet UITextField *txtUtilities;
@property (retain, nonatomic) IBOutlet UITextField *txtTransportation;
@property (retain, nonatomic) IBOutlet UITextField *txtEntertainment;
@property (retain, nonatomic) IBOutlet UITextField *txtClothing;
@property (retain, nonatomic) IBOutlet UITextField *txtSavings;
@property (retain, nonatomic) IBOutlet UITextField *txtEducation;
@property (retain, nonatomic) IBOutlet UITextField *txtContribution;
@property (retain, nonatomic) IBOutlet UITextField *txtHouseholdHelp;
@property (retain, nonatomic) IBOutlet UITextField *txtOthers;
@property (retain, nonatomic) IBOutlet UITextView *txtArea_Notes;

@property (retain, nonatomic) IBOutlet UISlider *sliderAnnualInterestRate;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segInsuranceMaintenance;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segAccidentProtection;

@property (retain, nonatomic) IBOutlet UITextField *txtBudget;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UILabel *lbl_InterestRate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalMonthlyExpense;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalAnnualExpense;
@property (retain, nonatomic) IBOutlet UILabel *lbl_CapitalRequired;
@property (retain, nonatomic) IBOutlet UILabel *lbl_InsurancePolicies;
@property (retain, nonatomic) IBOutlet UILabel *lbl_PersonalAssets;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ProtectionGoal;


@property (retain, nonatomic) IBOutlet UIButton *btnCalculate;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;
@property (retain, nonatomic) IBOutlet UIButton *btnSaveData;


@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;


- (void) gotoHome;
- (IBAction)sliderInterestRate:(id)sender;
- (IBAction)calculateData:(id)sender;
- (IBAction)viewProducts:(id)sender;
- (IBAction)saveData:(id)sender;


@end
