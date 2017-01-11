//
//  ReferenceDataDao.h
//  FNA_20120319
//
//  Created by Manulife on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReferenceDataDao : NSObject

+ (float)getCOIRate: (int)age withGender:(NSString *)gender;
+ (float)getPremiumLoad: (int)currency withPremium:(float)premium;
+ (float)getPolicyFee: (int)currency;
+ (float)getBidOfferSpread;

+ (double)getMgtFee:(int)currencyCode withFund:(int)fund;

@end




