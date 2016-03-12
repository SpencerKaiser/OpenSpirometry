//
//  SpiroDataTransitionViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/14/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpiroDataTransitionViewController : UIViewController

typedef enum {
    SpiroTransitionDefault,
    SpiroTransitionCoachingSplitter
} SpiroTransitionType;

//@property (strong, nonatomic) NSMutableDictionary* userData;        //Need to make sure this isn't retained by this VC (will this VC dealloc???)
@property (assign, nonatomic) SpiroTransitionType type;
@end
