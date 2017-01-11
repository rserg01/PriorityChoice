//
//  Session_Retirement.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/4/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_Retirement.h"

@implementation Session_Retirement

@synthesize monthlyIncomeNeeded;
@synthesize inflationRate;
@synthesize interestRate;
@synthesize insuranceNeeded;
@synthesize needForInsurance;
@synthesize disability;
@synthesize budget;
@synthesize retirementAge;
@synthesize marketRate;
@synthesize notes;
@synthesize currentMonthlyEarning;
@synthesize serviceYearsFrDateHired;
@synthesize expectedAnnualIncrease;
@synthesize retirementBenefitFactor;

static  Session_Retirement* _session = nil;

+(Session_Retirement *) sharedSession
{
	@synchronized([Session_Retirement class])
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
	@synchronized([Session_Retirement class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

-(void) dealloc {
    
    [monthlyIncomeNeeded release];
    [inflationRate release];
    [interestRate release];
    [insuranceNeeded release];
    [disability release];
    [needForInsurance release];
    [budget release];
    [retirementAge release];
    [marketRate release];
    [notes release];
    [currentMonthlyEarning release];
    [serviceYearsFrDateHired release];
    [expectedAnnualIncrease release];
    [retirementBenefitFactor release];
    [super dealloc];
    
}

@end
