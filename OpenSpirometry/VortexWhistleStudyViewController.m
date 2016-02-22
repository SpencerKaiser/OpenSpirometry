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
@property (assign, nonatomic) BOOL errorOccurred;
@end

@implementation VortexWhistleStudyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI VARIABLE MODIFICATION
    [self.actionButton setTitle:@"Begin Effort" forState:UIControlStateNormal];
    self.titleLabel.text = @"Ready for Calibration";
//    self.helpText.text = @"After beginning calibration, remain as quiet as possible until prompted to begin using the whistle."
    self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
    
    if (self.userConfigData) {
        NSLog(@"User Config Data: %@", self.userConfigData);
        [super storeUserConfigData:self.userConfigData];
        self.userConfigData = nil;      // We no longer need a copy in this subclass
    } else {
        [NSException raise:@"User Config Data not found" format:@"User configuration data MUST be passed into this View Controller."];
    }
    
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}

-(void)modalDismissed {
    self.titleLabel.text = @"Ready for Calibration";
    self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
    self.actionButton.enabled = true;
}

- (IBAction)actionButtonPressed:(id)sender {
    if (self.errorOccurred) {
        self.titleLabel.text = @"Ready for Calibration";
        self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
        self.errorOccurred = false;
    } else {
        [super prepareForGameStart];
        self.titleLabel.text = @"Calibrating...";
        self.descriptionLabel.text = @"Stay as quiet as possible for a few more seconds.";
        self.actionButton.enabled = false;
    }
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
    self.errorOccurred = true;
    self.titleLabel.text = @"Whoops!";
    self.descriptionLabel.text = @"Something went wrong.\n\nWhen you're ready to continue, hit the button below and you'll be able to restart the effort.";
    
    [self.actionButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Continue" forState:UIControlStateSelected];
    self.actionButton.enabled = true;
}

-(void)dealloc{
    NSLog(@"Did dealloc VortexWhistleStudy VC");
}


@end
