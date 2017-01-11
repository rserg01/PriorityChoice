//
//  Support_EstatePlanning.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/13/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_EstatePlanning.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"
#import "Session_EstatePlanning.h"
#import "GetPersonalProfile.h"

@implementation Support_EstatePlanning

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
								   @"FROM tEstatePlanning WHERE _Id=%@", profileId];
            
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

+ (NSError *) getEstatePlanning: (NSString *)profileId
{
    NSError *error=nil;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"FuneralExp, "
                                   @"JudicialExp, "
                                   @"EstateClaims, "
                                   @"InsolvencyClaim, "
                                   @"UnpaidMortgage, "
                                   @"MedicalExp, "
                                   @"RetirementBen, "
                                   @"SpouseInterestToEstate, "
                                   @"StandardDeduction, "
                                   @"NetTaxableEstate, "
                                   @"TaxRate, "
                                   @"Budget, "
                                   @"Notes "
								   @"FROM tEstatePlanning WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_EstatePlanning sharedSession].exp_funeral =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [Session_EstatePlanning sharedSession].exp_judicial =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [Session_EstatePlanning sharedSession].exp_estateClaims =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [Session_EstatePlanning sharedSession].exp_insolvency =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                    [Session_EstatePlanning sharedSession].exp_unpaidMortgage =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
                    [Session_EstatePlanning sharedSession].exp_medical =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)] ;
                    [Session_EstatePlanning sharedSession].exp_retirement =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)] ;
                    [Session_EstatePlanning sharedSession].exp_spouseInterest =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)] ;
                    [Session_EstatePlanning sharedSession].exp_standardDedudction =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 8)] ;
                    [Session_EstatePlanning sharedSession].exp_netTaxableEstate =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 9)] ;
                    [Session_EstatePlanning sharedSession].exp_taxRate =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)] ;
                    [Session_EstatePlanning sharedSession].budget =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 11)] ;
                    [Session_EstatePlanning sharedSession].notes =[NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(sqliteStatement, 12)];
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

+ (NSError *) newEstatePlanning: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tEstatePlanning ("
                           @"_Id, ClientId, "
                           @"FuneralExp, "
                           @"JudicialExp, "
                           @"EstateClaims, "
                           @"InsolvencyClaim, "
                           @"UnpaidMortgage, "
                           @"MedicalExp, "
                           @"RetirementBen, "
                           @"SpouseInterestToEstate, "
                           @"StandardDeduction, "
                           @"NetTaxableEstate, "
                           @"TaxRate, "
                           @"Budget, "
                           @"Notes "
						   @") VALUES ("
                           @"%@, %@,"
                           @"%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, "
                           @"\"%@\") ",
						   profileId,profileId,
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @""];
	
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateEstatePlanning: (NSString *)profileId
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tEstatePlanning SET "
						   @"FuneralExp = %@, "
                           @"JudicialExp = %@, "
                           @"EstateClaims = %@, "
                           @"InsolvencyClaim = %@, "
                           @"UnpaidMortgage = %@, "
                           @"MedicalExp = %@, "
                           @"RetirementBen = %@, "
                           @"SpouseInterestToEstate = %@, "
                           @"StandardDeduction = %@, "
                           @"NetTaxableEstate = %@, "
                           @"TaxRate = %@, "
                           @"Budget = %@, "
                           @"Notes = \"%@\" "
                           @"WHERE _Id = %@",
                           
                           [Session_EstatePlanning sharedSession].exp_funeral,
                           [Session_EstatePlanning sharedSession].exp_judicial,
                           [Session_EstatePlanning sharedSession].exp_estateClaims,
                           [Session_EstatePlanning sharedSession].exp_insolvency,
                           [Session_EstatePlanning sharedSession].exp_unpaidMortgage,
                           [Session_EstatePlanning sharedSession].exp_medical,
                           [Session_EstatePlanning sharedSession].exp_retirement,
                           [Session_EstatePlanning sharedSession].exp_spouseInterest,
                           [Session_EstatePlanning sharedSession].exp_standardDedudction,
                           [Session_EstatePlanning sharedSession].exp_netTaxableEstate,
                           [Session_EstatePlanning sharedSession].exp_taxRate,
                           [Session_EstatePlanning sharedSession].budget,
                           [Session_EstatePlanning sharedSession].notes,
                           profileId ];
    
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) computeTotalExpenses
{
    NSNumber *totalExpenses = [NSNumber numberWithFloat:([[Session_EstatePlanning sharedSession].exp_funeral floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_judicial floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_estateClaims floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_insolvency floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_unpaidMortgage floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_medical floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_retirement floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_spouseInterest floatValue] +
                                      [[Session_EstatePlanning sharedSession].exp_standardDedudction floatValue])];
    
    NSLog(@"totalExpenses = %f", [totalExpenses floatValue]);
    return totalExpenses;
}

