//
//  Support_IncomeProtection.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/29/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_IncomeProtection.h"
#import "Session_IncomeProtection.h"
#import "SQLiteManager.h"
#import <sqlite3.h>

@implementation Support_IncomeProtection

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
								   @"FROM tIncomeProtection WHERE _Id=%@", profileId];
            
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

+ (BOOL) getIncomeProtection

{
    BOOL retVal = NO;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"Housing, Food, Utilities, Tranpo, Clothing, Entertainment, "
                                   @"SavingsPerMonth, Medical, Education, Contribution, HouseholdHelp, OtherExp, "
                                   @"AssumedAnnualIntRate, InsuranceNeed, AccidentDisabilityNeed, ProtectionGoal, Budget, Notes "
								   @"FROM tIncomeProtection WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_IncomeProtection sharedSession].housing =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [Session_IncomeProtection sharedSession].food =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [Session_IncomeProtection sharedSession].utilities =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [Session_IncomeProtection sharedSession].transportation =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                    [Session_IncomeProtection sharedSession].clothing =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
                    [Session_IncomeProtection sharedSession].entertainment =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)] ;
                    [Session_IncomeProtection sharedSession].savings =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)] ;
                    [Session_IncomeProtection sharedSession].medical =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)] ;
                    [Session_IncomeProtection sharedSession].education =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 8)] ;
                    [Session_IncomeProtection sharedSession].contribution =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 9)] ;
                    [Session_IncomeProtection sharedSession].householdHelp =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)] ;
                    [Session_IncomeProtection sharedSession].others =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 11)] ;
                    
                    [Session_IncomeProtection sharedSession].interestRate =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 12)] ;
                    [Session_IncomeProtection sharedSession].insuranceNeed = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 13)];
                    [Session_IncomeProtection sharedSession].disabilityNeed =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 14)];
                    [Session_IncomeProtection sharedSession].protectionGoal =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 15)] ;
                    [Session_IncomeProtection sharedSession].budget =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 16)] ;
                    [Session_IncomeProtection sharedSession].notes =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 17)];
                    
                    retVal = YES;
				}
			}
            
            NSLog(@"%d",[[Session_IncomeProtection sharedSession].housing intValue]);
            
            [FNASession sharedSession].totalPersonalAssets = [NSNumber numberWithDouble:
                                                              ([[Session_IncomeProtection sharedSession].housing doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].food doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].utilities doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].transportation doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].clothing doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].entertainment doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].savings doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].medical doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].education doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].contribution doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].householdHelp doubleValue] +
                                                               [[Session_IncomeProtection sharedSession].others doubleValue])];
            
            NSLog(@"TotalPersonalAsset = %@", [FNASession sharedSession].totalPersonalAssets);
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return retVal;
    
}

+ (NSNumber *) getMonthlyExpense

{
    NSNumber *monthlyExpense = [NSNumber numberWithDouble:([[Session_IncomeProtection sharedSession].housing doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].food doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].utilities doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].transportation doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].clothing doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].entertainment doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].savings doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].medical doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].education doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].contribution doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].householdHelp doubleValue] +
                                                           [[Session_IncomeProtection sharedSession].others doubleValue])];
                               
    
    return monthlyExpense;
}

+ (NSNumber *) getAnnualExpense:(NSNumber *)monthlyExpense

{
    NSNumber *annualExpense = [NSNumber numberWithDouble:[monthlyExpense doubleValue] * 12];
    
    return  annualExpense;
}

+ (NSNumber *) capitalRequired:(NSNumber *)annualExpense
           assumedInterestRate:(NSNumber *)assumedInterestRate

{
    float intRate = [assumedInterestRate floatValue];
    intRate = roundf(intRate * 100) / 100;
    
    NSNumber *roundedIntRate = [[[NSNumber alloc]init]autorelease];
    NSNumber *capitalRequired = [[[NSNumber alloc]init]autorelease];
    
    roundedIntRate = [NSNumber numberWithDouble:intRate];
    capitalRequired = [NSNumber numberWithDouble:[annualExpense doubleValue] / [roundedIntRate doubleValue]];
    
    
    return capitalRequired;
}

