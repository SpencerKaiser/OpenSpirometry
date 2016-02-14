//
//  optionsTableViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsTableViewController <NSObject>

-(void)optionSelected:(NSString*)selection;

@end

@interface OptionsTableViewController : UITableViewController
@property (weak, nonatomic) NSString* type;
@property (weak, nonatomic) id<OptionsTableViewController> delegate;
@end
