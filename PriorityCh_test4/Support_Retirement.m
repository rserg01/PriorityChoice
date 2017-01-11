//
//  Support_Retirement.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/4/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_Retirement.h"
#import "Session_Retirement.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"

@implementation Support_Retirement

+ (NSNumber *) checkExisingEntry:(NSString *)profileId
{
    NSNumber *numOfRows = nil;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT COUNT (*) "
								   @"FROM tRetirementPlanning WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    numOfRows =[NSNumber numberWithInt:sqlite3_column_int(sqliteStatement, 0)] ;
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    NSLog(@"numOfRows = %@", numOfRows);
    return numOfRows;
}

+ (void) getRetirement:(NSString *)profileId
{
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"MonthlyIncomeNeeded, InflationRate, InterestRate, InsuranceNeed, AccidentDisabilityNeed, Budget, "
                                   @"RetirementAge, MarketRate, Notes, CurrentMoEarnings, ServYrsFrDateHired, ExpectedAnnInc, "
                                   @"RetBenFactor "
								   @"FROM tRetirementPlanning WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Retirement sharedSession].monthlyIncomeNeeded = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)];
                    [Session_Retirement sharedSession].inflationRate = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)];
                    [Session_Retirement sharedSession].interestRate = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)];
                    [Session_Retirement sharedSession].insuranceNeeded = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)];
                    [Session_Retirement sharedSession].needForInsurance = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 4)];
                    [Session_Retirement sharedSession].budget = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)];
                    [Session_Retirement sharedSession].retirementAge = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)];
                    [Session_Retirement sharedSession].marketRate = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)];
                    [Session_Retirement sharedSession].notes = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 8)];
                    [Session_Retirement sharedSession].currentMonthlyEarning = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 9)];
                    [Session_Retirement sharedSession].serviceYearsFrDateHired = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)];
                    [Session_Retirement sharedSession].expectedAnnualIncrease = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 11)];
                    [Session_Retirement sharedSession].retirementBenefitFactor = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 12)];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
}

+ (NSError *) newRetirement: (NSString *)profileId

{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tRetirementPlanning ("
                           @"_Id, ClientId, "
                           @"MonthlyIncomeNeeded, InflationRate, InterestRate, InsuranceNeed, AccidentDisabilityNeed, Budget, "
                           @"RetirementAge, MarketRate, Notes, CurrentMoEarnings, ServYrsFrDateHired, ExpectedAnnInc, "
                           @"RetBenFactor "
						   @") VALUES ("
                           @"%@, %@,"
                           @"%d, %d, %d, \"%@\", %d, %d, "
                           @"%d, %d, \"%@\", %d, %d, %d, %d)",
						   profileId,profileId,
                           0, 0, 0, @"Y", 0, 0, 0, 0, @"", 0, 0, 0, 0];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateRetirement:(NSString *)profileId

{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tRetirementPlanning SET "
						   @"MonthlyIncomeNeeded = %@, "
                           @"InflationRate = %@,"
                           @"InterestRate = %@, "
                           @"InsuranceNeed = \"%@\", "
                           @"AccidentDisabilityNeed = \"%@\", "
                           @"Budget = %@, "
                           @"RetirementAge =%@, "
                           @"MarketRate = %@, "
                           @"Notes = \"%@\", "
                           @"CurrentMoEarnings = %@, "
                           @"ServYrsFrDateHired = %@, "
                           @"ExpectedAnnInc =%@, "
                           @"RetBenFactor = %@ "
                           @"WHERE _Id = %@",
                           [Session_Retirement sharedSession].monthlyIncomeNeeded,
                           [Session_Retirement sharedSession].inflationRate,
                           [Session_Retirement sharedSession].interestRate,
                           [Session_Retirement sharedSession].disability,
                           [Session_Retirement sharedSession].needForInsurance,
                           [Session_Retirement sharedSession].budget,
                           [Session_Retirement sharedSession].retirementAge,
                           [Session_Retirement sharedSession].marketRate,
                           [Session_Retirement sharedSession].notes,
                           [Session_Retirement sharedSession].currentMonthlyEarning,
                           [Session_Retirement sharedSession].serviceYearsFrDateHired,
                           [Session_Retirement sharedSession].expectedAnnualIncrease,
                           [Session_Retirement sharedSession].retirementBenefitFactor,
                           profileId ];

	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
    
}

+ (NSDate *) getBirthdate:(NSString *)birthdate

{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"mm/dd/yyyy"];
    NSDate *birthdDte = [dateFormat dateFromString:birthdate];
    [dateFormat release];
    
    return birthdDte;
    
}

+ (NSNumber *) getCurrentAge: (NSDate *) birthDate

{
    NSNumber *currentAge = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:birthDate];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return currentAge = [NSNumber numberWithInt:[dateComponentsNow year] - [dateComponentsBirth year] - 1] ;
    } else {
        return currentAge = [NSNumber numberWithInt: [dateComponentsNow year] - [dateComponentsBirth year]];
    }
}

+ (NSNumber *) getYearsBeforeRetirement: (NSNumber *)currentAge
                          retirementAge: (NSNumber *)retirementAge
{
    return [NSNumber numberWithInt:([retirementAge intValue] - [currentAge intValue])];
}

