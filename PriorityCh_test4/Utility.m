//
//  Utility.h
//
//  Created by Manulife on 02/29/12.
//


#import "Utility.h"
#import "AppDelegate.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "NSData+Base64.h"
#import "SBJSON.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "AESCrypt.h"
#import "FNASession.h"
#import "FnaConstants.h"

@implementation Utility 

+ (UIAlertView *) showAlerViewWithTitle:(NSString *)title 
							withMessage:(NSString *)message
				  withCancelButtonTitle:(NSString *)cancelButtonTitle
				   withOtherButtonTitle:(NSString *)otherButtonTitle
							withSpinner:(BOOL)spinner
						   withDelegate:(id)delegate
{
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title
														 message:message
														delegate:delegate 
											   cancelButtonTitle:cancelButtonTitle 
											   otherButtonTitles:otherButtonTitle, nil] autorelease];
	
	if (spinner) 
	{			
		UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activity startAnimating];
		
		CGRect frame = [activity frame];
		frame.origin.x = 125.0;
		frame.origin.y = 50.0;
		activity.frame = frame;
		
		[alertView addSubview:activity];
		[activity release];	
	}
	//[alertView show];
	
	return alertView;
}

+ (NSString *) getBundleId
{
	return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString*) getUDID
{
	//return [[[UIDevice currentDevice] uniqueIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return @"";
}

+ (NSString *) documentsDirectory 
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *) filePath:(NSString *)file
{
	@synchronized([Utility class])
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *filePath = [[[self class] documentsDirectory] stringByAppendingPathComponent:file];
		
		if (![fileManager fileExistsAtPath:filePath]) 
		{
			NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:file ofType:@""];
			if (defaultFilePath) 
			{
				[fileManager copyItemAtPath:defaultFilePath toPath:filePath error:NULL];
			}
		}		
		return filePath;
	}
	
	return nil;
}

+(NSString *) dataToString:(NSData *)data
{	
	return [[[NSString alloc]  initWithBytes:[data bytes]
									  length:[data length] 
									encoding: NSUTF8StringEncoding] autorelease];
}

+(NSData *) stringToData:(NSString *)string
{
	return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (void) saveToUserDefaults:(NSString*)key value:(NSString*)value
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		
	[defaults setValue:value forKey:key];
}

+ (NSString*) getUserDefaultsValue:(NSString*)key
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void) setEnableTabBarItems:(BOOL)value items:(NSArray*)items
{
//	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	NSMutableArray *arrItems = [[delegate.tabBarController.tabBar.items mutableCopy] autorelease];
//	//Log(@"items : %@",arrItems);
//	for (int i = 0; i < [items count]; i++) 
//	{
//		NSString *strValue = [items objectAtIndex:i];
//		if(strValue && ![strValue isEqualToString:@""])
//		{
//			UITabBarItem *barItem = [arrItems objectAtIndex:[strValue intValue]];
//			[barItem setEnabled:value];
//		}		
//	}
}

+ (BOOL) validateEmail:(NSString *)emailstring 
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:emailstring];
}

+ (NSString *) fortmatNumberCurrencyStyle:(NSString *)number withCurrencySymbol:(NSString *)symbol
{
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setCurrencySymbol:symbol];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
}

+ (NSString *) formatAccountValueStyle:(NSString *)number withCurrencySymbol:(NSString *)symbol
{
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setCurrencySymbol:symbol];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
}

+ (NSArray *) getColumnNamesForTable:(NSString*)tableName
{
	sqlite3 *database = nil;
	NSMutableArray *arrFieldNames = [[[NSMutableArray alloc] init] autorelease];
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![tableName isEqualToString:@""]) 
		{				
			NSString *sqlSelect = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{				
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
					//Log(@"COLUMN NAME : %@",);
					[arrFieldNames addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)]];
				}
			}
			else 
			{
				//NSLog(@"failed to execute statement: %@", sqlQuery);
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
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
	
	//Log(@"arrFieldNames : %@",arrFieldNames);
	
	return arrFieldNames;
}

