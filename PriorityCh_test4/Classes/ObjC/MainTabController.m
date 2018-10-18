//
//  MainTabController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "MainTabController.h"
#import "FNASession.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([[FNASession sharedSession].selectedMainMenu isEqualToString: @"Main"]) {
        self.selectedIndex = 1;
    }
    else {
        self.selectedIndex = 0;
    }
}

- (void) timeoutProcedure
{
    [self performSegueWithIdentifier:@"Exit" sender:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
