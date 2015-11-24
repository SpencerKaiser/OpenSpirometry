//
//  VortexWhistleStudyViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 11/2/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "VortexWhistleStudyViewController.h"

@interface VortexWhistleStudyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation VortexWhistleStudyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI VARIABLE MODIFICATION
    [self.actionButton setTitle:@"Begin Effort" forState:UIControlStateNormal];
    self.titleLabel.text = @"Ready for Calibration";
    self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Wait for a brief period after view appears to make the app opening smoother
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [super presentIntroModal];
    });
}

-(void)modalDismissed {
    self.titleLabel.text = @"Ready for Calibration";
    self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
    self.actionButton.enabled = true;
}

- (IBAction)actionButtonPressed:(id)sender {
    [super prepareForGameStart];
    self.titleLabel.text = @"Calibrating...";
    self.descriptionLabel.text = @"Stay as quiet as possible for a few more seconds.";
    self.actionButton.enabled = false;
}

-(void)readyForGameStart{
    self.titleLabel.text = @"Calibration Complete";
    self.descriptionLabel.text = @"Start when ready";
}

-(void)userBeganTest {
    self.titleLabel.text = @"EXHALE!";
    self.descriptionLabel.text = @"Keep going";
}

-(void)userNearingCompletion {
    self.titleLabel.text = @"ALMOST THERE!";
    self.descriptionLabel.text = @"Exhale as long as possible";
}

-(void)userFinishedTest {
    self.titleLabel.text = @"Effort Complete";
    self.descriptionLabel.text = @"";
    [super gameHasEnded];
}

-(void)errorOccured: (NSString*) error {
    
}


@end
