//
//  FNAProfilesViewController.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FNAProfilesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{

}
@property(nonatomic, retain) IBOutlet UITableView *tblProfiles;
@property(nonatomic, retain) IBOutlet UILabel *lblTotal;
@property (retain, nonatomic) IBOutlet UIButton *btnSync;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Overlay;


-(IBAction)syncProfiles:(id)sender;
- (void) getNumberOfClients;
- (void) internetReachable;
@end


