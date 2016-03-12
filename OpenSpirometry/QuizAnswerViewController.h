//
//  QuizAnswerViewController.h
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 3/1/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuizAnswerDelegate <NSObject>
-(void)answerTappedAtIndex:(int)index;
@end

@interface QuizAnswerViewController : UIViewController
@property (strong, nonatomic)NSString* answerText;
@property (assign, nonatomic)int answerIndex;
@property id QuizAnswerDelegate;

- (void)desellectAnswer;
@end
