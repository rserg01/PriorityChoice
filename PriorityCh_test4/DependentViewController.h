//
//  DependentViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DependentViewControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <DependentViewControllerDelegate> _delegate_Dependent;

@interface DependentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, assign) id <DependentViewControllerDelegate> delegate_Dependent;

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *navBtn_Done;

- (IBAction)closeModal:(id)sender;


@end
