//
//  BackGestureViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/14/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "BackGestureViewController.h"

@interface BackGestureViewController ()

@end

@implementation BackGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHandler:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
}

- (void)tripleTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
