//
//  RiskCapacityViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalQuestionnaireViewController.h"

@interface RiskCapacityViewController : UIViewController <ModalQuestionnaireControllerDelegate> {
    
}

@property (retain, nonatomic) IBOutlet UIButton *btn_TimeFrame;
@property (retain, nonatomic) IBOutlet UIButton *btnNeedForInvestment;
@property (retain, nonatomic) IBOutlet UIButton *btn_CashFlow;
@property (retain, nonatomic) IBOutlet UIButton *btn_Retirement;


@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Title;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RiskCapacityScore;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ScoreInterpretation;
@property (retain, nonatomic) IBOutlet UILabel *lbl_AgeScore;


@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIButton *btnSave;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;


- (IBAction)btnAction:(id)sender;
- (IBAction)saveManucare:(id)sender;

@end
