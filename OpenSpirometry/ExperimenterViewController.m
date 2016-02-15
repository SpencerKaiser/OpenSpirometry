//
//  ExperimenterViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "ExperimenterViewController.h"
#import "BackGestureViewController.h"

@interface ExperimenterViewController () <UIPopoverPresentationControllerDelegate>
// UI ELEMENTS
@property (weak, nonatomic) IBOutlet UITextField* userIDField;
@property (weak, nonatomic) IBOutlet UISegmentedControl* userGroupControl;
@property (weak, nonatomic) IBOutlet UILabel* switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch* enableCoachingSwitch;

@property (weak, nonatomic) IBOutlet UIButton* mouthpieceButton;
@property (weak, nonatomic) IBOutlet UIButton* downstreamButton;

@property (weak, nonatomic) IBOutlet UIButton*completeButton;

@property (strong, nonatomic) OptionsTableViewController* popover;
@property (weak, nonatomic) UIPopoverPresentationController* popoverController;

// DATA ELEMENTS
@property (assign, nonatomic) CGFloat popoverWidth, popoverHeight;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* popoverType;
@property (strong, nonatomic) NSString* selectedMouthpiece;
@property (strong, nonatomic) NSString* selectedDownstreamTube;
@end

@implementation ExperimenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI MODIFICATION
    
    self.completeButton.enabled = false;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.userIDField addTarget:self
                         action:@selector(userIDFieldChanged:)
               forControlEvents:UIControlEventEditingChanged];
    
    
    [self.userGroupControl addTarget:self
                              action:@selector(userGroupChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    
    self.enableCoachingSwitch.on = false;           //Disable coaching by default
    self.enableCoachingSwitch.enabled = false;      //Disable the switch itself by default
    self.switchLabel.textColor = [UIColor lightGrayColor];
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.popover = [storyboard instantiateViewControllerWithIdentifier:@"OptionsTableViewControllerScene"];
    self.popover.delegate = self;
    self.popover.modalPresentationStyle = UIModalPresentationPopover;
    
    self.popoverWidth = self.view.frame.size.width * 0.80;
    self.popoverHeight = self.view.frame.size.height * 0.30;
    
    self.popover.preferredContentSize = CGSizeMake(self.popoverWidth, self.popoverHeight);
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
}

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    [self resetFields];
}

- (void)resetFields {
    self.selectedMouthpiece = nil;
    [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateNormal];
    [self.mouthpieceButton setTitle:@"Select a Mouthpiece" forState:UIControlStateSelected];
    
    self.selectedDownstreamTube = nil;
    [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateNormal];
    [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateSelected];
    self.downstreamButton.enabled = true;
    
    self.userID = nil;
    self.userIDField.text = @"";
    
    self.userGroupControl.selectedSegmentIndex = 0;
    
    self.enableCoachingSwitch.on = false;
    self.enableCoachingSwitch.enabled = false;
    
    self.completeButton.enabled = false;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PropogateUserData"])
    {
        // Get reference to the destination view controller
        BackGestureViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
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
        
        vc.userData = userConfigData;       // Pass user data to destination VC
    }
}


- (void)dismissKeyboard {
    [self.userIDField resignFirstResponder];
    self.userID = self.userIDField.text;
    [self checkRequiredFields];
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
    if (userGroupSegmentedControl.selectedSegmentIndex == 1) {
        // PARTICIPANT IS IN APP + COACHING GROUP
        self.enableCoachingSwitch.enabled = true;
        self.switchLabel.textColor = [UIColor blackColor];
    } else {
        self.enableCoachingSwitch.on = false;
        self.enableCoachingSwitch.enabled = false;
        self.switchLabel.textColor = [UIColor lightGrayColor];
    }
    [self checkRequiredFields];
}


- (void)checkRequiredFields {
    if (self.userID.length > 0 && ([self.selectedMouthpiece isEqual:@"DigiDoc Whistle"] || (self.selectedMouthpiece && self.selectedDownstreamTube))) {
        self.completeButton.enabled = true;
    } else {
        self.completeButton.enabled = false;
    }
}

- (IBAction)mouthpieceButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Mouthpiece"];
}

- (IBAction)downstreamButtonTapped:(id)sender {
    [self setPopoverTypeAndPresent:@"Downstream"];
}

- (void)setPopoverTypeAndPresent:(NSString*)type {
    self.popoverType = type;
    [self.popover setOptionType:self.popoverType];
    
    self.popoverController = [self.popover popoverPresentationController];
    self.popoverController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popoverController.delegate = self;
    self.popoverController.sourceView = self.view;
    
    //    NSLog(@"View Weidth: %f, Height: %f", self.view.frame.size.width, self.view.frame.size.height);
    //    NSLog(@"Button X: %f, Y: %f", self.downstreamButton.frame.origin.x, self.downstreamButton.frame.origin.y);
    
    CGFloat xPos, yPos;
    
    if ([self.popoverType isEqualToString:@"Mouthpiece"]) {
        xPos = self.mouthpieceButton.frame.origin.x + (0.5 * self.mouthpieceButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.mouthpieceButton.frame.origin.y;
    } else if ([self.popoverType isEqualToString:@"Downstream"]){
        xPos = self.downstreamButton.frame.origin.x + (0.5 * self.downstreamButton.frame.size.width) - (0.5 * self.popoverWidth);
        yPos = self.downstreamButton.frame.origin.y;
    } else {
        [NSException raise:@"Invalid Popover Type" format:@"An invalid popover type was used..."];
    }
    
    self.popoverController.sourceRect = CGRectMake(xPos, yPos, self.popoverWidth, self.popoverHeight);
    
    [self presentViewController:self.popover animated:YES completion:nil];
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
        } else {
            [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateNormal];
            [self.downstreamButton setTitle:@"Select a Downstream Tube" forState:UIControlStateSelected];
            
            self.downstreamButton.enabled = true;
        }
        
    } else {
        self.selectedDownstreamTube = selection;
//        NSLog(@"Downstream Tube Selected: %@", selection);
        [self.downstreamButton setTitle:self.selectedDownstreamTube forState:UIControlStateNormal];
        [self.downstreamButton setTitle:self.selectedDownstreamTube forState:UIControlStateSelected];
    }
    [self.popover dismissViewControllerAnimated:YES completion:nil];
    [self checkRequiredFields];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)dealloc{
    NSLog(@"Did dealloc experimenter config panel");
}



// Before complete button is pressed, check to make sure user is of correct group

@end
;