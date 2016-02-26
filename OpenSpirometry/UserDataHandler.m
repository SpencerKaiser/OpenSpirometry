//
//  UserDataHandler.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/18/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "UserDataHandler.h"

@interface UserDataHandler()

@property (strong, nonatomic) NSString* userDataFilePath;               // Path to user data file

@end

@implementation UserDataHandler

#pragma mark - PUBLIC API

// TODO: Implement functions
- (NSString *)generateUserID {
    
    
    // USE A JSON FILE WITH AN ARRAY CONTAINING ALL USED USER IDs
    
    return @"";
}

- (NSString *)getUserGroupForID:(NSString *)userID {
    // Save current state of the UserDataHandler
    NSString* currUserID = self.userID;
    NSString* currUserDataFilePath = self.userDataFilePath;
    
    self.userID = userID;
    NSMutableDictionary* userData = [self getUserDataForID:userID];
    
    NSString* userGroup = userData[@"Metadata"][@"UserGroup"];
    
    
    self.userID = currUserID;
    self.userDataFilePath = currUserDataFilePath;

    return userGroup;
}

- (void)writeUserDataToMemory:(NSMutableDictionary *)userData {
    
    if (!userData) {
        [NSException raise:@"No User Data Found" format:@"A dictionary of user data is required by this function"];
    }
    
    [self checkFilePath];
    
    // Create JSON encoded file from current user data (which may or may not be complete)
    NSData* JSONFile = [self NSDataFromObject:userData];
    // Write updated user data to memory
    [JSONFile writeToFile:self.userDataFilePath atomically:NO];
}

- (void)writeMetadata:(NSDictionary *)additionalFields toUserData:(NSMutableDictionary *)userData {
    // Metadata consists of data added to the root level of the User Data file (e.g., UserID)
    
    [self checkFilePath];
    
    // If metadata dictionary doesn't exist, create it
    if (!userData[@"Metadata"]) {
        userData[@"Metadata"] = [[NSMutableDictionary alloc] init];
    }
    
    [userData[@"Metadata"] addEntriesFromDictionary:additionalFields];
    
    // Save metadata to memory
    [self writeUserDataToMemory:userData];
}

// TODO: Implement function
- (NSString *)readMetadataForKey:(NSString *)key {
    return @"";
}



- (NSMutableDictionary *)getUserDataForID:(NSString *)userID {
    [self checkFilePath];
    
    NSMutableDictionary* userData;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.userDataFilePath]) {
        // File for user exists...
        // Read raw data into NSData object
        NSData* rawUserData = [[NSData alloc] initWithContentsOfFile:self.userDataFilePath];
        userData = [self objectFromJSON:rawUserData];
    } else {
        // File for user does not exist...
        // Create mutable array to contain all user file data
        userData = [[NSMutableDictionary alloc] init];
        userData[@"Tests"] = [[NSMutableArray alloc] init];
        
        NSMutableDictionary* userMetadata = [[NSMutableDictionary alloc] init];
        userMetadata[@"UserID"] = userID;
        [userData setObject:userMetadata forKey:@"Metadata"];
    }
    
    return userData;
}


- (BOOL)userDataFileExistsForUserID:(NSString*)userID {
    // Get UI Documents Paths
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get path to documents root
    NSString* documents = [paths firstObject];
    
    // Set local path variable
    NSString* dataFilePath = [NSString stringWithFormat:@"%@/%@.json", documents, userID];

    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        return true;
    }
    return false;
}


#pragma mark - PRIVATE UTILITIES
//- (void)setUserID:(NSString *)userID {
//    // Overwriting setter; if userID changes, userDataFilePath become nil so data is not written to the wrong file
//    if (userID != _userID) {
//        userID = _userID;
//        self.userDataFilePath = nil;
//    }
//}

- (void)checkFilePath {
    // Ensure file path exists
    if (!self.userDataFilePath) {
        [self getUserDataFilePath];
    }
}

- (void)getUserDataFilePath {
    if (!self.userID || [self.userID isEqualToString:@""]) {
        [NSException raise:@"User ID Not Found" format:@"A User ID is required by this function and must be set using the setUserID function"];
    }
    
    // Get UI Documents Paths
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get path to documents root
    NSString* documents = [paths firstObject];
    
    // Set local path variable
    self.userDataFilePath = [NSString stringWithFormat:@"%@/%@.json", documents, self.userID];
    
    NSLog(@"File Path: %@", self.userDataFilePath);
}

-(NSMutableDictionary*)objectFromJSON: (NSData*) rawData {
    return [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:nil];       // Return dictionary from JSON encoded NSData
}

-(NSData*)NSDataFromObject:(NSDictionary*) dataObject {
    return [NSJSONSerialization dataWithJSONObject:dataObject options:0 error:nil];                                 // Return JSON encoded NSData object from dictionary
}

@end
