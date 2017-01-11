//
//  ModalPersonalAssetsViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 6/19/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalPersonalAssetsViewController.h"
#import "FNASession.h"

@interface ModalPersonalAssetsViewController ()

@property (nonatomic, retain) NSNumber *savings;
@property (nonatomic, retain) NSNumber *current;
@property (nonatomic, retain) NSNumber *stocks;
@property (nonatomic, retain) NSNumber *bonds;
@property (nonatomic, retain) NSNumber *mutualBonds;
@property (nonatomic, retain) NSNumber *collectibles;

@end

@implementation ModalPersonalAssetsViewController

@synthesize delegate2 = _delegate2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTopButtons];
	
    [_txt_SavingsAccount setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientSavings doubleValue]]];
    [_txt_CurrentAccount setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientCurrent doubleValue]]];
    [_txt_Bonds setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientBonds doubleValue]]];
    [_txt_MutualBonds setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientMutual doubleValue]]];
    [_txt_Stocks setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientStocks doubleValue]]];
    [_txt_Collectibles setText:[NSString stringWithFormat:@"%.0f", [[FNASession sharedSession].clientCollectibles doubleValue]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) addTopButtons
{
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(exitModal)];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveUpdates)];
    
    _navBar.rightBarButtonItems = [NSArray arrayWithObjects:done, save, nil];
    
    [done release];
    [save release];
}

- (void) getValuesFromInput
{
    [FNASession sharedSession].clientSavings = [NSNumber numberWithDouble:[_txt_SavingsAccount.text doubleValue]];
    [FNASession sharedSession].clientCurrent  = [NSNumber numberWithDouble:[_txt_CurrentAccount.text doubleValue]];
    [FNASession sharedSession].clientBonds  = [NSNumber numberWithDouble:[_txt_Bonds.text doubleValue]];
    [FNASession sharedSession].clientStocks  = [NSNumber numberWithDouble:[_txt_Stocks.text doubleValue]];
    [FNASession sharedSession].clientMutual  = [NSNumber numberWithDouble:[_txt_MutualBonds.text doubleValue]];
    [FNASession sharedSession].clientCollectibles  = [NSNumber numberWithDouble:[_txt_Collectibles.text doubleValue]];
}

- (void) saveUpdates
{
    [self.view endEditing:YES];
    
    [self getValuesFromInput];
    
    [_delegate2 saveUpdates];
}

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

- (void) exitModal
{
    [_delegate2 finishedDoingMyThing:@"assets"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lbl_Overlay release];
    [_txt_SavingsAccount release];
    [_txt_CurrentAccount release];
    [_txt_Stocks release];
    [_txt_Bonds release];
    [_txt_MutualBonds release];
    [_txt_Collectibles release];
    [_savings release];
    [_current release];
    [_stocks release];
    [_bonds release];
    [_mutualBonds release];
    [_collectibles release];
    [_navBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLbl_Overlay:nil];
    [self setTxt_SavingsAccount:nil];
    [self setTxt_CurrentAccount:nil];
    [self setTxt_Stocks:nil];
    [self setTxt_Bonds:nil];
    [self setTxt_MutualBonds:nil];
    [self setTxt_Collectibles:nil];
    [self setSavings:nil];
    [self setCurrent:nil];
    [self setStocks:nil];
    [self setBonds:nil];
    [self setMutualBonds:nil];
    [self setCollectibles:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

@end
