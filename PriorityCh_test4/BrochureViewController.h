//
//  BrochureViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrochureViewController : UIViewController <UIScrollViewDelegate>{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (nonatomic, assign) NSString *productName;


@end
