//
//  GetPersonalProfile.h
//  PriorityCh_test4
//
//  Created by Manulife on 4/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPersonalProfile : NSObject {
    
}

+ (void)GetPersonalProfile: (NSString *) profileId;

+ (NSError *)InsertNewPersonalProfile:(NSString *)profileid
                             lastName:(NSString *)lastName
                            firstName:(NSString *)firstName
                           middleName:(NSString *)middleName
                          dateOfBirth:(NSString *)dateOfBirth
                               gender:(NSNumber *)gender
                             address1:(NSString *)address1
                             address2:(NSString *)address2
                             address3:(NSString *)address3
                           occupation:(NSString *)occupation
                              ofcAdd1:(NSString *)ofcAdd1
                              ofcAdd2:(NSString *)ofcAdd2
                              ofcAdd3:(NSString *)ofcAdd3
                             landline:(NSString *)landline
                               mobile:(NSString *)mobile
                            ofcTelNum:(NSString *)ofcTelNum
                                email:(NSString *)email;

+ (NSError *)UpdatePersonalProfile: (NSString *)profileid
                         lastName:(NSString *)lastName
                        firstName:(NSString *)firstName
                       middleName:(NSString *)middleName
                      dateOfBirth:(NSString *)dateOfBirth
                           gender:(NSNumber *)gender
                         address1:(NSString *)address1
                         address2:(NSString *)address2
                         address3:(NSString *)address3
                       occupation:(NSString *)occupation
                          ofcAdd1:(NSString *)ofcAdd1
                          ofcAdd2:(NSString *)ofcAdd2
                          ofcAdd3:(NSString *)ofcAdd3
                         landline:(NSString *)landline
                           mobile:(NSString *)mobile
                        ofcTelNum:(NSString *)ofcTelNum
                            email:(NSString *)email;

+ (NSError *)UpdatePersonalAssets: (NSString *)profileId
                         savings:(NSNumber *)savings
                         current:(NSNumber *)current
                           bonds:(NSNumber *)bonds
                          stocks:(NSNumber *)stocks
                          mutual:(NSNumber *)mutual
                    collectibles:(NSNumber *)collectibles;

+ (NSError *) UpdateRealProperty:(NSString *)profileId
                primaryresidence:(NSNumber *)primaryresidence
               vacationresidence:(NSNumber *)vacationresidence
                  rentalproperty:(NSNumber *)rentalproperty
                            land:(NSNumber *)land;

+ (NSError *) UpdateInsurance:(NSString *)profileId
                lifeInsurance:(NSNumber *)lifeInsurance
              healthInsurance:(NSNumber *)healthInsurance
          disabilityInsurance:(NSNumber *)disabilityInsurance;

+ (NSError *) UpdateBusiness:(NSString *)profileId
                    soleProp:(NSNumber *)soleProp
                 partnership:(NSNumber *)partnership
                 corporation:(NSNumber *)corporation;

+ (NSString *) getNewProfileIdNumber;

+ (NSNumber *) getTotalPersonalAssets: (NSString *) profileId;

+ (NSNumber *) getTotalInsurance: (NSString *) profileId;

+ (NSNumber *) getTotalBusiness: (NSString *) profileId;

+ (NSNumber *) getTotalRealProperty: (NSString *) profileId;

+ (NSMutableArray *) getAllProfileNames;

+ (NSMutableArray *) getAllProfileNames_Synch;

+ (NSMutableArray *) getDependents: (NSString *) profileId;

+ (NSMutableArray *) getDependentInfo: (NSString *) profileId dependentId: (NSString *) dependentId;

+ (NSString *) generateDependentId;

+ (NSError *) saveDependent: (NSString *) profileId
                dependentId: (NSString *) dependentId
                  firstName: (NSString *) firstName
                   lastName: (NSString *) lastName
                 middleName: (NSString *) middleName
                dateOfBirth: (NSString *) dateOfBirth
               relationship: (NSString *) relationship;

+ (NSError *) updateDependent: (NSString *) profileId
                  dependentId: (NSString *) dependentId
                    firstName: (NSString *) firstName
                     lastName: (NSString *) lastName
                   middleName: (NSString *) middleName
                  dateOfBirth: (NSString *) dateOfBirth
                 relationship: (NSString *) relationship;

+ (NSNumber *) checkExisingDependent:(NSString *)dependentId profileId: (NSString *) profileId;

+ (NSString *) internetReachable;

+ (void) purgeSequence;

+ (NSError *) purgeData:(NSString *) tableName;

+ (NSMutableArray *) getProfilesForPurge;

+ (void) checkDataStoreValidity;

@end
