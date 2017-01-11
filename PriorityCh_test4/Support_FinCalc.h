//
//  Support_FinCalc.h
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Constant Values

#define kPesoCurrency                    14
#define kDollarCurrency                  2

#define kPolicyFee_Peso                  33.3333333333333
#define kPolicyFee_Dollar                0.833333333333333

#pragma mark - MinMax Values

#define kMinimumPremiumAlloc_Dollar_APBF_AGF     12499.99
#define kMinimumPremiumAlloc_Peso_AffMaxGold     499999.99

#pragma mark - Growth Rates

#define kAnnualGrowth_Bond_Peso_Low      0.00327373978219891
#define kAnnualGrowth_Bond_Peso_Med      0.00643403011000343
#define kAnnualGrowth_Bond_Peso_High     0.00797414042890376
#define kAnnualGrowth_Equity_Peso_Low    0.00327373978219891
#define kAnnualGrowth_Equity_Peso_Med    0.00643403011000343
#define kAnnualGrowth_Equity_Peso_High   0.00797414042890376
#define kAnnualGrowth_Stable_Peso_Low    0.00327373978219891
#define kAnnualGrowth_Stable_Peso_Med    0.00643403011000343
#define kAnnualGrowth_Stable_Peso_High   0.00797414042890376
#define kAnnualGrowth_Balanced_Peso_Low    0.00327373978219891
#define kAnnualGrowth_Balanced_Peso_Med    0.00643403011000343
#define kAnnualGrowth_Balanced_Peso_High   0.00797414042890376

#define kAnnualGrowth_Bond_Dollar_Low    0.00246626977230369
#define kAnnualGrowth_Bond_Dollar_Med    0.00486755056534305
#define kAnnualGrowth_Bond_Dollar_High   0.00643403011000343
#define kAnnualGrowth_Equity_Dollar_Low  0.00246626977230369
#define kAnnualGrowth_Equity_Dollar_Med  0.00486755056534305
#define kAnnualGrowth_Equity_Dollar_High 0.00643403011000343
#define kAnnualGrowth_Stable_Dollar_Low  0
#define kAnnualGrowth_Stable_Dollar_Med  0
#define kAnnualGrowth_Stable_Dollar_High 0

#pragma mark - HWM Premium Load

#define kHwm_PremLoad                    0.03
#define kHwm_TopUpPremLoad               0.03
#define kHwm_BidOfferSpread              0


#pragma mark - HWM Growth rate

#define kAnnualGrowth_HWM_Low            0.03
#define kAnnualGrowth_HWM_Med            0.06
#define kAnnualGrowth_HWM_High           0.08

#define kMonthlyGrowth_HWM_Low           0.00246626977230369
#define kMonthlyGrowth_HWM_Med           0.00486755056534305
#define kMonthlyGrowth_HWM_High          0.00643403011000343

//Indicators
#define kHWM_ManagementFee               0.028

#define kValidationSuccesful             @"YES"
#define kValidationNotSuccessful         @"NO"

#pragma mark - Error Messages

#define kAgeEmpty                        @"Current age is required"
#define kSexEmpty                        @"Client's gender is required"
#define kAgeError                        @"Client age should be between 0 and 70"

#define kErrPercentageValue              @"Fund allocation does not accept decimal numbers."

