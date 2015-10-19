//
//  ModalActionPageViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/18/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalActionPageViewController <NSObject>

-(void)userActionTaken;     // Called the the action page's action button is pressed

@end

@interface ModalActionPageViewController : UIViewController
@property (nonatomic, assign) id<ModalActionPageViewController> actionPageDelegate;
@property (strong, nonatomic) NSMutableDictionary* pageConfig;    // Configuration data passed into page on instantiation
@property (strong, nonatomic) NSMutableDictionary* pageData;      // Data object used to store page data, which will be retrieved by the modal
@end
