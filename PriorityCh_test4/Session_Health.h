//
//  Session_Health.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_Health : NSObject {
    
}

@property (nonatomic, retain) NSNumber *healthProtection;
@property (nonatomic, retain) NSString *healthPlan;
@property (nonatomic, retain) NSNumber *hospitalRoom;
@property (nonatomic, retain) NSString *accidentProtection;
@property (nonatomic, retain) NSNumber *coverageNeeded;
@property (nonatomic, retain) NSString *criticalIllnessNeed;
@property (nonatomic, retain) NSNumber *criticalIllnessCoverage;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSNumber *employeeCoverage;
@property (nonatomic, retain) NSNumber *semiPrivate;
@property (nonatomic, retain) NSNumber *smallPrivate;
@property (nonatomic, retain) NSNumber *privateDeluxe;
@property (nonatomic, retain) NSNumber *suite;
@property (nonatomic, retain) NSNumber *medAndNursingCare;
@property (nonatomic, retain) NSString *notes;


+(Session_Health *) sharedSession;

@end
