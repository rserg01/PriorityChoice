//
//  ProfilesTableViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilesTableViewControllerDelegate

-(void)finishedDoingMyThing:(NSString *)labelString;

@end

__unsafe_unretained id <ProfilesTableViewControllerDelegate> _rankingDelegate;

@interface ProfilesTableViewController : UIViewController <UITableViewDelegate> {
    
}

@property (nonatomic, assign) id <ProfilesTableViewControllerDelegate> rankingDelegate;

@property (retain, nonatomic) IBOutlet UIButton *btn_Close;
@property (retain, nonatomic) IBOutlet UITableView *tblView;

- (IBAction)dismissView:(id)sender;

@end
