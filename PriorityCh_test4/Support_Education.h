//
//  Support_Education.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Support_Education : NSObject {
    
}

+ (NSNumber *) checkExisingEntry:(NSString *)profileId dependentId: (NSString *) dependentId;

+ (NSMutableArray *) getEducFunding: (NSString *)profileId dependentId: (NSString *) dependentId;

+ (NSError *) newEducFunding: (NSString *)profileId dependentId: (NSString *)dependentId;

+ (NSError *) updateEducFunding: (NSString *) profileId
                    dependentId: (NSString *) dependentId
              presentAnnualCost: (NSNumber *) presentAnnualCost
                    yearOfEntry: (NSNumber *) yearOfEntry
                         budget: (NSNumber *) budget
                  insImportance: (NSString *) insImportance
                educSavingsGoal: (NSNumber *) educSavingsGoal
                          notes: (NSString *) notes
         allocatedPersonalAsset: (NSNumber *) allocatedPersonalAsset;

+ (NSNumber *) getFutureCost: (NSNumber *)presentCost
                 yearOfEntry: (NSNumber *)yearOfEntry
                 currentYear: (NSNumber *)currentYear;

+ (NSNumber *) computeSavingsGoal: (NSNumber *)presentAnnualCost
                          savings: (NSNumber *)savings;

+ (NSNumber *) getCurrentYear;

@end
