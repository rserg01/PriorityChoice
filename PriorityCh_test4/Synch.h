//
//  Synch.h
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Synch : NSObject

+ (BOOL) synchToServer;

+ (NSNumber *) internetReachable;

+ (NSString *) syncPersonal: (NSString *)clientId;

+ (NSString *) syncOtherTables:tableName
                   withDataSet:(NSString *)dataset
                  withClientId:(NSString *)clientId;

+ (NSString*) createTables: (NSString *)tableName
               withDataSet:(NSString *)dataset
              withClientId:(NSString *)clientId;

+ (NSString*) createTables2: (NSString *)tableName
                withDataSet:(NSString *)dataset
               withClientId:(NSString *)clientId;

+ (NSString *) sendToServer:(NSString *)resultArrayString;

@end
