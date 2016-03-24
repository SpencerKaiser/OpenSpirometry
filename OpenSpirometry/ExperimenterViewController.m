//
//  ExperimenterViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "ExperimenterViewController.h"
#import "VortexWhistleStudyViewController.h"
#import "SpiroDataTransitionViewController.h"
#import "UserData.h"
#import "UserDataHandler.h"


@interface ExperimenterViewController () <UIPopoverPresentationControllerDelegate>
// UI ELEMENTS
@property (weak, nonatomic) IBOutlet UITextField* userIDField;
@property (weak, nonatomic) IBOutlet UILabel *userIDHelpLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl* userGroupControl;
@property (weak, nonatomic) IBOutlet UILabel* switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch* enableCoachingSwitch;

@property (weak, nonatomic) IBOutlet UIButton* mouthpieceButton;
@property (weak, nonatomic) IBOutlet UIButton* downstreamButton;

@property (weak, nonatomic) IBOutlet UIButton* ballButton;
@property (weak, nonatomic) IBOutlet UILabel* ballLabel;

@property (weak, nonatomic) IBOutlet UIButton* sidestackButton;
@property (weak, nonatomic) IBOutlet UILabel* sideStackLabel;

@property (weak, nonatomic) IBOutlet UILabel* pwgLabel;
@property (weak, nonatomic) IBOutlet UIButton* pwgButton;
@property (weak, nonatomic) IBOutlet UIView* pwgSpacer;

@property (weak, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) OptionsTableViewController* popover;
@property (weak, nonatomic) UIPopoverPresentationController* popoverController;

// DATA ELEMENTS
@property (assign, nonatomic) CGFloat popoverWidth;
@property (assign, nonatomic) CGFloat popoverHeight;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* popoverType;
@property (strong, nonatomic) NSString* selectedMouthpiece;
@property (strong, nonatomic) NSString* selectedDownstreamTube;
@property (strong, nonatomic) NSString* selectedBall;
@property (strong, nonatomic) NSString* selectedSidestack;
@property (strong, nonatomic) NSString* selectedPWGFile;

@property (strong, nonatomic) UserData* sharedUserData;
@property (strong, nonatomic) UserDataHandler* userDataHandler;
@end

@implementation ExperimenterViewController

#pragma mark - INSTANTIATION AND ALLOCATION
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sharedUserData = [UserData sharedInstance];
    self.userDataHandler = [[UserDataHandler alloc] init];
    
    // UI MODIFICATION
    
    self.completeButton.enabled = false;
    
    self.userIDHelpLabel.text = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.userIDField addTarget:self
                         action:@selector(userIDFieldChanged:)
               forControlEvents:UIControlEventEditingChanged];
    
    [self.userIDField addTarget:self
                         action:@selector(checkUserIDLength:)
               forControlEvents:UIControlEventEditingDidEnd];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle };
    [self.userGroupControl setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    [self.userGroupControl addTarget:self
                              action:@selector(userGroupChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    
    self.enableCoachingSwitch.on = false;           //Disable coaching by default
    self.enableCoachingSwitch.enabled = false;      //Disable the switch itself by default
    self.switchLabel.textColor = [UIColor lightGrayColor];
    
    [self hideBallAndSidestackElements];
    [self hidePWGElements];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.popover = [storyboard instantiateViewControllerWithIdentifier:@"OptionsTableViewControllerScene"];
    self.popover.delegate = self;
    self.popover.modalPresentationStyle = UIModalPresentationPopover;
    
    self.popoverWidth = self.view.frame.size.width * 0.80;
    self.popoverHeight = self.view.frame.size.height * 0.30;
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
    
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)],
                           nil];
    [numberToolbar sizeToFit];
    self.userIDField.inputAccessoryView = numberToolbar;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.sharedUserData clearAllData];         // In case we are returning to this VC after a successful test
    [self checkUserIDLength:self.userIDField];
}

#pragma mark - HANDLERS

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    [self resetFields];
}

- (void)userIDFieldChanged:(UITextField *)userIDField {
    // If length is > 1, enable submit button
    // If length == 3, dismiss keyboard
    if (self.userIDField.text.length >= 1) {
        if (self.userIDField.text.length >= 3) {
            [self dismissKeyboard];
        }
    } else {
    }
}

