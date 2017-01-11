//
//  SQLiteManager.h
//  FNA
//
//  Created by Manulife on 3/5/12.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteManager : NSObject 
{

}

+ (BOOL) openDatabase:(sqlite3 **)database;
+ (BOOL) openFinCalcDb:(sqlite3 **)finCalcDb;
+ (void) closeDatabase:(sqlite3 **)database;
+ (void) closeFinCalcDb:(sqlite3 **)finCalcDb;

+ (void) sqliteExec:(NSString *)sqlQuery error:(NSError **)error;
+ (void) sqliteExec2:(NSString *)sqlQuery error:(NSError **)error;
+ (NSString *) databasePath;
+ (NSString *) finCalcDbPath;
+ (NSString *) databaseName;
+ (NSString *) finCalcDbName;
@end
