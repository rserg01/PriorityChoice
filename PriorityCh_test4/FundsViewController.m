//
//  FundsViewController.m
//  PriorityChoice_v25
//
//  Created by Manulife Philippines on 12/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FundsViewController.h"
#import "FNASession.h"

@interface FundsViewController ()

@end

@implementation FundsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addTopButtons];
}

- (void) addTopButtons
{
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    [_navItem setLeftBarButtonItems:[NSArray arrayWithObjects:homeButton, nil] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gotoHome {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)dealloc {
    [_navItem release];
    [super dealloc];
}
@end
