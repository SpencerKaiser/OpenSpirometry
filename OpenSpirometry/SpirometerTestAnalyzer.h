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

typedef enum : NSUInteger {
    SpiroTestStateNoEffortsAdded,
    SpiroTestStateTestComplete,
    SpiroTestStateInsufficient
} SpiroTestState;

@interface SpirometerTestAnalyzer : NSObject

-(void)addEffortResults:(NSDictionary*)effortResults;
//-(void)addEffortResults:(NSDictionary*)effortResults withNote:(NSString*)effortNote;        //TODO: Add functionality
//getSpiroTestState() which will return enum value for state
-(void)clearAllEfforts;
-(void)addTestNotes:(NSString*)testNotes;
//saveToPersistentStore
@end