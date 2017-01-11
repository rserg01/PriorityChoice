//
//  ModalActivationViewController.h
//  PriorityCh_test4
//
//  Created by Mateo on 7/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalActivationViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *navButton;

- (IBAction)closeModal:(id)sender;



@end
