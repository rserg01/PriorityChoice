//
//  FnaConstants.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

//General Config
#define kExpirationDateString @"06/01/2015"
#define kExpirationDate_Formatted @"June 1, 2015"
#define kPhilippineCurrency @"P "	
#define kPesoCode 14
#define kDollarCode 2
#define kSynchUrl_Prod @"http://10.128.35.10/Fna/SyncTables"
#define kSynchUrl_Debug @"https://www.mymanulife.com.ph/cwsprd/Fna/SyncTables"
#define kActivationUrl_Prod @"https://www.mymanulife.com.ph/cwsprd/Fna/ActivateApp"
#define kActivationUrl_Debug @"http://10.128.35.10/Fna/ActivateApp"
#define kActivationUrl_AWS_Prod @"https://www.manutouch.com.ph/ifp/fna/FnaService/VerifyAgent"
#define kActivationUrl_AWS_Debug @"https://www.manutouch.com.ph:8445/ifp/fna/FnaService/VerifyAgent"
#define kWebsiteMyManulife @"www.mymanulife.com.ph"
#define kRevision @""
#define kPurgeDays 5
#define kPasswordValidation @"(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"
#define kDecimalNotAllowed @"^([0-9]+)?(\\.([0-9]{0})?)?$"
#define kEncryptionKey @"ykQ9rasa1EyC3ciVz6Re";

//Security Warnings
#define kErr_Jailbroken @"Priority Choice is not allowed to run in a jailbroken device."
#define kReminder_InternetConnection @"Please make sure that you have an active internet connecion before starting the activation process."
#define kReminder_Passcode @"Please make sure that you have passcode enabled to ensure security on your iPad."
#define kExpiredApp @"Your App already expired. \nYou may download the new version from https://www.myManulife.com.ph/cwsprd/Fna"
#define kExpirationWarning @"Your App is about to expire. Please don't forget to synch your data to our servers."
#define kErr_NoInternet @"You need an active internet conection to proceed with the activation. Please close the FNA App and try again."
#define kErr_InternetDetected @"Your device has connected to the server. Sync will begin."
#define kErr_SynchSuccess @"Synch successul."
#define kErr_SynchFail @"Synch failed."
#define kReminder_PurgeReminder @"Profiles saved in your device has a 5-day expiry. Records are automatically deleted after the expiry date. Please make sure that you synch your App with our server before the expiry date."
#define kReminder_IdleTime @"This session will expire within 15 minutes of inactivity."
#define kReminder_RecordsPruged @"Some profiles in your device has expired. All these records has been deleted from the device."

//Activation
#define kActivationFailed @"Activation failed. Please check your internet connection and activation details."
#define kActivationSuccess @"Activation successful"
#define kNoAgentCode @"Please enter your agent code"
#define kNoBirthdate @"Please enter your birthdate. Follow this format: mm/dd/yyyy"
#define kNoTin @"Please enter your TIN"
#define kNoUsername_Activation @"Please enter your username"
#define kNoPassword_Activation @"Please enter your password. Minimum of 8 alphanumeric characters."
#define kNoConfirmPassword @"Please re-enter your password"
#define kConfirmPasswordDidNotMatch @"Your confirmation password did not match."
#define kImage_IdCard_Green @"name-tag-identification-card_edited"
#define kImage_IdCard_Grayscale @"name-tag-identification-card_grayscale"
#define kActivationReminder_AgentCode @"Please exclude SA in typing your agent code"
#define kActivationReminder_Birthdat @"Please follow this format: mm/dd/yyyy"
#define kActivationReminder_Username @"You will assign your own username for this app."
#define kActivationReminder_Password @"Password should be alphanumeric and at least 8 characters long"
#define kPasswordComplexity @"Password too weak."

//Forgot Password
#define kPasswordChangeFailed @"Password change failed."
#define kPasswordChangeSuccess @"Password change successful."

//Login
#define kLoginFailed @"The username and password did not match. You only have 3 attempts."
#define kLoginSuccessful @"Login successful"
#define kNoUsername @"The username cannot be empty."
#define kNoPassword @"The password cannot be empty."
#define kLockout @"You have made 3 unsuccessful login attempts. Your app has been locked out. You will need to reinstall the app."
#define kLockoutNotice @"This app has been locked out. To continue using the app you will need to reinstall and reactivate."

