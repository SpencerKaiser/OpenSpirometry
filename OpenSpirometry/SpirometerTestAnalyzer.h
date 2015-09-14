//
//  SpirometerTestAnalyzer.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SpirometerTestAnalyzer : NSObject

-(void)addEffortResults:(NSDictionary*)effortResults;
-(void)clearAllEfforts;
-(void)addTestNotes:(NSString*)testNotes;


@end