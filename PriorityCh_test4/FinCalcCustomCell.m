//
//  FinCalcCustomCell.m
//  FNA_20120319
//
//  Created by Manulife on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FinCalcCustomCell.h"

@implementation FinCalcCustomCell
@synthesize lblYear;
@synthesize lblAge;
@synthesize lblAcctValue;
@synthesize lblDeathBen;



- (void)dealloc 
{	
    [lblYear release];
    [lblAge release];
    [lblAcctValue release];
    [lblDeathBen release];
    [super dealloc];
}


@end

