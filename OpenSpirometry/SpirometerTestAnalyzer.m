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
}


#pragma mark Public Interface

-(void)addEffortResults:(NSDictionary*)effortResults{
    
}

-(void)clearAllEfforts{
    
}

-(void)addTestNotes:(NSString*)testNotes{
    
}

@end
