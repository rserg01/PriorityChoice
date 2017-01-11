//
//  RiskAttitudeViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalQuestionnaireViewController.h"

@interface RiskAttitudeViewController : UIViewController <ModalQuestionnaireControllerDelegate>  {
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Title;

@property (retain, nonatomic) IBOutlet UIButton *btn_InvestDrop;
@property (retain, nonatomic) IBOutlet UIButton *btn_InterestValue;
@property (retain, nonatomic) IBOutlet UIButton *btn_Returns;
@property (retain, nonatomic) IBOutlet UIButton *btn_Risk;
@property (retain, nonatomic) IBOutlet UIButton *btn_Review;
@property (retain, nonatomic) IBOutlet UIButton *btn_Overall;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Score;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ScoreInterpretation;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UIButton *btn_save;


- (IBAction)btnAction:(id)sender;
- (IBAction)saveInfo:(id)sender;

@end
