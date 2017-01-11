//
//  FinCalcMpDisclaimerViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 8/22/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalcMpDisclaimerViewController.h"

@interface FinCalcMpDisclaimerViewController ()

@end

@implementation FinCalcMpDisclaimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    NSString *strDisclaimer;
    strDisclaimer = @"DisclaimerMp";
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:strDisclaimer ofType:@"pdf" inDirectory:@""];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_viewWebDisclaimer loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewWebDisclaimer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setViewWebDisclaimer:nil];
    [super viewDidUnload];
}
@end
