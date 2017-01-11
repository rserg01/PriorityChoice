//
//  InTheNewsViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "InTheNewsViewController.h"
#import "FNASession.h"
#import "Utility.h"
#import "FnaConstants.h"

@interface InTheNewsViewController ()

@end

@implementation InTheNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTopButtons];
    
    NSString *newsClipping = [[[NSString alloc]init]autorelease];
    
    if ([[Utility getUserDefaultsValue:@"CHANNEL"] isEqualToString:@"MBCL"]) {
        newsClipping = kImage_About_News_Mcbl;
    }
    else {
        newsClipping = kImage_About_News_MP;
    }
    
	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:newsClipping]];
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
