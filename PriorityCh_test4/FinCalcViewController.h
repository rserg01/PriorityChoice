//
//  FinCalcViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinCalcViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay_AffGold;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay_AffGoldMax;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay_Wealth;

@property (retain, nonatomic) IBOutlet UIButton *btn_AffGold;
@property (retain, nonatomic) IBOutlet UIButton *btn_AffGoldMax;
@property (retain, nonatomic) IBOutlet UIButton *btn_Wealth;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btn_Home;


- (IBAction)affGoldAction:(id)sender;
- (IBAction)affGoldMaxAction:(id)sender;
- (IBAction)gotoHome:(id)sender;


@end
