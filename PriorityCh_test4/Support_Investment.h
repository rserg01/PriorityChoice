//
//  Support_Investment.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Support_Investment : NSObject {
    
}

+ (NSNumber *) checkExisingEntry: (NSString *) profileId;
+ (void) getInvestment: (NSString *)profileId;
+ (NSError *) newInvestment: (NSString *)profileId;
+ (NSError *) updateInvestment: (NSString *)profileId;

+ (NSNumber *) getTotalSavingsPlan: (NSNumber *) emergencyFund
                        retirement: (NSNumber *) retirement
                           newHome: (NSNumber *) newHome
                            newCar: (NSNumber *) newCar
                           holiday: (NSNumber *) holiday
                          business: (NSNumber *) business
                            legacy: (NSNumber *) legacy
                         estateTax: (NSNumber *) estateTax;

+ (NSNumber *) getTotalInvestments;

+ (NSNumber *) getInvestmentRequired: (NSNumber *) totalSavingsPlan
                  currentInvestments: (NSNumber *) currentInvestments;

@end
