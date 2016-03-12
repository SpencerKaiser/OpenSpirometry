//
//  SpirometerTestAnalyzer.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "SpirometerTestAnalyzer.h"
#import "UserDataHandler.h"
#import <Foundation/Foundation.h>

#define numEffortsForFixedDurationType 4
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]

@interface SpirometerTestAnalyzer()
@property (nonatomic, assign) SpiroTestState currentState;
@property (nonatomic, assign) SpiroTestType testType;

// Persistent Store Variables
@property (strong, nonatomic) NSString* userIdentifier;
@property (strong, nonatomic) NSMutableDictionary* userDataFile;        // Pointer to all user data
@property (strong, nonatomic) NSMutableDictionary* testData;            // Pointer to current test data
//@property (strong, nonatomic) NSString* userDataFilePath;               // Path to user data file

@property (strong, nonatomic) UserDataHandler* userDataHandler;
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

- (id)init {
    if(self = [super init]){
        [self setup];
        return self;
    }
    return nil;
}

- (void)dealloc {
    
}

- (void)setup {
    //Perform any actions (instatiating variables, etc.) that must be done upon object creation
    //This will be done within the init() function, prior to returning a copy of this object to its calling function
    [self createTestDataContainer];
    
    self.testType = SpiroTestTypeStandard;  //Default test type is set to standard
    
    self.userDataHandler = [[UserDataHandler alloc] init];
}


#pragma mark - PUBLIC INTERFACE
- (SpiroTestState)addEffortResults:(NSDictionary*)effortResults {
    // Add the new effort to the efforts array within the current test
    [self.testData[@"Efforts"] addObject:effortResults];
    
    [self evaluateEfforts]; // Check test status and write data to memory
    
    return self.currentState;
}

- (SpiroTestState)overwritePreviousEffortResults:(NSDictionary*)effortResults {
    [self.testData[@"Efforts"] removeLastObject];
    return [self addEffortResults:effortResults];
}
 
- (void)addTestNotes:(NSString*)notes {
    if (self.testData[@"Notes"]) {
        notes = [NSString stringWithFormat:@"[%@] Appended: %@", self.testData[@"Notes"], notes];
    }
    self.testData[@"Notes"] = notes;
    
    [self.userDataHandler writeUserDataToMemory:self.userDataFile];
}

-(SpiroTestState)getCurrentSpiroTestState {
    return self.currentState;
}

- (void)clearAllEfforts {
    //Call function to reinstantiate data container
    [self createTestDataContainer];
    
    // !!!: NOT TESTED
    // This function only clears the efforts from local memory but does not clear what has already been written to persistent storage
}

-(void)setSpiroTestType:(SpiroTestType)testType{
    self.testType = testType;
}


#pragma mark - PRIVATE INTERFACE
- (void)evaluateEfforts {
    switch (self.testType) {
        case SpiroTestTypeStandard:
            [self evaluateForStandardType];
            break;
        case SpiroTestTypeFixedDuration:
            [self evaluateForFixedDurationType];
            break;
    }
    
    // Check if test is complete... if complete, add timestamps to test data
    // Entering this function will result in data being written to memory
    if (self.currentState == SpiroTestStateTestComplete) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
        NSString *prettyTimeStamp = [dateFormat stringFromDate:[[NSDate alloc] init]];
        
        [self addFieldsToTestData:[[NSDictionary alloc] initWithObjectsAndKeys:TimeStamp, @"Completion", prettyTimeStamp, @"CompletionFormatted", nil]];
    } else {
        // If this block is reached, save to memory as it has not yet been saved
        [self.userDataHandler writeUserDataToMemory:self.userDataFile];
    }
}

- (void)evaluateForStandardType {
    // TODO: Test Analysis Logic
    // Need to evaluate the effort data and determine whether the test should conclude
    if (self.testData.count >= numEffortsForFixedDurationType) {
        self.currentState = SpiroTestStateTestComplete;
    }
    else {
        self.currentState = SpiroTestStateInsufficient;
    }
}

- (void)evaluateForFixedDurationType {
    // Grab reference to current efforts for test (including recently added effort)
    NSMutableArray* efforts = [self.testData objectForKey:@"Efforts"];
    
    // Evaluate number of efforts against the defined number needed for a fixed duration test
    if (efforts.count < numEffortsForFixedDurationType) {
        self.currentState = SpiroTestStateInsufficient;
    }
    else if (efforts.count >= numEffortsForFixedDurationType) {
        self.currentState = SpiroTestStateTestComplete;
    }
}


- (void)createTestDataContainer {
    self.testData = [[NSMutableDictionary alloc] init];
    
    //Create empty array to contain efforts and push it into the test data dictionary
    [self.testData setObject:[[NSMutableArray alloc] init] forKey:@"Efforts"];
    
    self.currentState = SpiroTestStateNoEffortsAdded;
}

- (void)addUserIdentifier:(NSString *)userIdentifier {
    self.userIdentifier = userIdentifier;
    self.userDataHandler.userID = self.userIdentifier;
}

#pragma mark - USER DATA STORAGE
- (void)addFieldsToTestData: (NSDictionary*) additionalFields {
    [self checkStorageParams];
    [self.testData addEntriesFromDictionary:additionalFields];
    [self.userDataHandler writeUserDataToMemory:self.userDataFile];
}

- (void)addMetadataToUserData: (NSDictionary*) additionalFields {
    [self checkStorageParams];    
    [self.userDataHandler writeMetadata:additionalFields toUserData:self.userDataFile];
}

- (void)checkStorageParams {
    if (!self.userDataFile) {
        if (!self.userIdentifier) {
            [NSException raise:@"No User ID Found" format:@"User ID is required for this type of interaction with the UserDataHandler"];
        }
        self.userDataFile = [self.userDataHandler getUserDataForID:self.userIdentifier];
        NSMutableArray* tests = self.userDataFile[@"Tests"];
        [tests addObject:self.testData];
    }
}


@end