+ (NSNumber *) computeGrossEstate:(NSNumber *) personalAssets
                         business:(NSNumber *) business
                     realProperty:(NSNumber *) realProperty
                        insurance:(NSNumber *) insurance
{
    return [NSNumber numberWithFloat:([personalAssets floatValue] + [business floatValue] + [realProperty floatValue] + [insurance floatValue])];
}

+ (NSNumber *) computeNetEstate:(NSNumber *) grossEstate
                     deductions:(NSNumber *) deductions
{
    NSNumber *netEstate = [NSNumber numberWithFloat:([grossEstate floatValue] - [deductions floatValue])];
    return netEstate;
}

+ (NSNumber *) computePercentage:(NSNumber *) netEstate
{
    NSNumber *percentage;
    
    if([netEstate intValue] > 10000000)
    {
        percentage = [NSNumber numberWithFloat:20];
    }
    else if([netEstate intValue] > 5000000)
    {
        percentage = [NSNumber numberWithFloat:15];
    }
    else if([netEstate intValue] > 2000000)
    {
        percentage = [NSNumber numberWithFloat:11];
    }
    else if([netEstate intValue] > 500000)
    {
        percentage = [NSNumber numberWithFloat:8];
    }
    else if([netEstate intValue] > 200000)
    {
        percentage = [NSNumber numberWithFloat:5];
    }
    else
    {
        percentage = [NSNumber numberWithFloat:0];
    }
    
    return percentage;
}

+ (NSNumber *) computeAppliedTax:(NSNumber *) netEstate
{
    NSNumber *appliedTax;
    
    if([netEstate intValue] > 10000000)
    {
        appliedTax = [NSNumber numberWithFloat:1215000.0] ;
    }
    else if([netEstate intValue] > 5000000)
    {
        appliedTax = [NSNumber numberWithFloat:465000.0] ;
    }
    else if([netEstate intValue] > 2000000)
    {
        appliedTax = [NSNumber numberWithFloat:135000.0];
    }
    else if([netEstate intValue] > 500000)
    {
        appliedTax = [NSNumber numberWithFloat:15000.0] ;
    }
    else if([netEstate intValue] > 200000)
    {
        appliedTax = [NSNumber numberWithFloat:0.0] ;
    }
    else
    {
        appliedTax = [NSNumber numberWithFloat:0.0] ;
    }
    
    return appliedTax;
    
}

+ (NSNumber *) computeExcessAmount:(NSNumber *) netEstate
{
    NSNumber *excessAmount;
    
    if([netEstate intValue] > 10000000)
    {
        excessAmount = [NSNumber numberWithFloat:([netEstate floatValue] - 10000000.0)];
    }
    else if([netEstate intValue] > 5000000)
    {
        excessAmount = [NSNumber numberWithFloat:([netEstate floatValue] - 5000000.0)];
    }
    else if([netEstate intValue] > 2000000)
    {
        excessAmount = [NSNumber numberWithFloat:([netEstate floatValue] - 2000000.0)];
    }
    else if([netEstate intValue] > 500000)
    {
        excessAmount = [NSNumber numberWithFloat:([netEstate floatValue] - 500000.0)];
    }
    else if([netEstate intValue] > 200000)
    {
        excessAmount = [NSNumber numberWithFloat:([netEstate floatValue] - 200000.0)];
    }
    else
    {
        excessAmount = [NSNumber numberWithFloat:0];
    }
    
    return  excessAmount;
}

+ (NSNumber *) computeEstateTax:(NSNumber *) grossEstate
                     deductions:(NSNumber *) deductions
                      netEstate:(NSNumber *) netEstate
                     appliedTax:(NSNumber *) appliedTax
                     percentage:(NSNumber *) percentage
                   excessAmount:(NSNumber *) excessAmount
{
    NSNumber *estateTaxDue =[NSNumber numberWithFloat:(([excessAmount floatValue] * ([percentage floatValue]/100.0)) + [appliedTax floatValue])] ;
    
    return estateTaxDue;
}

+ (NSNumber *) computeGap:(NSNumber *) grossEstate
               deductions:(NSNumber *) deductions
             estateTaxDue:(NSNumber *) estateTaxDue
{
    return [NSNumber numberWithFloat:([grossEstate floatValue] - [deductions floatValue] - [estateTaxDue floatValue])];
}


@end
