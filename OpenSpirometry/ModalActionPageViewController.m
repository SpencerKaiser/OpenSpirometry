//
//  ModalActionPageViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/18/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalActionPageViewController.h"

@interface ModalActionPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionDescription;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation ModalActionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageConfig) {
        [NSException raise:@"No Page Configurations Found" format:@"The pageConfig dictionary must be instantiated prior to presenting this view"];
    }
    
    // Set UI elements according to config data
    self.actionLabel.text = self.pageConfig[@"Label"];
    self.actionDescription.text = self.pageConfig[@"Description"];
    [self.actionButton setTitle:self.pageConfig[@"Button"] forState:UIControlStateNormal];
}

- (IBAction)actionButtonPressed:(id)sender {
    if([self.actionPageDelegate respondsToSelector:@selector(userActionTaken)])
    {
        [self.actionPageDelegate userActionTaken];
    } else {
        [NSException raise:@"Delegate must implement functionality for userActionTaken" format:@"This method is required for core functionality."];
    }
}

-(void)dealloc{
    NSLog(@"Did dealloc action page view");
}

@end
