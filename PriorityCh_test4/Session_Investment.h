//
//  Session_Investment.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#define kObjKey_prEmergencyFund @"prEmergencyFund"
#define kObjKey_prRetirement @"prRetirement"
#define kObjKey_prNewHome @"prNewHome"
#define kObjKey_prNewCar @"prNewCar"
#define kObjKey_prHoliday @"prHoliday"
#define kObjKey_prLegacy @"prLegacy"
#define kObjKey_prEstateTax @"prEstateTax"
#define kObjKey_savingCategory @"savingCategory"
#define kObjKey_workingInvestment @"workingInvestment"
#define kObjKey_investmentRequired @"investmentRequired"
#define kObjKey_budget @"budget"
#define kObjKey_investmentNeeded @"investmentNeeded"
#define kObjKey_notes @"notes"
#define kObjKey_costOfSavings @"costOfSavings"
#define kObjKey_prBusiness @"prBusiness"
#define kObjKey_riskCapacity @"riskCapacity"
#define kObjKey_riskAttitude @"riskAttitude"


#import <Foundation/Foundation.h>

@interface Session_Investment : NSObject

@property (nonatomic, retain) NSNumber *prEmergencyFund;
@property (nonatomic, retain) NSNumber *prRetirement;
@property (nonatomic, retain) NSNumber *prNewHome;
@property (nonatomic, retain) NSNumber *prNewCar;
@property (nonatomic, retain) NSNumber *prHoliday;
@property (nonatomic, retain) NSNumber *prLegacy;
@property (nonatomic, retain) NSNumber *prEstateTax;
@property (nonatomic, retain) NSString *savingCategory;
@property (nonatomic, retain) NSString *workingInvestment;
@property (nonatomic, retain) NSNumber *investmentRequired;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSString *investmentNeeded;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSNumber *costOfSavings;
@property (nonatomic, retain) NSNumber *prBusiness;
@property (nonatomic, retain) NSString *riskCapacity;
@property (nonatomic, retain) NSString *riskAttitude;

+(Session_Investment *) sharedSession;

@end
