//
//  Support_FinCalc.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "Support_FinCalc.h"
#import "FnaConstants.h"
#import "ReferenceDataDao.h"
#import "FNASession.h"
#import "Support_Retirement.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "Utility.h"

@implementation Support_FinCalc

+ (NSMutableArray *) Validate: (NSNumber *) premium
                     bondFund: (NSNumber *) bondFund
                   equityFund: (NSNumber *) equityFund
                   stableFund: (NSNumber *) stableFund
                      apbFund: (NSNumber *) apbFund
                 balancedFund: (NSNumber *) balancedFund
                          age: (NSNumber *) age
                          sex: (NSString *) sex
                  productName: (NSString *) productName
                     currency: (NSNumber *) currency
                       dbType: (NSNumber *) dbType
                      channel: (NSString *) channel
{
    //NSArray for funds
    NSMutableArray *arrFunds = [[[NSMutableArray alloc]init]autorelease];
    [arrFunds addObject:[NSDictionary dictionaryWithObjectsAndKeys:bondFund, @"bondFund", stableFund, @"stableFund", equityFund, @"equityFund",  apbFund, @"apbFund", balancedFund, @"balancedFund", nil]];
    
    //NSArry for Errors
    NSMutableArray *arrErrors = [[[NSMutableArray alloc]init]autorelease];
    
    if ([age compare:[NSNumber numberWithInt:0]] == NSOrderedAscending) {
        [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kAgeError, @"Error", nil]];
    }
    else if ([age compare:[NSNumber numberWithInt:70]] == NSOrderedDescending) {
        [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kAgeError, @"Error", nil]];
    }
    
    //check percentage values
    if ([arrErrors count] == 0) {
     
        if (![self percentageValidation:bondFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPercentageValue, @"Error", nil]];
        }
        
        if (![self percentageValidation:equityFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPercentageValue, @"Error", nil]];
        }
        
        if (![self percentageValidation:stableFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPercentageValue, @"Error", nil]];
        }
        
        if (![self percentageValidation:apbFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPercentageValue, @"Error", nil]];
        }
        
        if (![self percentageValidation:balancedFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPercentageValue, @"Error", nil]];
        }
        
    }
    
    
    if ([arrErrors count] == 0) {
        
        NSDictionary *item = [arrFunds objectAtIndex:0];
        
        //check fund allocation divisibility
        
        if (![self checkDivisibility:[item objectForKey:@"bondFund"]]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrDivisibility, @"Error", nil]];
        }
        
        if (![self checkDivisibility:[item objectForKey:@"stableFund"]]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrDivisibility, @"Error", nil]];
        }
        
        if (![self checkDivisibility:[item objectForKey:@"equityFund"]]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrDivisibility, @"Error", nil]];
        }
        
        if (![self checkDivisibility:[item objectForKey:@"apbFund"]]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrDivisibility, @"Error", nil]];
        }
        
        if (![self checkDivisibility:[item objectForKey:@"balancedFund"]]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrDivisibility, @"Error", nil]];
        }
        
        //check minimum fund allocation
        
        if ([productName isEqualToString:kProductName_AffluenceGold]) {
            
            if ([currency compare:[NSNumber numberWithInt:14]] == NSOrderedSame) {
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"bondFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_EnrichMax_Peso_Bond : kErrMinAlloc_AffGold_Peso_Bond, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"equityFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_EnrichMax_Peso_Equity : kErrMinAlloc_AffGold_Peso_Equity, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"stableFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_EnrichMax_Peso_Stable : kErrMinAlloc_AffGold_Peso_Stable, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"balancedFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_AffGold_Peso_Balanced : kErrMinAlloc_AffGold_Peso_Balanced, @"Error", nil]];
                }
                
            } else {
            
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"bondFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_EnrichMax_Dollar : kErrMinAlloc_AffGold_Dollar, @"Error", nil]];
                }
            }
            
        }
        
        if ([productName isEqualToString:kProductName_AffluenceMaxGold]) {
            
            if ([currency compare:[NSNumber numberWithInt:14]] == NSOrderedSame) {
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"bondFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Platinum_Peso_Secure : kErrMinAlloc_AffGoldMax_Peso_Secure, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"equityFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Platinum_Peso_Growth : kErrMinAlloc_AffGoldMax_Peso_Growth, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"stableFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Platinum_Peso_Diversified : kErrMinAlloc_AffGoldMax_Peso_Diversified, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"balancedFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? @"" : kErrMinAlloc_AffGoldMax_Peso_Dynamic, @"Error", nil]];
                }
                
            } else {
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"bondFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Platinum_Dollar_Secure : kErrMinAlloc_AffGoldMax_Dollar_Secure, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"equityFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Paltinum_Dollar_Growth : kErrMinAlloc_AffGoldMax_Dollar_Growth, @"Error", nil]];
                }
                
                if (![self checkMinimumFuncAllocation:[item objectForKey:@"apbFund"]]) {
                    [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[channel isEqualToString:@"MBCL"] ? kErrMinAlloc_Paltinum_Dollar_Apbf : kErrMinAlloc_AffGoldMax_Dollar_Apbf, @"Error", nil]];
                }
            }
        }
        
        
        //check Minimum APBF and AGF Premium Allocation for dollar only
        if ([productName isEqualToString:kProductName_AffluenceMaxGold] || [productName isEqualToString:kProductName_PlatinumInvest]) {
            
            if ([currency compare:[NSNumber numberWithInt:2]]== NSOrderedSame) {
                
                if ([apbFund compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
                    
                    if ([self AgfApbfMinAllocation:apbFund
                                   equityAllocation:equityFund
                                           currency:currency
                                            premium:premium
                                        productName:productName]) {
                        
                        [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrAgfApbfMinPremAlloc, @"Error", nil]];
                    }
                }
                
                if ([equityFund compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
                    
                    if ([self AgfApbfMinAllocation:apbFund
                                   equityAllocation:equityFund
                                           currency:currency
                                            premium:premium
                                        productName:productName]) {
                        
                        [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrAgfApbfMinPremAlloc, @"Error", nil]];
                    }
                }
                
                
            }
            
            
        }
        
        if (![self checkTotalFundAllocation:bondFund equityFund:equityFund stableFund:stableFund apbf:apbFund balancedFund:balancedFund]) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrTotalFundAllocation, @"Error", nil]];
        }
        
        //check Premium
        
        if ([premium compare:[NSNumber numberWithDouble:0]] == NSOrderedSame) {
            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrPremiumIsRequired, @"Error", nil]];
        }
        else {
            
            if (![self checkPremiumAllocation:currency
                                      premium:premium
                                  productName:productName]) {
                
                if ([productName isEqualToString:kProductName_AffluenceMaxGold] || [productName isEqualToString:kProductName_PlatinumInvest]) {
                    switch ([currency intValue]) {
                        case kPesoCurrency:
                            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrMinPrem_AffMaxGold_Peso, @"Error", nil]];
                            break;
                        case kDollarCurrency:
                            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrMinPrem_AffMaxGold_Dollar, @"Error", nil]];
                        default:
                            break;
                    }
                }
                
                if ([productName isEqualToString:kProductName_AffluenceGold] || [productName isEqualToString:kProductName_EnrichMax]) {
                    switch ([currency intValue]) {
                        case kPesoCurrency:
                            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrMinPrem_AffGold_Peso, @"Error", nil]];
                            break;
                        case kDollarCurrency:
                            [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrMinPrem_AffGold_Dollar, @"Error", nil]];
                        default:
                            break;
                    }
                    
                }
                
                if ([productName isEqualToString:kproductName_WealthPremier]) {
                    
                     [arrErrors addObject:[NSDictionary dictionaryWithObjectsAndKeys:kErrMinPrem_WealthPremier, @"Error", nil]];
                }
            }
        }
    }
       
    return arrErrors;
   
}


