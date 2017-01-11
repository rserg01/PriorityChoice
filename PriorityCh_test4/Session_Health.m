//
//  Session_Health.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_Health.h"

@implementation Session_Health

@synthesize healthProtection;
@synthesize hospitalRoom;
@synthesize accidentProtection;
@synthesize coverageNeeded;
@synthesize criticalIllnessNeed;
@synthesize criticalIllnessCoverage;
@synthesize budget;
@synthesize employeeCoverage;
@synthesize semiPrivate;
@synthesize smallPrivate;
@synthesize privateDeluxe;
@synthesize suite;
@synthesize medAndNursingCare;
@synthesize notes;

static  Session_Health* _session = nil;

+(Session_Health *) sharedSession
{
	@synchronized([Session_Health class])
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
	@synchronized([Session_Health class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void)dealloc
{
    [healthProtection release];
    [hospitalRoom release];
    [accidentProtection release];
    [coverageNeeded release];
    [criticalIllnessNeed release];
    [criticalIllnessCoverage release];
    [budget release];
    [employeeCoverage release];
    [semiPrivate release];
    [smallPrivate release];
    [privateDeluxe release];
    [suite release];
    [medAndNursingCare release];
    [notes release];
    [super dealloc];
}

@end
