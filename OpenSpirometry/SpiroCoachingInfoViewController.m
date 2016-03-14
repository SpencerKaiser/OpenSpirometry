//
//  SpiroCoachingInfoViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/29/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "SpiroCoachingInfoViewController.h"
#import "QuizQuestionViewController.h"

@interface SpiroCoachingInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoHeader;
@property (weak, nonatomic) IBOutlet UILabel *infoBody;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) NSMutableArray* coachingInfoText;
@property (assign, nonatomic) int currentTextGroup;
@property (assign, nonatomic) int currentTextGroupItem;
@property (assign, nonatomic) BOOL allInfoShown;

@end

@implementation SpiroCoachingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoBody.text = @"";
    self.infoHeader.text = @"";
    
    self.actionButton.alpha = 0.0;
    [self.actionButton.layer setBorderWidth:1.0];
    [self.actionButton.layer setCornerRadius:5.0];
    [self.actionButton.layer setBorderColor:[self.actionButton.titleLabel.textColor CGColor]];
    
//    [self.actionButton addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
//    [self.actionButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
//    [self.actionButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    self.coachingInfoText = [[NSMutableArray alloc] init];
    [self loadCoachingText];
    
    self.currentTextGroup = 0;
    self.currentTextGroupItem = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginCoachingInfoDisplay];
    });
}

- (void)buttonHighlighted:(UIButton*)button {
//    self.actionButton.alpha = self.actionButton.titleLabel.alpha;
}

- (void)buttonReleased:(UIButton*)button {
//    self.actionButton.alpha = self.actionButton.alpha;
}

- (void)loadCoachingText {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CoachingText" ofType:@"json"];
    NSLog(@"QuizQuestions.json File Path: %@", filePath);
    
    self.coachingInfoText = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:filePath] options:NSJSONReadingMutableContainers error:nil];
}

- (void)beginCoachingInfoDisplay {
    [self showNextTextItem];
    [self.actionButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Continue" forState:UIControlStateSelected];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.actionButton.alpha = 1.0;
        }];
    });
}

- (IBAction)actionButtonTapped:(id)sender {
    if (self.allInfoShown) {
        [self presentQuizVC];
    } else {
        [self showNextTextItem];
    }
    
}

- (void)showNextTextItem {
    self.actionButton.enabled = true;
    [UIView animateWithDuration:0.5 animations:^(void){
        self.actionButton.alpha = 1.0;
    }];
    NSDictionary* currentGroup = self.coachingInfoText[self.currentTextGroup];
    NSArray* currentGroupText = currentGroup[@"GroupText"];
    if (self.currentTextGroupItem < currentGroupText.count) {
        if ([self.infoHeader.text isEqualToString:@""]) {
            [self setInfoHeaderText:currentGroup[@"Header"]];
        }
        
        
        // If additional text items exit, append to existing text
        NSString* bodyText = currentGroupText[self.currentTextGroupItem];
        
        if (self.currentTextGroupItem > 0) {
            bodyText = [NSString stringWithFormat:@"\n\n%@", bodyText];
        }
        [self setInfoBodyText:[NSString stringWithFormat:@"%@%@", self.infoBody.text, bodyText]];
        self.currentTextGroupItem += 1;
    } else if (self.currentTextGroup + 1 < self.coachingInfoText.count) {
        // The next group of items exists
        self.currentTextGroupItem = 0;
        self.currentTextGroup += 1;
        [self setInfoBodyText:@""];
        [self setInfoHeaderText:@""];
        self.actionButton.enabled = false;
        [UIView animateWithDuration:0.5 animations:^(void){
            self.actionButton.alpha = 0.0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showNextTextItem];        // After small delay to clear screen, return to function with newly updated group
        });
    } else {
        // All groups have been displayed
        [self allInfoHasBeenShown];
    }
}

- (void)setLabelText:(NSString*)text forLabel:(UILabel*)label {
    // Adapted from: http://stackoverflow.com/questions/3073520/animate-text-change-in-uilabel
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    // This will fade:
    label.text = text;
}

- (void)setInfoBodyText:(NSString*)text {
    [self setLabelText:text forLabel:self.infoBody];
}

- (void)setInfoHeaderText:(NSString*)text {
    [self setLabelText:text forLabel:self.infoHeader];
}


- (void)allInfoHasBeenShown {
    self.allInfoShown = true;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.actionButton.alpha = 0.0;
                         [self setInfoHeaderText:@""];
                         [self setInfoBodyText:@""];
                     }
                     completion:^(BOOL finished) {
                         self.actionButton.enabled = false;
                         [self setInfoHeaderText:@"Get Ready..."];
                         [self setInfoBodyText:@"Now we're going to test your knowledge of spirometry with a short quiz.\n\nWhen you are ready, tap the button at the bottom of the screen."];
                         [self.actionButton setTitle:@"I'm Ready" forState:UIControlStateNormal];
                         [self.actionButton setTitle:@"I'm Ready" forState:UIControlStateSelected];
                         [UIView animateWithDuration:1.0 animations:^{
                             self.actionButton.alpha = 1.0;
                             self.actionButton.enabled = true;

                         }];
                     }];
}

- (void)presentQuizVC {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SpiroCoaching" bundle:nil];
    QuizQuestionViewController* quizVC = [storyboard instantiateViewControllerWithIdentifier:@"QuizQuestionScene"];
    [self presentViewController:quizVC animated:YES completion:nil];
}

@end
