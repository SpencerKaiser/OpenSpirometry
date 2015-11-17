//
//  SpirometerTestAnalyzer.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "SpirometerTestAnalyzer.h"
#import <Foundation/Foundation.h>

#define numEffortsForFixedDurationType 5

@interface SpirometerTestAnalyzer()
@property (nonatomic, strong) NSMutableDictionary* testData;
@property (nonatomic, assign) SpiroTestState currentState;
@property (nonatomic, assign) SpiroTestType testType;
@end


@implementation SpirometerTestAnalyzer

#pragma mark - INIT/DEALLOC
//CREATE SINGLETON OF TEST ANALYZER
+ (SpirometerTestAnalyzer *) testAnalyzer {
    static SpirometerTestAnalyzer * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        _sharedInstance = [[SpirometerTestAnalyzer alloc] init];
    });
    return _sharedInstance;
}

-(id)init {
    if(self = [super init]){
        [self setup];
        return self;
    }
    return nil;
}

-(void)dealloc {
    
}

-(void)setup {
    //Perform any actions (instatiating variables, etc.) that must be done upon object creation
    //This will be done within the init() function, prior to returning a copy of this object to its calling function
    [self createTestDataContainer];
    self.currentState = SpiroTestStateNoEffortsAdded;
    
    self.testType = SpiroTestTypeStandard;  //Default test type is set to standard
}




#pragma mark - PUBLIC INTERFACE
-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults {
    //Grab reference to efforts array
    NSMutableArray* efforts = [self.testData objectForKey:@"efforts"];
    [efforts addObject: effortResults];
    
    [self evaluateEfforts];
    
    return self.currentState;
}

-(SpiroTestState)addEffortResults:(NSDictionary*)effortResults withNote:(NSString*)effortNote {
    //Create new dictionary with existing effort results
    NSMutableDictionary* effortResultsWithNote = [[NSMutableDictionary alloc] initWithDictionary:effortResults];
    //Add note to effort
    [effortResultsWithNote setObject:effortNote forKey:@"Note"];
    
    //Grab reference to efforts array
    NSMutableArray* efforts = [self.testData objectForKey:@"efforts"];
    [efforts addObject: effortResultsWithNote];
    
    [self evaluateEfforts];
    
    return self.currentState;
}

-(SpiroTestState)getCurrentSpiroTestState {
    return self.currentState;
}

-(void)clearAllEfforts {
    //Call function to reinstatiate data container
    [self createTestDataContainer];
}

-(void)addTestNotes:(NSString*)testNotes {
    [self.testData setObject:testNotes forKey:@"Notes"];
}

-(void)saveToPersistentStore {
    // TODO: Send Test to Core Data
    // This will be the outlet to the other portion of the app which saves the data to core data for future access
}

-(void)setSpiroTestType:(SpiroTestType)testType{
    self.testType = testType;
}


#pragma mark - PRIVATE INTERFACE
-(void)evaluateEfforts {
    // TODO: Results Logic
    // This function should test to see if the data is satisfactory or if the test should end
    // Once the evaluation is complete, the current state is saved into self.currentState
    
    // TODO: Split functionality into individual methods
    // This switch will call functions depending on the valu of testType
    
    switch (self.testType) {
        case SpiroTestTypeStandard:
        {
            if (self.testData.count >= 4 || self.testData.count >= 5) {
                self.currentState = SpiroTestStateTestComplete;
            }
            else {
                self.currentState = SpiroTestStateInsufficient;
            }
            break;
        }
        case SpiroTestTypeFixedDuration:
        {
            // Grab reference to current efforts for test (including recently added effort)
            NSMutableArray* efforts = [self.testData objectForKey:@"efforts"];
            
            // Evaluate number of efforts against the defined number needed for a fixed duration test
            if (efforts.count < numEffortsForFixedDurationType) {
                self.currentState = SpiroTestStateInsufficient;
            }
            else if (efforts.count >= numEffortsForFixedDurationType) {
                self.currentState = SpiroTestStateTestComplete;
            }
            break;
        }
    }
}

-(void)createTestDataContainer {
    self.testData = [[NSMutableDictionary alloc] init];
    
    //Create empty array to contain efforts and push it into the test data dictionary
    [self.testData setObject:[[NSMutableArray alloc] init] forKey:@"efforts"];
    self.currentState = SpiroTestStateNoEffortsAdded;
}


@end
