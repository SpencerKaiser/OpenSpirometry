//
//  TestingEnvironmentViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/14/15.
//  Copyright (c) 2015 Eric Larson. All rights reserved.
//

#import "FVCTestTrialsViewController.h"
#import "SpirometerEffortAnalyzer.h"
#import "SpirometerTestAnalyzer.h"
#import "SpiroModalViewController.h"

@interface FVCTestTrialsViewController ()
@property (strong, nonatomic) SpirometerEffortAnalyzer* effortAnalyzer;
@property (strong, nonatomic) SpirometerTestAnalyzer* testAnalyzer;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *clearEffortButton;
@property (weak, nonatomic) IBOutlet UIButton *openPopoverButton;
@property (weak, nonatomic) IBOutlet UIView *gameContainerView;
@property (weak, nonatomic) IBOutlet UIView *parentViewContentView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;

@property (strong, nonatomic) UIViewController* effortPopoverViewController;
@property (strong, nonatomic) UIViewController* gameViewController;
@end

@implementation FVCTestTrialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.gameViewController = [[self childViewControllers] objectAtIndex:0];
    self.gameContainerView.hidden = true;
    self.blurView.hidden = true;
    
    
    self.effortAnalyzer = [[SpirometerEffortAnalyzer alloc] init];
    self.effortAnalyzer.delegate = self;
    self.effortAnalyzer.prefferredAudioMaxUpdateIntervalInSeconds = 1.0/24.0; // the default is 30FPS, so setting lower
    // the FPS possible on this depends on the audio buffer size and sampling rate, which is different for different phones
    // most likely this has a maximum update rate of about 100 FPS
    
    // **for debugging**: this turns on the debug mode for reading the effort from a file (only wav currently supported)
    [self.effortAnalyzer activateDebugAudioModeWithWAVFile:@"VortexWhistleRed"]; // default audio file name
    
    
    self.testAnalyzer = [[SpirometerTestAnalyzer alloc] init];
    
    //POPOVER
    self.definesPresentationContext = YES;
    
    self.effortPopoverViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EffortPopoverViewControllerScene"];
    self.effortPopoverViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.effortPopoverViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.addButton.enabled = false;
    self.clearEffortButton.enabled = false;
}

- (IBAction)startEffortButtonPressed:(id)sender {
    self.startButton.enabled = false;
}

- (IBAction)openPopoverButton:(id)sender {
    
//    self.blurView.alpha = 0;
//    self.blurView.hidden = false;
    [UIView animateWithDuration:1.0 animations:^{
//        self.blurView.alpha = 1;
    }completion:^(BOOL finished) {
        [self presentViewController:self.effortPopoverViewController animated:true completion:nil];
//        self.parentViewContentView.hidden = true;
        self.gameContainerView.hidden = false;
    }];
}

-(void)returningFromPopover{
    NSLog(@"Returned!");
}

- (IBAction)addEffort:(id)sender {
//    [self.testAnalyzer addEffortResults:[[NSDictionary alloc]init]];
}
- (IBAction)clearEffortButtonPressed:(id)sender {
    [self.testAnalyzer clearAllEfforts];
    self.startButton.enabled = true;
    self.clearEffortButton.enabled = false;
}

-(void)didStartExhaling{
    //[self testBegan]
    
    
}

-(void)willEndTestSoon{
}

-(void)didEndEffortWithResults:(NSDictionary*)results{
    self.addButton.enabled = true;
}

@end
