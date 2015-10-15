//
//  SpiroCoreViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/27/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "SpiroCoreViewController.h"
#import "SpirometerEffortAnalyzer.h"
#import "SpirometerTestAnalyzer.h"
#import "SpiroModalViewController.h"


@interface SpiroCoreViewController ()
// DATA ELEMENTS
@property (strong, nonatomic) SpirometerEffortAnalyzer* effortAnalyzer;
@property (strong, nonatomic) SpirometerTestAnalyzer* testAnalyzer;
@property (strong, nonatomic) NSDictionary* latestEffortResults;
@property (nonatomic, assign) SpiroTestState spiroTestStatus;

// UI ELEMENTS
@property (strong, nonatomic) SpiroModalViewController* spiroTestTransitionModal;

@end


@implementation SpiroCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#pragma mark Initialization
    //----------EFFORT ANALYZER----------
    self.effortAnalyzer = [[SpirometerEffortAnalyzer alloc] init];
    self.effortAnalyzer.delegate = self;
    self.effortAnalyzer.prefferredAudioMaxUpdateIntervalInSeconds = 1.0/24.0; // the default is 30FPS, so setting lower
    // the FPS possible on this depends on the audio buffer size and sampling rate, which is different for different phones
    // most likely this has a maximum update rate of about 100 FPS
    
    // **for debugging**: this turns on the debug mode for reading the effort from a file (only wav currently supported)
    [self.effortAnalyzer activateDebugAudioModeWithWAVFile:@"VortexWhistleRed"]; // default audio file name
    
    
    //-----------TEST ANALYZER-----------
    self.testAnalyzer = [[SpirometerTestAnalyzer alloc] init];
    self.spiroTestStatus = [self.testAnalyzer getCurrentSpiroTestState];
    
    
    
    //----------------UI-----------------
    // Create reference to modal view controller and configure modal settings
    self.definesPresentationContext = YES;
    self.spiroTestTransitionModal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpiroModalViewControllerScene"];
    self.spiroTestTransitionModal.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.spiroTestTransitionModal.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.spiroTestTransitionModal.delegate = self;
}


#pragma mark - UI TRANSITIONS

-(void)modalDismissedWithInfo:(NSDictionary *)modalInfo {
    NSLog(@"Modal Dismissed with message: %@", [modalInfo objectForKey:@"Notes"]);
    
    //NEED TO SAVE EFFORT/TEST
    
}



#pragma mark - GAMING API
// The following functions can be overwritten by a subclass
// Required callbacks must be implemented or an exception will be raised


#pragma mark Gaming Functions

// prepareForGameStart: Call to prepare game environment
// • Begins calibration process
// • User should be prompted to be as silent as possible BEFORE calling this function
// • Callback function calibrationDidFinish will be called when finished
-(void)prepareForGameStart {
    [self startSpiroEffort];
}

// gameHasEnded: Call announce when the game has ended
// • Calling this function will begin the process of display results to the user
// • After displaying results, the process will continue or the test will end
-(void)gameHasEnded {
    // DISPLAY RESULTS
    
    NSMutableDictionary* modalData = [[NSMutableDictionary alloc] init];
    modalData[@"ModalType"] = @(SpiroEffortResultsModal);
    //[modalData setObject:[NSNumber numberWithInt:SpiroEffortResultsModal] forKey:@"ModalType"];
    NSLog(@"%@", [NSNumber numberWithInt:SpiroEffortResultsModal]);
    [modalData setObject:self.latestEffortResults forKey:@"EffortData"];

    self.spiroTestTransitionModal.modalData = modalData;
    
    [self presentViewController:self.spiroTestTransitionModal animated:true completion:nil];
}


#pragma mark Gaming Callbacks

// readyForGameStart - REQUIRED: Ready for game to begin
// • Notifies game that exhalation can begin
// • NOTE: Exhalation must begin within 10 seconds
//      (TIME_OUT_WAIT_FOR_TEST_START < SpirometerConstants.h)
-(void)readyForGameStart {
    [NSException raise:@"No custom implementation for readyForGameStart" format:@"Function must be implemented within subclass"];
}

