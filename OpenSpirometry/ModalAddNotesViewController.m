//
//  ModalAddNotesViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/19/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalAddNotesViewController.h"

@interface ModalAddNotesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDescription;
@property (weak, nonatomic) IBOutlet UITextView *noteView;

@end

@implementation ModalAddNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageConfig) {
        [NSException raise:@"No Page Configurations Found" format:@"The pageConfig dictionary must be instantiated prior to presenting this view"];
    }
    
    // Set UI elements according to config data
    self.noteLabel.text = self.pageConfig[@"Label"];
    self.noteDescription.text = self.pageConfig[@"Description"];
    self.noteView.text = self.pageConfig[@"Placeholder"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dealloc{
    NSLog(@"Did dealloc notes view");
}

-(void)dismissKeyboard {
    [self.noteView resignFirstResponder];
}

//TODO: Add functionality to move modal up when keyboar is active
//TODO: Add 'done' toolbar above keyboard

@end