//Priority Choice
#define kLoadSuccessful @"Loading successful."
#define kNoProfileActive @"Theres no active profile.\nRecords cannot be saved."
#define kActiveProfileSet @"Active Profile set."
#define kSelectedController_Education @"Education"
#define kSelectedController_Retirement @"Retirement"
#define kSelectedController_Investment @"Investment"
#define kSelectedController_Health @"Health"
#define kSelectedController_Estate @"EstatePlanning"
#define kSelectedController_Income @"IncomeProtection"
#define kImageRanking_Education @"blue_BG2_2013"
#define kImageRanking_Retirement @"green_BG2_2013"
#define kImageRanking_Investment @"orange_BG2_2013"
#define kImageRanking_Health @"violet_BG2_2013"
#define kImageRanking_Estate @"yellow_BG2_2013"
#define kImageRanking_Income @"red_BG2_2013"

//Financial Calculator
#define kNotDivisible @"Allocation should be divisible by 5."
#define kFundMaxAllocation @"Maximum Fund allocation is at 100%"
#define kMinimumPremiumPeso_ErrorMsg @"Minimum premium is P 75,000"
#define kMinimumPremiumDollar_ErrorMsg @"Minimum premium is $ 1,500"

//Profile Manager
#define kProfile_NoLastName @"Last name is required."
#define kProfile_NoFirstName @"First name is required."
#define kProfile_NoEmail @"Email is required."
#define kProfile_NoDob @"Date of Birth is required."
#define kProfile_ErrDob @"Date of birth is the same date as today."
#define kProfile_ErrNoDependents @"No dependents were pulled out. Please add a dependent."
#define kProfile_SelectDependent @"Please select a dependent from the list."
#define kProfile_NoProfile @"No existing client record available. Please create a new profile to proceed."

//Email
#define kDataset_IncomeProtection @"incomeDataSet"
#define kDataset_PriorityRank @"priorityDataSet"
#define kDataset_Education @"educDataSet"
#define kDataset_Retirement @"retirementDataSet"
#define kDataset_Investment @"investmentDataSet"
#define kDataset_Health @"healthDataSet"
#define kDataset_Estate @"estateDataset"

//Synch
#define kTableName_AgentProfile @"tAgentInfo"
#define kTableName_PriorityRank @"tPriorityRank"
#define kTableName_Education @"tEducFunding"
#define kTableName_EstatePlanning @"tEstatePlanning"
#define kTableName_Investment @"tFundAccumulation"
#define kTableName_Health @"tImpairedHealth"
#define kTableName_Income @"tIncomeProtection"
#define kTableName_Manucare @"tManucare"
#define kTableName_Dependents @"tProfile_Dependent"
#define kTableName_ClientProfile @"tProfile_Personal"
#define kTableName_Spouse @"tProfile_Spouse"
#define kTableName_Retirement @"tRetirementPlanning"

//Compass
#define kCompassImg_RP_PreFamily @"RP_PreFamily"
#define kCompassImg_RP_YoungFamily @"RP_YoungFamily"
#define kCompassImg_RP_GrowingFamily @"RP_GrowingFamily"
#define kCompassImg_RP_EmptyNester @"RP_EmptyNester"
#define kCompassImg_RP_Retired @"RP_Retired"

