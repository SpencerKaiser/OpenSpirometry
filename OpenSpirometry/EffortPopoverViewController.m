//
//  EffortPopoverViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/17/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "EffortPopoverViewController.h"

@interface EffortPopoverViewController()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end


@implementation EffortPopoverViewController
-(void)viewDidLoad{
    
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self returnToPresenter];
    }];
}
-(void)returnToPresenter{
//    UIViewController* presenter = [self presentingViewController];
//    presenter.
}
@end
