//
//  QuizQuestionViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/1/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "QuizQuestionViewController.h"
#import "SpiroDataTransitionViewController.h"
#import "UserData.h"

@interface QuizQuestionViewController ()
@property (strong, nonatomic) NSMutableDictionary* currentQuestion;

@property (assign, nonatomic) int selectedAnswerIndex;

@property (strong, nonatomic) NSMutableArray* answerVCs;

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

@property (weak, nonatomic) IBOutlet UILabel *answerValidationLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerFeedbackLabel;
@property (strong, nonatomic) IBOutlet UIView *answerValidationView;

@end

@implementation QuizQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.answerVCs = [[NSMutableArray alloc] init];
    
    if (!self.quizQuestions) {
        [self loadQuizQuestions];
    }
    
    self.currentQuestion = self.quizQuestions[self.questionNumber];
    
    self.questionTextLabel.text = self.currentQuestion[@"Question"];
    
    self.actionButton.alpha = 0.0;
    [self.actionButton setTitle:@"Confirm Answer" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Confirm Answer" forState:UIControlStateSelected];
    
    [self.actionButton.layer setBorderWidth:1.0];
    [self.actionButton.layer setCornerRadius:5.0];
    [self.actionButton.layer setBorderColor:[self.actionButton.titleLabel.textColor CGColor]];
    
    self.actionButton.enabled = false;  // Must be disabled after so the border of the button is not grey
    
    self.answerTextLabel.text = @"";
    
    [self createAnswerViews];
}

- (void)loadQuizQuestions {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"QuizQuestions" ofType:@"json"];
    NSLog(@"QuizQuestions.json File Path: %@", filePath);
    
    self.quizQuestions = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:filePath] options:NSJSONReadingMutableContainers error:nil];
}

- (void)createAnswerViews {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SpiroCoaching" bundle:nil];
    
    NSArray* answers = self.currentQuestion[@"Answers"];
    float answerViewHeight = (float)self.mainContainer.frame.size.height/(float)answers.count;
    float answerViewWidth = (float)self.mainContainer.frame.size.width;
    
    CGRect answerFrame;
    answerFrame.origin.x = 0;
    answerFrame.size.width = answerViewWidth;
    answerFrame.size.height = answerViewHeight;
    
    for (int i = 0; i < answers.count; i++) {
        QuizAnswerViewController* answerVC = [storyboard instantiateViewControllerWithIdentifier:@"QuizAnswerScene"];
        answerVC.QuizAnswerDelegate = self;
        answerVC.answerText = @"Answer text";
        
        answerFrame.origin.y = 0 + (answerViewHeight * i);
        answerVC.view.frame = answerFrame;
        
        answerVC.answerText = answers[i];
        answerVC.answerIndex = i;
        
        [self addChildViewController:answerVC];
        [self.mainContainer addSubview:answerVC.view];
        
        [self.answerVCs addObject:answerVC];
    }
}

- (void)answerTappedAtIndex:(int)index {
    self.selectedAnswerIndex = index;
    
    self.actionButton.enabled = true;
    [UIView animateWithDuration:1.0 animations:^{
        self.actionButton.alpha = 1.0;
    }completion:nil];
    
    [self desellectAllExcept:index];
}

- (void)desellectAllExcept:(int)index {
    NSArray* answers = self.currentQuestion[@"Answers"];
    for (int i = 0; i < answers.count; i++) {
        if (i != index) {
            QuizAnswerViewController* answerVC = self.answerVCs[i];
            [answerVC desellectAnswer];
        }
    }
}