+ (BOOL) checkDivisibility: (NSNumber *) fundAmount
{
    NSNumber *remainder = [NSNumber numberWithInt:([fundAmount intValue] % 5)];
    
    return [remainder compare:[NSNumber numberWithInt:0]]== NSOrderedSame  ? YES : NO;
}

+ (BOOL) checkMinimumFuncAllocation: (NSNumber *) fundAlloc {
    
    BOOL retVal = NO;
    
    if ([fundAlloc compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
        retVal = YES;
    }
    else if ([fundAlloc compare:[NSNumber numberWithDouble:20]] == NSOrderedSame) {
        retVal = YES;
    }
    else if ([fundAlloc compare:[NSNumber numberWithDouble:20]] == NSOrderedDescending) {
        retVal = YES;
    }
    
    return retVal;
}

+ (BOOL) checkTotalFundAllocation: (NSNumber *) bondFund
                       equityFund: (NSNumber *) equityFund
                       stableFund: (NSNumber *) stableFund
                             apbf: (NSNumber *) apbf
                     balancedFund: (NSNumber *) balancedFund
{
    NSNumber *total = [NSNumber numberWithInt:[bondFund intValue] + [equityFund intValue] + [stableFund intValue] + [apbf intValue] + [balancedFund intValue]];
    
    return [total compare:[NSNumber numberWithInt:100]] == NSOrderedSame ? YES : NO;
}

+ (BOOL) AgfApbfMinAllocation : (NSNumber *) apbfAllocation
              equityAllocation: (NSNumber *) equityAllocation
                      currency: (NSNumber *) currency
                       premium: (NSNumber *) premium
                   productName: (NSString *) productName
{
    
    //check if AGF and APBF value is equal or greater than $12,500
    NSNumber *currentFundValue1 = 0;
    NSNumber *currentFundValue2 = 0;
    //NSNumber *divisor = [NSNumber numberWithDouble:100];
    NSNumber *apbfFundPercentage = [NSNumber numberWithDouble:([apbfAllocation doubleValue] / 100)] ;
    NSNumber *agfFundPercentage =[NSNumber numberWithDouble:([equityAllocation doubleValue] / 100)] ;
    
    BOOL retValue = FALSE;
    
    //check currency - only applicable to dollar
    if ([currency compare:[NSNumber numberWithInt:kDollarCurrency]] == NSOrderedSame ) {
        
        //check APBF if the value is >= $12500
        currentFundValue1 = [NSNumber numberWithDouble:([premium doubleValue] * [apbfFundPercentage doubleValue])];
        
        if (![apbfFundPercentage compare:[NSNumber numberWithInt:0]]==NSOrderedSame) {
            
            if ([currentFundValue1 compare:[NSNumber numberWithDouble:12499]]== NSOrderedAscending)  {
                retValue = TRUE;
            }
            else if ([currentFundValue1 compare:[NSNumber numberWithDouble:12499]]== NSOrderedSame)
            {
                retValue = TRUE;
            }
        }
        
        //check AGF if the value is >= $12500
        currentFundValue2 = [NSNumber numberWithDouble:([premium doubleValue] * [agfFundPercentage doubleValue])];
        
        if (![agfFundPercentage compare:[NSNumber numberWithDouble:0]]==NSOrderedSame) {
            
            if ([currentFundValue2 compare:[NSNumber numberWithDouble:12499]]== NSOrderedAscending)  {
                retValue = TRUE;
            }
            else if ([currentFundValue2 compare:[NSNumber numberWithDouble:12499]]== NSOrderedSame)
            {
                retValue = TRUE;
            }
        }
        
    }
    
    return  retValue;
    
}

+ (BOOL) checkPremiumAllocation: (NSNumber *) currency
                        premium: (NSNumber *) premium
                    productName: (NSString *) productName
{
    BOOL isValid = NO;
    
    if ([productName isEqualToString:kProductName_AffluenceMaxGold] || [productName isEqualToString:kProductName_PlatinumInvest]) {
        switch ([currency intValue]) {
            case kPesoCurrency:
                isValid = [premium compare:[NSNumber numberWithDouble:kMinimumPremiumAlloc_Peso_AffMaxGold]] == NSOrderedDescending ? YES : NO;
                break;
            case kDollarCurrency:
                isValid = [premium compare:[NSNumber numberWithDouble:kMinimumPremiumAlloc_Dollar_APBF_AGF]] == NSOrderedDescending ? YES : NO;
            default:
                break;
        }
    }
    
    if ([productName isEqualToString:kProductName_AffluenceGold] || [productName isEqualToString:kProductName_EnrichMax]) {
        switch ([currency intValue]) {
            case kPesoCurrency:
                if ([premium compare:[NSNumber numberWithDouble:75000]] == NSOrderedSame) {
                    isValid = YES;
                }
                else if ([premium compare:[NSNumber numberWithDouble:75000]] == NSOrderedDescending) {
                    isValid = YES;
                }
                break;
            case kDollarCurrency:
                if ([premium compare:[NSNumber numberWithDouble:1500]] == NSOrderedSame) {
                    isValid = YES;
                }
                else if ([premium compare:[NSNumber numberWithDouble:1500]] == NSOrderedDescending) {
                    isValid = YES;
                }
                break;
            default:
                break;
        }
    }
    
    if ([productName isEqualToString:kproductName_WealthPremier]) {
        
        if ([premium compare:[NSNumber numberWithDouble:10000]]==NSOrderedSame) {
            
            isValid = YES;
        }
        else if ([premium compare:[NSNumber numberWithDouble:10000]]==NSOrderedDescending) {
            
            isValid = YES;
        }
        else {
            
            isValid = NO;
        }
    }
    
    return isValid;
}

+ (NSNumber *) getCurrentAge
{
    return [Support_Retirement getCurrentAge:[Support_Retirement getBirthdate:[FNASession sharedSession].clientDob]];
}

+ (NSMutableArray *) getAccountValue: (NSNumber *) age
                             premium: (NSNumber *) premium
                      bondAllocation: (NSNumber *) bondAllocation
                    equityAllocation: (NSNumber *) equityAllocation
                    stableAllocation: (NSNumber *) stableAllocation
                  balancedAllocation: (NSNumber *) balancedAllocation
                      apbfAllocation: (NSNumber *) apbfAllocation
                          growthRate: (NSNumber *) growthRate
                         productName: (NSString *) productName
                            currency: (NSNumber *) currency
                               isFel: (NSNumber *) isFel
                              gender: (NSString *) gender
                        deathBenType: (NSNumber *) deathBenType
{
    NSMutableArray *arrchild = [[[NSMutableArray alloc]init]autorelease];
    
    NSNumber *tmpDbl = [[[NSNumber alloc]init]autorelease];
    tmpDbl = 0;
    NSNumber *premiumLoadAmt = [[[NSNumber alloc]init]autorelease];
    premiumLoadAmt = 0;
    NSNumber *premiumLoadRate = [[[NSNumber alloc]init]autorelease];
    premiumLoadRate = 0;
    NSNumber *bidOfferSpread = [[[NSNumber alloc]init]autorelease];
    bidOfferSpread = 0;
    NSNumber *bidOfferAmount = [[[NSNumber alloc]init]autorelease];
    bidOfferAmount = 0;
    NSNumber *netPremium = [[[NSNumber alloc]init]autorelease];
    netPremium = 0;
    NSNumber *acctValue = [[[NSNumber alloc]init]autorelease];
    acctValue = 0;
    NSNumber *currentAv = [[[NSNumber alloc]init]autorelease];
    currentAv = 0;
    NSNumber *db1NAAR = [[[NSNumber alloc]init]autorelease];
    db1NAAR = 0;
    NSNumber *db2NAAR = [[[NSNumber alloc]init]autorelease];
    db2NAAR = 0;
    NSNumber *finalNAAR = [[[NSNumber alloc]init]autorelease];
    finalNAAR = 0; 
    NSNumber *chargeCOI = [[[NSNumber alloc]init]autorelease];
    chargeCOI = 0;
    NSNumber *totalMonthlyCharge = [[[NSNumber alloc]init]autorelease];
    totalMonthlyCharge = 0;
    NSNumber *bondCurrentAV = [[[NSNumber alloc]init]autorelease];
    bondCurrentAV = 0;
    NSNumber *equityCurrentAV = [[[NSNumber alloc]init]autorelease];
    equityCurrentAV = 0;
    NSNumber *stableCurrentAV = [[[NSNumber alloc]init]autorelease];
    stableCurrentAV = 0;
    NSNumber *apbCurrentAV = [[[NSNumber alloc]init]autorelease];
    apbCurrentAV = 0;
    NSNumber *balancedCurrentAV = [[[NSNumber alloc]init]autorelease];
    balancedCurrentAV = 0;
    NSNumber *totalAV = [[[NSNumber alloc]init]autorelease];
    totalAV = 0;
    NSNumber *db1Total = [[[NSNumber alloc]init]autorelease];
    db1Total = 0;
    NSNumber *db2Total = [[[NSNumber alloc]init]autorelease];
    db2Total = 0;
    NSNumber *dbFinal = [[[NSNumber alloc]init]autorelease];
    dbFinal = 0;
    NSNumber *bondTotalAV = [[[NSNumber alloc]init]autorelease];
    bondTotalAV = 0;
    NSNumber *stableTotalAV = [[[NSNumber alloc]init]autorelease];
    stableTotalAV = 0;
    NSNumber *equityTotalAV = [[[NSNumber alloc]init]autorelease];
    equityTotalAV = 0;
    NSNumber *apbTotalAV = [[[NSNumber alloc]init]autorelease];
    apbTotalAV = 0;
    NSNumber *balancedTotalAV = [[[NSNumber alloc]init]autorelease];
    balancedTotalAV = 0;
    NSNumber *policyFee = [[[NSNumber alloc]init]autorelease];
    policyFee = 0;
    NSNumber *rateCOI = [[[NSNumber alloc]init]autorelease];
    rateCOI = 0;
    NSNumber *bondGrowthAnnual = [[[NSNumber alloc]init]autorelease]; //float
    bondGrowthAnnual = 0;
    NSNumber *stableGrowthAnnual = [[[NSNumber alloc]init]autorelease]; //float
    stableGrowthAnnual = 0;
    NSNumber *equityGrowthAnnual = [[[NSNumber alloc]init]autorelease]; //float
    equityGrowthAnnual = 0;
    NSNumber *apbGrowthAnnual = [[[NSNumber alloc]init]autorelease]; //float
    apbGrowthAnnual = 0;
    NSNumber *balancedGrowthAnnual = [[[NSNumber alloc]init]autorelease]; //float
    balancedGrowthAnnual = 0;
    NSNumber *bondGrowthMonthly = [[[NSNumber alloc]init]autorelease]; //float
    bondGrowthMonthly = 0;
    NSNumber *stableGrowthMonthly = [[[NSNumber alloc]init]autorelease]; //float
    stableGrowthMonthly = 0;
    NSNumber *equityGrowthMonthly = [[[NSNumber alloc]init]autorelease]; //float
    equityGrowthMonthly = 0;
    NSNumber *apbGrowthMonthly = [[[NSNumber alloc]init]autorelease]; //float
    apbGrowthMonthly = 0;
    NSNumber *balancedGrowthMonthly = [[[NSNumber alloc]init]autorelease]; //float
    balancedGrowthMonthly = 0;
    NSNumber *dbMultiplier = [NSNumber numberWithDouble:1.25];
    NSNumber *dbFinalRounded = [[[NSNumber alloc]init]autorelease];
    dbFinalRounded = 0;
    NSNumber *iterationValue = [[[NSNumber alloc]init]autorelease];
    iterationValue = 0;
    int yearSpan = 0;
    
    NSNumber *monthCount = [[[NSNumber alloc]init]autorelease];
    monthCount = 0;
    NSNumber *yearCount = [[[NSNumber alloc]init]autorelease];
    yearCount = 0;
    
    NSNumber *faceAmount = [[[NSNumber alloc]init]autorelease];
    faceAmount = [NSNumber numberWithDouble:([premium doubleValue] * [dbMultiplier doubleValue])] ;
    NSLog(@"faceAmount = %@", faceAmount);
    
    
    [arrchild removeAllObjects];

    bondGrowthAnnual = [self getAnnualGrowth:productName
                                    fundName:@"BOND"
                                    currency:currency
                             growthRateIndex:growthRate];
    
    bondGrowthMonthly = [self getMonthlyGrowth:productName
                                    fundName:@"BOND"
                                    currency:currency
                             growthRateIndex:growthRate];

    
    stableGrowthAnnual = [self getAnnualGrowth:productName
                                    fundName:@"STABLE"
                                    currency:currency
                             growthRateIndex:growthRate];
    
    stableGrowthMonthly = [self getMonthlyGrowth:productName
                                    fundName:@"STABLE"
                                    currency:currency
                             growthRateIndex:growthRate];

    
    equityGrowthAnnual = [self getAnnualGrowth:productName
                                    fundName:@"EQUITY"
                                    currency:currency
                             growthRateIndex:growthRate];
    
    equityGrowthMonthly = [self getMonthlyGrowth:productName
                                    fundName:@"EQUITY"
                                    currency:currency
                             growthRateIndex:growthRate];

    
    apbGrowthAnnual = [self getAnnualGrowth:productName
                                    fundName:@"APB"
                                    currency:currency
                             growthRateIndex:growthRate];
    
    apbGrowthMonthly = [self getMonthlyGrowth:productName
                                    fundName:@"APB"
                                    currency:currency
                             growthRateIndex:growthRate];
    
    balancedGrowthAnnual = [self getAnnualGrowth:productName
                                   fundName:@"BALANCED"
                                   currency:currency
                            growthRateIndex:growthRate];
    
    balancedGrowthMonthly = [self getMonthlyGrowth:productName
                                     fundName:@"BALANCED"
                                     currency:currency
                              growthRateIndex:growthRate];

    
    iterationValue = [NSNumber numberWithInt:(100 - [age intValue])];
    
    if ([productName isEqualToString:kproductName_WealthPremier]) {
        
        premiumLoadRate = [NSNumber numberWithDouble:kHwm_PremLoad];
    }
    else {
        
        if ([isFel compare:[NSNumber numberWithInt:1]]== NSOrderedSame) {
            
            premiumLoadRate = [self getPremiumLoadRate: currency
                                               premium: premium];
            
            policyFee = [self getPolicyFee:currency deathBenType:deathBenType];
        }
    }
    
   
    
    for(int intYear = 1; intYear < [iterationValue intValue]; intYear++)
    {
        yearCount = [NSNumber numberWithInt:intYear];
        
        rateCOI = [self getCOIRate:[NSNumber numberWithInt:([age intValue] + intYear - 1)] withGender:gender];
        
        
        
        for(int intMonth = 1; intMonth <= 12; intMonth++)
        {
            monthCount = [NSNumber numberWithInt:intMonth];
            
            premiumLoadAmt = [self getPremiumLoadAmt:premiumLoadRate
                                               gross:premium
                                             intYear:yearCount
                                            intMonth:monthCount];
            
            bidOfferSpread = [self getBidOfferSpread:productName];
            
            //determine BidOffer Spread
            if ([productName isEqualToString:kProductName_AffluenceGold]) {
                bidOfferAmount = [self getBidOfferAmount:premium premiumLoadAmt:premiumLoadAmt bidOfferSpread:bidOfferSpread deathBenType:deathBenType];
            }
            else {
                bidOfferAmount = 0;
            }
            
            
            
            tmpDbl = [NSNumber numberWithDouble:([premium doubleValue] - [premiumLoadAmt doubleValue])];
            
            netPremium = [self getNetPremium:premium
                                 premLoadAmt:premiumLoadAmt
                                 bidOfferAmt:bidOfferAmount
                                   yearCount:yearCount
                                  monthCount:monthCount
                                deathBenType:deathBenType];

            currentAv = [NSNumber numberWithDouble:([acctValue doubleValue] + [netPremium doubleValue])];
            db1NAAR = faceAmount;
            db2NAAR =  [NSNumber numberWithDouble:(([faceAmount compare:currentAv] == NSOrderedDescending ? [faceAmount doubleValue] : [currentAv doubleValue]) - [currentAv doubleValue])];
            finalNAAR = [NSNumber numberWithDouble:([deathBenType compare:[NSNumber numberWithInt:1]] == NSOrderedSame ? [db1NAAR doubleValue] : [db2NAAR doubleValue])];
            chargeCOI =  [NSNumber numberWithDouble:(([rateCOI doubleValue] / 12) * ([finalNAAR doubleValue] / 1000))];
            totalMonthlyCharge = [NSNumber numberWithDouble:([chargeCOI doubleValue] + [policyFee doubleValue])];
            
            NSString *strBondTotal = [[[NSString alloc]init]autorelease];
            NSString *strEquityTotal = [[[NSString alloc]init]autorelease];
            NSString *strStableTotal = [[[NSString alloc]init]autorelease];
            NSString *strBalancedTotal = [[[NSString alloc]init]autorelease];

            if ([bondAllocation compare:[NSNumber numberWithInt:0]] == NSOrderedDescending)
            {
                
                if ([productName isEqualToString:kproductName_WealthPremier]){
                                       
                    bondTotalAV = [self getCurrentAv:bondAllocation
                                  totalMonthlyCharge:totalMonthlyCharge
                                          netPremium:netPremium
                                        annualGrowth: bondGrowthMonthly
                                       fundCurrentAv:bondCurrentAV];
                }
                else {
                    
                    bondTotalAV = [self getCurrentAv:bondAllocation
                                  totalMonthlyCharge:totalMonthlyCharge
                                          netPremium:netPremium
                                        annualGrowth:bondGrowthAnnual
                                       fundCurrentAv:bondCurrentAV];
                }
                
                bondCurrentAV = bondTotalAV;
            }
            
            if ([equityAllocation compare:[NSNumber numberWithInt:0]] == NSOrderedDescending)
            {
                
                equityTotalAV = [self getCurrentAv:equityAllocation
                              totalMonthlyCharge:totalMonthlyCharge
                                      netPremium:netPremium
                                    annualGrowth:equityGrowthAnnual
                                   fundCurrentAv:equityCurrentAV];
                
                equityCurrentAV = equityTotalAV;
            }
            
            if ([stableAllocation compare:[NSNumber numberWithInt:0]] == NSOrderedDescending)
            {
                
                stableTotalAV = [self getCurrentAv:stableAllocation
                                totalMonthlyCharge:totalMonthlyCharge
                                        netPremium:netPremium
                                      annualGrowth:stableGrowthAnnual
                                     fundCurrentAv:stableCurrentAV];
                
                stableCurrentAV = stableTotalAV;
            }
            
            if ([apbfAllocation compare:[NSNumber numberWithInt:0]] == NSOrderedDescending)
            {
                
                apbTotalAV = [self getCurrentAv:apbfAllocation
                                totalMonthlyCharge:totalMonthlyCharge
                                        netPremium:netPremium
                                      annualGrowth:apbGrowthAnnual
                                     fundCurrentAv:apbCurrentAV];
                
                apbCurrentAV = apbTotalAV;
            }
            
            if ([balancedAllocation compare:[NSNumber numberWithInt:0]] == NSOrderedDescending)
            {
                
                balancedTotalAV = [self getCurrentAv:balancedAllocation
                                totalMonthlyCharge:totalMonthlyCharge
                                        netPremium:netPremium
                                      annualGrowth:balancedGrowthAnnual
                                     fundCurrentAv:balancedCurrentAV];
                
                balancedCurrentAV = balancedTotalAV;
            }

            
            strBondTotal = [NSString stringWithFormat:@"%@", bondTotalAV];
            strStableTotal = [NSString stringWithFormat:@"%@", stableTotalAV];
            strEquityTotal = [NSString stringWithFormat:@"%@", equityTotalAV];
            strBalancedTotal = [NSString stringWithFormat:@"%@", balancedTotalAV];
            
            totalAV = [NSNumber numberWithDouble:([bondCurrentAV doubleValue] + [stableCurrentAV doubleValue] + [equityCurrentAV doubleValue] + [apbCurrentAV doubleValue] + [balancedCurrentAV doubleValue])];
            
            db1Total = [NSNumber numberWithDouble:([faceAmount doubleValue] + [totalAV doubleValue])];
            db2Total = [NSNumber numberWithDouble:([faceAmount compare:totalAV] == NSOrderedDescending ? [faceAmount doubleValue] : [totalAV doubleValue])];
            dbFinal = [NSNumber numberWithDouble:([deathBenType compare:[NSNumber numberWithInt:1]] == NSOrderedSame ? [db1Total doubleValue] : [db2Total doubleValue])];
            
            acctValue = totalAV;
        }
        
        premiumLoadRate = 0;
        yearSpan = [age intValue] + intYear;
        acctValue = [NSNumber numberWithFloat:(roundf([acctValue floatValue]))];
        dbFinalRounded =[NSNumber numberWithFloat:(roundf([dbFinal floatValue]))];
        
        acctValue = [self negativeValues:acctValue];
        
        NSNumber *zeroValue = [[[NSNumber alloc]init]autorelease];
        zeroValue = 0;
        
        if ([acctValue floatValue] == [zeroValue floatValue]) {
            dbFinalRounded = 0;
        }
        
        //convert acctValue and dbFinal to string
        NSString *strAcctValue = [Utility formatAccountValueStyle:[NSString stringWithFormat:@"%.0f", [acctValue doubleValue]] withCurrencySymbol:@""];
        NSString *strDbFinal = [Utility formatAccountValueStyle:[NSString stringWithFormat:@"%.0f", [dbFinalRounded doubleValue]] withCurrencySymbol:@""];
        
        //bind to array
        [arrchild addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%i", intYear], @"intYear",
                                  [NSString stringWithFormat:@"%i", yearSpan], @"yearSpan",
                                  [NSString stringWithFormat:@"%@", strAcctValue], @"strAcctValue",
                                  [NSString stringWithFormat:@"%@", strDbFinal], @"strDbFinal",nil]];
    }
    
    return arrchild;
}