- (void)userGroupChanged:(UISegmentedControl *)userGroupSegmentedControl {
    int selected = (int)userGroupSegmentedControl.selectedSegmentIndex;
    
    if (selected == 3) {
        // PWG Group
        self.enableCoachingSwitch.on = false;
        self.enableCoachingSwitch.enabled = false;
        self.switchLabel.textColor = [UIColor lightGrayColor];
        
        if (self.selectedPWGFile) {
            [self.pwgButton setTitle:self.selectedPWGFile forState:UIControlStateSelected];
            [self.pwgButton setTitle:self.selectedPWGFile forState:UIControlStateNormal];
        } else {
            [self.pwgButton setTitle:@"Select a PWG File" forState:UIControlStateSelected];
            [self.pwgButton setTitle:@"Select a PWG File" forState:UIControlStateNormal];
        }
        [self showPWGElements];
    } else {
        // ALL OTHER USER GROUPS
        [self hidePWGElements];
        
        if (self.selectedMouthpiece) {
            [self.mouthpieceButton setTitle:self.selectedMouthpiece forState:UIControlStateSelected];
            [self.mouthpieceButton setTitle:self.selectedMouthpiece forState:UIControlStateNormal];
        } else {
            [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateSelected];
            [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateNormal];
        }
        
        if (selected == 1) {
            // PARTICIPANT IS IN APP + COACHING GROUP
            self.enableCoachingSwitch.enabled = true;
            self.switchLabel.textColor = [UIColor blackColor];
        } else {
            self.enableCoachingSwitch.on = false;
            self.enableCoachingSwitch.enabled = false;
            self.switchLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    [self checkRequiredFields];
}

- (void)optionSelected:(NSString *)selection {
    if ([self.popoverType isEqual: @"Mouthpiece"] ) {
        self.selectedMouthpiece = selection;
        //        NSLog(@"Mouthpiece Selected: %@", selection);
        [self.mouthpieceButton setTitle:self.selectedMouthpiece forState:UIControlStateNormal];
        [self.mouthpieceButton setTitle:self.selectedMouthpiece forState:UIControlStateSelected];
        
        if ([self.selectedMouthpiece isEqualToString:@"DigiDoc Whistle"]) {
            self.selectedDownstreamTube = nil;
            [self.downstreamButton setTitle:@"None" forState:UIControlStateNormal];
            [self.downstreamButton setTitle:@"None" forState:UIControlStateSelected];
            self.downstreamButton.enabled = false;
            [self hideBallAndSidestackElements];
        } else {
            NSString* downstreamText = @"Select a Downstream Tube";
            if (self.selectedDownstreamTube) {
                downstreamText = self.selectedDownstreamTube;
            }
            [self.downstreamButton setTitle:downstreamText forState:UIControlStateNormal];
            [self.downstreamButton setTitle:downstreamText forState:UIControlStateSelected];
            self.downstreamButton.enabled = true;
            
            [self showBallAndSidestackElements];
        }
        
    } else if ([self.popoverType isEqualToString:@"Downstream"]) {
        self.selectedDownstreamTube = selection;
        //        NSLog(@"Downstream Tube Selected: %@", selection);
        [self.downstreamButton setTitle:self.selectedDownstreamTube forState:UIControlStateNormal];
        [self.downstreamButton setTitle:self.selectedDownstreamTube forState:UIControlStateSelected];
    } else if ([self.popoverType isEqualToString:@"PWG"]) {
        self.selectedPWGFile = selection;
        [self.pwgButton setTitle:self.selectedPWGFile forState:UIControlStateNormal];
        [self.pwgButton setTitle:self.selectedPWGFile forState:UIControlStateSelected];
    } else if ([self.popoverType isEqualToString:@"Ball"]) {
        self.selectedBall = selection;
        [self.ballButton setTitle:self.selectedBall forState:UIControlStateNormal];
        [self.ballButton setTitle:self.selectedBall forState:UIControlStateSelected];
    } else if ([self.popoverType isEqualToString:@"Sidestack"]) {
        self.selectedSidestack = selection;
        [self.sidestackButton setTitle:self.selectedSidestack forState:UIControlStateNormal];
        [self.sidestackButton setTitle:self.selectedSidestack forState:UIControlStateSelected];
    }
    [self.popover dismissViewControllerAnimated:YES completion:nil];
    [self checkRequiredFields];
}


- (IBAction)mouthpieceButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Mouthpiece"];
}

- (IBAction)downstreamButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Downstream"];
}

- (IBAction)ballButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Ball"];
}

- (IBAction)sidestackButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Sidestack"];
}

- (IBAction)pwgButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"PWG"];
}

