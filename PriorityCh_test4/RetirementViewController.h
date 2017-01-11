//
//  RetirementViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/5/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalProfileViewController.h"
#import "ModalActiveProfileViewController.h"

@interface RetirementViewController : UIViewController <UITextFieldDelegate, ModalActiveProfileControllerDelegate, ModalProfileControllerDelegate> {
}

@property (retain, nonatomic) IBOutlet UILabel *lblCurrentAge;
@property (retain, nonatomic) IBOutlet UILabel *lblRetirementAge;
@property (retain, nonatomic) IBOutlet UILabel *lblYearsToRetirement;
@property (retain, nonatomic) IBOutlet UILabel *lblInflationFactor;
@property (retain, nonatomic) IBOutlet UILabel *lblRateOfReturn;
@property (retain, nonatomic) IBOutlet UILabel *lblServiceYears;
@property (retain, nonatomic) IBOutlet UILabel *lblAnnualIncrease;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;
@property (retain, nonatomic) IBOutlet UILabel *lbl_DesiredAnnualIncome;
@property (retain, nonatomic) IBOutlet UILabel *lbl_DesiredAnnualIncomeAtRetirement;
@property (retain, nonatomic) IBOutlet UILabel *lbl_CapitalRequired;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ExpectedRetirementBenefit;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RetirementGap;


@property (retain, nonatomic) IBOutlet UISlider *slide_RetirementAge;
@property (retain, nonatomic) IBOutlet UISlider *slider_InflationFactor;
@property (retain, nonatomic) IBOutlet UISlider *slide_RateOfReturn;
@property (retain, nonatomic) IBOutlet UISlider *slide_ServiceYears;
@property (retain, nonatomic) IBOutlet UISlider *slide_AnnualIncrease;


@property (retain, nonatomic) IBOutlet UITextField *txtMonthlyIncome;
@property (retain, nonatomic) IBOutlet UITextField *txtCurrentMonthlyEarnings;
@property (retain, nonatomic) IBOutlet UITextView *txtRetirementPlan;
@property (retain, nonatomic) IBOutlet UITextField *txtBudget;


@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_RetirementBenefitFactor;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_InsuranceMaintenance;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_Disability;

@property (retain, nonatomic) IBOutlet UIButton *btnSave;
@property (retain, nonatomic) IBOutlet UIButton *btnCalculate;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;


@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;

- (IBAction)calculateRetirement:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)sliderChanged_RetirementAge:(id)sender;
- (IBAction)sliderChanged_InflationFactor:(id)sender;
- (IBAction)sliderChanged_RateOfReturn:(id)sender;
- (IBAction)sliderChanged_ServiceYears:(id)sender;
- (IBAction)sliderChanged_AnnualIncrease:(id)sender;
- (IBAction)segChanged_Retirementfactor:(id)sender;
- (IBAction)segChanged_InsuranceMaintenance:(id)sender;
- (IBAction)segChanged_Disability:(id)sender;

- (IBAction)textFieldChanged:(id)sender;
- (IBAction)viewProducts:(id)sender;



@end
