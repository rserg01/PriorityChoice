//
//  FinCalcMpViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinCalcErrorListViewController.h"
#import "ModalActiveProfileViewController.h"

#define kFundName_MP_BondFund @"Bond Fund"
#define kFundName_MP_EquityFund @"Equity Fund"
#define kFundName_MP_StableFund @"Stable Fund"
#define kFundName_MP_Apbf @"Asia Pacific Bond Fund"
#define kFundName_MP_Balanced @"Balanced Fund"
#define kFundName_MP_SecureFund @"Secure Fund"
#define kFundName_MP_GrowthFund @"Growth Fund"
#define kFundName_MP_Diversified @"Diversified Value Fund"
#define kFundName_MP_Dynamic @"Dynamic Alloc Fund"
#define kFundName_MP_ASEAN @"ASEAN Growth Fund"

@interface FinCalcMpViewController : UIViewController <FinCalcErrorListViewControllerDelegate, ModalActiveProfileControllerDelegate> {
}

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;
@property (retain, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) IBOutlet UISegmentedControl *switchCurrency;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switchDeathBenType;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switchGrowthRate;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switch_Gender;

@property (retain, nonatomic) IBOutlet UITextField *txtBondFUnd;
@property (retain, nonatomic) IBOutlet UITextField *txtEquityFund;
@property (retain, nonatomic) IBOutlet UITextField *txtStableFund;
@property (retain, nonatomic) IBOutlet UITextField *txtApbf;
@property (retain, nonatomic) IBOutlet UITextField *txtBalanced;
@property (retain, nonatomic) IBOutlet UITextField *txt_Premium;
@property (retain, nonatomic) IBOutlet UITextField *txt_CurrentAge;

@property (retain, nonatomic) IBOutlet UILabel *lbl_BondFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_EquityFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_StableFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Apbf;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Balanced;

@property (retain, nonatomic) IBOutlet UIButton *btnCompute;

@property (retain, nonatomic) IBOutlet UIImageView *img_Title;


- (IBAction)compute:(id)sender;
- (IBAction)changeCurrency:(id)sender;

@end
