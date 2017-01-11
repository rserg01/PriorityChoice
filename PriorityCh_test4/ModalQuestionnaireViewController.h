//
//  ModalQuestionnaireViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 7/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalQuestionnaireControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <ModalQuestionnaireControllerDelegate> _delegate_Questions;

@interface ModalQuestionnaireViewController : UIViewController {
    
}

@property (nonatomic, assign) id <ModalQuestionnaireControllerDelegate> delegate_Questions;

@property (retain, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *navBtn;

- (IBAction)done:(id)sender;


@end
