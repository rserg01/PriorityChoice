//
//  Activation.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/28/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Activation.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "NSData+Base64.h"
#import "SBJSON.h"
#import "FnaConstants.h"

@implementation Activation

+ (BOOL)checkExpiration: (NSString *)expirationDateString
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *expirationDate = [[NSDate alloc] init];
    // voila!
    expirationDate = [dateFormatter dateFromString:expirationDateString];
    [dateFormatter release];
    
    NSComparisonResult result = [now compare:expirationDate];
    
    return result == NSOrderedAscending ? NO : YES;
}

+ (BOOL) cydiaCheck
{

    NSString *filePath = @"/Applications/Cydia.app";
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] ? YES : NO;
}

+ (NSString *) activateApp: (NSString *) agentCode
                 birthDate: (NSString *) birthdate
                       tin: (NSString *) tin
                  username: (NSString *) username
                  password: (NSString *) password
{
    
    NSDictionary *stubData = [NSDictionary dictionaryWithObjectsAndKeys:
                              agentCode,@"agentcode",
                              tin,@"tin",
                              birthdate,@"birthdate",
                              nil];
    
    SBJSON *json = [[SBJSON alloc] init];
    NSString *resultArrayString = [json stringWithObject:stubData allowScalar:YES error:nil];
    
    [json release];
    
    NSURL *url = [NSURL URLWithString:kActivationUrl_AWS_Debug];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy: NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:60];
    
    
    NSData *requestData = [NSData dataWithBytes:[resultArrayString UTF8String] length:[resultArrayString length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSError *oError = [[NSError alloc] init];
    NSHTTPURLResponse *oResponseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&oResponseCode error:&oError];
    NSString *strResult = [[NSString alloc] initWithData:oResponseData
                                                encoding:NSUTF8StringEncoding];
    NSLog(@"agentCode = %@", agentCode);
    NSLog(@"birthdate = %@", birthdate);
    NSLog(@"tin = %@", tin);
    NSLog(@"strResult = %@", strResult);
    
    /*
     AWS FNA Service Return Results
     1 - Agent is MP
     2 - Agent is MCB
     -1 - Agent Code is incorrect
     -2 - Agent not active
     -3 - Agent birthdate incorrect 
     -4 - Agent TIN is incorrect
     */
    
    return strResult;
}

+ (NSError *) saveAgentInfo: (NSString *) strResult
                   username: (NSString *) username
                   password: (NSString *) password
                  agentCode: (NSString *) agentCode
                        tin: (NSString *) tin
                  birthdate:(NSString *) birthdate
{
    NSError *error = nil;
    
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    
    NSDictionary *jsonObject = [json objectWithString:strResult error:NULL];
    NSLog(@"dictionary");
    NSLog(@"%@ - %@", [jsonObject objectForKey:@"agentname"],[jsonObject objectForKey:@"agentemail"]);
    
    NSString *strResult_AgentName = [jsonObject objectForKey:@"agentname"];
    
    NSLog(@"responseData = %@", strResult_AgentName);
    NSLog(@"jsonobject_count = %lu", (unsigned long)[jsonObject count]);
    
    if([jsonObject count] > 0) //TODO: original: ([arr count] == 9)
    {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tAgentInfo ("
                               @"_Id, Username, Password, "
                               @"AgentCode, DateOfBirth, Email, Tin, FullName) "
                               @"VALUES("
                               @"%@, \"%@\", \"%@\", "
                               @"\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               @"1", username, password,
                               agentCode, birthdate,[NSString stringWithFormat:@"%@", [jsonObject objectForKey:@"agentemail"]] , tin, [NSString stringWithFormat:@"%@", [jsonObject objectForKey:@"agentname"]]];
        
        
        NSLog(@"sqlInsert: %@", sqlInsert);
        [SQLiteManager sqliteExec:sqlInsert error:&error];
        
        if (!error)
        {
            //check distribution channel
            NSString *channel = @"";
            if ([[agentCode substringToIndex:1] isEqualToString:@"C"]) {
                channel = @"MBCL";
            } else {
                channel = @"AGENCY";
            }
            
            [Utility saveToUserDefaults:@"USERNAME" value:username];
            [Utility saveToUserDefaults:@"PASSWORD" value:password];
            [Utility saveToUserDefaults:@"CHANNEL" value:channel];
            [Utility saveToUserDefaults:@"LOCKOUT" value:@"NO"];
        }
    }
    
    return error;
}

+ (NSError *) saveNewPassword: (NSString *) password

{
    NSError *error = nil;
   
        NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tAgentInfo SET "
                               @"Password = \"%@\" "
                               @"WHERE _Id = %@",
                               password, @"1"];
        
        
        NSLog(@"sqlInsert: %@", sqlInsert);
        [SQLiteManager sqliteExec:sqlInsert error:&error];
        
        if (!error)
        {
            [Utility saveToUserDefaults:@"PASSWORD" value:password];
        }
    
    return error;
}

+ (BOOL) loginToApp: (NSString *) username
           password: (NSString *) password
{
    if ([username isEqualToString:[Utility getUserDefaultsValue:@"USERNAME"]]) {
        if ([password isEqualToString:[Utility getUserDefaultsValue:@"PASSWORD"]]) {
            return YES;
        }
    }
   
    return NO;
    
}

+ (NSMutableArray *) getAgentInfo
{
    NSError *error = nil;
    
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
        NSString *sqlSelect = @"SELECT AgentCode, Email, FullName FROM tAgentInfo";
        
        sqlite3_stmt *sqliteStatement = NULL;
        
        NSLog(@"sqlStatement = %@", sqlSelect);
        
        if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
            {
                [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)], @"agentCode", [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)], @"agentEmail", [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)], @"agentFullName",nil]];
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(sqliteStatement);
        [SQLiteManager sqliteExec:sqlSelect error:&error];
        [SQLiteManager closeDatabase:&database]; //make sure to close the database
    }
    
    return arr;
}

+ (BOOL) passwordValidation: (NSString *) password
{
    
    NSRegularExpression *passwordRegex = [NSRegularExpression regularExpressionWithPattern:kPasswordValidation options:NSRegularExpressionCaseInsensitive error:nil];
    
    int numberMatches = [passwordRegex numberOfMatchesInString:password options:0 range:NSMakeRange(0, password.length)];
    
    BOOL validPassword = numberMatches > 0;
    
    return validPassword;
}

@end