// exhalationBegan - OPTIONAL: User began test (began exhalation)
-(void)userBeganTest {
    
}

// userNearingCompletion - REQUIRED: User will soon finish the test
-(void)userNearingCompletion {
    [NSException raise:@"No custom implementation for userNearingCompletion" format:@"Function must be implemented within subclass"];
}

// userFinishedTest - REQUIRED: User finished test, game should end soon
-(void)userFinishedTest {
    [NSException raise:@"No custom implementation for userFinishedTest" format:@"Function must be implemented within subclass"];
}

// errorOccured - REQUIRED: An error occured during the test, game should not
// start or should halt if in progress
-(void)errorOccured: (NSString*) error {
    [NSException raise:@"No custom implementation for errorOccured" format:@"Function must be implemented within subclass. Error Message Encountered: %@", error];
}

// wasLastGame - OPTIONAL: Current game will be last game of test
// Once the user has made 3 satisfactory efforts (of 5 total),
// this function will be called. This function can be used to display
// final game results before user will see test results.
-(void)wasLastGame {
    
}



#pragma mark -  ADVANCED API
// The following functions CAN be overwritten, however, it is not advised
// If function(s) below are overwritten, the subclassed function
// MUST call the function of the super (e.g., [super functionName])

#pragma mark Spiro Effort Callbacks

-(void)didFinishCalibratingSilence {
    NSLog(@"[super] didFinishCalibratingSilence");
    [self readyForGameStart];
}

-(void)didTimeoutWaitingForTestToStart {
    NSLog(@"[super] didTimeoutWaitingForTestToStart");
    [self errorOccured:@"didTimeoutWaitingForTestToStart"];
}

-(void)didStartExhaling {
    NSLog(@"[super] didStartExhaling");
    [self userBeganTest];
}

-(void)willEndTestSoon {
    NSLog(@"[super] willEndTestSoon");
    [self userNearingCompletion];
}

-(void)didCancelEffort {
    NSLog(@"[super] didCancelEffort");
    [self errorOccured:@"didCancelEffort"];
}

-(void)didEndEffortWithResults:(NSDictionary*)results {
    // Save results locally
    self.latestEffortResults = results;
    
    NSLog(@"[super] didEndEffortWithResults");
    
    SpiroTestState currentTestState = [self.testAnalyzer getCurrentSpiroTestState];

    [self userFinishedTest];
    
    // TODO: Implement SpiroState Switch
    // If this test was the last test, call [self wasLastGame] to indicate test is complete
    
}

-(void)didUpdateFlow:(float)flowInLitersPerSecond andVolume:(float)volumeInLiters {
//    NSLog(@"[super] didUpdateFlow");
}

-(void)didUpdateAudioBufferWithMaximum:(float)maxAudioValue {
//    NSLog(@"[super] didUpdateAudioBufferWithMaximum");
}


#pragma mark - PRIVATE API
// The following functions must NOT be be overwritten.

-(void)startSpiroEffort {
    NSLog(@"[super] startSpiroEffort \n\t-> SpiroEffortAnalyzer:beginListeningForEffort");
    [self.effortAnalyzer beginListeningForEffort];
}

-(void)saveSpiroEffort:(NSDictionary*)results {
    NSLog(@"[super] saveSpiroEffort \n\t-> SpiroTestAnalyzer:addEffortResults");
    self.spiroTestStatus = [self.testAnalyzer addEffortResults:results];
}

-(void)saveSpiroEffort:(NSDictionary*)results withNote:(NSString*)note {
    NSLog(@"[super] saveSpiroEffort withNote \n\t-> SpiroEffortAnalyzer:addEffortResults withNote");
    self.spiroTestStatus = [self.testAnalyzer addEffortResults:results withNote:note];
}

-(void)saveSpiroTestData {
    NSLog(@"[super] saveTest");
}

@end