#define kErrMinAlloc_AffGold_Peso_Bond              @"Minimum fund allocation for Affluence Gold Peso Bond Fund is 20%"
#define kErrMinAlloc_AffGold_Peso_Equity            @"Minimum fund allocation for Affluence Gold Peso Equity Fund is 20%"
#define kErrMinAlloc_AffGold_Peso_Stable            @"Minimum fund allocation for Affluence Gold Peso Stable Fund is 20%"
#define kErrMinAlloc_AffGold_Peso_Balanced          @"Minimum fund allocation for Affluence Gold Peso Balanced Fund is 20%"
#define kErrMinAlloc_AffGold_Dollar                 @"Minimum fund allocation for Affluence Gold Dollar is 100%"
#define kErrMinAlloc_AffGoldMax_Peso_Secure         @"Minimum fund allocation for Affluence Max Gold Peso Secure Fund is 20%"
#define kErrMinAlloc_AffGoldMax_Peso_Growth         @"Minimum fund allocation for Affluence Max Gold Peso Growth Fund is 20%"
#define kErrMinAlloc_AffGoldMax_Peso_Diversified    @"Minimum fund allocation for Affluence Max Gold Peso Diversified Fund is 20%"
#define kErrMinAlloc_AffGoldMax_Peso_Dynamic        @"Minimum fund allocation for Affluence Gold Peso Dynamic Fund is 20%"
#define kErrMinAlloc_AffGoldMax_Dollar_Secure       @"Minimum fund allocation for Affluence Max Gold Dollar Secure Fundis 20%"
#define kErrMinAlloc_AffGoldMax_Dollar_Growth       @"Minimum fund allocation for Affluence Max Gold Dollar Growth Fund is 20%"
#define kErrMinAlloc_AffGoldMax_Dollar_Apbf         @"Minimum fund allocation for Affluence Max Gold Dollar Asia Pacific Bond Fund is 20%"

#define kErrMinAlloc_EnrichMax_Peso_Bond              @"Minimum fund allocation for MCBL Enrich Max Peso Bond Fund is 20%"
#define kErrMinAlloc_EnrichMax_Peso_Equity            @"Minimum fund allocation for MCBL Enrich Max Peso Equity Fund is 20%"
#define kErrMinAlloc_EnrichMax_Peso_Stable            @"Minimum fund allocation for MCBL Enrich Max Peso Stable Fund is 20%"
#define kErrMinAlloc_EnrichMax_Dollar                 @"Minimum fund allocation for MCBL Enrich Max Dollar is 100%"
#define kErrMinAlloc_Platinum_Peso_Secure         @"Minimum fund allocation for MCBL Platinum Invest Elite Peso Secure Fund is 20%"
#define kErrMinAlloc_Platinum_Peso_Growth         @"Minimum fund allocation for MCBL Platinum Invest Elite Peso Growth Fund is 20%"
#define kErrMinAlloc_Platinum_Peso_Diversified    @"Minimum fund allocation for MCBL Platinum Invest Elite Peso Diversified Fund is 20%"
#define kErrMinAlloc_Platinum_Dollar_Secure       @"Minimum fund allocation for MCBL Platinum Invest Elite Dollar Secure Fundis 20%"
#define kErrMinAlloc_Paltinum_Dollar_Growth       @"Minimum fund allocation for MCBL Platinum Invest Elite Dollar Growth Fund is 20%"
#define kErrMinAlloc_Paltinum_Dollar_Apbf         @"Minimum fund allocation for MCBL Platinum Invest Elite Dollar Asia Pacific Bond Fund is 20%"

#define kErrTotalFundAllocation          @"Total fund allocation should be 100%"
#define kErrDivisibility                 @"Fund allocation should be divisible by 5"
#define kErrAgfApbfMinPremAlloc          @"Minimum APBF and AGF allocation should be equal or greater than $12,500"
#define kErrPesoMinPremAlloc             @"Minimum fund allocation should be equal or greater than P500,000"
#define kErrPremiumIsRequired            @"Please type in your premium"
#define kErrMinPrem_AffGold_Peso         @"Minimum premium is P75,000"
#define kErrMinPrem_AffGold_Dollar       @"Minimum premium is $1,500"
#define kErrMinPrem_AffMaxGold_Peso      @"Minimum premium is P500,000"
#define kErrMinPrem_AffMaxGold_Dollar    @"Minimum premium is $12,500"
#define kErrMinPrem_WealthPremier        @"Minimum premium is $10,000"

#pragma mark Product Names

#define kProductName_AffluenceGold       @"AffluenceGold"
#define kProductName_AffluenceMaxGold    @"AffluenceMaxGold"
#define kproductName_WealthPremier       @"WealthPremier"
#define kProductName_PlatinumInvest      @"PlatinumInvest"
#define kProductName_EnrichMax           @"EnrichMax"
#define kProductName_McblWealthPrem      @"McblWealthPremier"

@interface Support_FinCalc : NSObject {
    
}

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
                      channel: (NSString *) channel;

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
                        deathBenType: (NSNumber *) deathBenType;

@end
