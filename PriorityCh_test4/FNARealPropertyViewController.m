//
//  FNARealPropertyViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNARealPropertyViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>


typedef enum
{
	kTagPrimaryResidence= 0,
	kTagVacationHomes	= 1,
	kTagRentalProperty	= 2,
	kTagLand			= 3
} kTag;

@interface FNARealPropertyViewController()
- (void) assignValuesToLabels;
- (void) updateSessionValues;

@end


@implementation FNARealPropertyViewController
@synthesize imgTemplate;
@synthesize lblPrimaryResidence, lblVacationHomes, lblRentalProperty, lblLand;
@synthesize txtLand, txtPrimaryResidence, txtRentalProperty, txtVacationHomes;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
	self.navigationItem.title = @"Real Property";
	self.navigationController.navigationBarHidden = NO;
	[self assignValuesToLabels];
    
    [txtPrimaryResidence becomeFirstResponder];
}

#pragma mark - Custom Methods

- (void) sendErrorMessage: (NSString *)errorMessage
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release]; // if you are not using ARC
}

- (void) assignValuesToLabels {
    
    [lblPrimaryResidence setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientPrimaryResidence] withCurrencySymbol:@"Php "]];
    [lblVacationHomes setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientVacationresidence] withCurrencySymbol:@"Php "]];
    [lblRentalProperty setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientRentalProperty] withCurrencySymbol:@"Php "]];
    [lblLand setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientLand] withCurrencySymbol:@"Php "]];
}

- (void) updateSessionValues {
    
     [FNASession sharedSession].clientPrimaryResidence = [txtPrimaryResidence.text length] == 0 ? [FNASession sharedSession].clientPrimaryResidence : [NSNumber numberWithDouble:[txtPrimaryResidence.text doubleValue]];
    [FNASession sharedSession].clientVacationresidence = [txtVacationHomes.text length] == 0 ? [FNASession sharedSession].clientVacationresidence : [NSNumber numberWithDouble:[txtVacationHomes.text doubleValue]];
    [FNASession sharedSession].clientRentalProperty = [txtRentalProperty.text length] == 0 ? [FNASession sharedSession].clientRentalProperty : [NSNumber numberWithDouble:[txtRentalProperty.text doubleValue]];
    [FNASession sharedSession].clientLand = [txtLand.text length] == 0 ? [FNASession sharedSession].clientLand : [NSNumber numberWithDouble:[txtLand.text doubleValue]];
    
}

- (IBAction) textFieldDidEndEditing:(id)sender
{
    [self updateSessionValues];
    
    NSError *error = [GetPersonalProfile UpdateRealProperty:[FNASession sharedSession].profileId
                                           primaryresidence:[FNASession sharedSession].clientPrimaryResidence
                                          vacationresidence:[FNASession sharedSession].clientVacationresidence
                                             rentalproperty:[FNASession sharedSession].clientRentalProperty
                                                       land:[FNASession sharedSession].clientLand];
    
    if (error)
	{
		[self sendErrorMessage:[error localizedDescription]];
	}
    
    [self assignValuesToLabels];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setImgTemplate:nil];
    [self setTxtPrimaryResidence:nil];
    [self setTxtVacationHomes:nil];
    [self setTxtRentalProperty:nil];
    [self setTxtLand:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[lblPrimaryResidence release];
    [lblVacationHomes release];
    [lblRentalProperty release];
	[lblLand release];
    [imgTemplate release];
    [txtPrimaryResidence release];
    [txtVacationHomes release];
    [txtRentalProperty release];
    [txtLand release];
    [_lbl_Overlay release];
    [super dealloc];
}


@end
