//
//  ModalTimerPageViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/15/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalTimerPageViewController <NSObject>

-(void)userActionTaken;     // Called the the action page's action button is pressed

@end

@interface ModalTimerPageViewController : UIViewController
@property (weak, nonatomic) id<ModalTimerPageViewController> modalTimerPageDelegate;
@property (strong, nonatomic) NSMutableDictionary* pageConfig;    // Configuration data passed into page on instantiation
@property (strong, nonatomic) NSMutableDictionary* pageData;      // Data object used to store page data, which will be retrieved by the modal
@end