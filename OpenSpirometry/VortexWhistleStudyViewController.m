//
//  VortexWhistleStudyViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 11/2/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "VortexWhistleStudyViewController.h"
#import "UserData.h"

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
    [self.actionButton.layer setBorderWidth:2.0];
    [self.actionButton.layer setCornerRadius:5.0];
    [self.actionButton.layer setBorderColor:[self.actionButton.titleLabel.textColor CGColor]];
    
    self.titleLabel.text = @"Ready for Calibration";
//    self.helpText.text = @"After beginning calibration, remain as quiet as possible until prompted to begin using the whistle."
    self.descriptionLabel.text = @"Press the 'Begin Effort' button below.";
    
    UserData* sharedUserData = [UserData sharedInstance];
    self.userConfigData = sharedUserData.userData;
    
    if (self.userConfigData) {
        NSLog(@"User Config Data: %@", self.userConfigData);
        [super storeUserConfigData:self.userConfigData];
        self.userConfigData = nil;      // We no longer need a copy in this subclass
    } else {
        [NSException raise:@"User Config Data not found" format:@"User configuration data is required and was not found within the UserData singleton."];
    }
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}

-(void)modalDismissed {
    [self setLabelText:@"Ready for Calibration" forLabel:self.titleLabel];
    [self setLabelText:@"Press the 'Begin Effort' button below." forLabel:self.descriptionLabel];
    self.actionButton.enabled = true;
    [UIView animateWithDuration:0.5 animations:^(void){
        self.actionButton.alpha = 1.0;
    }];
}

- (IBAction)actionButtonPressed:(id)sender {
    if (self.errorOccurred) {
        [self setLabelText:@"Ready for Calibration" forLabel:self.titleLabel];
        [self setLabelText:@"Press the 'Begin Effort' button below." forLabel:self.descriptionLabel];
        self.errorOccurred = false;
        [UIView animateWithDuration:0.5 animations:^(void){
            self.actionButton.alpha = 1.0;
        }];
    } else {
        [super prepareForGameStart];
        [self setLabelText:@"Calibrating..." forLabel:self.titleLabel];
        [self setLabelText:@"Stay as quiet as possible for a few more seconds." forLabel:self.descriptionLabel];
        self.actionButton.enabled = false;
        [UIView animateWithDuration:0.5 animations:^(void){
            self.actionButton.alpha = 0.0;
        }];
    }
}

- (void)setLabelText:(NSString*)text forLabel:(UILabel*)label {
    // Adapted from: http://stackoverflow.com/questions/3073520/animate-text-change-in-uilabel
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    // This will fade:
    label.text = text;
}

-(void)readyForGameStart{
    [self setLabelText:@"Calibration Complete" forLabel:self.titleLabel];
    [self setLabelText:@"Start when ready" forLabel:self.descriptionLabel];
}

-(void)userBeganTest {
    [self setLabelText:@"EXHALE!" forLabel:self.titleLabel];
    [self setLabelText:@"Keep going!" forLabel:self.descriptionLabel];
}

-(void)userNearingCompletion {
    [self setLabelText:@"ALMOST THERE!" forLabel:self.titleLabel];
    [self setLabelText:@"Exhale as long as possible" forLabel:self.descriptionLabel];
}

-(void)userFinishedTest {
    [self setLabelText:@"Effort Complete" forLabel:self.titleLabel];
    [self setLabelText:@"" forLabel:self.descriptionLabel];
    [super gameHasEnded];
}

-(void)errorOccured: (NSString*) error {
    self.errorOccurred = true;
    
    [self setLabelText:@"Whoops!" forLabel:self.titleLabel];
    [self setLabelText:@"Something went wrong.\n\nWhen you're ready to continue, hit the button below and you'll be able to restart the effort." forLabel:self.descriptionLabel];
    
    [self.actionButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Continue" forState:UIControlStateSelected];
    self.actionButton.enabled = true;
}

-(void)dealloc{
    NSLog(@"Did dealloc VortexWhistleStudy VC");
}


@end
