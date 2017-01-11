//
//  Session_IncomeProtection.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_IncomeProtection : NSObject {
    
    NSString *activeProfileId;
    
    NSNumber *housing;
    NSNumber *food;
    NSNumber *utilities;
    NSNumber *transportation;
    NSNumber *entertainment;
    NSNumber *clothing;
    NSNumber *savings;
    NSNumber *medical;
    NSNumber *education;
    NSNumber *householdHelp;
    NSNumber *contribution;
    NSNumber *others;
    
    NSNumber *interestRate;
    NSString *insuranceNeed;
    NSString *disabilityNeed;
    NSNumber *protectionGoal;
    NSNumber *budget;
    NSString *notes;
    
    
}

@property (nonatomic, retain) NSString *activeProfileId;
@property (nonatomic, retain) NSNumber *housing;
@property (nonatomic, retain) NSNumber *food;
@property (nonatomic, retain) NSNumber *utilities;
@property (nonatomic, retain) NSNumber *transportation;
@property (nonatomic, retain) NSNumber *entertainment;
@property (nonatomic, retain) NSNumber *clothing;
@property (nonatomic, retain) NSNumber *savings;
@property (nonatomic, retain) NSNumber *medical;
@property (nonatomic, retain) NSNumber *education;
@property (nonatomic, retain) NSNumber *householdHelp;
@property (nonatomic, retain) NSNumber *contribution;
@property (nonatomic, retain) NSNumber *others;

@property (nonatomic, retain) NSNumber *interestRate;
@property (nonatomic, retain) NSString *insuranceNeed;
@property (nonatomic, retain) NSString *disabilityNeed;
@property (nonatomic, retain) NSNumber *protectionGoal;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSString *notes;


+(Session_IncomeProtection *) sharedSession;

@end
