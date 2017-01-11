//
//  Support_EstatePlanning.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Support_EstatePlanning : NSObject

+ (NSNumber *) checkExisingEntry:(NSString *)profileId;
+ (NSError *) getEstatePlanning: (NSString *)profileId;
+ (NSError *) newEstatePlanning: (NSString *)profileId;
+ (NSError *) updateEstatePlanning: (NSString *)profileId;
+ (NSNumber *) computeTotalExpenses;
+ (NSNumber *) computeGrossEstate:(NSNumber *) personalAssets
                         business:(NSNumber *) business
                     realProperty:(NSNumber *) realProperty
                        insurance:(NSNumber *) insurance;
+ (NSNumber *) computeNetEstate:(NSNumber *) grossEstate
                     deductions:(NSNumber *) deductions;
+ (NSNumber *) computePercentage:(NSNumber *) netEstate;
+ (NSNumber *) computeAppliedTax:(NSNumber *) netEstate;
+ (NSNumber *) computeExcessAmount:(NSNumber *) netEstate;
+ (NSNumber *) computeEstateTax:(NSNumber *) grossEstate
                     deductions:(NSNumber *) deductions
                      netEstate:(NSNumber *) netEstate
                     appliedTax:(NSNumber *) appliedTax
                     percentage:(NSNumber *) percentage
                   excessAmount:(NSNumber *) excessAmount;
+ (NSNumber *) computeGap:(NSNumber *) grossEstate
               deductions:(NSNumber *) deductions
             estateTaxDue:(NSNumber *) estateTaxDue;
@end
