//
//  Session_Education.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_Education : NSObject {
    
}

@property (nonatomic, retain) NSNumber *presentAnnualCost;
@property (nonatomic, retain) NSNumber *yearOfEntry;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSString *insuranceImportance;
@property (nonatomic, retain) NSNumber *educSavingsGoal;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSNumber *allocatedPersonalAsset;
@property (nonatomic, retain) NSNumber *totalSavings;
@property (nonatomic, retain) NSNumber *futureCost;

+(Session_Education *) sharedSession;

@end
