//
//  MainSwitchViewController.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSwitchViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UINavigationBar *nav;

@property (retain, nonatomic) IBOutlet UIButton *btnProfileManager;
@property (retain, nonatomic) IBOutlet UIButton *btnPriorityCompass;
@property (retain, nonatomic) IBOutlet UIButton *btnPriorityRanking;
@property (retain, nonatomic) IBOutlet UIButton *btnProducts;
@property (retain, nonatomic) IBOutlet UIButton *btnAboutManulife;
@property (retain, nonatomic) IBOutlet UIButton *btnManucare;
@property (retain, nonatomic) IBOutlet UIButton *btn_FinCalc;
@property (retain, nonatomic) IBOutlet UIButton *btnSync;

@property (retain, nonatomic) IBOutlet UIView *viewPopup;

- (IBAction)gotoProducts:(id)sender;
- (IBAction)gotoCompass:(id)sender;
- (IBAction)gotoRankings:(id)sender;
- (IBAction)gotoProfileManager:(id)sender;
- (IBAction)gotoManucare:(id)sender;
- (IBAction)gotoFinCalc:(id)sender;
- (IBAction)gotoAbout:(id)sender;



@end
