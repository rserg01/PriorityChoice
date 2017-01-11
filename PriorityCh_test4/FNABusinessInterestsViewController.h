//
//  FNABusinessInterestsViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNABusinessInterestsViewController : UIViewController {

}

@property(nonatomic, retain) IBOutlet UILabel *lblSoleProprietorship;
@property(nonatomic, retain) IBOutlet UILabel *lblPartnership;
@property(nonatomic, retain) IBOutlet UILabel *lblCorporation;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UITextField *txtSoleProprietorship;
@property (retain, nonatomic) IBOutlet UITextField *txtPartnership;
@property (retain, nonatomic) IBOutlet UITextField *txtCorporation;

- (IBAction)textFieldDidEndEditing:(id)sender;

@end
