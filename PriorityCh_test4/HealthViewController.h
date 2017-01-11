//
//  HealthViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"

@interface HealthViewController : UIViewController <UITextFieldDelegate, ModalActiveProfileControllerDelegate, ModalProfileControllerDelegate>  {
    
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmployeeCoverage;
@property (retain, nonatomic) IBOutlet UITextField *txtHealthProtection;
@property (retain, nonatomic) IBOutlet UITextField *txtSemiPrivate;
@property (retain, nonatomic) IBOutlet UITextField *txtSmallPrivate;
@property (retain, nonatomic) IBOutlet UITextField *txtPrivate;
@property (retain, nonatomic) IBOutlet UITextField *txtSuite;
@property (retain, nonatomic) IBOutlet UITextField *txtNursingExpenses;
@property (retain, nonatomic) IBOutlet UITextField *txtCriticallIllnessCoverage;
@property (retain, nonatomic) IBOutlet UITextView *txtArea_Notes;
@property (retain, nonatomic) IBOutlet UITextField *txtBudget;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segInclusionToHealthPlan;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segAccidentProtection;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segCriticalIllness;

@property (retain, nonatomic) IBOutlet UILabel *lbl_CurrentTotalBenefit;
@property (retain, nonatomic) IBOutlet UILabel *lbl_AdditionalBenefitsReq;
@property (retain, nonatomic) IBOutlet UILabel *lbl_CapitalRequired;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;


@property (retain, nonatomic) IBOutlet UIButton *btnCompute;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;


- (IBAction)computeHealth:(id)sender;
- (IBAction)saveHealth:(id)sender;
- (IBAction)viewProducts:(id)sender;



@end
