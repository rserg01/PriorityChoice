//
//  EducationViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 9/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalActiveProfileViewController.h"
#import "ModalProfileViewController.h"
#import "ModalPersonalAssetsViewController.h"
#import "DependentViewController.h"

@interface EducationViewController : UIViewController <UITextFieldDelegate, ModalActiveProfileControllerDelegate, ModalProfileControllerDelegate, DependentViewControllerDelegate, ModalPersonalAssetsControllerDelegate>  {
}


@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UITextField *txtPresentAnnualCost;
@property (retain, nonatomic) IBOutlet UITextField *txtCurrentEducationalPlan;
@property (retain, nonatomic) IBOutlet UITextField *txtPersonalAssetAllocated;
@property (retain, nonatomic) IBOutlet UITextField *txtYearOfEntry;
@property (retain, nonatomic) IBOutlet UITextField *txtBudget;
@property (retain, nonatomic) IBOutlet UITextView *txt_Notes;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segInsuranceMaintenance;

@property (retain, nonatomic) IBOutlet UIButton *btn_Calculate;
@property (retain, nonatomic) IBOutlet UIButton *btn_Save;
@property (retain, nonatomic) IBOutlet UIButton *btn_UpdateAssets;
@property (retain, nonatomic) IBOutlet UIButton *btn_viewProducts;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UILabel *lblCurrentSavings;
@property (retain, nonatomic) IBOutlet UILabel *lbl_FutureCost;
@property (retain, nonatomic) IBOutlet UILabel *lbl_SavingsGoal;
@property (retain, nonatomic) IBOutlet UILabel *lbl_DependentName;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TotalPersonalAsset;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;

- (IBAction)compute:(id)sender;
- (IBAction)saveInfo:(id)sender;
- (IBAction)viewProducts:(id)sender;
- (IBAction)updateAssets:(id)sender;

@end