+ (NSNumber *) getAnnualGrowth: (NSString *) productName
                      fundName: (NSString *) fundName
                      currency: (NSNumber *) currency
               growthRateIndex: (NSNumber *) growthRateIndex
{
    NSNumber *annualGrowth = [[[NSNumber alloc]init]autorelease];
    
    if ([productName isEqualToString:kproductName_WealthPremier]) {
        
        switch ([growthRateIndex intValue]) {
            case 0:
                annualGrowth =[NSNumber numberWithDouble:kAnnualGrowth_HWM_Low] ;
                break;
            case 1:
                annualGrowth = [NSNumber numberWithDouble:kAnnualGrowth_HWM_Med];
                break;
            case 2:
                annualGrowth = [NSNumber numberWithDouble:kAnnualGrowth_HWM_High];
                break;
            default:
                break;
        }
    }
    else {
        
        annualGrowth = [self getGrowthRate:fundName
                              withCurrency:currency
                                  withRate:growthRateIndex];
    }
    
    return annualGrowth;
}

+ (NSNumber *) getMonthlyGrowth: (NSString *) productName
                      fundName: (NSString *) fundName
                      currency: (NSNumber *) currency
               growthRateIndex: (NSNumber *) growthRateIndex
{
    NSNumber *monthlyGrowth = [[[NSNumber alloc]init]autorelease];
    
    if ([productName isEqualToString:kproductName_WealthPremier]) {
        
        switch ([growthRateIndex intValue]) {
            case 0:
                monthlyGrowth =[NSNumber numberWithDouble:kMonthlyGrowth_HWM_Low] ;
                break;
            case 1:
                monthlyGrowth = [NSNumber numberWithDouble:kMonthlyGrowth_HWM_Med];
                break;
            case 2:
                monthlyGrowth = [NSNumber numberWithDouble:kMonthlyGrowth_HWM_High];
                break;
            default:
                break;
        }
    }
       
    return monthlyGrowth;
}


