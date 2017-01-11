//
//  FNASession.m
//  FNA
//
//  Created by Hermoso Cariaga on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FNASession.h"

@implementation FNASession 

@synthesize profileId, agentCode, dependentId, age, name;
@synthesize clientFirstName;
@synthesize clientLastName;
@synthesize clientMiddleName;
@synthesize clientDob;
@synthesize clientAddress1;
@synthesize clientAddress2;
@synthesize clientAddress3;
@synthesize clientLandLine;
@synthesize clientMobile;
@synthesize clientOfficeTelNum;
@synthesize clientEmail;
@synthesize clientGender;
@synthesize clientOccupation;
@synthesize clientOfficeAdd1;
@synthesize clientOfficeAdd2;
@synthesize clientOfficeAdd3;
@synthesize clientSoleProp;
@synthesize clientCorporation;
@synthesize clientPartnership;
@synthesize clientLifeInsurance;
@synthesize clientHealthInsurance;
@synthesize clientDisabilityInsurance;
@synthesize clientPrimaryResidence;
@synthesize clientVacationresidence;
@synthesize clientRentalProperty;
@synthesize clientLand;
@synthesize clientSavings;
@synthesize clientCurrent;
@synthesize clientBonds;
@synthesize clientStocks;
@synthesize clientCollectibles;
@synthesize clientMutual;
@synthesize clientIv;
@synthesize clientSalt;
@synthesize loginFailedCount;

@synthesize totalPersonalAssets;
@synthesize totalInsurance;
@synthesize totalBusiness;
@synthesize totalRealProperty;

@synthesize selectedController;
@synthesize selectedMainMenu;
@synthesize selectedProduct;

@synthesize arrProfiles, arrDependents, activationErrors, finCalcErrors;

@synthesize agentEmail;
@synthesize agentFullName;

@synthesize dependentDob, dependentName, dependentRelationship;

@synthesize recordsForPurging;

static FNASession* _session = nil;

#pragma mark -
#pragma mark Memory Management

+(FNASession *) sharedSession
{
	@synchronized([FNASession class])
	{
		if (!_session)
		{
			_session	= [[self alloc] init];									
		}
		return _session;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([FNASession class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc 
{
	[profileId release];
    [clientFirstName release];
    [clientLastName release];
    [clientMiddleName release];
    [clientDob release];
    [clientAddress1 release];
    [clientAddress2 release];
    [clientAddress3 release];
    [clientLandLine release];
    [clientMobile release];
    [clientOfficeTelNum release];
    [clientEmail release];
    [clientGender release];
    [clientOccupation release];
    [clientOfficeAdd1 release];
    [clientOfficeAdd2 release];
    [clientOfficeAdd3 release];
    [clientSoleProp release];
    [clientPartnership release];
    [clientCorporation release];
    [clientLifeInsurance release];
    [clientHealthInsurance release];
    [clientDisabilityInsurance release];
    [clientPrimaryResidence release];
    [clientVacationresidence release];
    [clientRentalProperty release];
    [clientLand release];
    [clientSavings release];
    [clientCurrent release];
    [clientBonds release];
    [clientStocks release];
    [clientMutual release];
    [clientCollectibles release];
    [clientIv release];
    [clientSalt release];
    [loginFailedCount release];
    
    [totalPersonalAssets release];
    [totalInsurance release];
    [totalBusiness release];
    [totalRealProperty release];
    
    [name release];
	[agentCode release];
	[dependentId release];
    [age release];
    
    [selectedController release];
    [selectedMainMenu release];
    [selectedProduct release];
    
    [arrProfiles release];
    [finCalcErrors release];
    [arrDependents release];
    [activationErrors release];
    
    [agentEmail release];
    [agentFullName release];
    
    [recordsForPurging release];
    
    [super dealloc];
}


@end
