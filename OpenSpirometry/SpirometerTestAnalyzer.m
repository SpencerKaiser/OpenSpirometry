//
//  SpirometerTestAnalyzer.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "SpirometerTestAnalyzer.h"
#import <Foundation/Foundation.h>



@interface SpirometerTestAnalyzer()
@property (nonatomic, strong) NSMutableDictionary* testData;

@end


@implementation SpirometerTestAnalyzer

#pragma mark Init/Dealloc
//CREATE SINGLETON OF TEST ANALYZER
+ (SpirometerTestAnalyzer *) testAnalyzer
{
    static SpirometerTestAnalyzer * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        _sharedInstance = [[SpirometerTestAnalyzer alloc] init];
    });
    
    return _sharedInstance;
}

-(id)init{
    if(self = [super init]){
        [self setup];
        return self;
    }
    return nil;
}

-(void)dealloc{
    
}

-(void)setup{
    //Perform any actions (instatiating variables, etc.) that must be done upon object creation
    //This will be done within the init() function, prior to returning a copy of this object to its calling function
    [self createTestDataContainer];
}



#pragma mark Delegate Events
-(void)issueTestComplete{

}



#pragma mark Private Functions
-(bool)resultsAreSatisfactory{
    if([[self.testData objectForKey:@"efforts"] count] >= 4){
        //PERFORM LOGIC TO TEST IF RESULTS ARE ACTUALLY ADEQUATE
        //TODO: Results logic
        return true;
    } else{
        return false;
    }
}

-(void)createTestDataContainer{
    self.testData = [[NSMutableDictionary alloc] init];
    
    //Create empty array to contain efforts and push it into the test data dictionary
    [self.testData setObject:[[NSMutableArray alloc] init] forKey:@"efforts"];
}



#pragma mark Public Interface
-(void)addEffortResults:(NSDictionary*)effortResults{
    
    //Grab reference to efforts array
    NSMutableArray* efforts = [self.testData objectForKey:@"efforts"];
    [efforts addObject:effortResults];
    
    //TODO: Reimplement as a switch statement
    //TODO: Look into using enum
    //Private enum: 'not enough efforts' (< 3), 'insufficient test' (not satisfactory yet), 'test complete', 'test complete with errors', etc.
    
    SpiroTestState testState;
//    testState = []   <-- Function to determine state of test which returns enum results
    
    switch (testState) {
        case SpiroTestStateInsufficient:
            
            break;
            
        default:
            break;
    }
    
    if( [efforts count] < 3 ){
        
    } else if ([efforts count] >= 3 ){
        //TEST FOR ACCURACY REQUIREMENTS
        if([self resultsAreSatisfactory]){
            [self issueTestComplete];
        }
        
    } else if( [efforts count] == 5 ){
        [self issueTestComplete];
    }
}

-(void)clearAllEfforts{
    //Call function to reinstatiate data container
    [self createTestDataContainer];
}

-(void)addTestNotes:(NSString*)testNotes{
    [self.testData setObject:testNotes forKey:@"Notes"];
}

@end