+ (NSNumber *)getGrowthRate: (NSString *)fund
               withCurrency:(NSNumber *)currency
                   withRate:(NSNumber *)rate

{
 
    NSNumber *growthRate = [[[NSNumber alloc]init]autorelease];
    growthRate = 0;
    
    if ([fund isEqualToString:@"BOND"]) {
        
        switch ([currency intValue]) {
            case kPesoCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Peso_Low];
                        break;
                    case 1:
                        growthRate =[NSNumber numberWithDouble:kAnnualGrowth_Bond_Peso_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Peso_High];
                    default:
                        break;
                }
                break;
                
            case kDollarCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_Low];
                        break;
                    case 1:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_High];
                        break;
                    default:
                        break;
                }
                
            default:
                break;
        }
    }
    
    if ([fund isEqualToString:@"EQUITY"]) {
        
        switch ([currency intValue]) {
            case kPesoCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Equity_Peso_Low];
                        break;
                    case 1:
                        growthRate =[NSNumber numberWithDouble:kAnnualGrowth_Equity_Peso_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Equity_Peso_High];
                        break;
                    default:
                        break;
                }
                break;
                
            case kDollarCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Equity_Dollar_Low];
                        break;
                    case 1:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Equity_Dollar_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Equity_Dollar_High];
                    default:
                        break;
                }
                
            default:
                break;
        }
    }
    
    if ([fund isEqualToString:@"STABLE"]) {
        
        switch ([currency intValue]) {
            case kPesoCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Stable_Peso_Low];
                        break;
                    case 1:
                        growthRate =[NSNumber numberWithDouble:kAnnualGrowth_Stable_Peso_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Stable_Peso_High];
                        break;
                    default:
                        break;
                }
                break;
                
            case kDollarCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Stable_Dollar_Low];
                        break;
                    case 1:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Stable_Dollar_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Stable_Dollar_High];
                    default:
                        break;
                }
                
            default:
                break;
        }
    }
    
    if ([fund isEqualToString:@"BALANCED"]) {
        
        switch ([currency intValue]) {
            case kPesoCurrency:
                switch ([rate intValue]) {
                    case 0:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Balanced_Peso_Low];
                        break;
                    case 1:
                        growthRate =[NSNumber numberWithDouble:kAnnualGrowth_Balanced_Peso_Med];
                        break;
                    case 2:
                        growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Balanced_Peso_High];
                        break;
                    default:
                        break;
                }
                default:
                break;
        }
    }

    
    if ([fund isEqualToString:@"APB"]) {
        
        switch ([rate intValue]) {
            case 0:
                growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_Low];
                break;
            case 1:
                growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_Med];
                break;
            case 2:
                growthRate = [NSNumber numberWithDouble:kAnnualGrowth_Bond_Dollar_High];
            default:
                break;
        }
    }

    return growthRate;
    
}

