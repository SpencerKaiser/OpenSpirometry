//
//  SpirometerTestAnalyzer.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//SpiroTestState - Used to determine whether testing should continue
typedef enum {
    SpiroTestStateNoEffortsAdded,
    SpiroTestStateTestComplete,
    SpiroTestStateInsufficient
} SpiroTestState;

typedef enum {
    SpiroTestTypeStandard,          // Min of 3 tests, stop once requirements are met OR after 5 tests
    SpiroTestTypeFixedDuration      // Stop after fixed number of tests, do not analyze results
} SpiroTestType;

@interface SpirometerTestAnalyzer : NSObject
-(SpiroTestState)getCurrentSpiroTestState;
-(void)setSpiroTestType:(SpiroTestType)testType;
-(void)clearAllEfforts;

-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults;

-(void)addUserIdentifier:(NSString*)userIdentifier;
-(void)addFieldsToTestData:(NSDictionary*)additionalFields;
-(void)addMetadataToUserData:(NSDictionary*)additionalFields;
@end