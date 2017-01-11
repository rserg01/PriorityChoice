//
//  FNADependentsViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNAAddDependentViewController.h"


@interface FNADependentsViewController : UIViewController <UITableViewDelegate, FNAAddDependentViewControllerDelegate>
{

}
@property(nonatomic, retain) IBOutlet UITableView *tblDependents;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;


@end
