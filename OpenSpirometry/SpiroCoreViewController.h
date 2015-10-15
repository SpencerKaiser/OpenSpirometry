//
//  SpiroCoreViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/27/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpirometerEffortAnalyzer.h"
#import "SpirometerTestAnalyzer.h"
#import "SpiroModalViewController.h"

@interface SpiroCoreViewController : UIViewController <SpirometerEffortDelegate, SpiroModalViewController>
-(void)prepareForGameStart;
-(void)gameHasEnded;
@end
