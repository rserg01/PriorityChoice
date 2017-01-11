//
//  Support_Investment.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/6/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_Investment.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"
#import "Session_Investment.h"
#import "GetPersonalProfile.h"

@implementation Support_Investment

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
								   @"FROM tFundAccumulation WHERE _Id=%@", profileId];
            
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

+ (void) getInvestment: (NSString *)profileId
{
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"prEmergencyFund, "
                                   @"prRetirement, "
                                   @"prNewHome, "
                                   @"prNewCar, "
                                   @"prHoliday, "
                                   @"prLegacy, "
                                   @"prEstateTax, "
                                   @"prBusiness, "
                                   @"SavingCategory, "
                                   @"WorkingInvestment, "
                                   @"InvestmentRequired, "
                                   @"Budget, "
                                   @"CostOfSavings "
								   @"FROM tFundAccumulation WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Investment sharedSession].prEmergencyFund = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)];
                    [Session_Investment sharedSession].prRetirement = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)];
                    [Session_Investment sharedSession].prNewHome = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)];
                    [Session_Investment sharedSession].prNewCar = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)];
                    [Session_Investment sharedSession].prHoliday = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)];
                    [Session_Investment sharedSession].prLegacy = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)];
                    [Session_Investment sharedSession].prEstateTax = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)];
                    [Session_Investment sharedSession].prBusiness = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)];
                    [Session_Investment sharedSession].savingCategory = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 8)];
                    [Session_Investment sharedSession].workingInvestment = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 9)];
                    [Session_Investment sharedSession].investmentRequired = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)];
                    [Session_Investment sharedSession].budget = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 11)];
                    [Session_Investment sharedSession].costOfSavings = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 12)];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
}

+ (NSError *) newInvestment: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tFundAccumulation ("
                           @"_Id, ClientId, "
                           @"prEmergencyFund, prRetirement, prNewHome, prNewCar, prHoliday, prLegacy, prEstateTax, prBusiness, "
                           @"SavingCategory, WorkingInvestment, InvestmentRequired, Budget, InvestmentNeed, Notes, CostOfSavings, "
                           @"RiskCapacity, RiskAttitude "
						   @") VALUES ("
                           
                           @"%@, %@,"
                           
                           @"%d, %d, %d, %d, %d, %d, %d, %d, "
                           
                           @"\"%@\", \"%@\", %d, %d, \"%@\", \"%@\", %d, "
                           
                           @"\"%@\", \"%@\" "
                           
                           @")",
						   profileId,profileId,
                           0, 0, 0, 0, 0, 0, 0, 0,
                           @"1", @"", 0, 0, @"", @"", 0,
                           @"", @""];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateInvestment: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tFundAccumulation SET "
						   @"prEmergencyFund = %@, "
                           @"prRetirement = %@, "
                           @"prNewHome = %@, "
                           @"prNewCar = %@, "
                           @"prHoliday = %@, "
                           @"prLegacy = %@, "
                           @"prEstateTax = %@, "
                           @"prBusiness = %@, "
                           @"SavingCategory = \"%@\", "
                           @"WorkingInvestment = \"%@\", "
                           @"InvestmentRequired = %@, "
                           @"Budget = %@, "
                           @"CostOfSavings = %@ "
                           @"WHERE _Id = %@",
                           [Session_Investment sharedSession].prEmergencyFund,
                           [Session_Investment sharedSession].prRetirement,
                           [Session_Investment sharedSession].prNewHome,
                           [Session_Investment sharedSession].prNewCar,
                           [Session_Investment sharedSession].prHoliday,
                           [Session_Investment sharedSession].prLegacy,
                           [Session_Investment sharedSession].prEstateTax,
                           [Session_Investment sharedSession].prBusiness,
                           [Session_Investment sharedSession].savingCategory,
                           [Session_Investment sharedSession].workingInvestment,
                           [Session_Investment sharedSession].investmentRequired,
                           [Session_Investment sharedSession].budget,
                           [Session_Investment sharedSession].costOfSavings,
                           profileId ];
    
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) getTotalSavingsPlan: (NSNumber *) emergencyFund
                        retirement: (NSNumber *) retirement
                           newHome: (NSNumber *) newHome
                            newCar: (NSNumber *) newCar
                           holiday: (NSNumber *) holiday
                          business: (NSNumber *) business
                            legacy: (NSNumber *) legacy
                         estateTax: (NSNumber *) estateTax
{
    return [NSNumber numberWithDouble:([emergencyFund doubleValue] +
                                       [retirement doubleValue] +
                                       [newHome doubleValue] +
                                       [newCar doubleValue] +
                                       [holiday doubleValue] +
                                       [business doubleValue] +
                                       [legacy doubleValue] +
                                       [estateTax doubleValue])];
}

+ (NSNumber *) getTotalInvestments
{
    return [GetPersonalProfile getTotalPersonalAssets: [FNASession sharedSession].profileId];
}

+ (NSNumber *) getInvestmentRequired: (NSNumber *) totalSavingsPlan
           currentInvestments: (NSNumber *) currentInvestments
{
    return [NSNumber numberWithFloat:([totalSavingsPlan floatValue] - [currentInvestments floatValue])];
}

- (void) dealloc
{
    [super dealloc];
}

@end
