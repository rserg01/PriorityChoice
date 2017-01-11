    //
//  FNAPriorityCompassViewController.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAPriorityCompassViewController.h"
#import "Utility.h"
#import "MainSwitchViewController.h"
#import "FnaConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "FNASession.h"

@interface FNAPriorityCompassViewController()
- (BOOL) checkCurrentAngle;
@end

@implementation FNAPriorityCompassViewController
@synthesize imgTemplate;
@synthesize imgCompass, imgArrow, imgDetails;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    UIImage *mcblTemplate = [UIImage imageNamed: @"LifeCompass5_templateWithMcbl.png"];
    
    //change images per sales channel
    if ([strChannel isEqualToString:@"MCBL"])
    {
        [imgTemplate setImage:mcblTemplate];
    }
    
    
}

- (IBAction)nvBtnDone:(id)sender {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
        UITouch *touch=[[event allTouches]anyObject];
        [self transformSpinnerwithTouches:touch];
}

-(void)transformSpinnerwithTouches:(UITouch *)touchLocation
{	

	
    CGPoint touchLocationpoint = [touchLocation locationInView:self.view];
    CGPoint PrevioustouchLocationpoint = [touchLocation previousLocationInView:self.view];
    //origin is the respective point from that i gonna measure the angle of the current position with respective to previous position ....
    CGPoint origin;
    origin.x = imgArrow.center.x;
    origin.y = imgArrow.center.y;
	
    CGPoint previousDifference = [self vectorFromPoint:origin toPoint:PrevioustouchLocationpoint];
	
    CGAffineTransform newTransform = CGAffineTransformScale(imgArrow.transform, 1, 1);
    CGFloat previousRotation = atan2(previousDifference.y, previousDifference.x);
	
    CGPoint currentDifference = [self vectorFromPoint:origin toPoint:touchLocationpoint];
	
    CGFloat currentRotation = atan2(currentDifference.y, currentDifference.x);
    CGFloat newAngle = currentRotation - previousRotation;
	
    newTransform = CGAffineTransformRotate(newTransform, newAngle);
	//NSLog(@"angle: %2f", newAngle);
	
	CGAffineTransform oldTransform = [imgArrow transform];
	
    [self animateView:imgArrow toPosition:newTransform];
	
	if (![self checkCurrentAngle]) 
	{
		[self animateView:imgArrow toPosition:oldTransform];

	}
}


- (BOOL) checkCurrentAngle
{
	CGFloat radians = atan2f(imgArrow.transform.b, imgArrow.transform.a); 
	CGFloat degrees = radians * (180 / M_PI);
	
	//NSLog(@"degrees is %f",degrees);

	if ((degrees >=90.0 || degrees <=-90) ) 
	{
		return NO;
	}
 
	if (degrees > 40.0 && degrees <=80.0 /*|| (degrees>-140.0 && degrees<=-106.0)*/) 
	{
		//NSLog(@"Pre Family");
		[imgDetails setImage:[UIImage imageNamed:@"PreFamily.png"]];
        
        [self growImage:_img_RP_PreFamily];
        [self shrinkImage:_img_RP_YoungFamily];
        [self shrinkImage:_img_RP_GrowingFamily];
        [self shrinkImage:_img_RP_EmptyNester];
        [self shrinkImage:_img_RP_Retired];
	}
	else if (degrees >12.0 && degrees <=40.0/* || (degrees>-167.0 && degrees<=-140)*/) 
	{
		//NSLog(@"Young Family");
		[imgDetails setImage:[UIImage imageNamed:@"YoungFamily.png"]];
        
        [self shrinkImage:_img_RP_PreFamily];
        [self growImage:_img_RP_YoungFamily];
        [self shrinkImage:_img_RP_GrowingFamily];
        [self shrinkImage:_img_RP_EmptyNester];
        [self shrinkImage:_img_RP_Retired];
	}
	else if (degrees <=12.0 && degrees >=-13.0/* || (degrees>167.0 || degrees <=-167.0)*/) 
	{
		//NSLog(@"Growing Family");
		[imgDetails setImage:[UIImage imageNamed:@"GrowingFamily.png"]];
        
        [self shrinkImage:_img_RP_PreFamily];
        [self shrinkImage:_img_RP_YoungFamily];
        [self growImage:_img_RP_GrowingFamily];
        [self shrinkImage:_img_RP_EmptyNester];
        [self shrinkImage:_img_RP_Retired];
	}
	else if (degrees <13.0 && degrees >=-40.0/* || (degrees>140.0 && degrees<=167.0)*/) 
	{
		//NSLog(@"Empty Nester");
		[imgDetails setImage:[UIImage imageNamed:@"EmptyNester.png"]];
        
        [self shrinkImage:_img_RP_PreFamily];
        [self shrinkImage:_img_RP_YoungFamily];
        [self shrinkImage:_img_RP_GrowingFamily];
        [self growImage:_img_RP_EmptyNester];
        [self shrinkImage:_img_RP_Retired];
	}
	else if (degrees <40.0 && degrees >=-70.0/* || (degrees >=110.0 && degrees <=140.0)*/) 
	{
		//NSLog(@"Retired");
		[imgDetails setImage:[UIImage imageNamed:@"Retired.png"]];
        
        [self shrinkImage:_img_RP_PreFamily];
        [self shrinkImage:_img_RP_YoungFamily];
        [self shrinkImage:_img_RP_GrowingFamily];
        [self shrinkImage:_img_RP_EmptyNester];
        [self growImage:_img_RP_Retired];
	}/*
	else {
		return NO;
	}*/
	return YES;
}

-(void)animateView:(UIView *)theView toPosition:(CGAffineTransform) newTransform
{
	imgArrow.transform = newTransform;
}


-(CGPoint)vectorFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint
{
    CGFloat x = secondPoint.x - firstPoint.x;
    CGFloat y = secondPoint.y - firstPoint.y;
    CGPoint result = CGPointMake(x, y);
    //NSLog(@"%f %f",x,y);
    return result;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) growImage: (UIImageView *) image
{
    image.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    image.transform = CGAffineTransformMakeScale(2,2);
    image.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) shrinkImage: (UIImageView *) image
{
    [UIView beginAnimations:@"fadeInNewView2" context:NULL];
    [UIView setAnimationDuration:1.0];
    image.transform = CGAffineTransformMakeScale(1,1);
    image.alpha = 0.0f;
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [self setImgTemplate:nil];
    [self setImg_RP_Retired:nil];
    [self setImg_RP_EmptyNester:nil];
    [self setImg_RP_YoungFamily:nil];
    [self setImg_RP_GrowingFamily:nil];
    [self setImg_RP_PreFamily:nil];
    [self setLbl_Overlay:nil];
    [self setNvBtn_Done:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[imgCompass release];
	[imgArrow release];
	[imgDetails release];
    [imgTemplate release];
    [_img_RP_Retired release];
    [_img_RP_EmptyNester release];
    [_img_RP_YoungFamily release];
    [_img_RP_GrowingFamily release];
    [_img_RP_PreFamily release];
    [_lbl_Overlay release];
    [_nvBtn_Done release];
    [super dealloc];
}


@end
