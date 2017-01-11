//
//  Utility.h
//
//  Created by Manulife on 02/29/12.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (UIAlertView *) showAlerViewWithTitle:(NSString *)title 
							withMessage:(NSString *)message
				  withCancelButtonTitle:(NSString *)cancelButtonTitle
				   withOtherButtonTitle:(NSString *)otherButtonTitle
							withSpinner:(BOOL)spinner
						   withDelegate:(id)delegate;

+ (NSString *) getBundleId;
+ (NSString*) getUDID;
+ (NSString *) documentsDirectory;
+ (NSString *) filePath:(NSString *)file;
+ (NSString*) dataToString:(NSData *)data;
+ (NSData *) stringToData:(NSString *)string;
+ (void) saveToUserDefaults:(NSString*)key value:(NSString*)value;
+ (NSString*) getUserDefaultsValue:(NSString*)key;
+ (void) setEnableTabBarItems:(BOOL)value items:(NSArray*)items;
+ (BOOL) validateEmail:(NSString *)emailstring;

+ (NSString *) fortmatNumberCurrencyStyle:(NSString *)number withCurrencySymbol:(NSString *)symbol;
+ (NSString *) formatAccountValueStyle:(NSString *)number withCurrencySymbol:(NSString *)symbol;

+ (NSArray *) getColumnNamesForTable:(NSString*)tableName;
+ (NSArray *) getColumnNames:(NSString *)tableName;
+ (NSDictionary *) getDataSetFromFieldNames:(NSArray*)fieldNames withTable:(NSString*)tableName withClientID:(NSString*)clientID withDataSetName:(NSString*)dataSetName;
+ (NSDictionary *) getDataSetFromFieldNames2:(NSArray*)fieldNames withTable:(NSString*)tableName withClientID:(NSString*)clientID withDataSetName:(NSString*)dataSetName;

+ (NSArray *) getTableNames;
+ (NSDictionary *) createDataSetForUpload:(NSString*)clientID;

@end



