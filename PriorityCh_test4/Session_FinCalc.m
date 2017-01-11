//
//  Session_FinCalc.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_FinCalc.h"

@implementation Session_FinCalc

static  Session_FinCalc* _session = nil;

+(Session_FinCalc *) sharedSession
{
	@synchronized([Session_FinCalc class])
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
	@synchronized([Session_FinCalc class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc {
    [_productName release];
    [_bondFund release];
    [_equityFund release];
    [_stableFund release];
    [_apbf release];
    [_totalAllocation release];
    [_premium release];
    [_deathBenType release];
    [_currency release];
    [super dealloc];
}

@end
