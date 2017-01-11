//
//  PriorityCalcTabController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/18/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "PriorityCalcTabController.h"
#import "FNASession.h"
#import "FnaConstants.h"

@interface PriorityCalcTabController ()

@end

@implementation PriorityCalcTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Income]) {
        self.selectedIndex = 0;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Education]) {
        self.selectedIndex = 1;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Retirement]) {
        self.selectedIndex = 2;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Investment]) {
        self.selectedIndex = 3;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Estate]) {
        self.selectedIndex = 4;
    }
    if ([[FNASession sharedSession].selectedController isEqualToString: kSelectedController_Health]) {
        self.selectedIndex = 5;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [_tabs release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTabs:nil];
    [super viewDidUnload];
}
@end
