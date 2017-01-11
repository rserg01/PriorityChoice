    //
//  FNAPersonalPropertyViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAPersonalPropertyViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	kTagSavingsAccount	= 0,
	kTagCurrentAccount	= 1,
	kTagStocks			= 2,
	kTagBonds			= 3,
	kTagMutualBonds		= 4,
	kTagCollectibles	= 5
} kTag;

@interface FNAPersonalPropertyViewController()
- (void) assignValuesToLabels;
- (void) updateSessionValues;
@end


@implementation FNAPersonalPropertyViewController
@synthesize imgTemplate;
@synthesize txtSavings, txtBonds, txtCollectibles, txtCurrentAccount, txtMutualBonds, txtStocks;
@synthesize lblSavings, lblBonds, lblCollectibles, lblCurrent, lblMutualBonds, lblStocks;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title = @"Personal Property";
	self.navigationController.navigationBarHidden = NO;
    
    [GetPersonalProfile getTotalPersonalAssets:[FNASession sharedSession].profileId];
	[self assignValuesToLabels];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
    [txtSavings becomeFirstResponder];
}


#pragma mark - Custom Methods

-(void)assignValuesToLabels {
    
   [lblSavings setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientSavings] withCurrencySymbol:@"Php "]];
    [lblCurrent setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientCurrent] withCurrencySymbol:@"Php "]];
    [lblBonds setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientBonds] withCurrencySymbol:@"Php "]];
    [lblStocks setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientStocks] withCurrencySymbol:@"Php "]];
    [lblMutualBonds setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientMutual] withCurrencySymbol:@"Php "]];
    [lblCollectibles setText:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].clientCollectibles] withCurrencySymbol:@"Php "]];
}

- (void) updateSessionValues {
    
    [FNASession sharedSession].clientSavings = [txtSavings.text length] == 0 ? [FNASession sharedSession].clientSavings : [NSNumber numberWithDouble:[txtSavings.text doubleValue]];
    [FNASession sharedSession].clientCurrent = [txtCurrentAccount.text length] == 0 ? [FNASession sharedSession].clientCurrent : [NSNumber numberWithDouble:[txtCurrentAccount.text doubleValue]];
    [FNASession sharedSession].clientBonds = [txtBonds.text length] == 0 ? [FNASession sharedSession].clientBonds : [NSNumber numberWithDouble:[txtBonds.text doubleValue]];
    [FNASession sharedSession].clientMutual = [txtMutualBonds.text length] == 0 ? [FNASession sharedSession].clientMutual : [NSNumber numberWithDouble:[txtMutualBonds.text doubleValue]];
    [FNASession sharedSession].clientStocks = [txtStocks.text length] == 0 ? [FNASession sharedSession].clientStocks : [NSNumber numberWithDouble:[txtStocks.text doubleValue]];
    [FNASession sharedSession].clientCollectibles = [txtCollectibles.text length] == 0 ? [FNASession sharedSession].clientCollectibles : [NSNumber numberWithDouble:[txtCollectibles.text doubleValue]];

}

- (IBAction)txtFieldDidEndEditing:(id)sender {

    [self updateSessionValues];
    
    NSError *error = [GetPersonalProfile UpdatePersonalAssets:[FNASession sharedSession].profileId
                                                      savings:[FNASession sharedSession].clientSavings
                                                      current:[FNASession sharedSession].clientCurrent
                                                        bonds:[FNASession sharedSession].clientBonds
                                                       stocks:[FNASession sharedSession].clientStocks
                                                       mutual:[FNASession sharedSession].clientMutual
                                                 collectibles:[FNASession sharedSession].clientCollectibles];
    
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
    [self setTxtSavings:nil];
    [self setTxtCurrentAccount:nil];
    [self setTxtStocks:nil];
    [self setTxtBonds:nil];
    [self setTxtMutualBonds:nil];
    [self setTxtCollectibles:nil];
    [self setLblSavings:nil];
    [self setLblCurrent:nil];
    [self setLblStocks:nil];
    [self setLblBonds:nil];
    [self setLblMutualBonds:nil];
    [self setLblCollectibles:nil];
    [self setLbl_Overlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [imgTemplate release];
    [txtSavings release];
    [txtCurrentAccount release];
    [txtStocks release];
    [txtBonds release];
    [txtMutualBonds release];
    [txtCollectibles release];
    [lblSavings release];
    [lblCurrent release];
    [lblStocks release];
    [lblBonds release];
    [lblMutualBonds release];
    [lblCollectibles release];
    [_lbl_Overlay release];
    [super dealloc];
}


@end
