//
//  Session_Retirement.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/4/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#define kObjKey_monthlyIncomeNeeded @"monthlyIncomeNeeded"
#define kObjKey_inflationRate @"inflationRate"
#define kObjKey_interestRate @"interestRate"
#define kObjKey_insuranceNeeded @"insuranceNeeded"
#define kObjKey_needForInsurance @"needForInsurance"
#define kObjKey_disability @"disability"
#define kObjKey_budget @"budget"
#define kObjKey_retirementAge @"retirementAge"
#define kObjKey_marketRate @"marketRate"
#define kObjKey_notes @"notes"
#define kObjKey_currentMonthlyEarnings @"currentMonthlyEarning"
#define kObjKey_serviceYrsFrDateHired @"kObjKey_serviceYrsFrDateHired"
#define kObjKey_expectedAnnIncrease @"expectedAnnIncrease"
#define kObjKey_retirementBenFactor @"retirementBenFactor"

#import <Foundation/Foundation.h>

@interface Session_Retirement : NSObject {
    
}

@property (nonatomic, retain) NSNumber *monthlyIncomeNeeded;
@property (nonatomic, retain) NSNumber *inflationRate;
@property (nonatomic, retain) NSNumber *interestRate;
@property (nonatomic, retain) NSNumber *insuranceNeeded;
@property (nonatomic, retain) NSString *needForInsurance;
@property (nonatomic, retain) NSString *disability;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSNumber *retirementAge;
@property (nonatomic, retain) NSNumber *marketRate;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSNumber *currentMonthlyEarning;
@property (nonatomic, retain) NSNumber *serviceYearsFrDateHired;
@property (nonatomic, retain) NSNumber *expectedAnnualIncrease;
@property (nonatomic, retain) NSNumber *retirementBenefitFactor;

+(Session_Retirement *) sharedSession;

@end
