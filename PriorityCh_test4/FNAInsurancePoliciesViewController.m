    //
//  FNAInsurancePoliciesViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAInsurancePoliciesViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	kTagLifeInsurance		= 0,
	kTagHealthInsurance		= 1,
	kTagDisabilityInsurance	= 2
} kTag;

@interface FNAInsurancePoliciesViewController()
- (void) assignValuesToLabels;
- (void) updateSessionValues;
@end

@implementation FNAInsurancePoliciesViewController
@synthesize imgTemplate;
@synthesize lblLifeInsurance, lblHealthInsurance, lblDisabilityInsurance;
@synthesize txtDisability, txtHealthInsurance, txtLifeInsurance;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    _lbl_Overlay.layer.cornerRadius = 8;
    
	self.navigationItem.title = @"Insurance Policies";
	self.navigationController.navigationBarHidden = NO;
	
	[self assignValuesToLabels];
    
    [txtLifeInsurance becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    UIImage *mcblTemplate = [UIImage imageNamed: @"LifeCompass5_templateWithMcbl.png"];
    
    //change images per sales channel
    if ([strChannel isEqualToString:@"MCBL"])
    {
        [imgTemplate setImage:mcblTemplate];
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void) assignValuesToLabels {
    
    [lblLifeInsurance setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientLifeInsurance] withCurrencySymbol:@"Php "]];
    [lblHealthInsurance setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientHealthInsurance] withCurrencySymbol:@"Php "]];
    [lblDisabilityInsurance setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientDisabilityInsurance] withCurrencySymbol:@"Php "]];
}

- (void) updateSessionValues {
    
    [FNASession sharedSession].clientLifeInsurance = [txtLifeInsurance.text length] == 0 ? [FNASession sharedSession].clientLifeInsurance : [NSNumber numberWithDouble:[txtLifeInsurance.text doubleValue]];
    [FNASession sharedSession].clientHealthInsurance = [txtHealthInsurance.text length] == 0 ? [FNASession sharedSession].clientHealthInsurance : [NSNumber numberWithDouble:[txtHealthInsurance.text doubleValue]];
    [FNASession sharedSession].clientDisabilityInsurance = [txtDisability.text length] == 0 ? [FNASession sharedSession].clientDisabilityInsurance : [NSNumber numberWithDouble:[txtDisability.text doubleValue]];
    
}

- (IBAction) textFieldDidEndEditing:(id)sender
{
    [self updateSessionValues];
    
    NSError *error = [GetPersonalProfile UpdateInsurance:[FNASession sharedSession].profileId
                                           lifeInsurance:[FNASession sharedSession].clientLifeInsurance
                                         healthInsurance:[FNASession sharedSession].clientHealthInsurance
                                     disabilityInsurance:[FNASession sharedSession].clientDisabilityInsurance];
    
    if (error)
	{
		[Utility showAlerViewWithTitle:@"Profile Manager"
						   withMessage:[error localizedDescription]
				 withCancelButtonTitle:@"Ok"
				  withOtherButtonTitle:nil
						   withSpinner:NO
						  withDelegate:nil];
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
    [self setTxtLifeInsurance:nil];
    [self setTxtHealthInsurance:nil];
    [self setTxtDisability:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[lblLifeInsurance release]; 
	[lblHealthInsurance release];
	[lblDisabilityInsurance release];
    [imgTemplate release];
    [txtLifeInsurance release];
    [txtHealthInsurance release];
    [txtDisability release];
    [_lbl_Overlay release];
    [super dealloc];
}


@end
