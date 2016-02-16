//
//  TestCompleteViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/15/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "TestCompleteViewController.h"
#import "ExperimenterViewController.h"

@interface TestCompleteViewController ()

@end

@implementation TestCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
    
    UISwipeGestureRecognizer* backSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwipeHandler:)];
    backSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    backSwipe.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:backSwipe];
}

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    UIViewController* presentingVC = self.presentingViewController;
    while (presentingVC && ![presentingVC isKindOfClass:[ExperimenterViewController class]]) {
//        UIViewController* parentVC = presentingVC.presentingViewController;
//        [presentingVC dismissViewControllerAnimated:NO completion:nil];
//        presentingVC = parentVC;
        presentingVC = presentingVC.presentingViewController;
    }
    
    [presentingVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)backSwipeHandler:(UISwipeGestureRecognizer *)swipeRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
