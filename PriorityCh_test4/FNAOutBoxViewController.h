//
//  FNAOutBoxViewController.h
//  FNA
//
//  Created by Justin Limjap on 3/30/12.
//  Copyright 2012 iGen Dev Center, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface FNAOutBoxViewController : UIViewController 
	<UITableViewDelegate,MFMailComposeViewControllerDelegate>
{

}



@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *arrData;
@property (retain, nonatomic) IBOutlet UIImageView *imgTemplate;

- (IBAction) sendData:(id)sender;

@end
