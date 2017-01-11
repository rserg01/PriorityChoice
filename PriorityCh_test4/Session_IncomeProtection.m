//
//  Session_IncomeProtection.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Session_IncomeProtection.h"

@implementation Session_IncomeProtection

@synthesize activeProfileId;
@synthesize housing;
@synthesize food;
@synthesize utilities;
@synthesize transportation;
@synthesize entertainment;
@synthesize clothing;
@synthesize savings;
@synthesize medical;
@synthesize education;
@synthesize householdHelp;
@synthesize contribution;
@synthesize others;

@synthesize interestRate;
@synthesize insuranceNeed;
@synthesize disabilityNeed;
@synthesize protectionGoal;
@synthesize budget;
@synthesize notes;


static  Session_IncomeProtection* _session = nil;

+(Session_IncomeProtection *) sharedSession
{
	@synchronized([Session_IncomeProtection class])
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
	@synchronized([Session_IncomeProtection class])
	{
		NSAssert(_session == nil, @"Attempted to allocate a second instance of a singleton.");
		_session = [super alloc];
		return _session;
	}
	
	return nil;
}

- (void) dealloc {
    
    [activeProfileId release];
    [housing release];
    [food release];
    [utilities release];
    [transportation release];
    [entertainment release];
    [clothing release];
    [savings release];
    [medical release];
    [education release];
    [householdHelp release];
    [contribution release];
    [others release];
    
    [interestRate release];
    [insuranceNeed release];
    [disabilityNeed release];
    [protectionGoal release];
    [budget release];
    [notes release];
    
    [super dealloc];
}

@end
