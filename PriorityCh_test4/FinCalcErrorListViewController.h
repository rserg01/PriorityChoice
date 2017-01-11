//
//  FinCalcErrorListViewController.h
//  PriorityCh_test4
//
//  Created by Manulife on 6/7/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinCalcErrorListViewControllerDelegate

-(void)closeTheModal;

@end

__unsafe_unretained id <FinCalcErrorListViewControllerDelegate> _fincalc_error_delegate;

@interface FinCalcErrorListViewController : UIViewController <UITableViewDataSource> {
    
}

@property (nonatomic, assign) id <FinCalcErrorListViewControllerDelegate> fincalcerror_delegate;

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *navBarItem;

@end
