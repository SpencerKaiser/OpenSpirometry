//
//  QuizAnswerViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/1/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "QuizAnswerViewController.h"

@interface QuizAnswerViewController ()
@property (weak, nonatomic) IBOutlet UIView *answerButton;
@property (weak, nonatomic) IBOutlet UILabel *answerTextLabel;

@property (strong, nonatomic) CAShapeLayer *buttonLayer;

@end

@implementation QuizAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.answerButton.backgroundColor = [UIColor whiteColor];
    
    
    // Create Multiple-Choice-style button
    self.buttonLayer = [CAShapeLayer layer];
    
    float buttonWidth = self.answerButton.frame.size.width;
    float buttonHeight = self.answerButton.frame.size.height;
    
    [self.buttonLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, buttonWidth, buttonHeight)] CGPath]];
    
    
    self.buttonLayer.lineWidth = 5.0;
    [self.buttonLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
    
    [self.buttonLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    
    [[self.answerButton layer] addSublayer:self.buttonLayer];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(answerTapped)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.answerTextLabel.text = self.answerText;
}

- (void)answerTapped {
    if ([self.QuizAnswerDelegate respondsToSelector:@selector(answerTappedAtIndex:)]) {
        
        [self.buttonLayer setFillColor:[[[UIColor blueColor] colorWithAlphaComponent:0.7] CGColor]];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.QuizAnswerDelegate answerTappedAtIndex:self.answerIndex];
        });
    }
}

- (void)desellectAnswer {
    [self.buttonLayer setFillColor:[[UIColor whiteColor] CGColor]];
}


@end