- (IBAction)completeButtonTapped:(id)sender {
    NSString* storedUserGroup = [self.userDataHandler getUserGroupForID:self.userID];
    NSString* selectedUserGroup = [self.userGroupControl titleForSegmentAtIndex:self.userGroupControl.selectedSegmentIndex];
    
    if (storedUserGroup && ![storedUserGroup isEqualToString:selectedUserGroup]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User Group Mismatch"
                                                                       message:[NSString stringWithFormat: @"The selected User Group for User %@ does not match the User Group in the User Data file.\n\nSelected: %@\nStored: %@", self.userID, selectedUserGroup, storedUserGroup]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* overwriteAction = [UIAlertAction actionWithTitle:@"Overwrite User Group"
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction * action) {
                                                                    [self presentWelcomeVC];
                                                                }];
        
        [alert addAction:overwriteAction];
        
        UIAlertAction* revertAction = [UIAlertAction actionWithTitle:@"Revert to Stored User Group"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self selectUserGroup:storedUserGroup];
                                                             }];
        [alert addAction:revertAction];
        
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self presentWelcomeVC];
    }
    
}

- (IBAction)generateUserIDButtonTapped:(id)sender {
    self.userIDField.text = [self.userDataHandler generateUserID];
    [self checkUserIDLength:self.userIDField];
}



#pragma mark - UI MODIFIERS

- (void)resetFields {
    self.selectedMouthpiece = nil;
    [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateNormal];
    [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateSelected];
    
    self.selectedDownstreamTube = nil;
    [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateNormal];
    [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateSelected];
    self.downstreamButton.enabled = true;
    
    [self hideBallAndSidestackElements];
    

    [self hidePWGElements];
    
    self.userID = nil;
    self.userIDField.text = @"";
    
    [self selectUserGroup:@"App + Clinician"];
    
    self.enableCoachingSwitch.on = false;
    self.enableCoachingSwitch.enabled = false;
    
    self.completeButton.enabled = false;
}

- (void)selectUserGroup:(NSString*)userGroup {
    for (int i = 0; i < self.userGroupControl.numberOfSegments; i++) {
        if ([[self.userGroupControl titleForSegmentAtIndex:i] isEqualToString:userGroup]) {
            self.userGroupControl.selectedSegmentIndex = i;
            break;
        }
    }
    [self userGroupChanged:self.userGroupControl];
}

- (void)dismissKeyboard {
    [self.userIDField resignFirstResponder];
}

- (void)hidePWGElements {
    self.selectedPWGFile = nil;
    self.pwgButton.hidden = true;
    self.pwgLabel.hidden = true;
    self.pwgSpacer.hidden = true;
}

- (void)showPWGElements {
    self.pwgButton.hidden = false;
    self.pwgLabel.hidden = false;
    self.pwgSpacer.hidden = false;
}

- (void)hideBallAndSidestackElements {
    self.selectedBall = nil;
    self.ballButton.hidden = true;
    self.ballLabel.hidden = true;
    
    self.selectedSidestack = nil;
    self.sidestackButton.hidden = true;
    self.sideStackLabel.hidden = true;
}

- (void)showBallAndSidestackElements {
    NSString* ballText = @"Select a Ball";
    if (self.selectedBall) {
        ballText = self.selectedBall;
    }
    [self.ballButton setTitle:ballText forState:UIControlStateNormal];
    [self.ballButton setTitle:ballText forState:UIControlStateSelected];
    self.ballButton.hidden = false;
    self.ballLabel.hidden = false;
    
    NSString* sidestackText = @"Select a Sidestack";
    if (self.selectedSidestack) {
        sidestackText = self.selectedSidestack;
    }
    [self.sidestackButton setTitle:sidestackText forState:UIControlStateNormal];
    [self.sidestackButton setTitle:sidestackText forState:UIControlStateSelected];
    self.sidestackButton.hidden = false;
    self.sideStackLabel.hidden = false;
}


#pragma mark - UI COMPONENTS

