//
//  FinCalcViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalcViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Session_FinCalc.h"
#import "Support_FinCalc.h"
#import "FNASession.h"
#import "Utility.h"
#import "FnaConstants.h"

@interface FinCalcViewController ()

@property (nonatomic, retain) NSMutableArray *arrChild;

@end

@implementation FinCalcViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lbl_Overlay_AffGold.layer.cornerRadius = 8;
    _lbl_Overlay_AffGoldMax.layer.cornerRadius = 8;
    _lbl_Overlay_Wealth.layer.cornerRadius = 8;
    
    NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    if ([strChannel isEqual:@"MBCL"]) {
        
        [_btn_AffGold setImage:[UIImage imageNamed:kImage_FinCalc_Enrich] forState:UIControlStateNormal];
        [_btn_AffGoldMax setImage:[UIImage imageNamed:kImage_FinCalc_PlatinumInvest] forState:UIControlStateNormal];
        [_btn_Wealth setImage:[UIImage imageNamed:kImage_FinCalc_WealtherPremierMCBL] forState:UIControlStateNormal];
    }
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - IBAction

- (IBAction)affGoldAction:(id)sender {
    
    [Session_FinCalc sharedSession].productName = kProductName_AffluenceGold;
}

- (IBAction)affGoldMaxAction:(id)sender {
    
    [Session_FinCalc sharedSession].productName = kProductName_AffluenceMaxGold;
}

- (IBAction)gotoHome:(id)sender {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_lbl_Overlay_AffGold release];
    [_lbl_Overlay_AffGoldMax release];
    [_lbl_Overlay_Wealth release];
    [_btn_AffGold release];
    [_btn_AffGoldMax release];
    [_btn_Wealth release];
    [_btn_Home release];
    [_arrChild release];
    [super dealloc];
}

- (void) viewDidUnload
{
    [self setLbl_Overlay_AffGold:nil];
    [self setLbl_Overlay_AffGoldMax:nil];
    [self setLbl_Overlay_Wealth:nil];
    [self setBtn_AffGold:nil];
    [self setBtn_AffGoldMax:nil];
    [self setBtn_Wealth:nil];
    [self setBtn_Home:nil];
    [self setArrChild:nil];
    [super viewDidUnload];
}


@end
