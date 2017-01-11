//
//  EmailSender.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "EmailSender.h"
#import "FNAEmailSenderViewController.h"
#import "FNASession.h"
#import "Activation.h"
#import "GetPersonalProfile.h"

@implementation EmailSender 
    

+ (UIViewController *) sendEmailArray: (NSString *) profileId
                            tableName: (NSString *) tableName
                              dataSet: (NSString *) dataSet
{
    
    FNAEmailSenderViewController *email = [[[FNAEmailSenderViewController alloc] init]autorelease];
    [email setArrData:[NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:tableName,@"tableName",dataSet,@"dataSetName",profileId,@"clientID", nil],
                       nil]];
    
    NSArray *arr = [Activation getAgentInfo];
    NSDictionary *dic = [arr objectAtIndex:0];
    
    [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
    
    [email setClientEmail:[FNASession sharedSession].clientEmail];
    [email setAgentEmail:[dic objectForKey:@"agentEmail"]];
    
    return email;
}


@end
