//
//  ModalUserDataViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 11/3/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalUserDataViewController <NSObject>

-(void)userDataSubmitted:(NSMutableDictionary*)userData;

@end

@interface ModalUserDataViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, weak) id<ModalUserDataViewController> userDataPageDelegate;
@end
