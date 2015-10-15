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

@interface SpirometerTestAnalyzer : NSObject

-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults;
-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults withNote:(NSString*)effortNote;
-(SpiroTestState)getCurrentSpiroTestState;
-(void)clearAllEfforts;
-(void)addTestNotes:(NSString*)testNotes;
-(void)saveToPersistentStore;

@end