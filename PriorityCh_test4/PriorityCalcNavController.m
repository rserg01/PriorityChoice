//
//  PriorityCalcNavController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/25/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "PriorityCalcNavController.h"

@interface PriorityCalcNavController ()

-(void) gotoHome;

@end

@implementation PriorityCalcNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //add home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Send to Email" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome:)];
    [self.navigationItem setRightBarButtonItem:homeButton];
    
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

- (void) gotoHome {
    
    
    
}

@end
