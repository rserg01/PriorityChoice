//
//  ManucareViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalManuCareActiveProfileController.h"
#import "ModalManucareNewProfileController.h"

@interface ManucareViewController : UIViewController <ModalManuCareActiveProfileControllerDelegate, ModalManucareNewProfileControllerDelegate> {
    
}

@property (retain, nonatomic) IBOutlet UILabel *lblWriteUp;
@property (retain, nonatomic) IBOutlet UILabel *lblBg;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay_RiskCapacity;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay_RiskAttitude;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RiskCapacity_WriteUp;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RiskAttitude_WriteUp;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;


- (IBAction)gotoHome:(id)sender;
- (IBAction)gotoFunds:(id)sender;

@end
