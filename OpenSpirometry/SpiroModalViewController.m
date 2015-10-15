//
//  SpiroModalViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/17/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "SpiroModalViewController.h"

@interface SpiroModalViewController()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSMutableDictionary* modalDismissInfo;

@end


@implementation SpiroModalViewController
-(void)viewDidLoad {
    self.modalDismissInfo = [[NSMutableDictionary alloc] init];
    
    NSInteger modalType = [self.modalData[@"ModalType"] integerValue];
    
    switch (modalType) {
        case SpiroIntroModal:
            self.statusLabel.text = @"SpiroIntroModal";
            break;

        case SpiroEffortResultsModal:
            self.statusLabel.text = @"SpiroEffortResultsModal";
            break;
            
        case SpiroTestResultsModal:
            self.statusLabel.text = @"SpiroTestResultsModal";
            
        default:
            break;
    }
    
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self returnToPresenter];
    }];
}

-(void)returnToPresenter{
    if([self.delegate respondsToSelector:@selector(modalDismissedWithInfo:)])
    {
        [self.modalDismissInfo setObject:@"Returning from modal!" forKey:@"Notes"];
        [self.delegate modalDismissedWithInfo:self.modalDismissInfo];
    }
}


@end
