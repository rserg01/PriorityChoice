//
//  TestViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/24/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "TestViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //[[self.view superview] insertSubview:_view2 belowSubview:self.view];
}

- (void) changeView: (NSString *) command
{
    CGRect show = CGRectMake(724, 0, 300, 655);
    CGRect hidden = CGRectMake(1024, 0, 300, 655);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    
    if ([command isEqualToString:@"show"]) {
        [_view2 setFrame:show];
    }
    else {
        [_view2 setFrame:hidden];
    }
    
    [UIView commitAnimations];
}

- (void) blink
{
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1.25)]];
    [basic setAutoreverses:YES];
    [basic setRepeatCount:MAXFLOAT];
    [basic setDuration:0.25];
    [_btnShow.layer addAnimation:basic forKey:@"transform"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_view2 release];
    [_btnShow release];
    [_btnHide release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setView2:nil];
    [self setBtnShow:nil];
    [self setBtnHide:nil];
    [super viewDidUnload];
}
- (IBAction)show:(id)sender {
    
    [self changeView:@"show"];
    [self blink];
}

- (IBAction)hide:(id)sender {
    [self changeView:@"hidden"];
}
@end
