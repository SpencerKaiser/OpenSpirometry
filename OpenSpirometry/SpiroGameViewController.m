//
//  SpiroGameViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/27/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "SpiroGameViewController.h"

@interface SpiroGameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startEffortButton;

@end

@implementation SpiroGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startEffortButtonPressed:(id)sender {
    [super prepareForGameStart];
}

-(void)readyForGameStart{
    NSLog(@"Ready to Start Game!");
}

-(void)userBeganTest {
    NSLog(@"Game Started!");
}

-(void)userNearingCompletion {
    NSLog(@"Almost Finished!");
}

-(void)userFinishedTest {
    NSLog(@"Game Over.");
    [super gameHasEnded];
}

-(void)errorOccured: (NSString*) error {
    
}




@end
