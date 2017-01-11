//
//  Session_Education.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_Education.h"

@implementation Session_Education


static  Session_Education* _session = nil;

+(Session_Education *) sharedSession
{
	@synchronized([Session_Education class])
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
	@synchronized([Session_Education class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc
{
    [_presentAnnualCost release];
    [_yearOfEntry release];
    [_budget release];
    [_insuranceImportance release];
    [_educSavingsGoal release];
    [_notes release];
    [_allocatedPersonalAsset release];
    [_totalSavings release];
    [_futureCost release];
    [super dealloc];
}

@end
