//
//  WhyManulifeViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "WhyManulifeViewController.h"
#import "FNASession.h"
#import "Utility.h"

@interface WhyManulifeViewController ()

@end

@implementation WhyManulifeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTopButtons];
    
    NSString *whyManulife = [[[NSString alloc]init]autorelease];
    
    if ([[Utility getUserDefaultsValue:@"CHANNEL"] isEqualToString:@"MBCL"]) {
        whyManulife = @"Why_Manulife_MCBL";
    }
    else {
        whyManulife = @"WhyManulife_Sept_2014";
    }
	
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:whyManulife]];
    [self setImage:image];
    
    _scrollView.contentSize = CGSizeMake(image.frame.size.width, image.frame.size.height);
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 0.75;
    _scrollView.clipsToBounds = YES;
    _scrollView.delegate = self;
    [_scrollView addSubview:_image];
}

- (void) addTopButtons
{
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    [self.navigationItem setLeftBarButtonItem:homeButton];
}

- (void) gotoHome
{
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_image release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImage:nil];
    [super viewDidUnload];
}
@end
