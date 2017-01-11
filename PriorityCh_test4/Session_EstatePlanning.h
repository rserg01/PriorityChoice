//
//  Session_EstatePlanning.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session_EstatePlanning : NSObject {
    
}

@property (nonatomic, retain) NSNumber *exp_funeral;
@property (nonatomic, retain) NSNumber *exp_judicial;
@property (nonatomic, retain) NSNumber *exp_estateClaims;
@property (nonatomic, retain) NSNumber *exp_insolvency;
@property (nonatomic, retain) NSNumber *exp_unpaidMortgage;
@property (nonatomic, retain) NSNumber *exp_medical;
@property (nonatomic, retain) NSNumber *exp_retirement;
@property (nonatomic, retain) NSNumber *exp_spouseInterest;
@property (nonatomic, retain) NSNumber *exp_standardDedudction;
@property (nonatomic, retain) NSNumber *exp_netTaxableEstate;
@property (nonatomic, retain) NSNumber *exp_taxRate;
@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSString *notes;

+(Session_EstatePlanning *) sharedSession;

@end
