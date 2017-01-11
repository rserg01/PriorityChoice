//
//  Activation.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/28/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activation : NSObject {
    
}

+ (BOOL) checkExpiration: (NSString *)expirationDateString;

+ (BOOL) cydiaCheck;

+ (NSString *) activateApp: (NSString *) agentCode
                 birthDate: (NSString *) birthdate
                       tin: (NSString *) tin
                  username: (NSString *) username
                  password: (NSString *) password;

+ (NSError *) saveAgentInfo: (NSString *) strResult
                   username: (NSString *) username
                   password: (NSString *) password
                  agentCode: (NSString *) agentCode
                        tin: (NSString *) tin
                  birthdate:(NSString *) birthdate;

+ (BOOL) loginToApp: (NSString *) username
           password: (NSString *) password;

+ (NSMutableArray *) getAgentInfo;

+ (BOOL) passwordValidation: (NSString *) password;

+ (NSError *) saveNewPassword: (NSString *) password;

@end
