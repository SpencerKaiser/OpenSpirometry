//
//  SpiroDataTransitionViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/14/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "SpiroDataTransitionViewController.h"
#import "VortexWhistleStudyViewController.h"
#import "SpiroCoachingInfoViewController.h"

@interface SpiroDataTransitionViewController ()

@end

@implementation SpiroDataTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@", self.userData);
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
    
    
    if (!self.type) {
        self.type = SpiroTransitionDefault;
    }
}

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PropogateUserData"]) {
        // Get reference to the destination view controller
        SpiroDataTransitionViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.userData = self.userData;
    } else if ([[segue identifier] isEqualToString:@"FinalUserDataHandoff"]) {
        VortexWhistleStudyViewController *vc = [segue destinationViewController];
        vc.userConfigData = self.userData;
    }
    
    // MAKE SURE THIS VC WILL BE DEALLOCATED AFTER THE SEGUE COMPLETES
    // self.userData = nil;
}


- (IBAction)actionButtonTapped:(id)sender {
    switch (self.type) {
        case SpiroTransitionDefault:
        {
            break;
        }
        case SpiroTransitionCoachingSplitter:
        {
            if (self.userData[@"Coaching"]) {
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SpiroCoaching" bundle:nil];
                SpiroCoachingInfoViewController* coachingInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"SpiroCoachingInfoScene"];
                coachingInfoVC.userData = self.userData;
                [self presentViewController:coachingInfoVC animated:YES completion:nil];
            } else {
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SpiroDataTransitionViewController* testStartVC = [storyboard instantiateViewControllerWithIdentifier:@"BeginTestScene"];
                testStartVC.userData = self.userData;
                [self presentViewController:testStartVC animated:YES completion:nil];
            }
            break;
        }
    }
}


- (void)dealloc{
    NSLog(@"Did dealloc Gesture VC");
}

@end
