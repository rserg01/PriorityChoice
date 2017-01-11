//
//  Session_Manucare.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_Manucare.h"

@implementation Session_Manucare

@synthesize activeProfileId;
@synthesize timeFrame;
@synthesize retirementPlan;
@synthesize needForInvestment;
@synthesize cashFlowNeeds;
@synthesize ageScore;
@synthesize investmentDrop;
@synthesize interestValue;
@synthesize returns;
@synthesize riskDegree;
@synthesize reviewFrequency;
@synthesize overallAttitude;
@synthesize arr_Answers;

static  Session_Manucare* _session = nil;

+(Session_Manucare *) sharedSession
{
	@synchronized([Session_Manucare class])
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
	@synchronized([Session_Manucare class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc {
    
    [activeProfileId release];
    [timeFrame release];
    [needForInvestment release];
    [cashFlowNeeds release];
    [investmentDrop release];
    [interestValue release];
    [returns release];
    [riskDegree release];
    [reviewFrequency release];
    [overallAttitude release];
    [ageScore release];
    [arr_Answers release];
    [super dealloc];
    
}


@end
