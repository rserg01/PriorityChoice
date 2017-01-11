    //
//  FNABusinessInterestsViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNABusinessInterestsViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	kTagSoleProprietosrship= 0,
	kTagPartnersip	= 1,
	kTagCorpoation	= 2
} kTag;

@interface FNABusinessInterestsViewController()
- (void) assignValuesToLabels;
- (void) updateSessionValues;
@end

@implementation FNABusinessInterestsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [GetPersonalProfile getTotalBusiness:[FNASession sharedSession].profileId];
    
    _lbl_Overlay.layer.cornerRadius = 8;
	
	self.navigationItem.title = @"Business Interests";
	self.navigationController.navigationBarHidden = NO;
	[self assignValuesToLabels];
    
    [_txtCorporation becomeFirstResponder];
}

#pragma mark -
#pragma mark Custom Methods

- (void) assignValuesToLabels {
    
    [_lblSoleProprietorship setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.2f", [[FNASession sharedSession].clientSoleProp doubleValue]] withCurrencySymbol:@"Php "]];
    [_lblPartnership setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.2f", [[FNASession sharedSession].clientPartnership doubleValue]] withCurrencySymbol:@"Php "]];
    [_lblCorporation setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%.2f", [[FNASession sharedSession].clientCorporation doubleValue]] withCurrencySymbol:@"Php "]];
}

- (void) updateSessionValues {
    
    [FNASession sharedSession].clientSoleProp = [NSNumber numberWithDouble:[_txtSoleProprietorship.text doubleValue]];
    [FNASession sharedSession].clientPartnership = [NSNumber numberWithDouble:[_txtPartnership.text doubleValue]];
    [FNASession sharedSession].clientCorporation = [NSNumber numberWithDouble:[_txtCorporation.text doubleValue]];
    
    NSError *error = [GetPersonalProfile UpdateBusiness:[FNASession sharedSession].profileId
                                               soleProp:[FNASession sharedSession].clientSoleProp
                                            partnership:[FNASession sharedSession].clientPartnership
                                            corporation:[FNASession sharedSession].clientCorporation];
    
    if (error)
	{
		[Utility showAlerViewWithTitle:@"Profile Manager"
						   withMessage:[error localizedDescription]
				 withCancelButtonTitle:@"Ok"
				  withOtherButtonTitle:nil
						   withSpinner:NO
						  withDelegate:nil];
	} else {
        
        [self assignValuesToLabels];
    }
}

- (IBAction) textFieldDidEndEditing:(id)sender
{
    if ([_txtCorporation.text length] > 0 || [_txtPartnership.text length] > 0 || [_txtSoleProprietorship.text length] > 0) {
       [self updateSessionValues]; 
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setTxtSoleProprietorship:nil];
    [self setTxtPartnership:nil];
    [self setTxtCorporation:nil];
    [self setLblSoleProprietorship:nil];
    [self setLblPartnership:nil];
    [self setLblCorporation:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
}


- (void)dealloc {
    [_txtSoleProprietorship release];
    [_txtPartnership release];
    [_txtCorporation release];
    [_lblSoleProprietorship release];
    [_lblPartnership release];
    [_lblCorporation release];
    [_lbl_Overlay release];
    [super dealloc];
}


@end
