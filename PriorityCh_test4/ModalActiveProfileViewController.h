//
//  ModalActiveProfileViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalActiveProfileControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <ModalActiveProfileControllerDelegate> _delegate1;

@interface ModalActiveProfileViewController : UIViewController {
    
}

@property (nonatomic, assign) id <ModalActiveProfileControllerDelegate> delegate1;

@property (retain, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;


@end
