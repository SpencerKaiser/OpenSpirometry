//
//  ModalAddNotesViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/19/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalAddNotesViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary* pageConfig;    // Configuration data passed into page on instantiation
@property (strong, nonatomic) NSMutableDictionary* pageData;      // Data object used to store page data, which will be retrieved by the modal
@end