+ (NSNumber *) getDesiredAnnualIncome:(NSNumber *)monthlyIncomeNeeded
{
    return [NSNumber numberWithDouble:([monthlyIncomeNeeded doubleValue] * 12)];
}

+ (NSNumber *) getAnnualIncomeAtRetirement:(NSNumber *)inflationRate
                             retirementYears:(NSNumber *)retirementYears
                   desiredIncomeRetirement:(NSNumber *)desiredIncomeRetirement

{
    NSNumber *_inflationRate = [[[NSNumber alloc]init]autorelease];
    NSNumber *_retirementYears = [[[NSNumber alloc]init]autorelease];
    NSNumber *_desiredIncomeAtRetirement = [[[NSNumber alloc]init]autorelease];
    
    _inflationRate = inflationRate;
    _retirementYears = retirementYears;
    _desiredIncomeAtRetirement = desiredIncomeRetirement;
    
    NSNumber *factor1 = [[[NSNumber alloc]init]autorelease];
    NSNumber *factor2 = [[[NSNumber alloc]init]autorelease];
    NSNumber *factor3 = [[[NSNumber alloc]init]autorelease];
    
    factor1 = [NSNumber numberWithDouble:(1+[inflationRate floatValue])];

    factor2 = [NSNumber numberWithFloat:(pow([factor1 floatValue], round([retirementYears floatValue])))];

    factor3 = [NSNumber numberWithFloat:([desiredIncomeRetirement floatValue] * [factor2 floatValue])];
    
    return factor3;
}

+ (NSNumber *) getRetirementBenefitFactor: (NSNumber *) selectedIndex
{
    NSNumber *retBenFactor=nil;
    
    switch ([selectedIndex intValue]) {
        case 0:
            retBenFactor = [NSNumber numberWithDouble:.5];
            break;
        case 1:
            retBenFactor = [NSNumber numberWithDouble:.75];
            break;
        case 2:
            retBenFactor = [NSNumber numberWithDouble:1];
            break;
        case 3:
            retBenFactor = [NSNumber numberWithDouble:1.25];
            break;
        case 4:
            retBenFactor = [NSNumber numberWithDouble:1.5];
            break;
        case 5:
            retBenFactor = [NSNumber numberWithDouble:1.75];
            break;
        case 6:
            retBenFactor = [NSNumber numberWithDouble:2];
            break;
        case 7:
            retBenFactor = [NSNumber numberWithDouble:2.25];
            break;
        case 8:
            retBenFactor = [NSNumber numberWithDouble:2.5];
            break;
        case 9:
            retBenFactor = [NSNumber numberWithDouble:2.75];
            break;
        default:
            break;
    }
    
    return retBenFactor;
    
}

+ (NSNumber *) getCapitalRequired: (NSNumber *) marketRate
                    retirementAge: (NSNumber *) retirementAge
            annIncomeAtRetirement: (NSNumber *) annIncomeAtRetirement
{
    retirementAge = [NSNumber numberWithDouble:round([retirementAge doubleValue])] ;
    
    NSNumber *factor1 = [NSNumber numberWithFloat:(1+[marketRate floatValue])];
    NSNumber *factor2 = [NSNumber numberWithFloat:(90 - [retirementAge floatValue])];
    NSNumber *factor3 = [NSNumber numberWithFloat:(pow([factor1 floatValue], [factor2 floatValue]))];
    NSNumber *factor4 = [NSNumber numberWithFloat:(1/[factor3 floatValue])];
    NSNumber *factor5 = [NSNumber numberWithFloat:(1 - [factor4 floatValue])];
    NSNumber *factor6 = [NSNumber numberWithFloat:([annIncomeAtRetirement floatValue] * [factor5 floatValue])];
    NSNumber *factor7 = [NSNumber numberWithFloat:([factor6 floatValue]/ [marketRate floatValue])];
    
    return factor7;
}


+ (NSNumber *) getExpectedRetirementBenefit: (NSNumber *) currentMonthlyEarnings
                              retirementYears: (NSNumber *) retirementYears
                        servYearsFrHireDate: (NSNumber *) servYearsFrHireDate
                        retirementBenFactor: (NSNumber *) retirementBenFactor
                        expectedAnnIncrease: (NSNumber *) expectedAnnIncrease
{
    expectedAnnIncrease = [NSNumber numberWithFloat:([expectedAnnIncrease floatValue]/100)];

    NSNumber *factor1 = [NSNumber numberWithFloat:(powf((1+[expectedAnnIncrease floatValue]), [retirementYears floatValue]))];
   
    NSNumber *factor2 = [NSNumber numberWithFloat:([factor1 floatValue] * [currentMonthlyEarnings floatValue])];

    NSNumber *factor3 = [NSNumber numberWithFloat:([factor2 floatValue] * [servYearsFrHireDate floatValue] * [retirementBenFactor floatValue])];
    
    return factor3;
    
}

+ (NSNumber *) getRetirementgap: (NSNumber *)capitalRequired
          expectedRetirementBen: (NSNumber *)expectedRetirementBen
{
    return [NSNumber numberWithDouble:([capitalRequired doubleValue] - [expectedRetirementBen doubleValue])];
}





@end
