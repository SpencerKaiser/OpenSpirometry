//
//  SpirometerTestAnalyzer.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

//TODO: REMOVE DELEGATION

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
    SpiroTestTypeFixedDuration      // Stop after 5 tests, do not evaluate results
} SpiroTestType;

@interface SpirometerTestAnalyzer : NSObject

-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults;
-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults withNote:(NSString*)effortNote;
-(SpiroTestState)getCurrentSpiroTestState;
-(void)clearAllEfforts;
-(void)addTestNotes:(NSString*)testNotes;
-(void)saveToPersistentStore;
-(void)setSpiroTestType:(SpiroTestType)testType;

@end