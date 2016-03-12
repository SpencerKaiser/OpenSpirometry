//
//  QuizQuestionViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/1/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizAnswerViewController.h"

@interface QuizQuestionViewController : UIViewController <QuizAnswerDelegate>
@property (strong, nonatomic) NSMutableArray* quizQuestions;
@property (assign, nonatomic) int questionNumber;
@end
