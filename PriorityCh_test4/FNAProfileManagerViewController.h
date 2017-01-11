//
//  FNAProfileManagerViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNAProfileManagerViewController : UIViewController <UITableViewDelegate> 
{

}
@property(nonatomic, retain) IBOutlet UITableView *tblProfile;
@property(nonatomic, retain) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

//Summary

@property (retain, nonatomic) IBOutlet UILabel *lblBirthdate;
@property (retain, nonatomic) IBOutlet UILabel *lblLandline;
@property (retain, nonatomic) IBOutlet UILabel *lblMobile;
@property (retain, nonatomic) IBOutlet UILabel *lblEmail;

@property (retain, nonatomic) IBOutlet UILabel *lblPersonalAssets;
@property (retain, nonatomic) IBOutlet UILabel *lblRealProperty;
@property (retain, nonatomic) IBOutlet UILabel *lblInsurancePolicies;
@property (retain, nonatomic) IBOutlet UILabel *lblBusinessInterests;

@end