+ (NSArray *) getColumnNames:(NSString *)tableName
{
	sqlite3 *database = nil;
	NSMutableArray *arrFieldNames = [[[NSMutableArray alloc] init] autorelease];
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![tableName isEqualToString:@""]) 
		{				
			NSString *sqlSelect = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{				
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
					//Log(@"COLUMN NAME : %@",);
					[arrFieldNames addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)]];
				}
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
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
	
	//Log(@"arrFieldNames : %@",arrFieldNames);
	
	return arrFieldNames;
}

+ (NSDictionary *) getDataSetFromFieldNames:(NSArray*)fieldNames withTable:(NSString*)tableName withClientID:(NSString*)clientID withDataSetName:(NSString*)dataSetName
{
	sqlite3 *database = nil;
	
	NSMutableArray *arrResult = [[[NSMutableArray alloc] init] autorelease];
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![tableName isEqualToString:@""] && [fieldNames count] > 0) 
		{				
			NSString *sqlSelect = @"SELECT ";
			for (int i = 0; i < [fieldNames count]; i++) 
			{
				if(i == 0)
				{
					sqlSelect = [sqlSelect stringByAppendingFormat:@"%@ ",[fieldNames objectAtIndex:i]];
				}
				else 
				{
					sqlSelect = [sqlSelect stringByAppendingFormat:@",%@ ",[fieldNames objectAtIndex:i]];
				}				
			}
            
            if (clientID == nil)
            {
                sqlSelect = [sqlSelect stringByAppendingFormat:@"FROM %@",tableName];
                NSLog(@"sqlSelect: %@", sqlSelect);

            }
            else
            {
                sqlSelect = [sqlSelect stringByAppendingFormat:@"FROM %@ WHERE _Id=%@",tableName,clientID];
                NSLog(@"sqlSelect: %@", sqlSelect);
            }
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{				
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{		
					NSMutableDictionary *dicResult = [[[NSMutableDictionary alloc] init] autorelease];
					for (int i = 0; i < [fieldNames count]; i++) 
					{
						//Log(@"fieldNames : %@",[fieldNames objectAtIndex:i]);
                        if ([[fieldNames objectAtIndex:i] isEqualToString:@"FirstName"] || [[fieldNames objectAtIndex:i] isEqualToString:@"LastName"] || [[fieldNames objectAtIndex:i] isEqualToString:@"MiddleName"])
                        {
                            NSString *decryptString = [[[NSString alloc]init]autorelease];
                            decryptString =[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, i)] password:[self generateEncryptionKey]];
                            
                            [dicResult setObject:decryptString forKey:[fieldNames objectAtIndex:i]];
                        }
                        else
                        {
                            char *ch = (char *)sqlite3_column_text(sqliteStatement, i);
                            
                            if(ch == NULL)
                            {
                                [dicResult setObject:@"" forKey:[fieldNames objectAtIndex:i]];
                            }
                            else 
                            {
                                [dicResult setObject:[NSString stringWithUTF8String:ch] forKey:[fieldNames objectAtIndex:i]];	
                            }
 
                        }
					}
					[dicResult setObject:dataSetName forKey:@"dataset"];
					[arrResult addObject:dicResult];
				}
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
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
    
	return [NSDictionary dictionaryWithObjectsAndKeys:arrResult, @"result" ,nil];
}

