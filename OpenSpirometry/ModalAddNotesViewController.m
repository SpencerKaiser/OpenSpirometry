//
//  ModalAddNotesViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/19/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalAddNotesViewController.h"

@interface ModalAddNotesViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDescription;
@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property (nonatomic, assign) int keyboardHeight;
@property (nonatomic, assign) BOOL placeholderTextCleared;
@property (nonatomic, assign) BOOL viewWasShifted;

@end

@implementation ModalAddNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageConfig) {
        [NSException raise:@"No Page Configurations Found" format:@"The pageConfig dictionary must be instantiated prior to presenting this view"];
    }
    
    if (self.pageConfig[@"Type"] ) {
        self.type = self.pageConfig[@"Type"];
    } else {
        self.type = @"Effort";
    }
    
    // Set UI elements according to config data
    self.noteLabel.text = self.pageConfig[@"Label"];
    self.noteDescription.text = self.pageConfig[@"Description"];
    self.noteView.text = self.pageConfig[@"Placeholder"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    self.noteView.delegate = self;
    
    //TODO: Add 'done' toolbar above keyboard
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!self.placeholderTextCleared) {
        self.noteView.text = @"";
        self.placeholderTextCleared = true;
    }
}

// Adopted from Apple's Keyboard Handling suggestions (https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html)
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    self.keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.3f animations:^{
        [self shiftViewUp];
    }];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self shiftViewDown];
    
    if (self.placeholderTextCleared) {
        self.notes = self.noteView.text;
    }
}

-(void)shiftViewUp {
    
    CGRect viewLocation =  self.view.frame;
    viewLocation.origin.y -= self.keyboardHeight;
    
    if (!self.viewWasShifted) {
        [self.view setFrame:viewLocation];
    }

    self.viewWasShifted = true;
}

-(void)shiftViewDown {
    CGRect viewLocation =  self.view.frame;
    viewLocation.origin.y += self.keyboardHeight;
    
    [self.view setFrame:viewLocation];
    
    self.viewWasShifted = false;
}



-(void)dismissKeyboard {
    [self.noteView resignFirstResponder];
}



-(void)dealloc{
    NSLog(@"Did dealloc notes view");
}

@end
