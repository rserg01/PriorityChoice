//
//  TestViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/24/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController {
    
}
@property (retain, nonatomic) IBOutlet UIView *view2;
@property (retain, nonatomic) IBOutlet UIButton *btnShow;
@property (retain, nonatomic) IBOutlet UIButton *btnHide;
- (IBAction)show:(id)sender;
- (IBAction)hide:(id)sender;


@end
