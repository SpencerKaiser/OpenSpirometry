//
//  UserData.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject
+ (UserData *)sharedInstance;
@property NSMutableDictionary* userData;

- (void)clearAllData;
@end
