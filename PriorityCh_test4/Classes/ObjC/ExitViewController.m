//
//  ExitViewController.m
//  PriorityChoice_v25
//
//  Created by Manulife Philippines on 11/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ExitViewController.h"
#import "FNASession.h"

@interface ExitViewController ()

@end

@implementation ExitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FNASession sharedSession].agentCode = @"";
    [FNASession sharedSession].selectedMainMenu = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMain:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}
@end
