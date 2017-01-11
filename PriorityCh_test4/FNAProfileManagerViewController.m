//
//  FNAProfileManagerViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAProfileManagerViewController.h"
#import "FNAGeneralInformationViewController.h"
#import "FNASpouseViewController.h"
#import "FNADependentsViewController.h"
#import "FNAAddDependentViewController.h"
#import "FNAPersonalPropertyViewController.h"
#import "FNARealPropertyViewController.h"
#import "FNAInsurancePoliciesViewController.h"
#import "FNABusinessInterestsViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNAEmailSenderViewController.h"
#import "GetPersonalProfile.h"
#import <QuartzCore/QuartzCore.h>

@interface FNAProfileManagerViewController()
@property(nonatomic, retain) NSMutableArray *arrChoices;
@end


@implementation FNAProfileManagerViewController
@synthesize imgTemplate;
@synthesize tblProfile, arrChoices;

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpArrChoices];
    _lbl_Overlay.layer.cornerRadius = 8;
    
    NSLog(@"%@", [FNASession sharedSession].profileId);
    
    if (![[FNASession sharedSession].profileId length] == 0) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setSummary];
    }
    else {
        [self sendErrorMessage:@"Tap on the sections to fill in new profile data"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    if (![[FNASession sharedSession].profileId length] == 0) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self setSummary];
        [tblProfile reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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

- (void) setUpArrChoices
{
    self.arrChoices = [[NSMutableArray alloc] init];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"info_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"General Information", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"user_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Spouse", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"users_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Dependents", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"case_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Personal Assets", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"home_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Real Property", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"heart_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Insurance Policies", @"title",
								@"", @"details", nil]];
	[self.arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								@"shopping_bag_icon&32.png",@"image",
								@"", @"cellBackgroundImage",
								@"Business Interest", @"title",
								@"", @"details", nil]];
}

- (void) setNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"Profile Management";
}

- (void) setSummary
{
    NSString *profileId = [[[NSString alloc]initWithString:[FNASession sharedSession].profileId]autorelease];
    
    if ([profileId length] > 0) {
        
        [FNASession sharedSession].totalBusiness = [GetPersonalProfile getTotalBusiness:profileId];
        [FNASession sharedSession].totalInsurance = [GetPersonalProfile getTotalInsurance:profileId];
        [FNASession sharedSession].totalPersonalAssets = [GetPersonalProfile getTotalPersonalAssets:profileId];
        [FNASession sharedSession].totalRealProperty = [GetPersonalProfile getTotalRealProperty:profileId];
        
        NSString *totalAssetString =[[[NSString alloc]initWithString:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].totalPersonalAssets] withCurrencySymbol:@"Php "]]autorelease] ;
        NSString *totalBusinessString =[[[NSString alloc]initWithString:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].totalBusiness] withCurrencySymbol:@"Php "]]autorelease];
        NSString *totalInsuranceString =[[[NSString alloc]initWithString:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].totalInsurance] withCurrencySymbol:@"Php "]]autorelease];
        NSString *totalRealPropertyString =[[[NSString alloc]initWithString:[Utility fortmatNumberCurrencyStyle:[NSString stringWithFormat:@"%@", [FNASession sharedSession].totalRealProperty] withCurrencySymbol:@"Php "]]autorelease];
        
        NSLog(@"%@", [FNASession sharedSession].name);
        [_lblName setText:[FNASession sharedSession].name];
        
        [_lblBirthdate setText:[NSString stringWithFormat:@"Birthdate: %@", [FNASession sharedSession].clientDob]];
        [_lblLandline setText:[NSString stringWithFormat:@"Landline: %@", [FNASession sharedSession].clientLandLine]];
        [_lblMobile setText:[NSString stringWithFormat:@"Mobile: %@", [FNASession sharedSession].clientMobile]];
        [_lblEmail setText:[NSString stringWithFormat:@"Email: %@", [FNASession sharedSession].clientEmail]];
        
        [_lblBusinessInterests setText:[NSString stringWithFormat:@"Total Business Interests: %@", totalBusinessString]];
        [_lblInsurancePolicies setText:[NSString stringWithFormat:@"Total Insurance Policies: %@", totalInsuranceString]];
        [_lblPersonalAssets setText:[NSString stringWithFormat:@"Total Personal Assets: %@", totalAssetString]];
        [_lblRealProperty setText:[NSString stringWithFormat:@"Total Real Property: %@", totalRealPropertyString]];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrChoices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%li%li", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	NSDictionary *item = [self.arrChoices objectAtIndex:indexPath.row];
	//TODO: Set the cell background image here - [item objectForKey:@"cellBackgroundImage"]
	
	[cell.textLabel setText:[item objectForKey:@"title"]];
	//[cell.detailTextLabel setNumberOfLines:2];
	//[cell.detailTextLabel setText:[item objectForKey:@"details"]];
	[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];
    //cell.showsReorderControl = YES;
	NSString *profileId = [FNASession sharedSession].profileId;
	if (!profileId || [profileId isEqualToString:@""])
	{
		if (indexPath.row > 0)
		{
			cell.userInteractionEnabled = NO;
			cell.textLabel.alpha = 0.439216f; // (1 - alpha) * 255 = 143
			cell.imageView.alpha = 0.439216f;
		}
	}
	else
	{
		cell.userInteractionEnabled = YES;
		cell.textLabel.alpha = 1; // (1 - alpha) * 255 = 143
		cell.imageView.alpha = 1;
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row==0)
	{
        [self performSegueWithIdentifier:@"segueToGeneralInformation" sender:self];
	}
	else if (indexPath.row==1)
	{
        [self performSegueWithIdentifier:@"segueToSpouse" sender:self];
	}
	else if (indexPath.row==2)
	{
        [self performSegueWithIdentifier:@"segueToDependents" sender:self];
	}
	else if (indexPath.row==3)
	{
        [self performSegueWithIdentifier:@"segueToPersonalAssets" sender:self];
	}
	else if (indexPath.row==4)
	{
        [self performSegueWithIdentifier:@"segueToRealProperty" sender:self];
	}
	else if (indexPath.row==5)
	{
        [self performSegueWithIdentifier:@"segueToInsurancePolicies" sender:self];
    }
	else if (indexPath.row==6)
	{
		[self performSegueWithIdentifier:@"segueToBusinessInterest" sender:self];
	}
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setImgTemplate:nil];
    [self setLbl_Overlay:nil];
    [self setLblBirthdate:nil];
    [self setLblLandline:nil];
    [self setLblMobile:nil];
    [self setLblEmail:nil];
    [self setLblPersonalAssets:nil];
    [self setLblRealProperty:nil];
    [self setLblInsurancePolicies:nil];
    [self setLblBusinessInterests:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.tblProfile release];
	[self.lblName release];
	[self.arrChoices release];
    [imgTemplate release];
    [_lbl_Overlay release];
    [_lblBirthdate release];
    [_lblLandline release];
    [_lblMobile release];
    [_lblEmail release];
    [_lblPersonalAssets release];
    [_lblRealProperty release];
    [_lblInsurancePolicies release];
    [_lblBusinessInterests release];
    [super dealloc];
}


@end