- (void)setPopoverTypeAndPresent:(NSString*)type {
    self.popoverType = type;
    [self.popover setOptionType:self.popoverType];
    
    self.popoverController = [self.popover popoverPresentationController];
    self.popoverController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popoverController.delegate = self;
    self.popoverController.sourceView = self.view;
    
    self.popover.preferredContentSize = CGSizeMake(self.popoverWidth, self.popoverHeight);
    
    CGFloat xPos, yPos;
    
    if ([self.popoverType isEqualToString:@"Mouthpiece"]) {
        xPos = self.mouthpieceButton.frame.origin.x + (0.5 * self.mouthpieceButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.mouthpieceButton.frame.origin.y;
    } else if ([self.popoverType isEqualToString:@"Downstream"]){
        xPos = self.downstreamButton.frame.origin.x + (0.5 * self.downstreamButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.downstreamButton.frame.origin.y;
    } else if ([self.popoverType isEqualToString:@"PWG"]) {
        xPos = self.pwgButton.frame.origin.x + (0.5 * self.pwgButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.pwgButton.frame.origin.y;
        
        self.popover.preferredContentSize = CGSizeMake(self.popoverWidth, self.view.frame.size.height * 0.60);
    } else if ([self.popoverType isEqualToString:@"Ball"]) {
        xPos = self.ballButton.frame.origin.x + (0.5 * self.ballButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.ballButton.frame.origin.y;
    } else if ([self.popoverType isEqualToString:@"Sidestack"]) {
        xPos = self.sidestackButton.frame.origin.x + (0.5 * self.sidestackButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.sidestackButton.frame.origin.y;
    } else {
        [NSException raise:@"Invalid Popover Type" format:@"An invalid popover type was used...[ExperimenterViewController.m]"];
    }
    
    self.popoverController.sourceRect = CGRectMake(xPos, yPos, self.popoverWidth, self.popoverHeight);
    
    [self presentViewController:self.popover animated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)presentWelcomeVC {
    NSMutableDictionary* userConfigData = [[NSMutableDictionary alloc] init];
    userConfigData[@"UserID"] = self.userID;
    userConfigData[@"UserGroup"] = [self.userGroupControl titleForSegmentAtIndex:self.userGroupControl.selectedSegmentIndex];
    userConfigData[@"Mouthpiece"] = self.selectedMouthpiece;
    
    if (self.selectedDownstreamTube) {
        userConfigData[@"DownstreamTube"] = self.selectedDownstreamTube;
    }
    
    if (self.enableCoachingSwitch.on) {
        userConfigData[@"Coaching"] = @"True";
    }
    
    if (self.selectedPWGFile) {
        userConfigData[@"PWGFile"] = self.selectedPWGFile;
    }
    
    if (self.selectedBall) {
        userConfigData[@"Ball"] = self.selectedBall;
    }
    
    if (self.selectedSidestack) {
        userConfigData[@"Sidestack"] = self.selectedSidestack;
    }
    
    self.sharedUserData.userData = userConfigData;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([[self.userGroupControl titleForSegmentAtIndex:self.userGroupControl.selectedSegmentIndex] isEqualToString:@"PWG"]) {
        VortexWhistleStudyViewController* testVC = [storyboard instantiateViewControllerWithIdentifier:@"VortexWhistleStudyViewScene"];
        [self presentViewController:testVC animated:YES completion:nil];
    } else {
        SpiroDataTransitionViewController* welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"UserWelcomeScene"];
        welcomeVC.type = SpiroTransitionCoachingSplitter;   // Next VC will evaluate whether or not to show coaching
        [self presentViewController:welcomeVC animated:YES completion:nil];
    }
}

#pragma mark - DATA CHECKERS

- (void)checkUserIDLength:(UITextField *)userIDField {
    self.userID = self.userIDField.text;
    if ((self.userID.length > 0 && self.userID.length < 3) || self.userID.length > 3) {
        self.userIDHelpLabel.text = @"User ID MUST be 3 numbers long";
        self.userIDHelpLabel.textColor = [UIColor redColor];
    } else if (self.userID.length == 3 && [self.userDataHandler userDataFileExistsForUserID:self.userID]) {
        self.userIDHelpLabel.text = @"User Data File Found";
        self.userIDHelpLabel.textColor = [UIColor greenColor];
        [self selectUserGroup:[self.userDataHandler getUserGroupForID:self.userID]];
    }
    else {
        self.userIDHelpLabel.text = @"";
    }
    [self checkRequiredFields];
}

- (void)checkRequiredFields {
    BOOL checkPassed = false;
    checkPassed = (self.userID.length == 3);
    checkPassed = checkPassed && self.selectedMouthpiece;
    
    
    if (![self.selectedMouthpiece isEqualToString:@"DigiDoc Whistle"]) {
        // Digidoc Whistle NOT selected
        checkPassed = checkPassed && self.selectedDownstreamTube && self.selectedBall && self.selectedSidestack;
    }
    
    NSString* userGroup = [self.userGroupControl titleForSegmentAtIndex:self.userGroupControl.selectedSegmentIndex];
    
    if ([userGroup isEqualToString:@"PWG"]) {
        // If user group is PWG
        checkPassed = checkPassed && self.selectedPWGFile;
    }
    
    if (checkPassed) {
        self.completeButton.enabled = true;
    } else {
        self.completeButton.enabled = false;
    }
}



#pragma mark - DEALLOC

-(void)dealloc{
    NSLog(@"Did dealloc experimenter config panel");
}

@end