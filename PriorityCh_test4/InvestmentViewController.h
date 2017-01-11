//
//  InvestmentViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalProfileViewController.h"
#import "ModalActiveProfileViewController.h"
#import "ModalPersonalAssetsViewController.h"

@interface InvestmentViewController : UIViewController <UITextFieldDelegate, ModalProfileControllerDelegate, ModalActiveProfileControllerDelegate, ModalPersonalAssetsControllerDelegate> {
    
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmergencyFund;
@property (retain, nonatomic) IBOutlet UITextField *txtRetirement;
@property (retain, nonatomic) IBOutlet UITextField *txtNewHome;
@property (retain, nonatomic) IBOutlet UITextField *txtNewCar;
@property (retain, nonatomic) IBOutlet UITextField *txtHoliday;
@property (retain, nonatomic) IBOutlet UITextField *txtBusiness;
@property (retain, nonatomic) IBOutlet UITextField *txtLegacy;
@property (retain, nonatomic) IBOutlet UITextField *txtEstateTax;
@property (retain, nonatomic) IBOutlet UITextField *txtBudget;
@property (retain, nonatomic) IBOutlet UITextField *txtOtherInvestments;

@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalCostOfSavingsPlan;
@property (retain, nonatomic) IBOutlet UILabel *lbl_CurrentAmtOfInvestments;
@property (retain, nonatomic) IBOutlet UILabel *lbl_InvestmentRequired;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ProtectionGoal;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TimeFrame;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalInvestments;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RiskCapacityScore;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RiskAttitudeScore;


@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;

@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_Investment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_PersonCategory;

@property (retain, nonatomic) IBOutlet UISlider *slide_TimeFrame;

@property (retain, nonatomic) IBOutlet UIButton *btnManucareTool;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;
@property (retain, nonatomic) IBOutlet UIButton *btnCalculate;
@property (retain, nonatomic) IBOutlet UIButton *btnUpdateAssets;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;


- (IBAction)gotoManuCareTool:(id)sender;
- (IBAction)saveInvestment:(id)sender;
- (IBAction)calculate:(id)sender;
- (IBAction)updateAssets:(id)sender;
- (IBAction)viewProducts:(id)sender;
- (IBAction)updateTimeFrame:(id)sender;


@end
