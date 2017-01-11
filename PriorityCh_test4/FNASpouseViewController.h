//
//  FNASpouseViewController.h
//  FNA
//
//  Created by Justin Limjap on 2/29/12.
//  Copyright 2012 iGen Dev Center, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNASpouseViewController : UIViewController 
{

}

@property(nonatomic, retain) IBOutlet UITextField *txtLastname;
@property(nonatomic, retain) IBOutlet UITextField *txtFirstname;
@property(nonatomic, retain) IBOutlet UITextField *txtMiddlename;
@property(nonatomic, retain) IBOutlet UITextField *txtBirthdate;
@property(nonatomic, retain) IBOutlet UILabel *lblGender;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segGender;
@property(nonatomic, retain) IBOutlet UITextField *txtOccupation;
@property(nonatomic, retain) IBOutlet UITextField *txtOfficeNo;
@property(nonatomic, retain) IBOutlet UITextField *txtOfficeAddress;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@end