+ (NSNumber *) getProtectionGoal:(NSNumber *)capitalRequired
                  totalInsurance:(NSNumber *)totalInsurance
                     totalAssets:(NSNumber *)totalAssets
{
    NSNumber *protectionGoal = [NSNumber numberWithDouble:[capitalRequired doubleValue] - [totalInsurance doubleValue] - [totalAssets doubleValue]];
    
    return  protectionGoal;
}

+ (NSError *) newIncomeProtection: (NSString *)profileId
                          housing:(NSNumber *)housing
                             food:(NSNumber *)food
                        utilities:(NSNumber *)utilities
                          transpo:(NSNumber *)transpo
                         clothing:(NSNumber *)clothing
                    entertainment:(NSNumber *)entertainment
                          savings:(NSNumber *)savings
                          medical:(NSNumber *)medical
                        education:(NSNumber *)education
                     contribution:(NSNumber *)contribution
                    householdHelp:(NSNumber *)householdHelp
                           others:(NSNumber *)others
                     interestRate:(NSNumber *)interestRate
                    insuranceNeed:(NSString *)insuranceNeed
                   disabilityNeed:(NSString *)disabilityNeed
                   protectionGoal:(NSNumber *)protectionGoal
                           budget:(NSNumber *)budget
                            notes: (NSString *)notes

{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tIncomeProtection ("
                           @"_Id, ClientId, "
						   @"Housing, Food, "
                           @"Utilities, Tranpo, "
                           @"Clothing, Entertainment, "
                           @"SavingsPerMonth, Medical, "
                           @"Education, Contribution, "
                           @"HouseholdHelp, OtherExp, "
                           @"AssumedAnnualIntRate, InsuranceNeed, "
                           @"AccidentDisabilityNeed, ProtectionGoal, "
                           @"Budget, Notes"
						   @") VALUES ("
                           @"%@, %@,"
                           @"%@, %@, "
                           @"%@, %@, "
                           @"%@, %@, "
                           @"%@, %@, "
                           @"%@, %@, "
                           @"%@, %@, "
                           @"%@, \"%@\", "
                           @"\"%@\", %@, "
                           @"%@,\"%@\")",
						   profileId,profileId,
                           housing,food,
                           utilities,transpo,
                           clothing,entertainment,
                           savings,medical,
                           education,contribution,
                           householdHelp, others,
                           interestRate, insuranceNeed,
                           disabilityNeed, protectionGoal,
                           budget, notes];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateIncomeProtection

{
    NSError *error = nil;
    
    NSString *profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tIncomeProtection SET "
						   @"Housing = %@, "
                           @"Food = %@,"
                           @"Utilities = %@, "
                           @"Tranpo = %@, "
                           @"Clothing = %@, "
                           @"Entertainment = %@, "
                           @"SavingsPerMonth =%@, "
                           @"Medical = %@, "
                           @"Education = %@, "
                           @"Contribution = %@, "
                           @"HouseholdHelp = %@, "
                           @"OtherExp =%@, "
                           @"AssumedAnnualIntRate = %@, "
                           @"InsuranceNeed = \"%@\", "
                           @"AccidentDisabilityNeed = \"%@\", "
                           @"ProtectionGoal = %@, "
                           @"Budget = %@, "
                           @"Notes = \"%@\" "
                           @"WHERE _Id = %@",
                           [Session_IncomeProtection sharedSession].housing,
                           [Session_IncomeProtection sharedSession].food,
                           [Session_IncomeProtection sharedSession].utilities,
                           [Session_IncomeProtection sharedSession].transportation,
                           [Session_IncomeProtection sharedSession].clothing,
                           [Session_IncomeProtection sharedSession].entertainment,
                           [Session_IncomeProtection sharedSession].savings,
                           [Session_IncomeProtection sharedSession].medical,
                           [Session_IncomeProtection sharedSession].education,
                           [Session_IncomeProtection sharedSession].contribution,
                           [Session_IncomeProtection sharedSession].householdHelp,
                           [Session_IncomeProtection sharedSession].others,
                           [Session_IncomeProtection sharedSession].interestRate,
                           [Session_IncomeProtection sharedSession].insuranceNeed,
                           [Session_IncomeProtection sharedSession].disabilityNeed,
                           [Session_IncomeProtection sharedSession].protectionGoal,
                           [Session_IncomeProtection sharedSession].budget,
                           [Session_IncomeProtection sharedSession].notes,
                           profileId ];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}


@end
