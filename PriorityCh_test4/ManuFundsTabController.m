//
//  ManuFundsTabController.m
//  PriorityCh_test4
//
//  Created by Manulife on 7/10/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ManuFundsTabController.h"
#import "FNASession.h"

@interface ManuFundsTabController ()

@end

@implementation ManuFundsTabController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addTopButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
