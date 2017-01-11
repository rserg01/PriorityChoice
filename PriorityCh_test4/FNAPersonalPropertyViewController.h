//
//  FNAPersonalPropertyViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNAPersonalPropertyViewController : UIViewController 
{

}

@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;

@property (retain, nonatomic) IBOutlet UITextField *txtSavings;
@property (retain, nonatomic) IBOutlet UITextField *txtCurrentAccount;
@property (retain, nonatomic) IBOutlet UITextField *txtStocks;
@property (retain, nonatomic) IBOutlet UITextField *txtBonds;
@property (retain, nonatomic) IBOutlet UITextField *txtMutualBonds;
@property (retain, nonatomic) IBOutlet UITextField *txtCollectibles;

@property (retain, nonatomic) IBOutlet UILabel *lblSavings;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrent;
@property (retain, nonatomic) IBOutlet UILabel *lblStocks;
@property (retain, nonatomic) IBOutlet UILabel *lblBonds;
@property (retain, nonatomic) IBOutlet UILabel *lblMutualBonds;
@property (retain, nonatomic) IBOutlet UILabel *lblCollectibles;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;


- (IBAction)txtFieldDidEndEditing:(id)sender;



@end
