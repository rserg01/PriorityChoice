//
//  ProductsTabController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ProductsTabController.h"
#import "FNASession.h"
#import "FnaConstants.h"

@interface ProductsTabController ()

@end

@implementation ProductsTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Income]) {
        self.selectedIndex = 5;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Education]) {
        self.selectedIndex = 1;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Retirement]) {
        self.selectedIndex = 2;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Investment]) {
        self.selectedIndex = 0;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Estate]) {
        self.selectedIndex = 3;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Health]) {
        self.selectedIndex = 4;
    }
    
    [FNASession sharedSession].selectedController = @"";
    
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
