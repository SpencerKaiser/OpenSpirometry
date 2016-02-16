//
//  BackGestureViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/14/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "BackGestureViewController.h"
#import "VortexWhistleStudyViewController.h"

@interface BackGestureViewController ()

@end

@implementation BackGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@", self.userData);
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
}

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PropogateUserData"]) {
        // Get reference to the destination view controller
        BackGestureViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.userData = self.userData;
    } else if ([[segue identifier] isEqualToString:@"FinalUserDataHandoff"]) {
        VortexWhistleStudyViewController *vc = [segue destinationViewController];
        vc.userConfigData = self.userData;
    }
    
    // MAKE SURE THIS VC WILL BE DEALLOCATED AFTER THE SEGUE COMPLETES
    // self.userData = nil;
}


- (void)dealloc{
    NSLog(@"Did dealloc Gesture VC");
}

@end
