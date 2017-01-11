//
//  Support_Health.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_Health.h"
#import "Session_Health.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"
#import "GetPersonalProfile.h"

@implementation Support_Health

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
								   @"FROM tImpairedHealth WHERE _Id=%@", profileId];
            
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

+ (NSError *) getImpariedHealth: (NSString *)profileId
{
    NSError *error=nil;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"HealthProtection, "
                                   @"HospitalRoom, "
                                   @"AccidentDisabilityProtection, "
                                   @"CoverageNeeded, "
                                   @"CriticaIllnessNeed, "
                                   @"CriticalIllnessCoverage, "
                                   @"Budget, "
                                   @"EmployeeCoverage, "
                                   @"SemiPrivate, "
                                   @"SmallPrivate, "
                                   @"PrivateDeLuxe, "
                                   @"Suite, "
                                   @"MedAndNursingCare, "
                                   @"Notes "
								   @"FROM tImpairedHealth WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Health sharedSession].healthProtection =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [Session_Health sharedSession].hospitalRoom =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [Session_Health sharedSession].accidentProtection =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 3)];
                    [Session_Health sharedSession].coverageNeeded =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
                    [Session_Health sharedSession].criticalIllnessNeed =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 5)];
                    [Session_Health sharedSession].criticalIllnessCoverage =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)] ;
                    [Session_Health sharedSession].budget =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)] ;
                    [Session_Health sharedSession].employeeCoverage =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)] ;
                    [Session_Health sharedSession].semiPrivate =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 8)] ;
                    [Session_Health sharedSession].smallPrivate =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 9)] ;
                    [Session_Health sharedSession].privateDeluxe =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)] ;
                    [Session_Health sharedSession].suite =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 11)] ;
                    [Session_Health sharedSession].medAndNursingCare =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 12)] ;
                    [Session_Health sharedSession].notes =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 13)];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager sqliteExec:sqlSelect error:&error];
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return error;
}

+ (NSError *) newImpairedHealth: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tImpairedHealth ("
                           @"_Id, ClientId, "
                           @"HealthProtection, "
                           @"HospitalRoom, "
                           @"AccidentDisabilityProtection, "
                           @"CoverageNeeded, "
                           @"CriticaIllnessNeed, "
                           @"CriticalIllnessCoverage, "
                           @"Budget, "
                           @"EmployeeCoverage, "
                           @"SemiPrivate, "
                           @"SmallPrivate, "
                           @"PrivateDeLuxe, "
                           @"Suite, "
                           @"MedAndNursingCare, "
                           @"Notes"
						   @") VALUES ("
                           @"%@, %@,"
                           @"\"%@\", %d, \"%@\", %d, \"%@\", %d, %d, %d, %d, %d, %d, %d, %d, \"%@\") ",
						   profileId,profileId,
                           @"Y", 0, @"Y", 0, @"Y", 0, 0, 0, 0, 0, 0, 0, 0, @""];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateImpairedHealth: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tImpairedHealth SET "
						   @"HealthProtection = \"%@\", "
                           @"HospitalRoom = %@, "
                           @"AccidentDisabilityProtection = \"%@\", "
                           @"CoverageNeeded = %@, "
                           @"CriticaIllnessNeed = \"%@\", "
                           @"CriticalIllnessCoverage = %@, "
                           @"Budget = %@, "
                           @"EmployeeCoverage = %@, "
                           @"SemiPrivate = %@, "
                           @"SmallPrivate = %@, "
                           @"PrivateDeLuxe = %@, "
                           @"Suite = %@, "
                           @"MedAndNursingCare = %@, "
                           @"Notes = \"%@\" "
                           @"WHERE _Id = %@",
                           
                           [Session_Health sharedSession].healthPlan,
                           [Session_Health sharedSession].hospitalRoom,
                           [Session_Health sharedSession].accidentProtection,
                           [Session_Health sharedSession].coverageNeeded,
                           [Session_Health sharedSession].criticalIllnessNeed,
                           [Session_Health sharedSession].criticalIllnessCoverage,
                           [Session_Health sharedSession].budget,
                           [Session_Health sharedSession].employeeCoverage,
                           [Session_Health sharedSession].semiPrivate,
                           [Session_Health sharedSession].smallPrivate,
                           [Session_Health sharedSession].privateDeluxe,
                           [Session_Health sharedSession].suite,
                           [Session_Health sharedSession].medAndNursingCare,
                           [Session_Health sharedSession].notes,
                           profileId ];
    
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) computeTotalCurrentBenefit: (NSNumber *) medicalBenefit
                           healthBenefit: (NSNumber *) healthBenefit
{
    return [NSNumber numberWithFloat:([medicalBenefit floatValue] + [healthBenefit floatValue])];
}

+ (NSNumber *) hospitalizationBen: (NSNumber *) semiPrivate
                     smallPrivate: (NSNumber *) smallPrivate
                    privateDeLuxe: (NSNumber *) privateDeLuxe
                            suite: (NSNumber *) suite;
{
    return [NSNumber numberWithFloat:([semiPrivate floatValue] + [smallPrivate floatValue] + [privateDeLuxe floatValue] + [suite floatValue])];
}

+ (NSNumber *) computeCoverageNeeded: (NSNumber *) additionalBenefit
                      currentBenefit: (NSNumber *) currentBenefit
{
    return [NSNumber numberWithFloat:([additionalBenefit floatValue] - [currentBenefit floatValue])];

}

+ (NSNumber *) additionalBenReq: (NSNumber *) medicalBenefit
               employeeCoverage: (NSNumber *) emplyeeCoverage
               personalCoverage: (NSNumber *) personalCoverage
{
    return [NSNumber numberWithFloat:([medicalBenefit floatValue] - [emplyeeCoverage floatValue] - [personalCoverage floatValue])];
}

+ (NSNumber *) capitalRequired: (NSNumber *) nursingExpenses
               criticalIllness: (NSNumber *) criticallIllness

{
    return [NSNumber numberWithFloat:[nursingExpenses floatValue] + [criticallIllness floatValue]];
}


@end
