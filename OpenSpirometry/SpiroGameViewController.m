//
//  SpiroGameViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/15/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "SpiroGameViewController.h"

@interface SpiroGameViewController()

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation SpiroGameViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.tempLabel.text = @"UPDATED GAME";
    
    [self presentingViewController];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self presentingViewController];
}


#pragma mark Default API Functions
-(bool)gameWillEndWithEffortCompletion{
    return true;
}

@end


