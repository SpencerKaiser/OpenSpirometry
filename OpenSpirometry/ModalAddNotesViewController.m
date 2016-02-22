//
//  ModalAddNotesViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 10/19/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalAddNotesViewController.h"
#define toolbarHeight 50
#define toolbarOffset -40

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
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, toolbarHeight)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)],
                           nil];
    [numberToolbar sizeToFit];
    self.noteView.inputAccessoryView = numberToolbar;
    
}


// NOTE: This may introduce a race condition if the height of the keyboard isn't set by [self keyboardWasShown]
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self shiftViewUp];
    if (!self.placeholderTextCleared) {
        self.noteView.text = @"";
        self.placeholderTextCleared = true;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self shiftViewDown];
    if (self.placeholderTextCleared) {
        self.notes = self.noteView.text;
    }
}

// Adopted from Apple's Keyboard Handling suggestions (https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html)
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    self.keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
}

-(void)shiftViewUp {
    CGRect viewLocation =  self.view.frame;
    //    viewLocation.origin.y -= (self.keyboardHeight + toolbarHeight);
    viewLocation.origin.y -= self.keyboardHeight + toolbarOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:viewLocation];
    }];
    
    self.viewWasShifted = true;
}

-(void)shiftViewDown {
    CGRect viewLocation =  self.view.frame;
    //    viewLocation.origin.y += (self.keyboardHeight + toolbarHeight);
    viewLocation.origin.y += self.keyboardHeight + toolbarOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:viewLocation];
    }];
    
    self.viewWasShifted = false;
}



-(void)dismissKeyboard {
    [self.noteView resignFirstResponder];
}



-(void)dealloc{
    NSLog(@"Did dealloc notes view");
}

@end
