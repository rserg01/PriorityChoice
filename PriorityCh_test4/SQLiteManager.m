//
//  SQLiteManager.m
//  FNA
//
//  Created by Manulife on 3/5/12.
//

#import "SQLiteManager.h"
#import "Utility.h"

@implementation SQLiteManager

+ (BOOL) openDatabase:(sqlite3 **)database
{
	//Log(@"openDatabase");
	
	NSString *databasePath = [[self class] databasePath];
	
	if (sqlite3_open([databasePath UTF8String], &*database) == SQLITE_OK)
	{
		return YES;
	}
	return NO;
}

+ (BOOL) openFinCalcDb:(sqlite3 **)finCalcDb
{
    //Log(@"openFinCalcDb");
    
    NSString *finCalcDbPath = [[self class] finCalcDbPath];
	
	if (sqlite3_open([finCalcDbPath UTF8String], &*finCalcDb) == SQLITE_OK)
	{
		return YES;
	}
	return NO;
}

+ (void) closeDatabase:(sqlite3 **)database
{
	//Log(@"closeDatabase");
	
	if (*database) 
	{
		sqlite3_close(*database);
	}
}

+ (void) closeFinCalcDb:(sqlite3 **)finCalcDb
{
    //Log(@"closeFinCalcDb");
    
    if (*finCalcDb) 
	{
		sqlite3_close(*finCalcDb);
	}
}

+ (void) sqliteExec:(NSString *)sqlQuery error:(NSError **)error
{
	sqlite3 *database = nil;
	
	NSString *databasePath = [[self class] databasePath];
	
	//Log(@"databasePath: %@", databasePath);
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		char *error_ = nil;
		sqlite3_exec(database, [sqlQuery UTF8String], NULL, NULL, &error_);	
		if (error_) 
		{
			*error = [NSError errorWithDomain:[Utility getBundleId] 
										 code:1 
									 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:error_] forKey:NSLocalizedDescriptionKey]];
		}
	}
	
	if (database) 
	{
		sqlite3_close(database);
	}
}

+ (void) sqliteExec2:(NSString *)sqlQuery error:(NSError **)error
{
    sqlite3 *finCalcDb = nil;
	
	NSString *finCalcDbPath = [[self class] finCalcDbPath];
	
	if (sqlite3_open([finCalcDbPath UTF8String], &finCalcDb) == SQLITE_OK)
	{
		char *error_ = nil;
		sqlite3_exec(finCalcDb, [sqlQuery UTF8String], NULL, NULL, &error_);	
		if (error_) 
		{
			*error = [NSError errorWithDomain:[Utility getBundleId] 
										 code:1 
									 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:error_] forKey:NSLocalizedDescriptionKey]];
		}
	}
	
	if (finCalcDb) 
	{
		sqlite3_close(finCalcDb);
	}
}

/*
- (void) sqliteSelect:(NSString *)sqlQuery sqliteStatement:(sqlite3_stmt **)sqliteStatement
{
	// Setup the database object
	sqlite3 *database = nil;
	
	NSString *databasePath = [[self class] databasePath];
	
	Log(@"databasePath: %@", databasePath);
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)		
	{
		NSLog(@"sqlite3_open - SQLITE_OK");
		
		// Setup the SQL Statement and compile it for faster access
		//sqlite3_stmt *compiledStatement;
	
		if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &*sqliteStatement, NULL) == SQLITE_OK) 
		{
			NSLog(@"sqlite3_prepare_v2 - SQLITE_OK");
			//NSLog(@"statement: %@", sqlQuery);
			
			//while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			//{
				//NSString *zpk = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];				
				//NSLog(@"zpk: %@", zpk);
			//}
		}
		else 
		{
			//NSLog(@"failed to execute statement: %@", sqlQuery);
			NSLog(@"failed to execute statement");
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(sqliteStatement);				
	}
	
	if(database)
		sqlite3_close(database);
	
}
*/

+ (NSString *) databasePath
{
	return [Utility filePath:[[self class] databaseName]];
}

+ (NSString *) finCalcDbPath
{
    return [Utility filePath:[[self class] finCalcDbName]];
}

+ (NSString *) databaseName
{
	return @"fnaDb.sqlite";
}

+ (NSString *) finCalcDbName
{
    return @"FnaFinCalc.sqlite";
}

@end
