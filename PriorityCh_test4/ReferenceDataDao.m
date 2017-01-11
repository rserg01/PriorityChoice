//
//  ReferenceDataDao.m
//  FNA_20120319
//
//  Created by Manulife on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReferenceDataDao.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"


@implementation ReferenceDataDao

+ (float)getCOIRate:(int)age withGender:(NSString*)gender{
    float retVal = 0;
    sqlite3 *finCalcDb = nil;
	if ([SQLiteManager openFinCalcDb:&finCalcDb]) //open database
	{
        NSString *sqlSelect = @"";
        
        if ([gender isEqualToString:@"F"])
        {
            sqlSelect = [NSString stringWithFormat:@"SELECT COI_FVALUE FROM COI_TABLE WHERE COI_AGE = %i",age];
        }
        else
        {
            sqlSelect = [NSString stringWithFormat:@"SELECT COI_MVALUE FROM COI_TABLE WHERE COI_AGE = %i",age];
        }
        
        sqlite3_stmt *sqliteStatement;
        
        if(sqlite3_prepare_v2(finCalcDb, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
            {
                NSString *strValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
                retVal = [strValue floatValue];
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(sqliteStatement);
        
        [SQLiteManager closeFinCalcDb:&finCalcDb]; //make sure to close the database
        
    }
    
    return retVal;
}


+ (float)getPremiumLoad: (int)currency withPremium:(float)premium
{
    float premLoad = 0;
    sqlite3 *finCalcDb = nil;
	if ([SQLiteManager openFinCalcDb:&finCalcDb]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = @"";
            
            sqlSelect = [NSString stringWithFormat:@"SELECT PREMLOAD_LOAD FROM PREMLOAD_TABLE WHERE PREMLOAD_CURRENCY = %i AND PREMLOAD_MIN <= %f and PREMLOAD_MAX  > %f",currency, premium, premium];

			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(finCalcDb, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    NSString *strPremLoad = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
                    premLoad = [strPremLoad floatValue];
                }
			}
			
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeFinCalcDb:&finCalcDb]; //make sure to close the database
			
		}
		else
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
	}
    return premLoad;
}

+ (float)getPolicyFee: (int)currency
{
    float policyFee = 0;
    sqlite3 *finCalcDb = nil;
	if ([SQLiteManager openFinCalcDb:&finCalcDb]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = @"";
            
            sqlSelect = [NSString stringWithFormat:@"SELECT PREMCHARGES_VALUE FROM PREMCHARGES_TABLE WHERE PREMCHARGES_CURRENCY = %i AND PREMCHARGES_TYPE= 'POLICY_FEE'",currency];
            
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(finCalcDb, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    NSString *strPolicyFee = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
                    policyFee = [strPolicyFee intValue];
                }
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeFinCalcDb:&finCalcDb]; //make sure to close the database
			
		}
		else
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
	}
	
    return policyFee;
}

+ (float)getBidOfferSpread
{
    float retVal = 0;
    sqlite3 *finCalcDb = nil;
	if ([SQLiteManager openFinCalcDb:&finCalcDb]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = @"";
            
            sqlSelect = [NSString stringWithFormat:@"SELECT PREMCHARGES_VALUE FROM PREMCHARGES_TABLE WHERE PREMCHARGES_TYPE= 'BIDOFFER_SPREAD'"];
         			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(finCalcDb, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    NSString *strRetVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
                    retVal = [strRetVal floatValue];
                }
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeFinCalcDb:&finCalcDb]; //make sure to close the database
			
		}
		else
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
	}
	
    return retVal;
}




+ (double)getMgtFee:(int)currencyCode withFund:(int)fund
{
    double retVal = 0;
    
    switch (fund) {
        case 0: //bond
            if (currencyCode != 14) {
                retVal = 0.0175;
            } else {
                retVal = 0.015;
            }
            break;
        case 1: //stable
            if (currencyCode != 14) {
                retVal = 0.0;
            } else {
                retVal = 0.0175;
            }
            break;
        case 2://equity
            if (currencyCode != 14) {
                retVal = 0.025;
            } else {
                retVal = 0.02;
            }
            break;
            
        default:
            break;
    }  
    //Log(@"getMgtFee = %f", retVal);
    return retVal;
}


@end

