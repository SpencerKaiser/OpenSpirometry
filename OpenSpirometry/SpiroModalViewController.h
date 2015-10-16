//
//  SpiroModalViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/17/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

//SpiroModalType - Used to determine the purpose of the modal
typedef enum {
    SpiroIntroModal,
    SpiroEffortResultsModal,
    SpiroTestResultsModal
} SpiroModalType;

@protocol SpiroModalViewController <NSObject>

-(void)modalDismissedWithInfo:(NSDictionary*)modalInfo;

@end


@interface SpiroModalViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, assign) id<SpiroModalViewController> modalDelegate;
@property (weak, nonatomic) NSMutableDictionary* modalData;    //Data passed into modal
@property (strong, nonatomic) UIPageViewController* modalPageViewController;

@end
