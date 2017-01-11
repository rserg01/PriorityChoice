//
//  Session_EstatePlanning.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_EstatePlanning.h"

@implementation Session_EstatePlanning


static  Session_EstatePlanning* _session = nil;

+(Session_EstatePlanning *) sharedSession
{
	@synchronized([Session_EstatePlanning class])
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
	@synchronized([Session_EstatePlanning class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc

{
    [_exp_funeral release];
    [_exp_judicial release];
    [_exp_estateClaims release];
    [_exp_insolvency release];
    [_exp_unpaidMortgage release];
    [_exp_medical release];
    [_exp_retirement release];
    [_exp_spouseInterest release];
    [_exp_standardDedudction release];
    [_exp_netTaxableEstate release];
    [_exp_taxRate release];
    [_budget release];
    [_notes release];
    [super dealloc];
}

@end
