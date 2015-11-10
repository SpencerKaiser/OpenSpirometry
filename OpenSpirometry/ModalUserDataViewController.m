//
//  ModalUserDataViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 11/3/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "ModalUserDataViewController.h"

@interface ModalUserDataViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UITextField *userIDField;
@property (weak, nonatomic) IBOutlet UIPickerView *mouthpiecePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *downstreamTubePicker;

@property (strong, nonatomic) NSArray* mouthpieces;
@property (strong, nonatomic) NSArray* downstreamTubes;
@end

@implementation ModalUserDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mouthpieces = [NSArray arrayWithObjects:
                        @"Mouthpiece A (Blue)",
                        @"Mouthpiece B (Red)",
                        @"Mouthpiece C (Green)",
                        @"Mouthpiece D (Yellow)",
                        @"Mouthpiece E (Black)",
                        nil];
    
    self.downstreamTubes = [NSArray arrayWithObjects:@"Downstream A (Blue)", @"Downstream B (Red)", @"Downstream C (Green)", @"Downstream D (Yellow)", @"Downstream E (Black)", nil];
    
    self.mouthpiecePicker.delegate = self;
    self.mouthpiecePicker.dataSource = self;
    
    self.downstreamTubePicker.delegate = self;
    self.downstreamTubePicker.dataSource = self;
    
    self.actionButton.enabled = false;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.userIDField addTarget:self
                         action:@selector(userIDFieldChanged:)
               forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonPressed:(id)sender {
    if([self.userDataPageDelegate respondsToSelector:@selector(userDataSubmitted:)])
    {
        NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
        userData[@"ID"] = self.userIDField.text;
        
        NSInteger selectedRow = [self.mouthpiecePicker selectedRowInComponent:0];   //Get the selected row of component 0 (only component)
        userData[@"Mouthpiece"] = [self.mouthpieces objectAtIndex:selectedRow];
        
        selectedRow = [self.downstreamTubePicker selectedRowInComponent:0];
        userData[@"Downstream Tube"] = [self.downstreamTubes objectAtIndex:selectedRow];
        
        [self.userDataPageDelegate userDataSubmitted:userData];
    } else {
        [NSException raise:@"Delegate must implement functionality for userDataSubmitted" format:@"This method is required for core functionality."];
    }
}

-(void)dismissKeyboard {
    [self.userIDField resignFirstResponder];
}

-(void)userIDFieldChanged:(UITextField *)userIDField {
    // If length is > 1, enable submit button
    // If length == 3, dismiss keyboard
    if (self.userIDField.text.length >= 1) {
        self.actionButton.enabled = true;
        if (self.userIDField.text.length >= 3) {
            [self dismissKeyboard];
        }
    } else {
        self.actionButton.enabled = false;
    }
}


#pragma mark - Picker Delegate Functions

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.mouthpiecePicker) {
        return self.mouthpieces.count;
    } else {
        return self.downstreamTubes.count;
    }
}

-(NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.mouthpiecePicker) {
        return self.mouthpieces[row];
    } else {
        return self.downstreamTubes[row];
    }
}

@end
