//
//  ExperimenterViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "ExperimenterViewController.h"
#import "OptionsTableViewController.h"

@interface ExperimenterViewController () <UIPopoverPresentationControllerDelegate>
// UI ELEMENTS
@property (weak, nonatomic) IBOutlet UITextField* userIDField;
@property (weak, nonatomic) IBOutlet UISegmentedControl* userGroupControl;
@property (weak, nonatomic) IBOutlet UILabel* switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch* enableCoachingSwitch;

@property (weak, nonatomic) IBOutlet UIButton* mouthpieceButton;
@property (weak, nonatomic) IBOutlet UIButton* downstreamButton;

@property (weak, nonatomic) IBOutlet UIButton*completeButton;

@property (strong, nonatomic) UIViewController* popover;
@property (weak, nonatomic) UIPopoverPresentationController* popoverController;

// DATA ELEMENTS
@property (strong, nonatomic) NSString* userID;
@property (assign, nonatomic) BOOL mouthpieceSelected;
@property (assign, nonatomic) BOOL downstreamTubeSelected;
@end

@implementation ExperimenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // DATA INITIALIZATION
    self.mouthpieceSelected = false;
    self.downstreamTubeSelected = false;

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
    
    
    self.popover = [[UITableViewController alloc] init];
//    self.popover = [[OptionsTableViewController alloc] init];
    self.popover.modalPresentationStyle = UIModalPresentationPopover;
    

}

- (void)dismissKeyboard {
    [self.userIDField resignFirstResponder];
    [self checkRequiredFields];
    self.userID = self.userIDField.text;
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
    NSLog(@"User Group Changed");
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
    if (self.userID && self.mouthpieceSelected && self.downstreamTubeSelected) {
        self.completeButton.enabled = true;
    }
}

- (IBAction)mouthpieceButtonTapped:(id)sender {
    self.popoverController = [self.popover popoverPresentationController];
    self.popoverController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popoverController.delegate = self;
    self.popoverController.sourceView = self.view;
    
    CGFloat xPos, yPos;
    xPos = self.mouthpieceButton.frame.origin.x + 0.5*self.mouthpieceButton.frame.size.width;
    yPos = self.mouthpieceButton.frame.origin.y + self.mouthpieceButton.frame.size.height - 25.0;
    
    self.popoverController.sourceRect = CGRectMake(xPos, yPos, 3.0, 3.0);
    [self presentViewController:self.popover animated:YES completion:nil];
}

- (IBAction)downstreamButtonTapped:(id)sender {
    self.popoverController = [self.popover popoverPresentationController];
    self.popoverController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popoverController.delegate = self;
    self.popoverController.sourceView = self.view;
    
    CGFloat xPos, yPos;
    xPos = self.downstreamButton.frame.origin.x + 0.5*self.downstreamButton.frame.size.width;
    yPos = self.downstreamButton.frame.origin.y + self.downstreamButton.frame.size.height - 25.0;
    
    self.popoverController.sourceRect = CGRectMake(xPos, yPos, 3.0, 3.0);
    [self presentViewController:self.popover animated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

-(void)dealloc{
    NSLog(@"Did dealloc experimenter config panel");
}



// Before complete button is pressed, check to make sure user is of correct group

@end
