//
//  Support_Education.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_Education.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import "Session_Education.h"

@implementation Support_Education

+ (NSNumber *) checkExisingEntry:(NSString *)profileId dependentId: (NSString *) dependentId
{
    NSNumber *numOfRows = nil;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT COUNT (*) "
								   @"FROM tEducFunding WHERE ClientId=%@ AND dependentId=%@", profileId, dependentId];
            
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

+ (NSMutableArray *) getEducFunding: (NSString *)profileId dependentId: (NSString *) dependentId
{
   
    NSMutableArray *arrResult = [[[NSMutableArray alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"PresentAnnualCost, "
                                   @"YearOfEntry, "
                                   @"EducBudget, "
                                   @"InsImportance, "
                                   @"EducSavingsGoal, "
                                   @"Notes, "
                                   @"AllocatedPersonalAsset "
								   @"FROM tEducFunding WHERE ClientId=%@ AND dependentId = %@", profileId, dependentId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    
                    [arrResult addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)],
                                 @"presentAnnualCost",
                                 [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)],
                                 @"yearOfEntry",
                                 [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)],
                                 @"budget",
                                 [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 3)],
                                 @"insuranceImportance",
                                 [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)],
                                 @"educSavingsGoal",
                                 [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 5)],
                                 @"notes",
                                 [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)],
                                 @"allocatedPersonalAsset",
                                 nil]];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return arrResult;
}

+ (NSString *) generateEducId
{
    NSString *newId = [[[NSString alloc]init]autorelease];
    
	sqlite3 *database = nil;
	
    if ([SQLiteManager openDatabase:&database]) //open database
	{
        NSString *sqlSelect = @"SELECT COUNT(*)+1 from tEducFunding";
        
        NSLog(@"sqlSelect: %@", sqlSelect);
        
        sqlite3_stmt *sqliteStatement;
        
        if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
            {
                newId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
            }
        }
        
        sqlite3_finalize(sqliteStatement);
        
        [SQLiteManager closeDatabase:&database];
	}
    
    return  newId;
}

+ (NSError *) newEducFunding: (NSString *)profileId dependentId: (NSString *)dependentId
{
    NSError *error = nil;
    
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tEducFunding ("
                           @"_Id, ClientId, DependentId, "
                           @"PresentAnnualCost, "
                           @"YearOfEntry, "
                           @"EducBudget, "
                           @"InsImportance, "
                           @"EducSavingsGoal, "
                           @"Notes, "
                           @"AllocatedPersonalAsset "
						   @") VALUES ("
                           @"%@, %@, %@, "
                           @"%d, %d, %d, \"%@\", %d, \"%@\", %d)",
						   [self generateEducId], profileId, dependentId,
                           0, 0, 0, @"Y", 0, @"", 0];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateEducFunding: (NSString *) profileId
                    dependentId: (NSString *) dependentId
              presentAnnualCost: (NSNumber *) presentAnnualCost
                    yearOfEntry: (NSNumber *) yearOfEntry
                         budget: (NSNumber *) budget
                  insImportance: (NSString *) insImportance
                educSavingsGoal: (NSNumber *) educSavingsGoal
                          notes: (NSString *) notes
         allocatedPersonalAsset: (NSNumber *) allocatedPersonalAsset
{
    NSError *error = nil;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tEducFunding SET "
                           @"PresentAnnualCost = %f, "
                           @"YearOfEntry = %f, "
                           @"EducBudget = %f, "
                           @"InsImportance = \"%@\", "
                           @"EducSavingsGoal = %f, "
                           @"Notes = \"%@\", "
                           @"AllocatedPersonalAsset = %f "
                           @"WHERE ClientId = %@ AND dependentId = %@",
                           [presentAnnualCost doubleValue],
                           [yearOfEntry doubleValue],
                           [budget doubleValue],
                           insImportance,
                           [educSavingsGoal doubleValue],
                           notes,
                           [allocatedPersonalAsset doubleValue],
                           profileId, dependentId];
    
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) getCurrentYear
{
    NSDateComponents *components = [[[NSDateComponents alloc]init] autorelease];
    NSNumber *year = [[[NSNumber alloc]init]autorelease];
    
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    year = [NSNumber numberWithInteger:[components year]];
    
    return year;
}

+ (NSNumber *) getFutureCost: (NSNumber *)presentCost
                 yearOfEntry: (NSNumber *)yearOfEntry
                 currentYear: (NSNumber *)currentYear
{
    NSNumber *step1 = [[[NSNumber alloc]init]autorelease];
    NSNumber *step2 = [[[NSNumber alloc]init]autorelease];
    NSNumber *step3 = [[[NSNumber alloc]init]autorelease];
    
    step1 = [NSNumber numberWithDouble:([yearOfEntry doubleValue] - [currentYear doubleValue])];
    step2 = [NSNumber numberWithDouble:(pow(1.1225, [step1 doubleValue]))];
    step3 = [NSNumber numberWithDouble:([presentCost doubleValue] * 4 * [step2 doubleValue])];
    
    
    return step3;
}

+ (NSNumber *) getSavings: (NSNumber *)allocatedAsset educPlan: (NSNumber *)educPlan
{
    return [NSNumber numberWithFloat:([allocatedAsset floatValue] + [educPlan floatValue])];
}

+ (NSNumber *) computeSavingsGoal: (NSNumber *)presentAnnualCost
                   savings: (NSNumber *)savings
{
    return [NSNumber numberWithDouble:([presentAnnualCost doubleValue] - [savings doubleValue])];
}

@end
