//
//  GetPersonalProfile.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "GetPersonalProfile.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "AESCrypt.h"
#import "FNASession.h"
#import "Utility.h"
#import "Reacheability.h"
#import "FnaConstants.h"

@implementation GetPersonalProfile

+(void)GetPersonalProfile: (NSString *) profileId
{
    NSString *encryptionKey;
    encryptionKey = [self generateEncryptionKey];
    
    if(profileId && ![profileId isEqualToString:@""])
    {
        sqlite3 *database = nil;
        if ([SQLiteManager openDatabase:&database]) //open database
        {
            NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"FirstName, MiddleName, LastName, "
                                   @"DateOfBirth, Gender, "
                                   @"AddressHome1, AddressHome2, AddressHome3, "
                                   @"Landline, Mobile, OfficeTelNum, "
                                   @"Occupation, "
                                   @"AddressOfc1, AddressOfc2, AddressOfc3, Email, "
                                   @"SoleProp, Partnership, Corporation, "
                                   @"PrimaryRes, VacationRes, RentalProp, Land, "
                                   @"LifeIns, HealthIns, DisabilityIns, "
                                   @"SavingsAcc, CurrentAcc, Bonds, Stocks, Mutual, Collec "
                                   @"FROM tProfile_Personal WHERE _Id =%@", profileId ];
            
            NSLog(@"sqlSelect: %@", sqlSelect);
            
            sqlite3_stmt *sqliteStatement;
            
            if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
                {
                    //client name
                    [FNASession sharedSession].clientFirstName = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)] password:encryptionKey];
                    [FNASession sharedSession].clientMiddleName = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)] password:encryptionKey];
                    [FNASession sharedSession].clientLastName = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)] password:encryptionKey];
                    
                    [FNASession sharedSession].name = [NSString stringWithFormat:@"%@ %@ %@",[FNASession sharedSession].clientFirstName, [FNASession sharedSession].clientMiddleName, [FNASession sharedSession].clientLastName];
                    
                    NSLog(@"FullName = %@", [FNASession sharedSession].name);
                    
                    //client DOB and gender
                    [FNASession sharedSession].clientDob = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
                    [FNASession sharedSession].clientGender= [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
                    
                    NSLog(@"DateOfBirth = %@", [FNASession sharedSession].clientDob);
                    NSLog(@"Gender = %@", [FNASession sharedSession].clientGender);
                    
                    //Home Address
                    [FNASession sharedSession].clientAddress1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];
                    [FNASession sharedSession].clientAddress2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 6)];
                    [FNASession sharedSession].clientAddress3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 7)];
                    
                    NSLog(@"Address = %@", [FNASession sharedSession].clientAddress1);
                    NSLog(@"Address = %@", [FNASession sharedSession].clientAddress2);
                    NSLog(@"Address = %@", [FNASession sharedSession].clientAddress3);
                    
                    //Contact details
                    [FNASession sharedSession].clientLandLine = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 8)];
                    [FNASession sharedSession].clientMobile = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 9)];
                    [FNASession sharedSession].clientOfficeTelNum = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 10)];
                    
                    NSLog(@"Landline = %@", [FNASession sharedSession].clientLandLine);
                    NSLog(@"Mobile = %@", [FNASession sharedSession].clientMobile);
                    NSLog(@"Office TelNum = %@", [FNASession sharedSession].clientOfficeTelNum);
                    
                    //Occupation
                    [FNASession sharedSession].clientOccupation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 11)];
                    
                    NSLog(@"Occupation = %@", [FNASession sharedSession].clientOccupation);
                    
                    //Office Address
                    [FNASession sharedSession].clientOfficeAdd1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 12)];
                    [FNASession sharedSession].clientOfficeAdd2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 13)];
                    [FNASession sharedSession].clientOfficeAdd3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 14)];
                    [FNASession sharedSession].clientEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 15)];
                    
                    NSLog(@"Office = %@", [FNASession sharedSession].clientOfficeAdd1);
                    NSLog(@"Office = %@", [FNASession sharedSession].clientOfficeAdd2);
                    NSLog(@"Office = %@", [FNASession sharedSession].clientOfficeAdd3);
                    
                    [FNASession sharedSession].clientSoleProp = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 16)];
                    [FNASession sharedSession].clientPartnership = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 17)];
                    [FNASession sharedSession].clientCorporation = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 18)];
                    
                    NSLog(@"SoleProp = %@", [FNASession sharedSession].clientSoleProp);
                    NSLog(@"Partnership = %@", [FNASession sharedSession].clientPartnership);
                    NSLog(@"Corporation = %@", [FNASession sharedSession].clientCorporation);
                    
                    [FNASession sharedSession].clientPrimaryResidence = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 19)];
                    [FNASession sharedSession].clientVacationresidence = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 20)];
                    [FNASession sharedSession].clientRentalProperty = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 21)];
                    [FNASession sharedSession].clientLand = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 22)];
                    
                    NSLog(@"PrimaryResidence = %@", [FNASession sharedSession].clientPrimaryResidence);
                    NSLog(@"VacationResidence = %@", [FNASession sharedSession].clientVacationresidence);
                    NSLog(@"Rental = %@", [FNASession sharedSession].clientRentalProperty);
                    NSLog(@"Land = %@", [FNASession sharedSession].clientLand);
                    
                    
                    [FNASession sharedSession].clientLifeInsurance = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 23)];
                    [FNASession sharedSession].clientHealthInsurance = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 24)];
                    [FNASession sharedSession].clientDisabilityInsurance = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 25)];
                    
                    NSLog(@"Life Insurance = %@", [FNASession sharedSession].clientLifeInsurance);
                    NSLog(@"Health Insurance = %@", [FNASession sharedSession].clientHealthInsurance);
                    NSLog(@"Disability = %@", [FNASession sharedSession].clientDisabilityInsurance);
                    
                    [FNASession sharedSession].clientSavings = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 26)];
                    [FNASession sharedSession].clientCurrent = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 27)];
                    [FNASession sharedSession].clientBonds = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 28)];
                    [FNASession sharedSession].clientStocks = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 29)];
                    [FNASession sharedSession].clientMutual = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 30)];
                    [FNASession sharedSession].clientCollectibles = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 31)];
                    
                    NSLog(@"Savings = %@", [FNASession sharedSession].clientSavings);
                    NSLog(@"Current = %@", [FNASession sharedSession].clientCurrent);
                    NSLog(@"Bonds = %@", [FNASession sharedSession].clientBonds);
                    NSLog(@"Stocks = %@", [FNASession sharedSession].clientStocks);
                    NSLog(@"Mutual = %@", [FNASession sharedSession].clientMutual);
                    NSLog(@"Collectibles = %@", [FNASession sharedSession].clientCollectibles);
                }
            }
            else 
            {
                //NSLog(@"failed to execute statement: %@", sqlQuery);
                NSLog(@"failed to execute statement");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(sqliteStatement);	
            
            [SQLiteManager closeDatabase:&database]; //make sure to close the database
        }
    }
}