//Product write up
#define kWealthPremier_WriteUp @"Wealth Premier is a single premium US Dollar-denominated variable life insurance product that is invested in the Fund which provides notional exposure to major international equity markets and a guaranteed level of downside protection."
#define kAffluenceGold_WriteUp @"Manulife's Affluence Gold is a single-pay, variable life insurance product designed to provide potential optimal return on your investment and insurance protection."
#define kAffluenceMaxGold_WriteUp @"Affluence Max Gold is a single-pay, variable life insurance products that is designed to give you the best possible returns on both your investment and built-in insurance protection coverage. It has very minimal charges that optimize the potential earnings from your policy."
#define kAffluenceBuilder_WriteUp @"Manulife's Affluence Builder is a regular pay variable universal life insurance product designed to provide you with optimal return potential."
#define kAffluenceBuilderAchieve_WriteUp @"Minimum 5-year pay variant that optimizes the earning potential on your medium-term forced savings / investment."
#define kSmartMinds_WriteUp @"Manulife's Smart Minds helps provide your child with a promising future through the following education benefits: Guaranteed Tuition Fund, guaranteed Education Allowance, Guaranteed Graduation Gift."
#define kFreedom15_WriteUp @"Manulife's Freedom15 is a participating endowment product that provides you guaranteed cash benefits for 15 years and insurance protection on one."
#define kFreedom20_WriteUp @"Manulife's Freedom20 is a participating endowment product that gives you a variety of guaranteed cash benefits over a 20-year period."
#define kFreedom65_WriteUp @"Manulife's Freedom65 is a participating endowment product that gives you guaranteed cash benefits until you reach the age of 65."
#define kPlanRight_WriteUp @"Manulife's Plan Right helps you prepare for a secure retirement. This savings plan provides a guaranteed pension at the time that you most need it , so that you can relax and enjoy life with financial benefits to pursue your yet unfulfilled dreams."
#define kSeasons100_WriteUp @"Manulife's Seasons 100 is a participating whole life insurance product that provides you cash returns and protection benefits throughout your lifetime."
#define kAdam_WriteUp @"The Manulife Adam Series is a financial protection product exclusively designed for men. It provdes a participating whole life protection coverage that accumulates cash values and earns dividends up to age 100."
#define kEve_WriteUp @"The Manulife Eve Series is exclusively designed for women. It is participating whole life product that accumulates cash values and earns dividends with coverage up to age 100."
#define kFlexisure_WriteUp @"Manulife FlexiSure is a participating whole life insurance product with variable life add-on feature that not only provides you guaranteed life protection coverage but also optimizes your earning potential thru investments made in any or a combination of professionally-managed funds."
#define kHorizons_WriteUp @"Manulife Horizons is a protection-oriented unit-linked product designed to provide you with life insurance coverage and access to your funds to address different financial needs anytime."
#define kAffluenceIncome_WriteUp @"Manulife Affluence Income is a peso-denominated single premium variable life insurance product designed to provide you with early access to your earnings to meet your short-term needs, unlimited earning potential through investment in a professionally managed fund to help achieve your medium to long-term goals, and life insurance coverage for your peace of mind."
#define kSecureSavings_WriteUp @"Manulife Secure Savings is a Peso-denominated non-participating endowment product that gives a variety of guaranteed cash benefits and life insurance protection all in one."

#define kMcblAsiaPacificBondFund_WriteUp @"MCBL Asia Pacific Bond Fund (APBF) is a USD-denominated fund desgined to maximize total returns over a medium-to-long term period from a combination capital appreciation and income generation. The APBF primarily invests in a diversified portfolio of fixed income securities issued by governments, agencies, supra-nationals and corporate issuers in the Asia Pacific region."
#define kMcblAseanGrowthFund_WriteUp @"Manulife Chinabank Life Assurance Corporation's USD-denominated ASEAN Growth Fund (AGF) is designed to generate long-term capital growth through investment in equity and equity-related securities of companies incorporated in countries which are members of the ASEAN and other emerging frontier markets as well as companies incorporated in countries outside ASEAN, but with material exposure to ASEAN markets."
#define kMcblBaseProtec_WriteUp @"Base Protect and Base Protect Plus are term insurance plans which provide fixed term protection coverage for (1) one and (5) five years respectively."
#define kMcblBrightMinds_WriteUp @"Bright Minds helps provide your child  with promising future through the following benefits: guaranteed tuition fund, guaranteed education allowance, guaranteed graduation gift, guaranteed life insurance for your child, guaranteed protection for the payor plus contingent fund."
#define kMcblEnrich_WriteUp @"MCBL Enrich is a suite of affordable variable life insurance products designed to provide you with optimal return potential on your investment and help you reach your future goals for protection and various savings needs."
#define kMcblEnrichMax_WriteUp @"MCBL Enrich Max is a single-pay, variable life insurance product designed to provide potential optimal return on your investment and insurance protection."
#define kMcblHealthProtect_WriteUp @"MCBL Health Protect is a critical illness insurance provides a lump sum benefit payment in the event that the person insured suffers from critical illness condition. It pays for expenses other products/ plans do not. This may help pay some or all of your hospital charges and professional fees, or even replace part of your lost income. It helps pay for other unexpected expenses such as additional tests and treatments, maintenance and medication after treatment and other expenses that may or may not be directly attributable to your critical illness."
#define kMcblMedProtect_WriteUp @"MCBL Med Protect is the right solution for your health needs, insuring you and your family against the financial hardships that could wipe out your savings."
#define kMcblHerlife_WriteUp @"MCBL Her Life is exclusively designed for women. It is a participating whole life product that accumulates cash values and earns dividends with coverage up to age 100.MCBL Her Life are packaged plans  that provide comprehensive life and health protection benefits that are \"must haves\" for women to be able to cope with the high demands of their multiple roles and responsibilities in life."
#define kMcblHisLife_WriteUp @"MCBL His Life is financial protection product exclusively designed for men. It provides participating whole life protection coverage that accumulates cash values and earns dividends up to age 100. MCBL His Life are packaged plans that give optimal life and health protection benefits with the assurance that whatever happens to you, your family will always be provided for."
#define kMcblLegacy100_WriteUp @"MCBL Legacy 100 is a participating whole life insurance product that provides you cash returns and protection benefits throughout your lifetime."
#define kMcblMedProtect @"MCBL MedProtect is a peso-denominated comprehensive health insurance products that covers you up to age 100. It covers medical expenses that other health insurance plans in the market do not. It helps defray your hospitalization related expenses."
#define kMcblMoneyMax15_WriteUp @"MCBL MoneyMax15 is a participating endowment product that provides you guaranteed cash benefits for years and insurance protection in one. Besides the guaranteed lump sum cash benefit, cash benefit payouts and maturity benefits, there are other benefits you can enjoy with MoneyMax15."
#define kMcblMoneyMax20_WriteUp @"MCBL MoneyMax20 is a participating endowment product that gives you a variety of guaranteed cash benefits over a 20-year period."
#define kMcblMoneyMax65_WriteUp @"MCBL MoneyMax65 is a participating endowment product that gives you guaranteed cash benefits until you reach the age of 65."
#define kMcblPlatinumInvest_WriteUp @"MCBL Platinum Invest Elite is a single-pay, variable life insurance product that is designed to give you the best possible returns on both your investment  and built-in insurance protection coverage. It has very minimal charges that optimizes the potential earnings from your policy."
#define kMcblProSecure_WriteUp @"With the life protection benefit provided by MCBL ProSecure, your beneficiaries can expect financial assistance to help them get through tough times. The protection benefit can be used to pay off certain obligations, or simply for your loved-ones to be able to continue living dream you spun together."
#define kMcblWealthPremier_WriteUp @"MCBL Wealth Premier is a single-premium US Dollar-denominated variable life insurance product that is invested in the Fund which provides notional exposure to major international equity markets and a guaranteed level of downside protection."

