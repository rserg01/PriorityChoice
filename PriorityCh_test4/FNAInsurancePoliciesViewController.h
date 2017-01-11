//
//  FNAInsurancePoliciesViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNAInsurancePoliciesViewController : UIViewController {

}

@property(nonatomic, retain) IBOutlet UILabel *lblLifeInsurance;
@property(nonatomic, retain) IBOutlet UILabel *lblHealthInsurance;
@property(nonatomic, retain) IBOutlet UILabel *lblDisabilityInsurance;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;

@property (retain, nonatomic) IBOutlet UITextField *txtLifeInsurance;
@property (retain, nonatomic) IBOutlet UITextField *txtHealthInsurance;
@property (retain, nonatomic) IBOutlet UITextField *txtDisability;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

- (IBAction)textFieldDidEndEditing:(id)sender;

@end