+ (NSDictionary *) getDataSetFromFieldNames2:(NSArray*)fieldNames withTable:(NSString*)tableName withClientID:(NSString*)clientID withDataSetName:(NSString*)dataSetName
{
	sqlite3 *database = nil;
	
	NSMutableArray *arrResult = [[[NSMutableArray alloc] init] autorelease];
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		if (![tableName isEqualToString:@""] && [fieldNames count] > 0) 
		{				
			NSString *sqlSelect = @"SELECT ";
			for (int i = 0; i < [fieldNames count]; i++) 
			{
				if(i == 0)
				{
					sqlSelect = [sqlSelect stringByAppendingFormat:@"%@ ",[fieldNames objectAtIndex:i]];
				}
				else 
				{
					sqlSelect = [sqlSelect stringByAppendingFormat:@",%@ ",[fieldNames objectAtIndex:i]];
				}				
			}
            
            sqlSelect = [sqlSelect stringByAppendingFormat:@"FROM %@ WHERE ClientId=%@",tableName,clientID];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{				
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{		
					NSMutableDictionary *dicResult = [[[NSMutableDictionary alloc] init] autorelease];
					for (int i = 0; i < [fieldNames count]; i++) 
					{
						//Log(@"fieldNames : %@",[fieldNames objectAtIndex:i]);
						char *ch = (char *)sqlite3_column_text(sqliteStatement, i);
						if(ch == NULL)
						{
							[dicResult setObject:@"" forKey:[fieldNames objectAtIndex:i]];
						}
						else 
						{
							[dicResult setObject:[NSString stringWithUTF8String:ch] forKey:[fieldNames objectAtIndex:i]];	
						}
                        
                        
					}
					[dicResult setObject:dataSetName forKey:@"dataset"];
					[arrResult addObject:dicResult];
				}
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
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
    
	return [NSDictionary dictionaryWithObjectsAndKeys:arrResult, @"result" ,nil];
}

+ (NSArray *) getTableNames
{
	NSMutableArray *arrTables = [[[NSMutableArray alloc] init] autorelease];
	
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tEducFunding",		@"tableName",@"educDataSet",		@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tIncomeProtection",	@"tableName",@"incomeDataSet",		@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tEstatePlanning",		@"tableName",@"estateDataSet",		@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tFundAccumulation",	@"tableName",@"investmentDataSet",	@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tImpairedHealth",		@"tableName",@"healthDataSet",		@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tRetirementPlanning",	@"tableName",@"retirementDataSet",	@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tProfile_Personal",	@"tableName",@"client",             @"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tProfile_Dependent",	@"tableName",@"dependentDataSet",	@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tProfile_Spouse",		@"tableName",@"spouseDataSet",		@"dataSetName",nil]];
	[arrTables addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tPriorityRank",		@"tableName",@"priorityDataSet",	@"dataSetName",nil]];
	
	return arrTables;
}

+ (NSDictionary *) createDataSetForUpload:(NSString*)clientID
{
//	NSMutableDictionary *dicFinal = [[[NSMutableDictionary alloc] init] autorelease];
    NSDictionary *dicResult = [[[NSDictionary alloc] init] autorelease];
	//NSMutableArray *arrResults = [[[NSMutableArray alloc] init] autorelease];
	
	UIAlertView *alertView = [Utility showAlerViewWithTitle:@"Uploading Information" withMessage:@"" withCancelButtonTitle:nil withOtherButtonTitle:nil withSpinner:YES withDelegate:nil];
	
	NSArray *arrTables = [NSArray arrayWithArray:[Utility getTableNames]];
	for(int i = 0; i < [arrTables count]; i++)
	{
		NSDictionary *dicTable = [NSDictionary dictionaryWithDictionary:[arrTables objectAtIndex:i]];
		NSString *tableName = [dicTable objectForKey:@"tableName"];
		
		NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:tableName]];
		
        dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames:arrFieldnames withTable:tableName withClientID:clientID withDataSetName:[dicTable objectForKey:@"dataSetName"]]];
//		NSArray *tempResult = [NSArray arrayWithArray:[dicResult objectForKey:@"result"]];
//		
//		for(int j = 0; j < [tempResult count]; j++)
//		{
//			[arrResults addObject:[tempResult objectAtIndex:j]];
//		}
        
	}
	
	[alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
	
	//[dicFinal setObject:arrResults forKey:@"result"];
	
	return dicResult;
}

// 20130225 - Surge - this is the old encryption used
//+ (NSString*) encryptString:(NSString*)strData {
//    
//    NSData* imageData	= [NSData dataWithData:[Utility stringToData:strData]];
//    NSString *base64sig = [imageData base64EncodedString];
//    NSLog(@"base64sig : %@",base64sig);
//    return base64sig;
//}
//
//+ (NSString*) decryptString:(NSString*)strData
//{
//    NSString *str = [Utility dataToString:[NSData dataFromBase64String:strData]];
//    NSLog(@"str : %@",str);
//    return str;
//}

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
