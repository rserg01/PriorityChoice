//
//  FNASession.h
//  FNA
//
//  Created by Hermoso Cariaga on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FNASession : NSObject 
{
	NSString *profileId;
	NSString *clientFirstName;
    NSString *clientLastName;
    NSString *clientMiddleName;
    NSString *clientDob;
    NSString *clientAddress1;
    NSString *clientAddress2;
    NSString *clientAddress3;
    NSString *clientLandLine;
    NSString *clientMobile;
    NSString *clientOfficeTelNum;
    NSString *clientEmail;
    NSString *clientGender;
    NSString *clientOccupation;
    NSString *clientOfficeAdd1;
    NSString *clientOfficeAdd2;
    NSString *clientOfficeAdd3;
    NSNumber *clientSoleProp;
    NSNumber *clientPartnership;
    NSNumber *clientCorporation;
    NSNumber *clientLifeInsurance;
    NSNumber *clientHealthInsurance;
    NSNumber *clientDisabilityInsurance;
    NSNumber *clientPrimaryResidence;
    NSNumber *clientVacationresidence;
    NSNumber *clientRentalProperty;
    NSNumber *clientLand;
    NSNumber *clientSavings;
    NSNumber *clientCurrent;
    NSNumber *clientBonds;
    NSNumber *clientStocks;
    NSNumber *clientMutual;
    NSNumber *clientCollectibles;
    NSString *clientIv;
    NSString *clientSalt;
    
    NSNumber *totalPersonalAssets;
    NSNumber *totalRealProperty;
    NSNumber *totalBusiness;
    NSNumber *totalInsurance;
    
	NSString *agentCode;
	NSString *dependentId;
    NSNumber *age;
    NSString *name;
    
    NSString *selectedController;
    
    NSNumber *recordsForPurging;
}

@property(nonatomic, retain) NSString *profileId;
@property(nonatomic, retain) NSString *clientFirstName;
@property(nonatomic, retain) NSString *clientLastName;
@property(nonatomic, retain) NSString *clientMiddleName;
@property(nonatomic, retain) NSString *clientDob;
@property(nonatomic, retain) NSString *clientAddress1;
@property(nonatomic, retain) NSString *clientAddress2;
@property(nonatomic, retain) NSString *clientAddress3;
@property(nonatomic, retain) NSString *clientLandLine;
@property(nonatomic, retain) NSString *clientMobile;
@property(nonatomic, retain) NSString *clientOfficeTelNum;
@property(nonatomic, retain) NSString *clientEmail;
@property(nonatomic, retain) NSString *clientGender;
@property(nonatomic, retain) NSString *clientOccupation;
@property(nonatomic, retain) NSString *clientOfficeAdd1;
@property(nonatomic, retain) NSString *clientOfficeAdd2;
@property(nonatomic, retain) NSString *clientOfficeAdd3;
@property(nonatomic, assign) NSNumber *clientSoleProp;
@property(nonatomic, retain) NSNumber *clientCorporation;
@property(nonatomic, retain) NSNumber *clientPartnership;
@property(nonatomic, retain) NSNumber *clientLifeInsurance;
@property(nonatomic, retain) NSNumber *clientHealthInsurance;
@property(nonatomic, retain) NSNumber *clientDisabilityInsurance;
@property(nonatomic, retain) NSNumber *clientPrimaryResidence;
@property(nonatomic, retain) NSNumber *clientVacationresidence;
@property(nonatomic, retain) NSNumber *clientRentalProperty;
@property(nonatomic, retain) NSNumber *clientLand;
@property(nonatomic, retain) NSNumber *clientSavings;
@property(nonatomic, retain) NSNumber *clientCurrent;
@property(nonatomic, retain) NSNumber *clientBonds;
@property(nonatomic, retain) NSNumber *clientStocks;
@property(nonatomic, retain) NSNumber *clientMutual;
@property(nonatomic, retain) NSNumber *clientCollectibles;
@property(nonatomic, retain) NSString *clientIv;
@property(nonatomic, retain) NSString *clientSalt;
@property(nonatomic, retain) NSNumber *loginFailedCount;

@property(nonatomic, retain) NSNumber *totalPersonalAssets;
@property(nonatomic, retain) NSNumber *totalRealProperty;
@property(nonatomic, retain) NSNumber *totalBusiness;
@property(nonatomic, retain) NSNumber *totalInsurance;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *agentCode;
@property(nonatomic, retain) NSString *agentEmail;
@property(nonatomic, retain) NSString *agentFullName;
@property(nonatomic, retain) NSString *dependentId;
@property(nonatomic, retain) NSNumber *age;

@property(nonatomic, retain) NSMutableArray *arrProfiles;
@property(nonatomic, retain) NSMutableArray *finCalcErrors;
@property(nonatomic, retain) NSMutableArray *arrDependents;
@property(nonatomic, retain) NSMutableArray *activationErrors;

@property(nonatomic, retain) NSString *selectedController; //used in Priority Choice
@property(nonatomic, retain) NSString *selectedMainMenu; //used in MainTabController
@property(nonatomic, retain) NSString *selectedProduct; //used in Products

@property(nonatomic, retain) NSString *dependentName;
@property(nonatomic, retain) NSString *dependentDob;
@property(nonatomic, retain) NSString *dependentRelationship;

@property(nonatomic, retain) NSNumber *recordsForPurging;

+(FNASession *) sharedSession;

@end
