//
//  ModalPersonalAssetsViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/19/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalPersonalAssetsControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;
-(void)saveUpdates;

@end

__unsafe_unretained id <ModalPersonalAssetsControllerDelegate> _delegate2;

@interface ModalPersonalAssetsViewController : UIViewController {
    
}

@property (nonatomic, assign) id <ModalPersonalAssetsControllerDelegate> delegate2;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UITextField *txt_SavingsAccount;
@property (retain, nonatomic) IBOutlet UITextField *txt_CurrentAccount;
@property (retain, nonatomic) IBOutlet UITextField *txt_Stocks;
@property (retain, nonatomic) IBOutlet UITextField *txt_Bonds;
@property (retain, nonatomic) IBOutlet UITextField *txt_MutualBonds;
@property (retain, nonatomic) IBOutlet UITextField *txt_Collectibles;

@property (retain, nonatomic) IBOutlet UINavigationItem *navBar;

@end
