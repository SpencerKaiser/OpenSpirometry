//
//  ModalTimerViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 12/1/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalTimerViewController.h"

@interface ModalTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionDescription;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation ModalTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageConfig) {
//        [NSException raise:@"No Page Configurations Found" format:@"The pageConfig dictionary must be instantiated prior to presenting this view"];
    }
    
    // Set UI elements according to config data
    self.pageLabel.text = @"Take a break before continuing.";
    self.actionDescription.text = @"";
    [self.actionButton setTitle:@"Continue" forState:UIControlStateNormal];
}


-(void)dealloc{
    NSLog(@"Did dealloc action page view");
}

@end
