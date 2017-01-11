//
//  Support_IncomeProtection.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNASession.h"
#import "Session_IncomeProtection.h"

@interface Support_IncomeProtection : NSObject {
    

}

+ (NSNumber *) checkExisingEntry:(NSString *)profileId;

+ (BOOL) getIncomeProtection;

+ (NSNumber *) getMonthlyExpense;

+ (NSNumber *) getAnnualExpense:(NSNumber *)monthlyExpense;

+ (NSNumber *) capitalRequired:(NSNumber *)annualExpense
           assumedInterestRate:(NSNumber *)assumedInterestRate;

+ (NSNumber *) getProtectionGoal:(NSNumber *)capitalRequired
                  totalInsurance:(NSNumber *)totalInsurance
                     totalAssets:(NSNumber *)totalAssets;

+ (NSError *) newIncomeProtection: (NSString *)profileId
                          housing:(NSNumber *)housing
                             food:(NSNumber *)food
                        utilities:(NSNumber *)utilities
                          transpo:(NSNumber *)transpo
                         clothing:(NSNumber *)clothing
                    entertainment:(NSNumber *)entertainment
                          savings:(NSNumber *)savings
                          medical:(NSNumber *)medical
                        education:(NSNumber *)education
                     contribution:(NSNumber *)contribution
                    householdHelp:(NSNumber *)householdHelp
                           others:(NSNumber *)others
                     interestRate:(NSNumber *)interestRate
                    insuranceNeed:(NSString *)insuranceNeed
                   disabilityNeed:(NSString *)disabilityNeed
                   protectionGoal:(NSNumber *)protectionGoal
                           budget:(NSNumber *)budget
                            notes: (NSString *)notes;

+ (NSError *) updateIncomeProtection;



@end
