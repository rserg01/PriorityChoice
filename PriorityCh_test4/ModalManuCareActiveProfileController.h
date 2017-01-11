//
//  ModalManuCareActiveProfileController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalManuCareActiveProfileControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <ModalManuCareActiveProfileControllerDelegate> _delegate_ActiveProfile;

@interface ModalManuCareActiveProfileController : UIViewController {
    
}

@property (nonatomic, assign) id <ModalManuCareActiveProfileControllerDelegate> delegate_ActiveProfile;

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btn_Close;

- (IBAction)closeModal:(id)sender;

@end
