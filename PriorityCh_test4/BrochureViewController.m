//
//  BrochureViewController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "BrochureViewController.h"

@interface BrochureViewController ()

@end

@implementation BrochureViewController

@synthesize productName = _productName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fileName = _productName;
    
    NSLog(@"fileName = %@", _productName);
	
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
    [self setProductImage:image];
    
    _scrollView.contentSize = CGSizeMake(image.frame.size.width, image.frame.size.height);
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 0.75;
    _scrollView.clipsToBounds = YES;
    _scrollView.delegate = self;
    [_scrollView addSubview:_productImage];
    
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _productImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_productImage release];
    [_productName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setProductImage:nil];
    [self setProductName:nil];
    [super viewDidUnload];
}
@end
