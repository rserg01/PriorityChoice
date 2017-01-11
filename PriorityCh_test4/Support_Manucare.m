//
//  Support_Manucare.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_Manucare.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNASession.h"
#import "Session_Manucare.h"
#import "FNASession.h"
#import "Support_Retirement.h"


@implementation Support_Manucare

+ (NSNumber *) checkExistingRiskCapacity: (NSString *)profileId
{
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect =
            [NSString stringWithFormat:@"SELECT "
                                   @"RC_TimeFrame_score, "
                                   @"RC_Retirement_score, "
                                   @"RC_Investment_score, "
                                   @"RC_CashFlow_score, "
                                   @"RC_Age_score "
								   @"FROM tManucare WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Manucare sharedSession].timeFrame =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [Session_Manucare sharedSession].retirementPlan =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [Session_Manucare sharedSession].needForInvestment =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [Session_Manucare sharedSession].cashFlowNeeds =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                    [Session_Manucare sharedSession].ageScore =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return [NSNumber numberWithInt:([[Session_Manucare sharedSession].timeFrame intValue] +
                                    [[Session_Manucare sharedSession].retirementPlan intValue] +
                                    [[Session_Manucare sharedSession].needForInvestment intValue] +
                                    [[Session_Manucare sharedSession].cashFlowNeeds intValue] +
                                    [[Session_Manucare sharedSession].ageScore intValue])];
}

+ (NSNumber *) checkExistingRiskAttitude: (NSString *)profileId
{
    sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect =
            [NSString stringWithFormat:@"SELECT "
             @"RA_InvestDrop_score, "
             @"RA_InvestValue_score, "
             @"RA_Returns_score, "
             @"RA_RiskDegree_score, "
             @"RA_Review_score, "
             @"RA_Overall_score "
             @"FROM tManucare WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Manucare sharedSession].investmentDrop =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
                    [Session_Manucare sharedSession].interestValue =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)] ;
                    [Session_Manucare sharedSession].returns =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)] ;
                    [Session_Manucare sharedSession].riskDegree =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)] ;
                    [Session_Manucare sharedSession].reviewFrequency =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)] ;
                    [Session_Manucare sharedSession].overallAttitude =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)] ;
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    return [NSNumber numberWithInt:([[Session_Manucare sharedSession].investmentDrop intValue] +
                                    [[Session_Manucare sharedSession].interestValue intValue] +
                                    [[Session_Manucare sharedSession].returns intValue] +
                                    [[Session_Manucare sharedSession].riskDegree intValue] +
                                    [[Session_Manucare sharedSession].reviewFrequency intValue] +
                                    [[Session_Manucare sharedSession].overallAttitude intValue])];
}

+ (NSError *) getManucare: (NSString *)profileId
{
    NSError *error=nil;
    
    sqlite3 *database = nil;
    
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
                                   @"RC_TimeFrame_score, "
                                   @"RC_Retirement_score, "
                                   @"RC_Investment_score, "
                                   @"RC_CashFlow_score, "
                                   @"RC_Age_score, "
                                   @"RA_InvestDrop_score, "
                                   @"RA_InvestValue_score, "
                                   @"RA_Returns_score, "
                                   @"RA_RiskDegree_score, "
                                   @"RA_Review_score, "
                                   @"RA_Overall_score "
								   @"FROM tManucare WHERE _Id=%@", profileId];
            
			sqlite3_stmt *sqliteStatement = NULL;
            
            NSLog(@"sqlStatement = %@", sqlSelect);
            
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
                    [Session_Manucare sharedSession].timeFrame =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)];
                    [Session_Manucare sharedSession].retirementPlan =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 1)];
                    [Session_Manucare sharedSession].needForInvestment =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 2)];
                    [Session_Manucare sharedSession].cashFlowNeeds =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 3)];
                    [Session_Manucare sharedSession].ageScore =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 4)];
                    [Session_Manucare sharedSession].investmentDrop =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 5)];
                    [Session_Manucare sharedSession].interestValue =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 6)];
                    [Session_Manucare sharedSession].returns =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 7)];
                    [Session_Manucare sharedSession].riskDegree =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 8)];
                    [Session_Manucare sharedSession].reviewFrequency =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 9)];
                    [Session_Manucare sharedSession].overallAttitude =[NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 10)];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			[SQLiteManager sqliteExec:sqlSelect error:&error];
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}
	}
    
    [Session_Manucare sharedSession].riskCapacityScore= [self getRiskCapacityScore:[Session_Manucare sharedSession].timeFrame
                                                                                    retirement:[Session_Manucare sharedSession].retirementPlan
                                                                                      cashFlow:[Session_Manucare sharedSession].cashFlowNeeds
                                                                                    investment:[Session_Manucare sharedSession].needForInvestment
                                                                                      ageScore:[Session_Manucare sharedSession].ageScore];
    
    [Session_Manucare sharedSession].riskAttitudeScore = [self getRiskAttitudeScore:[Session_Manucare sharedSession].investmentDrop
                                                                                  interestValue:[Session_Manucare sharedSession].interestValue
                                                                                        returns:[Session_Manucare sharedSession].returns
                                                                                     riskDegree:[Session_Manucare sharedSession].riskDegree
                                                                                         review:[Session_Manucare sharedSession].reviewFrequency
                                                                                        overall:[Session_Manucare sharedSession].overallAttitude];
    
    return error;
}

