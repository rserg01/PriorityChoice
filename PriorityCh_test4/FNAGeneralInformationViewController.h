//
//  FNAGeneralInformationViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNAGeneralInformationViewController : UIViewController 
{
}

@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;
@property(nonatomic, retain) IBOutlet UITextField *txtLastname;
@property(nonatomic, retain) IBOutlet UITextField *txtFirstname;
@property(nonatomic, retain) IBOutlet UITextField *txtMiddlename;
@property(nonatomic, retain) IBOutlet UITextField *txtBirthdate;
@property(nonatomic, retain) IBOutlet UITextField *txtAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtAddress2;
@property (retain, nonatomic) IBOutlet UITextField *txtAddress3;


@property(nonatomic, retain) IBOutlet UITextField *txtOccupation;
@property(nonatomic, retain) IBOutlet UITextField *txtOfficeAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtOfcAddress2;
@property (retain, nonatomic) IBOutlet UITextField *txtOfcAddress3;

@property(nonatomic, retain) IBOutlet UITextField *txtLandline;
@property(nonatomic, retain) IBOutlet UITextField *txtMobileNo;
@property(nonatomic, retain) IBOutlet UITextField *txtOfficeNo;
@property(nonatomic, retain) IBOutlet UITextField *txtEmail;
@property(nonatomic, retain) IBOutlet UISlider *sdrRetirementAge;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segGender;
@property(nonatomic, retain) IBOutlet UILabel *lblGender;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@end

