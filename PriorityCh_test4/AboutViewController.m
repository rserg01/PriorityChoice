//
//  AboutViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Glow.h"
#import "FNASession.h"
#import "FnaConstants.h"
#import "Utility.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTopButtons];
	
    _lbl_Overlay1.layer.cornerRadius = 8;
    _lbl_Overlay2.layer.cornerRadius = 8;
    
    [_image1 startGlowingWithColor:[UIColor whiteColor] intensity:0.2];
    [_image2 startGlowingWithColor:[UIColor whiteColor] intensity:0.2];
    
    NSString *boilerPlate = [[[NSString alloc]init]autorelease];
    NSString *banner = [[[NSString alloc]init]autorelease];
    
    if ([[Utility getUserDefaultsValue:@"CHANNEL"] isEqualToString:@"MBCL"]) {
        boilerPlate = kBoilerPlate_Mcbl;
        banner = kImage_About_McblBanner;
    }
    else {
        boilerPlate = kBoilerPlate;
        banner = kImage_About_Banner;
    }
   
    [_imageBanner setImage:[UIImage imageNamed:banner]];
    
    _txtArea_BoilerPlate.text = boilerPlate;
    
}

- (void) addTopButtons
{
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    [self.navigationItem setLeftBarButtonItem:homeButton];
}

- (void) gotoHome
{
    
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

- (void)dealloc {
    [_image1 release];
    [_image2 release];
    [_lbl_Overlay1 release];
    [_lbl_Overlay2 release];
    [_txtArea_BoilerPlate release];
    [_imageBanner release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImage1:nil];
    [self setImage2:nil];
    [self setLbl_Overlay1:nil];
    [self setLbl_Overlay2:nil];
    [self setTxtArea_BoilerPlate:nil];
    [super viewDidUnload];
}
@end
