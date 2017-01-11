//
//  Session_Investment.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_Investment.h"

@implementation Session_Investment

@synthesize prEmergencyFund;
@synthesize prRetirement;
@synthesize prNewHome;
@synthesize prNewCar;
@synthesize prHoliday;
@synthesize prLegacy;
@synthesize prEstateTax;
@synthesize savingCategory;
@synthesize workingInvestment;
@synthesize investmentRequired;
@synthesize budget;
@synthesize investmentNeeded;
@synthesize notes;
@synthesize costOfSavings;
@synthesize prBusiness;
@synthesize riskCapacity;
@synthesize riskAttitude;

static  Session_Investment* _session = nil;

+(Session_Investment *) sharedSession
{
	@synchronized([Session_Investment class])
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
	@synchronized([Session_Investment class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc {
    
    [prEmergencyFund release];
    [prRetirement release];
    [prNewHome release];
    [prNewCar release];
    [prHoliday release];
    [prLegacy release];
    [prEstateTax release];
    [savingCategory release];
    [workingInvestment release];
    [investmentRequired release];
    [budget release];
    [investmentNeeded release];
    [notes release];
    [costOfSavings release];
    [prBusiness release];
    [riskAttitude release];
    [riskCapacity release];
    [super dealloc];
}

@end