+(NSError *)InsertNewPersonalProfile:(NSString *)profileid
                    lastName:(NSString *)lastName
                   firstName:(NSString *)firstName
                  middleName:(NSString *)middleName
                 dateOfBirth:(NSString *)dateOfBirth
                      gender:(NSNumber *)gender
                    address1:(NSString *)address1
                    address2:(NSString *)address2
                    address3:(NSString *)address3
                  occupation:(NSString *)occupation
                     ofcAdd1:(NSString *)ofcAdd1
                     ofcAdd2:(NSString *)ofcAdd2
                     ofcAdd3:(NSString *)ofcAdd3
                    landline:(NSString *)landline
                      mobile:(NSString *)mobile
                   ofcTelNum:(NSString *)ofcTelNum
                       email:(NSString *)email
{
    NSString *strAgentCode = [NSString stringWithFormat:@"%@", [FNASession sharedSession].agentCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter release];
    dateFormatter = nil;
    
    //Validations
 
    
    //20130125 Surge - insert new encryption
    NSString *encryptionKey;
    encryptionKey = [self generateEncryptionKey];
    
    lastName = [AESCrypt encrypt:lastName password:encryptionKey];
    firstName = [AESCrypt encrypt:firstName password:encryptionKey];
    middleName = [AESCrypt encrypt:middleName password:encryptionKey];
    
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tProfile_Personal "
                           @"(_Id, LastName, FirstName, MiddleName, "
                           @"DateOfBirth, Gender, "
                           @"AddressHome1,AddressHome2,AddressHome3, "
                           @"Occupation, "
                           @"AddressOfc1,AddressOfc2,AddressOfc3, "
                           @"Landline, Mobile, OfficeTelNum, Email, "
                           @"DateSaved, AgentCode) "
                           @"VALUES "
                           @"(%@, \"%@\",\"%@\",\"%@\", "
                           @"\"%@\",\"%@\", "
                           @"\"%@\",\"%@\",\"%@\", "
                           @"\"%@\", "
                           @"\"%@\",\"%@\",\"%@\", "
                           @"\"%@\",\"%@\",\"%@\",\"%@\", "
                           @"\"%@\",\"%@\")",
                           
                           profileid,
                           lastName,
                           firstName, //[Utility encryptString:[self.txtFirstname text]],
                           middleName, //[Utility encryptString:[self.txtMiddlename text]],
                           dateOfBirth,
                           gender == 0 ? @"M":@"F",
                           [address1 length]==0 ? @"":address1 ,
                           [address2 length]==0 ? @"":address2,
                           [address3 length]==0 ? @"":address3,
                           [occupation length]==0 ? @"":occupation,
                           [ofcAdd1 length]==0 ? @"":ofcAdd1,
                           [ofcAdd2 length]==0 ? @"":ofcAdd2,
                           [ofcAdd3 length]==0 ? @"":ofcAdd3,
                           [landline length]==0 ? @"":landline,
                           [mobile length]==0 ? @"":mobile,
                           [ofcTelNum length]==0 ? @"":ofcTelNum,
                           [email length]==0 ? @"":email,
                           currentDate,
                           strAgentCode];
    
    NSError *error = nil;
    
    NSLog(@"sqlInsert_NewProfile: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+(NSError *)UpdatePersonalProfile: (NSString *)profileid
                         lastName:(NSString *)lastName
                        firstName:(NSString *)firstName
                       middleName:(NSString *)middleName
                      dateOfBirth:(NSString *)dateOfBirth
                           gender:(NSNumber *)gender
                         address1:(NSString *)address1
                         address2:(NSString *)address2
                         address3:(NSString *)address3
                       occupation:(NSString *)occupation
                          ofcAdd1:(NSString *)ofcAdd1
                          ofcAdd2:(NSString *)ofcAdd2
                          ofcAdd3:(NSString *)ofcAdd3
                         landline:(NSString *)landline
                           mobile:(NSString *)mobile
                        ofcTelNum:(NSString *)ofcTelNum
                            email:(NSString *)email
{
    NSString *strAgentCode = [NSString stringWithFormat:@"%@", [FNASession sharedSession].agentCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter release];
    dateFormatter = nil;
    
    //Validations
    
    
    //20130125 Surge - insert new encryption
    NSString *encryptionKey;
    encryptionKey = [self generateEncryptionKey];
    
    lastName = [AESCrypt encrypt:lastName password:encryptionKey];
    firstName = [AESCrypt encrypt:firstName password:encryptionKey];
    middleName = [AESCrypt encrypt:middleName password:encryptionKey];
    
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Personal SET "
                           @"LastName = '%@', FirstName = '%@', MiddleName = '%@', "
                           @"""DateOfBirth"" = '%@', ""Gender"" = '%@', "
                           @"Occupation = '%@', "
                           @"AddressHome1 = '%@',AddressHome2 = '%@',AddressHome3 = '%@', "
                           @"AddressOfc1 = '%@',AddressOfc2 = '%@',AddressOfc3 = '%@', "
                           @"Landline = '%@', Mobile = '%@', OfficeTelNum = '%@', Email = '%@', "
                           @"DateSaved = '%@', AgentCode = '%@' "
                           @"WHERE _Id = %@ ",
                           
                           lastName,firstName,middleName,
                           dateOfBirth,gender == 0 ? @"M":@"F",
                           [occupation length]==0 ? @"" : occupation,
                           [address1 length]==0 ? @"":address1,
                           [address2 length]==0 ? @"":address2,
                           [address3 length]==0 ? @"":address3,
                           [ofcAdd1 length]==0 ? @"":ofcAdd1,
                           [ofcAdd2 length]==0 ? @"":ofcAdd2,
                           [ofcAdd3 length]==0 ? @"":ofcAdd3,
                           [landline length]==0 ? @"":landline,
                           [mobile length]==0 ? @"":mobile,
                           [ofcTelNum length]==0 ? @"":ofcTelNum,
                           [email length]==0 ? @"":email,
                           currentDate,
                           strAgentCode,
                           profileid];
    
    NSError *error = nil;
    
    NSLog(@"Update tProfile_Personal: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) UpdatePersonalAssets:(NSString *)profileId
                           savings:(NSNumber *)savings
                           current:(NSNumber *)current
                             bonds:(NSNumber *)bonds
                            stocks:(NSNumber *)stocks
                            mutual:(NSNumber *)mutual
                      collectibles:(NSNumber *)collectibles
{
    
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Personal SET "
                           @"SavingsAcc = %@, "
                           @"CurrentAcc = %@, "
                           @"Stocks = %@, "
                           @"Bonds = %@, "
                           @"Mutual = %@, "
                           @"Collec = %@ "
                           @"WHERE _Id = %@ ",
                           
                           savings,
                           current,
                           stocks,
                           bonds,
                           mutual,
                           collectibles,
                           profileId];
    
    NSError *error = nil;
    
    NSLog(@"UpdatePersonalAssets: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    NSLog(@"%@", [error localizedDescription]);
    
    return error;
    
}

+ (NSError *) UpdateRealProperty:(NSString *)profileId
                primaryresidence:(NSNumber *)primaryresidence
               vacationresidence:(NSNumber *)vacationresidence
                  rentalproperty:(NSNumber *)rentalproperty
                            land:(NSNumber *)land
{
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Personal SET "
                           @"PrimaryRes = %@, "
                           @"VacationRes = %@, "
                           @"RentalProp = %@, "
                           @"Land = %@ "
                           @"WHERE _Id = %@ ",
                           
                           primaryresidence,
                           vacationresidence,
                           rentalproperty,
                           land,
                           profileId];
    
    NSError *error = nil;
    
    NSLog(@"UpdateRealProperty: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
    
}

+ (NSError *) UpdateInsurance:(NSString *)profileId
                lifeInsurance:(NSNumber *)lifeInsurance
              healthInsurance:(NSNumber *)healthInsurance
          disabilityInsurance:(NSNumber *)disabilityInsurance
{
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Personal SET "
                           @"LifeIns = %@, "
                           @"HealthIns = %@, "
                           @"DisabilityIns = %@ "
                           @"WHERE _Id = %@ ",
                           
                           lifeInsurance,
                           healthInsurance,
                           disabilityInsurance,
                           profileId];
    
    NSError *error = nil;
    
    NSLog(@"UpdateInsurance: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
    
}

+ (NSError *) UpdateBusiness:(NSString *)profileId
                    soleProp:(NSNumber *)soleProp
                 partnership:(NSNumber *)partnership
                 corporation:(NSNumber *)corporation
{
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Personal SET "
                           @"SoleProp = %@, "
                           @"Partnership = %@, "
                           @"Corporation = %@ "
                           @"WHERE _Id = %@ ",
                           
                           soleProp,
                           partnership,
                           corporation,
                           profileId];
    
    NSError *error = nil;
    
    NSLog(@"UpdateInsurance: %@", sqlInsert);
    
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
    
}

+ (NSString *) getNewProfileIdNumber

{
    
    int i = 0;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"_Id "
                                   @"FROM tProfile_Personal"];
			NSLog(@"sqlSelect: %@", sqlSelect);
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    i = sqlite3_column_int(sqliteStatement, 0);
                    NSLog(@"SQLite Rows: %i", i);
				}
			}
			else
			{
				//NSLog(@"failed to execute statement: %@", sqlQuery);
				NSLog(@"failed to execute statement : %@",sqlSelect);
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
			
		}
		else
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Database Error"
                              message:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]]
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
	}
    i = i + 1;
    
    NSString *retValue = [NSString stringWithFormat:@"%d", i];
    NSLog(@"newProfileId = %@", retValue);
    
    return  retValue;
    
}

+ (NSNumber *) getTotalPersonalAssets: (NSString *) profileId

{
    NSNumber *TOTAL_PersonalAsets = [[[NSNumber alloc]init] autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"SavingsAcc, CurrentAcc, Stocks, Bonds, Mutual, Collec "
								   @"FROM tProfile_Personal WHERE _Id=%@", profileId];
			
            NSLog(@"sqlSelect: %@", sqlSelect);
			
			sqlite3_stmt *sqliteStatement;
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [FNASession sharedSession].clientSavings =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [FNASession sharedSession].clientCurrent = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [FNASession sharedSession].clientStocks = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [FNASession sharedSession].clientBonds = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                    [FNASession sharedSession].clientMutual = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
                    [FNASession sharedSession].clientCollectibles = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)] ;
				}
			}

            //compute for Pesonal Assets
            TOTAL_PersonalAsets = [NSNumber numberWithDouble:([[FNASession sharedSession].clientSavings doubleValue] +
                                                              [[FNASession sharedSession].clientCurrent doubleValue]+
                                                              [[FNASession sharedSession].clientStocks doubleValue]+
                                                              [[FNASession sharedSession].clientBonds doubleValue]+
                                                              [[FNASession sharedSession].clientMutual doubleValue]+
                                                              [[FNASession sharedSession].clientCollectibles doubleValue])];
            
            NSLog(@"TotalPersonalAsset = %@", [FNASession sharedSession].totalPersonalAssets);
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return TOTAL_PersonalAsets;
}

+ (NSNumber *) getTotalInsurance: (NSString *) profileId

{
    NSNumber *TOTAL_Insurance = [[[NSNumber alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"LifeIns, HealthIns, DisabilityIns "
								   @"FROM tProfile_Personal WHERE _Id=%@", profileId];
			//Log(@"sqlSelect: %@", sqlSelect);
			
           
            
			sqlite3_stmt *sqliteStatement;
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [FNASession sharedSession].clientLifeInsurance =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [FNASession sharedSession].clientHealthInsurance = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [FNASession sharedSession].clientDisabilityInsurance = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
				}
			}
            
            //compute for Pesonal Assets
            TOTAL_Insurance = [NSNumber numberWithDouble:([[FNASession sharedSession].clientLifeInsurance doubleValue] +
                                                          [[FNASession sharedSession].clientHealthInsurance doubleValue]+
                                                          [[FNASession sharedSession].clientDisabilityInsurance doubleValue])];
            
            [FNASession sharedSession].totalInsurance = TOTAL_Insurance;
            
            NSLog(@"TotalInsurance = %@", [FNASession sharedSession].totalInsurance);
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
            
           
		}
	}
    
     return TOTAL_Insurance;
}

+ (NSNumber *) getTotalBusiness:(NSString *)profileId

{
    [FNASession sharedSession].clientSoleProp = nil;
    [FNASession sharedSession].clientPartnership = nil;
    [FNASession sharedSession].clientCorporation = nil;
    
    NSNumber *TOTAL_Business = [[[NSNumber alloc]init]autorelease];
    NSNumber *soleProp = [[[NSNumber alloc]init]autorelease];
    NSNumber *partnership = [[[NSNumber alloc]init]autorelease];
    NSNumber *corporation = [[[NSNumber alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"SoleProp, Partnership, Corporation "
								   @"FROM tProfile_Personal WHERE _Id=%@", profileId];
			
            
            NSLog(@"sqlSelect: %@", sqlSelect);
			
			sqlite3_stmt *sqliteStatement;
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    soleProp =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    partnership = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    corporation = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
				}
			}
            
            //compute for Pesonal Assets
            [FNASession sharedSession].clientSoleProp = soleProp;
            [FNASession sharedSession].clientPartnership = partnership;
            [FNASession sharedSession].clientCorporation = corporation;
            
            TOTAL_Business = [NSNumber numberWithDouble:([soleProp doubleValue] +
                                                         [partnership doubleValue]+
                                                         [corporation doubleValue])];
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    NSLog(@"TOTAL_Business = %@", TOTAL_Business);
    return TOTAL_Business;
}

+ (NSNumber *) getTotalRealProperty:(NSString *)profileId

{
    NSNumber *TOTAL_RealProperty = [[[NSNumber alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"PrimaryRes, VacationRes, RentalProp, Land "
								   @"FROM tProfile_Personal WHERE _Id=%@", profileId];
			//Log(@"sqlSelect: %@", sqlSelect);
			
           
            
			sqlite3_stmt *sqliteStatement;
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [FNASession sharedSession].clientPrimaryResidence =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [FNASession sharedSession].clientVacationresidence = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [FNASession sharedSession].clientRentalProperty = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [FNASession sharedSession].clientLand = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                }
			}
            
            //compute for Pesonal Assets
            TOTAL_RealProperty = [NSNumber numberWithDouble:([[FNASession sharedSession].clientPrimaryResidence doubleValue] +
                                                             [[FNASession sharedSession].clientVacationresidence doubleValue]+
                                                             [[FNASession sharedSession].clientRentalProperty doubleValue]+
                                                             [[FNASession sharedSession].clientLand doubleValue])];
            
            [FNASession sharedSession].totalRealProperty = TOTAL_RealProperty;
            
            NSLog(@"TotalRealProperty = %@", [FNASession sharedSession].totalRealProperty);
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
      
		}
	}
    
    return TOTAL_RealProperty;
}

+ (NSMutableArray *) getAllProfileNames

{
    NSError *error = nil;
    
    NSMutableArray *arrProfiles = [[[NSMutableArray alloc]init]autorelease];
    
    NSString *encryptionKey;
    encryptionKey = [self generateEncryptionKey];
    
    
    sqlite3 *database = nil;
    
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *sqlSelect = @"SELECT _Id, "
        @"FirstName, MiddleName, LastName, "
        @"AddressHome1 "
        @"FROM tProfile_Personal ORDER BY _Id ASC";
		
		sqlite3_stmt *sqliteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
		{
			[arrProfiles removeAllObjects];
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
			{
                NSString *strFirst = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)] password:encryptionKey];
                NSString *strMiddle = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)] password:encryptionKey];
                NSString *strLast = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)] password:encryptionKey];
                NSString *strFullName = [NSString stringWithFormat:@"%@ %@ %@",strFirst, strMiddle, strLast];
				[arrProfiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:
											 @"user_icon&24.png",@"image",
											 @"", @"cellBackgroundImage",
											 strFullName, @"title",
											 [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)], @"profileId",
											 [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)], @"details", nil]];
			}
        }
        
       
		
		// Release the compiled statement from memory
		sqlite3_finalize(sqliteStatement);
		
        [SQLiteManager sqliteExec:sqlSelect error:&error];
		[SQLiteManager closeDatabase:&database]; //make sure to close the database
	}
    
    return arrProfiles;

}

+ (NSMutableArray *) getAllProfileNames_Synch

{
    NSError *error = nil;
    
    NSMutableArray *arrProfiles = [[[NSMutableArray alloc]init]autorelease];
    
    
    sqlite3 *database = nil;
    
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *sqlSelect = @"SELECT _Id "
        @"FROM tProfile_Personal ORDER BY _Id ASC";
		
		sqlite3_stmt *sqliteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
		{
			[arrProfiles removeAllObjects];
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
			{
				[arrProfiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)],@"profileId", nil]];
			}
        }
        
        
		
		// Release the compiled statement from memory
		sqlite3_finalize(sqliteStatement);
		
        [SQLiteManager sqliteExec:sqlSelect error:&error];
		[SQLiteManager closeDatabase:&database]; //make sure to close the database
	}
    
    return arrProfiles;
    
}

+ (NSMutableArray *) getDependents: (NSString *) profileId
{
    NSMutableArray *arrDependents = [[[NSMutableArray alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *sqlSelect = [NSString stringWithFormat:@"SELECT _Id, "
                               @"(FirstName || \" \" || MiddleName || \" \" || LastName) AS Name "
                               @"FROM tProfile_Dependent WHERE ClientId=%@ ORDER BY _Id ASC", profileId];
		NSLog(@"%@", sqlSelect);
        
		sqlite3_stmt *sqliteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
		{
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
			{
				[arrDependents addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)], @"title",
                                          [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)], @"dependentId", nil]];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(sqliteStatement);
		
		[SQLiteManager closeDatabase:&database]; //make sure to close the database
	}

    return arrDependents;

}

+ (NSMutableArray *) getDependentInfo: (NSString *) profileId dependentId: (NSString *) dependentId

{
    NSMutableArray *arrDependentInfo = [[[NSMutableArray alloc]init]autorelease];
    
	sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                               @"LastName, FirstName, MiddleName, DateOfBirth, Relationship "
                               @"FROM tProfile_Dependent WHERE _Id=%@ AND ClientId=%@", dependentId, profileId];
        
        NSLog(@"sqlSelect = %@", sqlSelect);
        
        sqlite3_stmt *sqliteStatement;
        
        if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
            {
                NSString *lastName = [[[NSString alloc]init]autorelease];
                NSString *firstName = [[[NSString alloc]init]autorelease];
                NSString *middleName = [[[NSString alloc]init]autorelease];
                NSString *dateOfBirth = [[[NSString alloc]init]autorelease];
                NSString *relationship = [[[NSString alloc]init]autorelease];
                
                lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
                firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
                middleName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
                dateOfBirth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
                relationship = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
                
                lastName = [lastName length] > 0 ? lastName : @" ";
                firstName = [firstName length] > 0 ? firstName : @" ";
                middleName = [middleName length] > 0 ? middleName : @" ";
                dateOfBirth = [dateOfBirth length] > 0 ? dateOfBirth : @" ";
                relationship = [relationship length] > 0 ? relationship : @" ";
                
                [arrDependentInfo addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  lastName, @"lastName",
                  firstName, @"firstName",
                  middleName, @"middleName",
                  dateOfBirth, @"dateOfBirth",
                  relationship, @"relationship",
                  nil]];
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(sqliteStatement);
        
        [SQLiteManager closeDatabase:&database]; //make sure to close the databas
    }
    
    return arrDependentInfo;
}

+ (NSString *) generateDependentId
{
    NSString *newId = [[[NSString alloc]init]autorelease];
    
	sqlite3 *database = nil;
	
    if ([SQLiteManager openDatabase:&database]) //open database
	{
        NSString *sqlSelect = @"SELECT COUNT(*)+1 from tProfile_Dependent";
        
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

+ (NSError *) saveDependent: (NSString *) profileId
                dependentId: (NSString *) dependentId
                  firstName: (NSString *) firstName
                   lastName: (NSString *) lastName
                 middleName: (NSString *) middleName
                dateOfBirth: (NSString *) dateOfBirth
               relationship: (NSString *) relationship
{

    
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tProfile_Dependent ("
                           @"_Id, ClientId, LastName, FirstName, MiddleName, DateOfBirth, Relationship) "
                           @"VALUES (%@, %@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                           dependentId,
                           profileId,
                           lastName,
                           firstName,
                           middleName,
                           dateOfBirth,
                           relationship];
    
    NSError *error = nil;
    NSLog(@"sqlInsert: %@", sqlInsert);
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateDependent: (NSString *) profileId
                dependentId: (NSString *) dependentId
                  firstName: (NSString *) firstName
                   lastName: (NSString *) lastName
                 middleName: (NSString *) middleName
                dateOfBirth: (NSString *) dateOfBirth
               relationship: (NSString *) relationship
{
    
    NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tProfile_Dependent SET "
                           @"FirstName = \"%@\", "
                           @"LastName = \"%@\", "
                           @"MiddleName = \"%@\", "
                           @"DateOfBirth = \"%@\", "
                           @"Relationship = \"%@\" "
                           @"WHERE _Id = %@ AND ClientId = %@ ",
                           lastName,
                           firstName,
                           middleName,
                           dateOfBirth,
                           relationship,
                           dependentId, profileId];
    
    NSError *error = nil;
    NSLog(@"sqlInsert: %@", sqlInsert);
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) checkExisingDependent:(NSString *)dependentId profileId: (NSString *) profileId
{
    NSNumber *numOfRows = nil;
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT COUNT (*) "
								   @"FROM tProfile_Dependent WHERE _Id=%@ AND ClientId = %@", dependentId, profileId];
            
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

+ (NSString *) internetReachable
{
    __block NSString *result;
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"https://www.mymanulife.com.ph/cwsprd/"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {        
        result = [NSString stringWithFormat:@"Your device has connected to the server. Sync will begin."] ;
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        result = @"You need an active internet conection to proceed with the activation.\n Please close the FNA App and try again.";
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    return result;
}

+ (void) purgeSequence {
    
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    NSError *err = [[[NSError alloc]init]autorelease];
    
    [arr addObject:@"tProfile_Personal"];
    [arr addObject:@"tProfile_Dependent"];
    [arr addObject:@"tProfile_Spouse"];
    [arr addObject:@"tPriorityRank"];
    [arr addObject:@"tEducFunding"];
    [arr addObject:@"tIncomeProtection"];
    [arr addObject:@"tRetirementPlanning"];
    [arr addObject:@"tFundAccumulation"];
    [arr addObject:@"tImpairedHealth"];
    [arr addObject:@"tEstatePlanning"];
    [arr addObject:@"tManucare"];
    
    for (NSString *tableName in arr) {
        
        err = [GetPersonalProfile purgeData:tableName];
        
        if (err) {
            NSLog(@"Error in purge");
        }
    }
    
}

+ (NSError *) purgeData:(NSString *) tableName
{
    
    NSString *purgeStatement = [NSString stringWithFormat:@"DELETE FROM %@ WHERE _Id IS NOT NULL", tableName];
    
    NSError *error = nil;
    
    NSLog(@"UpdateInsurance: %@", purgeStatement);
    
    [SQLiteManager sqliteExec:purgeStatement error:&error];
    
    return error;
}

+ (void) checkDataStoreValidity
{
    // get number of profiles for purging
    NSMutableArray *arrForPurge = [[[NSMutableArray alloc]init]autorelease];
    arrForPurge = [GetPersonalProfile getProfilesForPurge];
    
    if ([arrForPurge count] > 0) {
        
        NSLog(@"purge count: %d", [arrForPurge count]);
        
        //purge expired profiles
        [GetPersonalProfile purgeExpiredProfiles:arrForPurge];
    }
}


+ (NSMutableArray *) getProfilesForPurge
{
    NSMutableArray *arrForPurge = [[NSMutableArray alloc]init];
    
    //get all profiles
    NSMutableArray *arrProfiles = [[NSMutableArray alloc]init];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *sqlSelect = @"SELECT _Id, DateSaved FROM tProfile_Personal";
		NSLog(@"%@", sqlSelect);
        
		sqlite3_stmt *sqliteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
		{
			while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
			{
				[arrProfiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)], @"saveDate",
                                          [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)], @"profileId", nil]];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(sqliteStatement);
		
		[SQLiteManager closeDatabase:&database]; //make sure to close the database
	}
    
    //filter profiles
    if ([arrProfiles count] > 0) {
        
        NSDictionary *item = [arrProfiles objectAtIndex:0];
        
        for(item in arrProfiles) {
            
            //convert string saveDate to NSDate
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *newSaveDate = [dateFormatter dateFromString: [item objectForKey:@"saveDate"]];
            NSDate *currentDate = [NSDate date];
            
            NSCalendar *gregorianCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:newSaveDate
                                                                  toDate:currentDate
                                                                 options:0];
            
            
            NSNumber *dayDiff = [NSNumber numberWithInt:[components day]] ;
            
            
            if ([dayDiff compare:[NSNumber numberWithInt:kPurgeDays]] == NSOrderedDescending ) {
                
                [arrForPurge addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [item objectForKey:@"saveDate"], @"saveDate",
                                        [item objectForKey:@"profileId"], @"profileId", nil]];
            }
            
            [item release];
            
        }
    }
    
    //return remaining valid profiles
    return arrForPurge;
}

+ (NSError *) purgeExpiredProfiles:(NSMutableArray *) arrForPurge
{
    NSError *error;
    
    NSDictionary *item = [arrForPurge objectAtIndex:0];
    
    for (item in arrForPurge) {
        
        NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
        
        [arr addObject:@"tProfile_Personal"];
        [arr addObject:@"tProfile_Dependent"];
        [arr addObject:@"tProfile_Spouse"];
        [arr addObject:@"tPriorityRank"];
        [arr addObject:@"tEducFunding"];
        [arr addObject:@"tIncomeProtection"];
        [arr addObject:@"tRetirementPlanning"];
        [arr addObject:@"tFundAccumulation"];
        [arr addObject:@"tImpairedHealth"];
        [arr addObject:@"tEstatePlanning"];
        [arr addObject:@"tManucare"];
        
        for (NSString *tableName in arr) {
            
            NSString *purgeStatement = [[NSString stringWithFormat:@"DELETE FROM %@ WHERE _Id = %@", tableName, [item objectForKey:@"profileId"]]autorelease];
            
            NSLog(@"UpdateInsurance: %@", purgeStatement);
            
            [SQLiteManager sqliteExec:purgeStatement error:&error];
        }
       
    }
    
    return error;
}

+ (NSString *) generateEncryptionKey
{
    NSString *encryptionKey;
    NSString *appendKey;
    encryptionKey = [FNASession sharedSession].agentCode;
    appendKey = kEncryptionKey;
    encryptionKey = [encryptionKey stringByAppendingString:appendKey];
    
    return encryptionKey;
}


@end
