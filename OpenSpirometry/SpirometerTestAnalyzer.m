//
//  SpirometerTestAnalyzer.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "SpirometerTestAnalyzer.h"
#import <Foundation/Foundation.h>

#define numEffortsForFixedDurationType 1
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@interface SpirometerTestAnalyzer()
@property (nonatomic, assign) SpiroTestState currentState;
@property (nonatomic, assign) SpiroTestType testType;

// Persistent Store Variables
@property (strong, nonatomic) NSString* userIdentifier;
@property (strong, nonatomic) NSMutableDictionary* userDataFile;        // Pointer to all user data
@property (strong, nonatomic) NSMutableDictionary* testData;            // Pointer to current test data
@property (strong, nonatomic) NSString* userDataFilePath;               // Path to user data file
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
    // Add the new effort to the efforts array within the current test
    [self.testData[@"Efforts"] addObject:effortResults];
    
    [self evaluateEfforts];
    
    return self.currentState;
}

- (SpiroTestState)overwritePreviousEffortResults:(NSDictionary*)effortResults {
    [self.testData[@"Efforts"] removeLastObject];
    return [self addEffortResults:effortResults];
}

- (void)addTestNotes:(NSString*)notes {
    self.testData[@"Notes"] = notes;
}

-(SpiroTestState)getCurrentSpiroTestState {
    return self.currentState;
}

-(void)clearAllEfforts {
    //Call function to reinstatiate data container
    [self createTestDataContainer];
}

-(void)setSpiroTestType:(SpiroTestType)testType{
    self.testType = testType;
}


#pragma mark - PRIVATE INTERFACE
-(void)evaluateEfforts {
    switch (self.testType) {
        case SpiroTestTypeStandard:
            [self evaluateForStandardType];
            break;
        case SpiroTestTypeFixedDuration:
            [self evaluateForFixedDurationType];
            break;
    }
    
    // TODO: If test complete, write timestamp to self.testData
    if (self.currentState == SpiroTestStateTestComplete) {
        [self addFieldsToTestData:[[NSDictionary alloc] initWithObjectsAndKeys:TimeStamp, @"Completion", nil] ];
        
        NSDate *myDate = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
        NSString *prettyTimeStamp = [dateFormat stringFromDate:myDate];
        
        // TODO: Use timestamp to continue test after a crash
        
        [self addFieldsToTestData:[[NSDictionary alloc] initWithObjectsAndKeys:TimeStamp, @"Completion", prettyTimeStamp, @"Completion (Formatted)", nil]];
        
        [self addMetadataToUserData:[[NSDictionary alloc] initWithObjectsAndKeys:self.userIdentifier, @"User ID", nil]];
    }
    
    
    [self writeUserDataToMemory];
}

-(void)evaluateForStandardType {
    // TODO: Test Analysis Logic
    // Need to evaluate the effort data and determine whether the test should conclude
    if (self.testData.count >= 4 || self.testData.count >= 5) {
        self.currentState = SpiroTestStateTestComplete;
    }
    else {
        self.currentState = SpiroTestStateInsufficient;
    }
}

-(void)evaluateForFixedDurationType {
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


-(void)createTestDataContainer {
    self.testData = [[NSMutableDictionary alloc] init];
    
    //Create empty array to contain efforts and push it into the test data dictionary
    [self.testData setObject:[[NSMutableArray alloc] init] forKey:@"Efforts"];
    
    self.currentState = SpiroTestStateNoEffortsAdded;
}

-(void)addUserIdentifier:(NSString *)userIdentifier {
    self.userIdentifier = userIdentifier;
}

#pragma mark - USER DATA STORAGE
-(void)addFieldsToTestData: (NSDictionary*) additionalFields {
     [self.testData addEntriesFromDictionary:additionalFields];
    
    // Save test data to memory
    [self writeUserDataToMemory];
}

-(void)addMetadataToUserData: (NSDictionary*) additionalFields {
    // Metadata consists of data added to the root level of the User Data file (e.g., UserID)
    if (!self.userDataFile) {
        [self getUserDataDocument];
    }
    
    if (!self.userDataFile[@"Metadata"]) {
        // If metadata dictionary doesn't exist, create it
        self.userDataFile[@"Metadata"] = [[NSMutableDictionary alloc] init];
    }
    
    [self.userDataFile[@"Metadata"] addEntriesFromDictionary:additionalFields];
    
    // Save metadata to memory
    [self writeUserDataToMemory];
}

-(void)getUserDataDocument {
    // Get UI Documents Paths
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get path to documents root
    NSString* documents = [paths firstObject];
    
    // If no user ID is supplied, assume a single user for the device; store data into "UserData.json"
    if (!self.userIdentifier) {
        self.userIdentifier = @"UserData";
    }
    // Set local path variable
    self.userDataFilePath = [NSString stringWithFormat:@"%@/%@.json", documents, self.userIdentifier];
    NSLog(@"File Path: %@", self.userDataFilePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.userDataFilePath]) {
        // File for user exists...
        // Read raw data into NSData object
        NSData* rawUserData = [[NSData alloc] initWithContentsOfFile:self.userDataFilePath];
        self.userDataFile = [self objectFromJSON:rawUserData];
        [self.userDataFile[@"Tests"] addObject:self.testData];
    } else {
        // File for user does not exist...
        // Create mutable array to contain all user file data
        self.userDataFile = [[NSMutableDictionary alloc] init];
        self.userDataFile[@"Tests"] = [[NSMutableArray alloc] init];
        [self.userDataFile[@"Tests"] addObject:self.testData];
    }
}

-(void)writeUserDataToMemory {
    if (!self.userDataFile || !self.userDataFilePath) {
        [self getUserDataDocument];
        
        // If this block executes, something went wrong; raise exception
        // [NSException raise:@"Invalid SpiroTest State Reached" format:@"Attempted to save data without user data file; no data destination"];
    }
    
    // Create JSON encoded file from current user data (which may or may not be complete)
    NSData* JSONFile = [self NSDataFromObject:self.userDataFile];
    // Write updated user data to memory
    [JSONFile writeToFile:self.userDataFilePath atomically:NO];
}

-(NSMutableDictionary*)objectFromJSON: (NSData*) rawData {
    return [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:nil];       // Return dictionary from JSON encoded NSData
}

-(NSData*)NSDataFromObject:(NSDictionary*) dataObject {
    return [NSJSONSerialization dataWithJSONObject:dataObject options:0 error:nil];                                 // Return JSON encoded NSData object from dictionary
}


@end
