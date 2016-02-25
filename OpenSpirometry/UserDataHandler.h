//
//  UserDataHandler.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/18/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataHandler : NSObject
@property (strong, nonatomic) NSString* userID;
- (NSString *)generateUserID;

#pragma mark - READ OPERATIONS
- (NSMutableDictionary *)getUserDataForID:(NSString *)userID;
- (NSString *)getUserGroupForID:(NSString *)userID;
- (NSString *)readMetadataForKey:(NSString *)key;

#pragma mark - WRITE OPERATIONS
- (void)writeUserDataToMemory:(NSMutableDictionary *)userData;
- (void)writeMetadata:(NSDictionary *)additionalFields toUserData:(NSMutableDictionary *)userData;

@end
