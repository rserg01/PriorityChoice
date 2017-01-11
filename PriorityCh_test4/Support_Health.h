//
//  Support_Health.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Support_Health : NSObject {
    
}

+ (NSNumber *) checkExisingEntry:(NSString *)profileId;
+ (NSError *) getImpariedHealth: (NSString *)profileId;
+ (NSError *) newImpairedHealth: (NSString *)profileId;
+ (NSError *) updateImpairedHealth: (NSString *)profileId;

+ (NSNumber *) computeTotalCurrentBenefit: (NSNumber *) medicalBenefit
                            healthBenefit: (NSNumber *) healthBenefit;

+ (NSNumber *) hospitalizationBen: (NSNumber *) semiPrivate
                            smallPrivate: (NSNumber *) smallPrivate
                           privateDeLuxe: (NSNumber *) privateDeLuxe
                                   suite: (NSNumber *) suite;

+ (NSNumber *) computeCoverageNeeded: (NSNumber *) additionalBenefit
                      currentBenefit: (NSNumber *) currentBenefit;

+ (NSNumber *) additionalBenReq: (NSNumber *) medicalBenefit
               employeeCoverage: (NSNumber *) emplyeeCoverage
               personalCoverage: (NSNumber *) personalCoverage;

+ (NSNumber *) capitalRequired: (NSNumber *) nursingExpenses
               criticalIllness: (NSNumber *) criticallIllness;

@end
