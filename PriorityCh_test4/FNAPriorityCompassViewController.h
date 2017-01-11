//
//  FNAPriorityCompassViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WheelControl.h"

@interface FNAPriorityCompassViewController : UIViewController// <WheelControlDelegate>
{
}

@property(nonatomic, retain) IBOutlet UIImageView *imgCompass;
@property(nonatomic, retain) IBOutlet UIImageView *imgArrow;
@property(nonatomic, retain) IBOutlet UIImageView *imgDetails;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nvBtn_Done;


@property (retain, nonatomic) IBOutlet UIImageView *img_RP_Retired;
@property (retain, nonatomic) IBOutlet UIImageView *img_RP_EmptyNester;
@property (retain, nonatomic) IBOutlet UIImageView *img_RP_YoungFamily;
@property (retain, nonatomic) IBOutlet UIImageView *img_RP_GrowingFamily;
@property (retain, nonatomic) IBOutlet UIImageView *img_RP_PreFamily;

@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;


-(void)transformSpinnerwithTouches:(UITouch *)touchLocation;
-(CGPoint)vectorFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint;
-(void)animateView:(UIView *)theView toPosition:(CGAffineTransform) newTransform;

- (IBAction)nvBtnDone:(id)sender;


@end
