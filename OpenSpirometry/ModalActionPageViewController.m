//
//  ModalActionPageViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/18/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalActionPageViewController.h"
#define timerDuration 60.0

@interface ModalActionPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionDescription;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
//@property (weak, nonatomic) IBOutlet UILabel *actionTimerLabel;
//@property (strong, nonatomic) NSTimer* timer;
//@property (assign, nonatomic) float timeRemaining;
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
    
//    self.actionButton.enabled = false;
//    
//    self.timeRemaining = timerDuration;
//    self.actionTimerLabel.text = [NSString stringWithFormat:@"%.0f", self.timeRemaining];
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
//    
//    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
//    tripleTap.numberOfTapsRequired = 3;
//    [self.view addGestureRecognizer:tripleTap];
}

//- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
//    [self.timer invalidate];
//    self.actionTimerLabel.text = @"";
//    self.actionButton.enabled = true;
//}

//- (void)updateTimer:(NSTimer*)timer {
//    if (self.timeRemaining >= 1.0) {
//        self.timeRemaining -= 1;
//        self.actionTimerLabel.text = [NSString stringWithFormat:@"%.0f", self.timeRemaining];
//    } else {
//        [timer invalidate];
//        self.actionTimerLabel.text = @"";
//        self.actionButton.enabled = true;
//    }
//
//}

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
