//
//  ModalManucareNewProfileController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/20/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalManucareNewProfileControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <ModalManucareNewProfileControllerDelegate> _delegate_NewProfile;

@interface ModalManucareNewProfileController : UIViewController {
    
}

@property (nonatomic, assign) id <ModalManucareNewProfileControllerDelegate> delegate_NewProfile;

@property (retain, nonatomic) IBOutlet UITextField *txtFirstName;
@property (retain, nonatomic) IBOutlet UITextField *txtLastName;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;

@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_Gender;

@property (retain, nonatomic) IBOutlet UIButton *btn_ShowPicker;
@property (retain, nonatomic) IBOutlet UIButton *btn_DatePickerDone;

@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (retain, nonatomic) IBOutlet UIView *viewDatePicker;

@property (retain, nonatomic) IBOutlet UILabel *lbl_BirthDateValue;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *navBarItem;


- (IBAction)showPicker:(id)sender;
- (IBAction)exitView:(id)sender;
- (IBAction)exitCalendar:(id)sender;

@end