+ (NSError *) newManucare: (NSString *)profileId
                 ageScore: (NSNumber *) ageScore
{
    NSError *error = nil;
    
    profileId = [FNASession sharedSession].profileId;
	NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tManucare ("
                           @"_Id, ClientId, "
                           @"RC_TimeFrame_score, "
                           @"RC_Retirement_score, "
                           @"RC_Investment_score, "
                           @"RC_CashFlow_score, "
                           @"RC_Age_score, "
                           @"RA_InvestDrop_score, "
                           @"RA_InvestValue_score, "
                           @"RA_Returns_score, "
                           @"RA_RiskDegree_score, "
                           @"RA_Review_score, "
                           @"RA_Overall_score "
						   @") VALUES ("
                           @"%@, %@,"
                           @"%d, %d, %d, %d, %@, %d, %d, %d, %d, %d, %d )",
						   profileId,profileId,
                           0, 0, 0, 0, ageScore, 0, 0, 0, 0, 0, 0];
	
	NSLog(@"newManucare: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSError *) updateManucare: (NSString *)profileId
{
    NSError *error = nil;

	NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE tManucare SET "
                           @"RC_TimeFrame_score = %@, "
                           @"RC_Retirement_score = %@, "
                           @"RC_Investment_score= %@, "
                           @"RC_CashFlow_score= %@, "
                           @"RC_Age_score= %@, "
                           @"RA_InvestDrop_score= %@, "
                           @"RA_InvestValue_score= %@, "
                           @"RA_Returns_score= %@, "
                           @"RA_RiskDegree_score= %@, "
                           @"RA_Review_score= %@, "
                           @"RA_Overall_score= %@ "
                           @"WHERE _Id = %@",
                           
                           [Session_Manucare sharedSession].timeFrame,
                           [Session_Manucare sharedSession].retirementPlan,
                           [Session_Manucare sharedSession].needForInvestment,
                           [Session_Manucare sharedSession].cashFlowNeeds,
                           [Session_Manucare sharedSession].ageScore,
                           [Session_Manucare sharedSession].investmentDrop,
                           [Session_Manucare sharedSession].interestValue,
                           [Session_Manucare sharedSession].returns,
                           [Session_Manucare sharedSession].riskDegree,
                           [Session_Manucare sharedSession].reviewFrequency,
                           [Session_Manucare sharedSession].overallAttitude,
                           profileId ];
    
	NSLog(@"sqlIncomeProtectionInsert: %@", sqlInsert);
	
    [SQLiteManager sqliteExec:sqlInsert error:&error];
    
    return error;
}

+ (NSNumber *) getRiskCapacityScore: (NSNumber *) timeFrame
                         retirement: (NSNumber *) retirement
                           cashFlow: (NSNumber *) cashflow
                         investment: (NSNumber *) investment
                           ageScore: (NSNumber *) ageScore
{
    NSLog(@"capacitySCore = %@", [NSNumber numberWithInt:([timeFrame intValue] + [retirement intValue] + [cashflow intValue] + [investment intValue] + [ageScore intValue])]);
    
    return [NSNumber numberWithInt:([timeFrame intValue] + [retirement intValue] + [cashflow intValue] + [investment intValue] + [ageScore intValue])];
}

+ (NSNumber *) getRiskAttitudeScore: (NSNumber *)investmentDrop
                      interestValue: (NSNumber *)interestValue
                            returns: (NSNumber *)returns
                         riskDegree: (NSNumber *)riskDegree
                             review: (NSNumber *)review
                            overall: (NSNumber *) overall
{
    return [NSNumber numberWithInt:([investmentDrop intValue] +
                                    [interestValue intValue] +
                                    [returns intValue] +
                                    [riskDegree intValue] +
                                    [review intValue] +
                                    [overall intValue])];
}

+ (NSString *) riskCapacitytScoreInterpretation: (NSNumber *) riskCapacityScore
{
    NSString *yourScoreString;
    
        
        if ([riskCapacityScore intValue] > 0 && [riskCapacityScore intValue] < 8 ) {
            
            //result = @"Low";
            yourScoreString = [NSString stringWithFormat:@"Your Risk Capacity Score is Low (%i points)\n"
                                                 "This may suggest that you have a low capacity to assume risks and can only afford to absorb minimal losses. A portfolio with low returns but with emphasis on capital preservation and low volatility may be appropriate for your situation.",[riskCapacityScore intValue]];
            
        } else if ([riskCapacityScore intValue] > 7 && [riskCapacityScore intValue] < 13) {
            
            //result = @"Medium";
            yourScoreString = [NSString stringWithFormat:@"Your Risk Capacity Score is Medium (%i points)\n"
                               "It would appear that you can afford to invest in a balance of risky and secure assets with moderate risk exposure and that you can take a share of growth in the risky assets but would be hesitant to gamble your full capital. Balancing between profits and loss reduction may be an appropriate goal.",[riskCapacityScore intValue]];
            
        } else if ([riskCapacityScore intValue] > 12 && [riskCapacityScore intValue] < 16){
            
            //result = @"High";
            yourScoreString = [NSString stringWithFormat:@"Your Risk Capacity Score is High (%i points)\n"
                               "In general, you may have the capacity to take a hit and not be excessively concerned given your capability to absorb a loss and wait out short-term drops, as fluctuations are something you apparently can afford. It would seem that, for you, security of capital is secondary to the potential for wealth accumulation.", [riskCapacityScore intValue]];
        } else {
            
            yourScoreString = @"Fill out the questions to know your score.";
            
        }
    
    return yourScoreString;
}

+ (NSString *) riskAttitudeScoreInterpretation: (NSNumber *) riskAttitudeScore
{
    
    NSString *yourScoreString = @"";
        
        if ([riskAttitudeScore intValue] > 0 && [riskAttitudeScore intValue] < 10) {
            
            yourScoreString = [NSString stringWithFormat:@"Your Risk Attitude Score is Conservative (%i points) \n"
                               "It is apparent that you are an investor with very low risk appetite, not willing to tolerate “noticeable downside market fluctuations”, and are prepared to forego significant upside potential. A fund invested primarily in fixed-income instruments may be suitable for you."
                               , [riskAttitudeScore intValue]];
            
        } else if ([riskAttitudeScore intValue] > 9 && [riskAttitudeScore intValue] < 15) {
            
            yourScoreString = [NSString stringWithFormat:@"Your Risk Attitude Score is Moderate (%i points) \n"
                               "You seem to have a moderate tolerance for risk; comfortable with modest short -term capital losses and fluctuations in your investment in anticipationof higher return. A fund composed predominantly of fixed-income instruments mixed with high-risk equities appears to be suitable for you."
                               
                               , [riskAttitudeScore intValue]];
            
        } else if ([riskAttitudeScore intValue] > 14 && [riskAttitudeScore intValue] < 19){
            
            yourScoreString = [NSString stringWithFormat:@"Your Risk Attitude Score is Aggressive (%i points) \n"
                               "This may indicate that you have the willingness to assume a high level of risk and may be prepared to lose majority of your money in exchange for the highest possible return. Fluctuations do not seem to matter to you as you appear to accept that occasional poor outcomes are a necessary part of long-term investment. You might prefer a fund allocation which is almost entirely biased towards equities."
                               
                               , [riskAttitudeScore intValue]];
            
        } else {
            
            yourScoreString = @"Fill out the questions to know your score.";
        }
    
    return yourScoreString;
}

+ (NSNumber *) getAgeScore
{
    NSNumber *score;
    
    NSNumber *currentAge =  [Support_Retirement getCurrentAge:[Support_Retirement getBirthdate:[FNASession sharedSession].clientDob]];
    
    NSLog(@"currentAge = %@", currentAge);
    
    if ([currentAge compare:[NSNumber numberWithInt:55]] == NSOrderedDescending) {
        
        score = [NSNumber numberWithInt:1];
    }
    else if ([currentAge compare:[NSNumber numberWithInt:35]] == NSOrderedDescending &&
        [currentAge compare:[NSNumber numberWithInt:56]] == NSOrderedAscending) {
        
        score = [NSNumber numberWithInt:2];
    }
    else if ([currentAge compare:[NSNumber numberWithInt:17]] == NSOrderedDescending &&
        [currentAge compare:[NSNumber numberWithInt:36]] == NSOrderedAscending) {
        
        score = [NSNumber numberWithInt:3];
    }
    else {
        score = [NSNumber numberWithInt:0];
    }
    
    return score;
}

+ (NSString *) getBtnString: (NSString *) question score:(NSNumber *) score
{
    NSString *btnString = [[[NSString alloc]init]autorelease];
    btnString = @"";
    
    if ([question isEqualToString:kQuestion_TimeFrame]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kTimeFrame_Ans1;
                break;
            case 2:
                btnString = kTimeFrame_Ans2;
                break;
            case 3:
                btnString = kTimeFrame_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_RetirementPlan]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kRetirementPlan_Ans1;
                break;
            case 2:
                btnString = kRetirementPlan_Ans2;
                break;
            case 3:
                btnString = kRetirementPlan_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_NeedforInvestment]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kNeedForInvestment_Ans1;
                break;
            case 2:
                btnString = kNeedForInvestment_Ans2;
                break;
            case 3:
                btnString = kNeedForInvestment_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_CashFlowNeeds]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kCashFlowNeeds_Ans1;
                break;
            case 2:
                btnString = kCashFlowNeeds_Ans2;
                break;
            case 3:
                btnString = kCashFlowNeeds_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_InvestmentDrop]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kInvestmentDrop_Ans1;
                break;
            case 2:
                btnString = kInvestmentDrop_Ans2;
                break;
            case 3:
                btnString = kInvestmentDrop_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_InterestValue]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kInterestValue_Ans1;
                break;
            case 2:
                btnString = kInterestValue_Ans2;
                break;
            case 3:
                btnString = kInterestValue_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_Returns]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kReturns_Ans1;
                break;
            case 2:
                btnString = kReturns_Ans2;
                break;
            case 3:
                btnString = kReturns_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_RiskDegree]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kRiskDegree_Ans1;
                break;
            case 2:
                btnString = kRiskDegree_Ans2;
                break;
            case 3:
                btnString = kRiskDegree_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_ReviewFrequency]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kReview_Ans1;
                break;
            case 2:
                btnString = kReview_Ans2;
                break;
            case 3:
                btnString = kReview_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    if ([question isEqualToString:kQuestion_Overall]) {
        
        switch ([score intValue]) {
            case 1:
                btnString = kOverall_Ans1;
                break;
            case 2:
                btnString = kOverall_Ans2;
                break;
            case 3:
                btnString = kOverall_Ans3;
                break;
            default:
                btnString = @"";
                break;
        }
    }
    
    
    return btnString;
}

+ (void) clearValues
{
    [Session_Manucare sharedSession].timeFrame =nil;
    [Session_Manucare sharedSession].retirementPlan =nil;
    [Session_Manucare sharedSession].needForInvestment =nil;
    [Session_Manucare sharedSession].cashFlowNeeds =nil;
    [Session_Manucare sharedSession].ageScore =nil;
    [Session_Manucare sharedSession].investmentDrop =nil;
    [Session_Manucare sharedSession].interestValue =nil;
    [Session_Manucare sharedSession].returns =nil;
    [Session_Manucare sharedSession].riskDegree =nil;
    [Session_Manucare sharedSession].reviewFrequency =nil;
    [Session_Manucare sharedSession].overallAttitude =nil;
}

@end