- (IBAction)actionButtonTapped:(id)sender {
    
    if (self.answerVCs) {
        // USER HAS SUBMITTED ANSWER
        // Remove answer VCs from container view
        for (int i = 0; i < self.answerVCs.count; i++) {
            QuizAnswerViewController* answerVC = self.answerVCs[i];
            [answerVC.view removeFromSuperview];
            [answerVC removeFromParentViewController];
        }
        self.answerVCs = nil;
        
        float validationViewWidth = self.mainContainer.frame.size.width;
        float validationViewHeight = self.mainContainer.frame.size.height;
        
        CGRect validationViewRect = CGRectMake(0.0, 0.0, validationViewWidth, validationViewHeight);
        
        [self.answerValidationView setFrame:validationViewRect];
        
        int correctAnswerIndex = [self.currentQuestion[@"AnswerIndex"] intValue];
        
        if (self.currentQuestion[@"AnswerIndex"]) {
            if (correctAnswerIndex == self.selectedAnswerIndex) {
                self.answerValidationLabel.text = @"Correct";
                [self.answerValidationLabel setTextColor:[UIColor greenColor]];
            } else {
                self.answerValidationLabel.text = @"Incorrect";
                NSArray* answers = self.currentQuestion[@"Answers"];
                self.answerTextLabel.text = [NSString stringWithFormat:@"You Chose \"%@\"", answers[self.selectedAnswerIndex]];
                [self.answerValidationLabel setTextColor:[UIColor redColor]];
            }
        } else {
            self.answerValidationLabel.text = @"";
            self.answerTextLabel.text = @"";
        }
        
        self.answerFeedbackLabel.text = self.currentQuestion[@"FeedbackText"];
        
        [self.mainContainer addSubview:self.answerValidationView];
        
        self.actionButton.enabled = false;
        [UIView animateWithDuration:1.0 animations:^{
            self.actionButton.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self.actionButton setTitle:@"Continue" forState:UIControlStateNormal];
            [self.actionButton setTitle:@"Continue" forState:UIControlStateSelected];
            self.actionButton.enabled = true;
            [UIView animateWithDuration:2.0 animations:^{
                self.actionButton.alpha = 1.0;
            }];
        }];
    } else {
        // USER HAS TAPPED TO CONTINUE TO NEXT QUESTION
        [self continueToNextQuestion];
    }
}

- (void)continueToNextQuestion {
    
    // Write quiz data to UserData...
    UserData* sharedUserData = [UserData sharedInstance];
    NSMutableDictionary* userData = sharedUserData.userData;
    if (!userData) {
        [NSException raise:@"No User Data Found" format:@"User data was not found within the shared instance of UserData... something went wrong."];
    }
    
    NSMutableArray* quizData = userData[@"QuizData"];
    if (!quizData) {
        quizData = [[NSMutableArray alloc] init];
        userData[@"QuizData"] = quizData;
    }
    
    NSMutableDictionary* questionData = [[NSMutableDictionary alloc] init];
    [quizData addObject:questionData];
    questionData[@"SelectedAnswerIndex"] = @(self.selectedAnswerIndex);
    
    
    if (self.selectedAnswerIndex == [self.currentQuestion[@"AnswerIndex"] intValue]) {
        questionData[@"Correct"] = @1;
    } else if ([self.currentQuestion[@"AnswerIndex"] intValue]) {
        // The answer will be marked as incorrect only if an AnswerIndex DOES exist and it does not match the selected answer
        questionData[@"Correct"] = @0;
    }
    
    
    self.questionNumber += 1;       // Increment to next question
    
    if (self.questionNumber < self.quizQuestions.count) {
        // MORE QUESTIONS EXIST
        // Create new VC from storyboard
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SpiroCoaching" bundle:nil];
        QuizQuestionViewController* quizVC = [storyboard instantiateViewControllerWithIdentifier:@"QuizQuestionScene"];
        
        // Pass quiz data to new quiz VC
        quizVC.quizQuestions = self.quizQuestions;          // Pass question data to new VC
        quizVC.questionNumber = self.questionNumber;        // Set new quiz VC question number
        
        [self presentViewController:quizVC animated:YES completion:nil];
    } else {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpiroDataTransitionViewController* testStartVC = [storyboard instantiateViewControllerWithIdentifier:@"BeginTestScene"];
        [self presentViewController:testStartVC animated:YES completion:nil];
    }
}

@end
