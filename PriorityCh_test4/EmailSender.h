//
//  EmailSender.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailSender : NSObject {
    
}

+ (UIViewController *) sendEmailArray: (NSString *) profileId
                            tableName: (NSString *) tableName
                              dataSet: (NSString *) dataSet;

@end
