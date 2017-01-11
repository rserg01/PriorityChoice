//
//  FinCalc.h
//  PriorityCh_test4
//
//  Created by Manulife on 8/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinCalcErrorListViewController.h"
#import "ModalActiveProfileViewController.h"


@interface FinCalc : UIViewController <FinCalcErrorListViewControllerDelegate, ModalActiveProfileControllerDelegate> {
    
}

@property (retain, nonatomic) IBOutlet UIImageView *img_Template;

@property (retain, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) IBOutlet UITextField *txtBondFund;
@property (retain, nonatomic) IBOutlet UITextField *txtEquityFund;
@property (retain, nonatomic) IBOutlet UITextField *txtStableFund;
@property (retain, nonatomic) IBOutlet UITextField *txtApbf;
@property (retain, nonatomic) IBOutlet UITextField *txtBalanced;
@property (retain, nonatomic) IBOutlet UITextField *txtPremium;
@property (retain, nonatomic) IBOutlet UITextField *txtCurrentAge;

@property (retain, nonatomic) IBOutlet UISegmentedControl *switchCurrency;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switchGender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switchGrowthRate;
@property (retain, nonatomic) IBOutlet UISegmentedControl *switchDeathBenType;

@property (retain, nonatomic) IBOutlet UILabel *lbl_BondFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_EquityFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_StableFund;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Apbf;
@property (retain, nonatomic) IBOutlet UILabel *lbl_BalancedFund;


@property (retain, nonatomic) IBOutlet UIButton *btn_Compute;

- (IBAction)compute:(id)sender;
- (IBAction)changeCurrency:(id)sender;


@end
