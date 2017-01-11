//
//  RankingNavController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/17/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "RankingNavController.h"

@interface RankingNavController ()

@end

@implementation RankingNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

@end
