//
//  FNARealPropertyViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNARealPropertyViewController : UIViewController 
{

}
@property(nonatomic, retain) IBOutlet UILabel *lblPrimaryResidence;
@property(nonatomic, retain) IBOutlet UILabel *lblVacationHomes;
@property(nonatomic, retain) IBOutlet UILabel *lblRentalProperty;
@property(nonatomic, retain) IBOutlet UILabel *lblLand;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UITextField *txtPrimaryResidence;
@property (retain, nonatomic) IBOutlet UITextField *txtVacationHomes;
@property (retain, nonatomic) IBOutlet UITextField *txtRentalProperty;
@property (retain, nonatomic) IBOutlet UITextField *txtLand;


- (IBAction)textFieldDidEndEditing:(id)sender;

@end