+ (NSNumber *) getPremiumLoadRate: (NSNumber *) currency
                          premium: (NSNumber *) premium
{
    NSNumber *premiumLoadRate = [[[NSNumber alloc]initWithDouble:0]autorelease];
    NSNumber *premiumLoadRate1 = [[[NSNumber alloc]init]autorelease];
    NSNumber *premiumLoadRate2 = [[[NSNumber alloc]init]autorelease];
    NSNumber *premiumLoadRate3 = [[[NSNumber alloc]init]autorelease];
    
    NSComparisonResult resultMin;
    NSComparisonResult resultMax;
    
    premiumLoadRate1 = [NSNumber numberWithDouble:0.05];
    premiumLoadRate2 = [NSNumber numberWithDouble:0.04];
    premiumLoadRate3 = [NSNumber numberWithDouble:0.03];
    
    switch ([currency intValue]) {
        
        case kPesoCurrency:
            
            // 75,000 - 100,000
            resultMin = [premium compare:[NSNumber numberWithInt:75000]];
            resultMax = [premium compare:[NSNumber numberWithInt:99999]];
           
            
            if (resultMin == NSOrderedSame || resultMax == NSOrderedAscending) {
                premiumLoadRate = premiumLoadRate1;
            }
            
            //100,001 - 250,000
            resultMin = [premium compare:[NSNumber numberWithInt:100000]];
            resultMax = [premium compare:[NSNumber numberWithInt:249999]];
            
            if ([premiumLoadRate compare:[NSNumber numberWithDouble:0]]==NSOrderedSame) {
                if ((resultMin == NSOrderedSame || resultMax == NSOrderedAscending)) {
                    premiumLoadRate = premiumLoadRate2;
                }
                else {
                    
                    premiumLoadRate = premiumLoadRate3;
                }
            }
            
            
            break;
            
        case kDollarCurrency:
            
            // 1,500 - 2,500
            resultMin = [premium compare:[NSNumber numberWithInt:1499]];
            resultMax = [premium compare:[NSNumber numberWithInt:2499]];
            
            if ((resultMin == NSOrderedDescending && resultMax == NSOrderedAscending)) {
                premiumLoadRate = premiumLoadRate1;
            }
                        
            //2,501 - 6,250
            resultMin = [premium compare:[NSNumber numberWithInt:2499]];
            resultMax = [premium compare:[NSNumber numberWithInt:6249]];
            
            if ([premiumLoadRate compare:[NSNumber numberWithDouble:0]]==NSOrderedSame) {
                if ((resultMin == NSOrderedDescending && resultMax == NSOrderedAscending)) {
                    premiumLoadRate = premiumLoadRate2;
                }
                else {
                    premiumLoadRate = premiumLoadRate3;
                }
            }
            
            
            break;
            
        default:
            break;
    }
    
    return premiumLoadRate;
}

