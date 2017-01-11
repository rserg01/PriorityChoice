//
//  Synch.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Synch.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "SBJSON.h"
#import "FnaConstants.h"
#import "Reacheability.h"
#import "GetPersonalProfile.h"


@implementation Synch

+ (BOOL) synchToServer
{
    BOOL result = FALSE;
    
        NSMutableArray *numOfClients = [[[NSMutableArray alloc]init]autorelease];
        
        numOfClients = [GetPersonalProfile getAllProfileNames_Synch];
        
        if ([numOfClients count] > 0) {
            
            int clientCount = [numOfClients count] + 1;
            
            for (int i = 1; i < clientCount; i++)
            {
                NSDictionary *dic = [numOfClients objectAtIndex:(i - 1)];
                
                if ([[Synch syncPersonal:[dic objectForKey:@"profileId"]] isEqualToString:@"1"])
                {
                    NSArray *tableArray = [NSArray arrayWithObjects:@"tProfile_Dependent", @"tProfile_Spouse", @"tPriorityRank", @"tEducFunding", @"tIncomeProtection", @"tRetirementPlanning", @"tFundAccumulation", @"tImpairedHealth", @"tEstatePlanning" , nil];
                    
                    NSArray *datasetArray = [NSArray arrayWithObjects:@"dependent", @"spouse", @"priorityDataSet", @"educDataSet", @"incomeDataSet", @"retirementDataSet", @"investmentDataSet", @"healthDataSet", @"estateDataSet" , nil];
                    
                    for (int i = 0; i < [tableArray count]; i++) {
                        
                        if([[Synch syncOtherTables:[tableArray objectAtIndex:i] withDataSet:[datasetArray objectAtIndex:i] withClientId:[dic objectForKey:@"profileId"]] isEqualToString:@"1"])
                        {
                            result = TRUE;
                        }
                    }
                }
            }
        }
        
    //TODO: add deletion for data in table (AISO requirement)
    
    return result;
    
}

+ (NSNumber *) internetReachable
{
    __block NSNumber *retVal = [[[NSNumber alloc]init]autorelease];
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:kWebsiteMyManulife];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        retVal = [NSNumber numberWithInt:1];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        retVal = [NSNumber numberWithInt:0];
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    //[reach startNotifier];
    
    return retVal;
}

+ (NSString *) syncPersonal: (NSString *)clientId
{
    NSString *resultArrayString = [self createTables:@"tProfile_Personal" withDataSet:@"client" withClientId:clientId];
    NSString *strResult = [self sendToServer:resultArrayString];
    NSLog(@"strResult Personal = %@", strResult);
    return strResult;
}

+ (NSString *) syncOtherTables:tableName
                   withDataSet:(NSString *)dataset
                  withClientId:(NSString *)clientId
{
    NSString *resultArrayString = [self createTables2:tableName withDataSet:dataset withClientId:clientId];
    NSString *strResult = [self sendToServer:resultArrayString];
    NSLog(@"strResult Personal = %@", strResult);
    return strResult;
}


+ (NSString*) createTables: (NSString *)tableName
               withDataSet:(NSString *)dataset
              withClientId:(NSString *)clientId
{
    NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:tableName]];
    
    NSDictionary *dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames:arrFieldnames withTable:tableName withClientID:clientId withDataSetName:dataset]];
    
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    NSString *resultArrayString = [json stringWithObject:dicResult allowScalar:YES error:nil];
    
    NSDictionary *dicTemp = [[[NSDictionary alloc] init] autorelease];
    dicTemp = [dicResult objectForKey:@"result"];
    resultArrayString = [json stringWithObject:dicTemp allowScalar:YES error:nil];
    
    NSLog(@"%@ = %@", tableName, resultArrayString);
    
    return resultArrayString;
}

+ (NSString*) createTables2: (NSString *)tableName
                withDataSet:(NSString *)dataset
               withClientId:(NSString *)clientId
{
    NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:tableName]];
    
    NSDictionary *dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames2:arrFieldnames withTable:tableName withClientID:clientId withDataSetName:dataset]];
    
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    NSString *resultArrayString = [json stringWithObject:dicResult allowScalar:YES error:nil];
    
    NSDictionary *dicTemp = [[[NSDictionary alloc] init] autorelease];
    dicTemp = [dicResult objectForKey:@"result"];
    resultArrayString = [json stringWithObject:dicTemp allowScalar:YES error:nil];
    
    NSLog(@"%@ = %@", tableName, resultArrayString);
    
    return resultArrayString;
}

+ (NSString *) sendToServer:(NSString *)resultArrayString
{
    NSURL *url = [NSURL URLWithString:kSynchUrl_Debug];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy: NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:300];
    
    
    NSData *requestData = [NSData dataWithBytes:[resultArrayString UTF8String]  length:[resultArrayString length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSError *oError = [[NSError alloc] init];
    NSHTTPURLResponse *oResponseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&oResponseCode error:&oError];
    NSString *strResult = [[NSString alloc] initWithData:oResponseData
                                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"strResult=%@", strResult);
    
    return strResult;
}

@end
