//
//  Support_Manucare.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/30/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#define kQuestion_TimeFrame @"What is your time frame committing your funds for investments?"
#define kQuestion_RetirementPlan @"How many years from now do you plan to retire?"
#define kQuestion_NeedforInvestment @"How important is your need for current investment income?"
#define kQuestion_CashFlowNeeds @"If the value of your investments declines significantly, would savings be able to meet your cash flow needs?"

#define kTimeFrame_Ans1 @"less than 3 years"
#define kTimeFrame_Ans2 @"up to 5 years"
#define kTimeFrame_Ans3 @"greater than 5 years"

#define kRetirementPlan_Ans1 @"less than 5 years"
#define kRetirementPlan_Ans2 @"6 to 15 years"
#define kRetirementPlan_Ans3 @"over 15 years"

#define kNeedForInvestment_Ans1 @"Very important. I have significant cash flow needs on a regular basis."
#define kNeedForInvestment_Ans2 @"Slightly important. I am willing to take out money from my principal to meet my cash flow needs."
#define kNeedForInvestment_Ans3 @"Not important. I do not anticipate any immediate need for my funds."

#define kCashFlowNeeds_Ans1 @"No, I have savings equivalent to less than one month of my monthly income."
#define kCashFlowNeeds_Ans2 @"Maybe. I have savings equivalent to one to two months of my monthly income. I am willing to tolerate negative returns during diffcult market conditions. "
#define kCashFlowNeeds_Ans3 @"Yes, I have savings equivalent to 3 to 6 months of my monthly income. I'm comfortable to take the risks of losing my principal for maximum return potential."

#define kQuestion_InvestmentDrop @"Historically, markets have experienced downturns. If your investment dropped by 10% within 6 months after you invested, which of the following best describes your likely course of action:"
#define kQuestion_InterestValue @"How comfortable are in the movement in the value of your investment?"
#define kQuestion_Returns @"In terms of the level of return/ earnings:"
#define kQuestion_RiskDegree @"What degree of risk are you willing to take with your investment?"
#define kQuestion_ReviewFrequency @"How often do you feel you will review your investment portfolio?"
#define kQuestion_Overall @"Your overall investment attitude:"

#define kInvestmentDrop_Ans1 @"You would cut your losses and transfer your funds to more secure investments."
#define kInvestmentDrop_Ans2 @"You would be concerned but would wait to see if the investments would improve - this was a risk you understood at the onset."
#define kInvestmentDrop_Ans3 @"You would invest more funds to take advantage of the lower unit/share prices."

#define kInterestValue_Ans1 @"I prefer an investment with very minimal fluctuations that is expected to grow at a slower rate at the longer term."
#define kInterestValue_Ans2 @"I prefer moderate growth with moderate volatility in the value of my investments. I can tolerate negative returns during difficult market conditions."
#define kInterestValue_Ans3 @"I am prepared to accept a large negative return, with frequent changes that vary WIDELY from year to year to seek higher returns over the long term."

#define kReturns_Ans1 @"I would be happy to settle for less return to preserve my capital."
#define kReturns_Ans2 @"I am looking for a moderate return which may expose me to a substantial level of risk, but not a major loss."
#define kReturns_Ans3 @"Maximum profit - I am looking for the highest return possible regardless of the risks."

#define kRiskDegree_Ans1 @"Very little - I am conservative and I hate losing money."
#define kRiskDegree_Ans2 @"I am prepared to accept occassional realized and unrealized losses."
#define kRiskDegree_Ans3 @"I can tolerate the risk of large losses to maximize my returns."

#define kReview_Ans1 @"Daily to Weekly"
#define kReview_Ans2 @"Monthly"
#define kReview_Ans3 @"After every few months"

#define kOverall_Ans1 @"I can live with very low returns as long as I can get back a least as much as I put in, with very minimal short-term losses and chances of losing my money."
#define kOverall_Ans2 @"My objective is to earn a substantial return and come out ahead over the long-term despite occasional negative returns. I understand that some risks are needed to achieve this."
#define kOverall_Ans3 @"I am looking forward to maximizing my earnings over the long term, even if it means experiencing frequent fluctuations and risking losing majority of my money."

#define kQuestionMark_Image @"question_mark.png"

#import <Foundation/Foundation.h>

@interface Support_Manucare : NSObject {
    
}

+ (NSNumber *) checkExistingRiskCapacity: (NSString *)profileId;
+ (NSNumber *) checkExistingRiskAttitude: (NSString *)profileId;
+ (NSError *) getManucare: (NSString *)profileId;
+ (NSError *) newManucare: (NSString *)profileId
                 ageScore: (NSNumber *) ageScore;
+ (NSError *) updateManucare: (NSString *)profileId;
+ (NSString *) riskCapacitytScoreInterpretation: (NSNumber *) riskCapacityScore;
+ (NSString *) riskAttitudeScoreInterpretation: (NSNumber *) riskAttitudeScore;
+ (NSNumber *) getRiskCapacityScore: (NSNumber *) timeFrame
                         retirement: (NSNumber *) retirement
                           cashFlow: (NSNumber *) cashflow
                         investment: (NSNumber *) investment
                           ageScore: (NSNumber *) ageScore;
+ (NSNumber *) getRiskAttitudeScore: (NSNumber *) investmentDrop
                      interestValue: (NSNumber *)interestValue
                            returns: (NSNumber *)returns
                         riskDegree: (NSNumber *)riskDegree
                             review: (NSNumber *)review
                            overall: (NSNumber *) overall;
+ (NSNumber *) getAgeScore;
+ (NSString *) getBtnString: (NSString *) question score:(NSNumber *) score;
+ (void) clearValues;

@end