+ (NSNumber *) getPremiumLoadAmt: (NSNumber *) premLoadRate
                           gross: (NSNumber *) gross
                         intYear: (NSNumber *) intYear
                        intMonth: (NSNumber *) intMonth
{
    NSNumber *premLoadAmt = [[[NSNumber alloc]init]autorelease];
    
    if ([intYear compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
        
        if ([intMonth compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
            
            premLoadAmt =  [NSNumber numberWithDouble:([gross doubleValue] * [premLoadRate doubleValue])];
        } else {
            
            premLoadAmt = [NSNumber numberWithDouble:0];
        }

    }else {
    
       premLoadAmt = [NSNumber numberWithDouble:0];
    }
    
    return premLoadAmt;

}

+ (NSNumber *) getBidOfferSpread: (NSString *) productName
{
    NSNumber *bidOfferSpread = [[[NSNumber alloc]init]autorelease];
    
    if ([productName isEqualToString:kproductName_WealthPremier]){
        
        bidOfferSpread = [NSNumber numberWithDouble:kHwm_BidOfferSpread];
    }
    else{
        
        bidOfferSpread = [NSNumber numberWithDouble:0.015];
    }
    
    return bidOfferSpread;
}

+ (NSNumber *) getBidOfferAmount: (NSNumber *) gross
                  premiumLoadAmt: (NSNumber *) premiumLoadAmt
                  bidOfferSpread: (NSNumber *) bidOfferSpread
                    deathBenType: (NSNumber *) deathBenType
{
    NSNumber *step1 = [[[NSNumber alloc]init]autorelease];
    NSNumber *step2 = [[[NSNumber alloc]init]autorelease];
    
        
        step1 = [NSNumber numberWithDouble:[gross doubleValue] - [premiumLoadAmt doubleValue]];
        step2 = [NSNumber numberWithDouble:[step1 doubleValue] * [bidOfferSpread doubleValue]];

    return step2;
}

+ (NSNumber *) getNetPremium: (NSNumber *) gross
                 premLoadAmt: (NSNumber *) premLoadAmt
                 bidOfferAmt: (NSNumber *) bidOfferAmt
                   yearCount: (NSNumber *) year
                  monthCount: (NSNumber *) month
                deathBenType: (NSNumber *) deathBenType
{
    NSNumber *netPremium = [[[NSNumber alloc]init]autorelease];
    
    
    if ([year compare:[NSNumber numberWithInt:1]] == NSOrderedDescending) {
        
        netPremium = [NSNumber numberWithInt:0];
    }
    else {
        
        if ([month compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
            
            netPremium = [NSNumber numberWithDouble:([gross doubleValue] - [premLoadAmt doubleValue] - [bidOfferAmt doubleValue])];
        }
        else {
            
            netPremium = [NSNumber numberWithInt:0];
        }
    }
    
    
    return netPremium;
}

+ (NSNumber *) getPolicyFee: (NSNumber *) currency deathBenType: (NSNumber *)deathBenType
{
    NSNumber *policyFee = [[[NSNumber alloc]init]autorelease];
    
        switch ([currency intValue]) {
            case kPesoCurrency:
                policyFee = [NSNumber numberWithDouble:kPolicyFee_Peso];
                break;
            case kDollarCurrency:
                policyFee = [NSNumber numberWithDouble:kPolicyFee_Dollar];
                break;
            default:
                break;
        }

    return policyFee;
}

+ (NSNumber *)getCOIRate:(NSNumber *)age
              withGender:(NSString*)gender

{
    NSNumber *coiRate = [[[NSNumber alloc]init]autorelease];
    sqlite3 *finCalcDb = nil;
	if ([SQLiteManager openFinCalcDb:&finCalcDb]) //open database
	{
        NSString *sqlSelect = @"";
        
        if ([gender isEqualToString:@"F"])
        {
            sqlSelect = [NSString stringWithFormat:@"SELECT COI_FVALUE FROM COI_TABLE WHERE COI_AGE = %i",[age intValue]];
        }
        else
        {
            sqlSelect = [NSString stringWithFormat:@"SELECT COI_MVALUE FROM COI_TABLE WHERE COI_AGE = %i",[age intValue]];
        }
        
        sqlite3_stmt *sqliteStatement;
        
        if(sqlite3_prepare_v2(finCalcDb, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
            {
                coiRate = [NSNumber numberWithDouble:sqlite3_column_double(sqliteStatement, 0)] ;
            }
        }
        else
        {
            //NSLog(@"failed to execute statement: %@", sqlQuery);
            NSLog(@"failed to execute statement");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(sqliteStatement);
        
        [SQLiteManager closeFinCalcDb:&finCalcDb]; //make sure to close the database
        
    }
	else
	{
		NSLog(@"Database Error");
	}
    return coiRate;
}

+ (NSNumber *) getCurrentAv: (NSNumber *) fundAlloc
         totalMonthlyCharge: (NSNumber *) totalMonthlyCharge
                 netPremium: (NSNumber *) netPremium
               annualGrowth: (NSNumber *) annualGrowth
              fundCurrentAv: (NSNumber *) fundCurrentAv;
{
    NSNumber *deductions = [[[NSNumber alloc]init]autorelease];
    NSNumber *fundNetPremium = [[[NSNumber alloc]init]autorelease];
    NSNumber *fundNetAv = [[[NSNumber alloc]init]autorelease];
    NSNumber *fundInterestAmt = [[[NSNumber alloc]init]autorelease];
    NSNumber *fundTotalAv = [[[NSNumber alloc]init]autorelease];
    
    if ([fundCurrentAv compare:[NSNumber numberWithDouble:0]]== NSOrderedDescending) {
        netPremium = 0;
    }
    
    deductions = [NSNumber numberWithDouble:([totalMonthlyCharge doubleValue] * [fundAlloc doubleValue])];
    fundNetPremium = [NSNumber numberWithDouble:([netPremium doubleValue] * [fundAlloc doubleValue])];
    fundNetAv = [NSNumber numberWithDouble:([fundCurrentAv doubleValue]) + [fundNetPremium doubleValue] - [deductions doubleValue]];
    fundInterestAmt = [NSNumber numberWithDouble:([fundNetAv doubleValue] * [annualGrowth doubleValue])];
    fundTotalAv = [NSNumber numberWithDouble:([fundNetAv doubleValue] + [fundInterestAmt doubleValue])];
    
    return fundTotalAv;
}

+ (BOOL) percentageValidation: (NSNumber *) number
{
    NSString *parseToString = [NSString stringWithFormat:@"%@",number];
    
    NSString *newString = [parseToString stringByReplacingCharactersInRange:NSMakeRange(0, parseToString.length) withString:parseToString];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kDecimalNotAllowed
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    
    if (numberOfMatches == 0){
        return NO;
    }
    else {
        return YES;
    }
}

+ (NSNumber *) negativeValues: (NSNumber *) number {
    
    NSNumber *retValue = [[[NSNumber alloc]init]autorelease];
    NSNumber *zeroValue = [[[NSNumber alloc]init]autorelease];
    zeroValue = 0;
    
    retValue = number;
    
    if ([retValue floatValue] < [zeroValue floatValue]) {
        retValue = 0;
    }
    
    return retValue;
    
}


@end
