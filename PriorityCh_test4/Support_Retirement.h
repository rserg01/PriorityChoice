//
//  Support_Retirement.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/4/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface Support_Retirement : NSObject {
    
}

+ (NSNumber *) checkExisingEntry:(NSString *)profileId;
+ (void) getRetirement:(NSString *)profileId;
+ (NSError *) newRetirement: (NSString *)profileId;
+ (NSError *) updateRetirement: (NSString *)profileId;

+ (NSDate *) getBirthdate:(NSString *)birthdate;
+ (NSNumber *) getCurrentAge: (NSDate *) birthDate;

+ (NSNumber *) getYearsBeforeRetirement: (NSNumber *)currentAge
                          retirementAge:(NSNumber *)retirementAge;

+ (NSNumber *) getDesiredAnnualIncome:(NSNumber *)monthlyIncomeNeeded;
+ (NSNumber *) getAnnualIncomeAtRetirement:(NSNumber *)inflationRate
                             retirementYears:(NSNumber *)retirementYears
                   desiredIncomeRetirement:(NSNumber *)desiredIncomeRetirement;

+ (NSNumber *) getCapitalRequired: (NSNumber *)marketRate
                    retirementAge: (NSNumber *) retirementAge
            annIncomeAtRetirement: (NSNumber *) annIncomeAtRetirement;

+ (NSNumber *) getExpectedRetirementBenefit: (NSNumber *) currentMonthlyEarnings
                              retirementYears: (NSNumber *) retirementYears
                        servYearsFrHireDate: (NSNumber *) servYearsFrHireDate
                        retirementBenFactor: (NSNumber *) retirementBenFactor
                        expectedAnnIncrease: (NSNumber *) expectedAnnIncrease;


+ (NSNumber *) getRetirementgap: (NSNumber *)capitalRequired
          expectedRetirementBen: (NSNumber *)expectedRetirementBen;

+ (NSNumber *) getRetirementBenefitFactor: (NSNumber *) selectedIndex;


@end
