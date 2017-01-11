//
//  Session_Manucare.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_Manucare : NSObject {
    
}

@property (nonatomic, retain) NSString *activeProfileId;

@property (nonatomic, retain) NSMutableArray *arr_Answers;

//Risk Capacity Assessment
@property (nonatomic, retain) NSNumber *timeFrame;
@property (nonatomic, retain) NSNumber *retirementPlan;
@property (nonatomic, retain) NSNumber *needForInvestment;
@property (nonatomic, retain) NSNumber *cashFlowNeeds;
@property (nonatomic, retain) NSNumber *ageScore;
@property (nonatomic, retain) NSNumber *riskCapacityScore;

//Risk Attitude Assessment
@property (nonatomic, retain) NSNumber *investmentDrop;
@property (nonatomic, retain) NSNumber *interestValue;
@property (nonatomic, retain) NSNumber *returns;
@property (nonatomic, retain) NSNumber *riskDegree;
@property (nonatomic, retain) NSNumber *reviewFrequency;
@property (nonatomic, retain) NSNumber *overallAttitude;
@property (nonatomic, retain) NSNumber *riskAttitudeScore;

+(Session_Manucare *) sharedSession;

@end
