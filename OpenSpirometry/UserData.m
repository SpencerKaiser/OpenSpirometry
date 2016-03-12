//
//  UserData.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (UserData *)sharedInstance {
    static UserData *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)clearAllData {
    self.userData = nil;
}

@end