//About Manulife
#define kBoilerPlate @"The Manufacturers Life Insurance Company opened its doors for business in the Philippines in 1907. Since then, Manulife’s Philippine Branch and later The Manufacturers Life Insurance Co. (Phils.), Inc. (Manulife Philippines) has grown to become one of the leading life insurance companies in the country.  Manulife Philippines is a wholly-owned domestic subsidiary of Manulife Financial Corporation, among the world’s largest life insurance companies by market capitalization.\n\nManulife is a leading Canada-based financial services group with principal operations in Asia, Canada and the United States. We operate as John Hancock in the U.S. and as Manulife in other parts of the world. We provide strong, reliable, trustworthy and forward-thinking solutions for our customers’ significant financial decisions. Our international network of employees, agents and distribution partners offers financial protection and wealth management products and services to millions of clients. We also provide asset management services to institutional customers. Assets under management by Manulife and its subsidiaries were approximately C$691 billion (US$596 billion) as at December 31, 2014.\n\nManulife Financial Corporation trades as ‘MFC’ on the TSX, NYSE and PSE, and under ‘945’ on the SEHK. Manulife can be found on the Internet at manulife.com"
#define kBoilerPlate_Mcbl @"Manulife Chinabank Life Assurance Corporation is a strategic alliance between Manulife Philippines and China Bank, providing a wide range of innovative insurance products and services to China Bank customers. The aim is to ensure that every client receives the best possible solution to meet his or her individual financial and insurance needs.\n\nManulife Philippines is a wholly-owned domestic subsidiary of Manulife Financial Corporation, among the world’s largest life insurance companies by market capitalization (as of January 31, 2014). Manulife Financial is a leading Canada-based financial services group with principal operations in Asia, Canada and the United States. Clients look to Manulife for strong, reliable, trustworthy and forward-thinking solutions for their most significant financial decisions. Our international network of employees, agents and distribution partners offers financial protection and wealth management products and services to millions of clients. Funds under management by Manulife Financial and its subsidiaries were C$599 billion (US$563 billion) as at December 31, 2013.\n\nChina Bank was established in 1920, was listed on the Philippine Stock Exchange in 1965, became the first bank in Southeast Asia to process deposit accounts on-line in 1969, the first Philippine bank to offer phone banking in 1988, and acquired its universal banking license in 1991. China Bank provides a wide range of banking services through its more than specialized business centers, close to 300 branches, over 500 ATMs nationwide and complemented by its internet and mobile banking alternative channels.  With nine decades of enduring partnerships marked by quality service to its clients, China Bank remains to be one of the most stable and profitable banks in the country."

