//
//  SpiroNavigationViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 12/1/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "SpiroNavigationViewController.h"
#import "VortexWhistleStudyViewController.h"

@interface SpiroNavigationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startTestButton;

@end

@implementation SpiroNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UINavigationController* test = self.navigationController;
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)startTestButtonPressed:(id)sender {
    VortexWhistleStudyViewController* newTestVC = [[VortexWhistleStudyViewController alloc] init];

    [self.navigationController pushViewController:newTestVC animated:YES];
}

@end
