//
//  RankingTableController.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/17/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilesTableViewController.h"
#import "ModalProfileViewController.h"

@interface RankingTableController : UITableViewController <ProfilesTableViewControllerDelegate, ModalProfileControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSString *priorityTap;
@property(nonatomic, retain) NSString *selectedController;

- (void) loadPriorityRankInformation:(UIAlertView*)alertView;
- (void) savePriorityRank:(UIAlertView*)alertView;

@end