//Images2
#define kImage_Brochure_Seasons100 @"Seasons100_Brochure_2013.png"
#define kImage_Brochure_Freedom65 @"Freedom65_Brochure_2013.png"
#define kImage_Brochure_Freedom20 @"Freedom20_Brochure.png"
#define kImage_Brochure_Freedom15 @"Freedom15_Brochure_2013.png"
#define kImage_Brochure_Eve @"Eve_Brochure_2013.png"
#define kImage_Brochure_Adam @"Adam_Brochure_2013.png"
#define kImage_Brochure_AffluenceGold @"AffluenceGold_Brochure_2013.png"
#define kImage_Brochure_AffluenceMaxGold @"AffluenceMaxGold_Brochure_2013.png"
#define kImage_Brochure_AffluenceBuilder @"AffluenceBuilder_Brochure_2014.png"
#define kImage_Brochure_WealthPremier @"WealthPremier_MP.png"
#define kImage_Brochure_SmartMinds @"SmartMinds_Brochure.png"
#define kImage_Brochure_HealthPlus @"HealthPlus_Brochure.png"
#define kImage_Brochure_PlanRight @"PlanRight2011_Brochure.png"
#define kImage_Brochure_Flexisure @"FlexiSure_2013.png"
#define kImage_Brochure_Horizons @"Horizons_Brochure_2013.png"
#define kImage_Brochure_AffluenceIncome @"Affluence_Income_Brochure_2013.png"
#define kImage_Brochure_SecureSavings @"SecureSavings_Brochure.png"

#define kImage_Brochure_McblAsiaPacificBondFund @"MCBL_APBF.png"
#define kImage_Brochure_McblAseanGrowthFund @"MCBL_ASEANGrowth.png"
#define kImage_Brochure_McblBaseProtec @"MCBL_BaseProtect.png"
#define kImage_Brochure_McblBrightMinds @"MCBL_BrightMinds.png"
#define kImage_Brochure_McblEnrich @"MCBL_Enrich.png"
#define kImage_Brochure_McblEnrichMax @"MCBL_Enrichmax.png"
#define kImage_Brochure_McblHealthProtect @"MCBL_HealthProtect.png"
#define kImage_Brochure_McblMedProtect @"MCBL_MedProtect.png"
#define kImage_Brochure_McblHerLife @"MCBL_HerLife.png"
#define kImage_Brochure_McblHisLife @"MCBL_HisLife.png"
#define kImage_Brochure_McblLegacy100 @"MCBL_Legacy100.png"
#define kImage_Brochure_McblMedProtect @"MCBL_MedProtect.png"
#define kImage_Brochure_McblMoneyMax15 @"MCBL_MoneyMax15.png"
#define kImage_Brochure_McblMoneyMax20 @"MCBL_MoneyMax20.png"
#define kImage_Brochure_McblMoneyMax65 @"MCBL_MoneyMax65.png"
#define kImage_Brochure_McblPlatinumInvest @"MCBL_PlatinumElite.png"
#define kImage_Brochure_McblProSecure @"MCBL_ProSecure.png"
#define kImage_Brochure_McblProSecurePlus @"MCBL_ProSecurePlus.png"
#define kImage_Brochure_McblWealthPremier @"MCBL_WealthPremier.png"

#define kImage_FinCalc_AffluenceGoldPic @"AffluenceGoldPic.png"
#define kImage_FinCalc_AffluenceMaxGold @"AffluenceMaxGoldPic.png"
#define kImage_FinCalc_WealthPremierMP @"WealthPremier2013.png"
#define kImage_FinCalc_WealtherPremierMCBL @"McblWealthPremier2013Pic.png"
#define kImage_FinCalc_Enrich @"EnrichPic.png"
#define kImage_FinCalc_PlatinumInvest @"PlatinumElitePic.png"

#define kImage_About_Banner @"MP_About_Banner"
#define kImage_About_McblBanner @"MCBL_FNA_Banner"
#define kImage_About_News_MP @"News_MP.png"
#define kImage_About_News_Mcbl @"News_MCBL.png"

@interface FnaConstants : NSObject

@end
