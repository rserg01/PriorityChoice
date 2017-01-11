//
//  FNAAddDependentViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FNAAddDependentViewControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <FNAAddDependentViewControllerDelegate> _delegate_AddDependent;


@interface FNAAddDependentViewController : UIViewController 
{

}

@property (nonatomic, assign) id <FNAAddDependentViewControllerDelegate> delegate_AddDependent;

@property(nonatomic, retain) IBOutlet UITextField *txtLastname;
@property(nonatomic, retain) IBOutlet UITextField *txtFirstname;
@property(nonatomic, retain) IBOutlet UITextField *txtMiddlename;
@property(nonatomic, retain) IBOutlet UITextField *txtBirthdate;
@property(nonatomic, retain) IBOutlet UITextField *txtRelationship;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;


@end
