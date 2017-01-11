//
//  FNAEmailSenderViewController.h
//  FNA_20120322
//
//  Created by Manulife on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface FNAEmailSenderViewController : UIViewController
    <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) NSArray *arrData;
@property(nonatomic, assign) NSString *clientEmail;
@property(nonatomic, assign) NSString *agentEmail;

@end
