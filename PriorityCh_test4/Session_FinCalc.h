//
//  Session_FinCalc.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_FinCalc : NSObject {
    
}

@property (retain, nonatomic) NSString *productName;
@property (retain, nonatomic) NSNumber *bondFund;
@property (retain, nonatomic) NSNumber *equityFund;
@property (retain, nonatomic) NSNumber *stableFund;
@property (retain, nonatomic) NSNumber *apbf;
@property (retain, nonatomic) NSNumber *totalAllocation;
@property (retain, nonatomic) NSNumber *premium;
@property (retain, nonatomic) NSNumber *currency;
@property (retain, nonatomic) NSNumber *deathBenType;
@property (retain, nonatomic) NSNumber *isFel;

+(Session_FinCalc *) sharedSession;

@end
