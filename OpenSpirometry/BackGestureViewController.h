//
//  BackGestureViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/14/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGestureViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary* userData;        //Need to make sure this isn't retained by this VC (will this VC dealloc???)
@end
