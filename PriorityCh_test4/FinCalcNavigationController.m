//
//  FinCalcNavigationController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalcNavigationController.h"

@interface FinCalcNavigationController ()

@end

@implementation FinCalcNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
