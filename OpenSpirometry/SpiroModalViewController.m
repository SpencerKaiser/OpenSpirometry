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
    [super viewDidLoad];
    
    // Grab reference to main storyboard
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Instantiate page VC as a scrolling with horizontal orientation
    self.modalPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                          options:nil];
    
    
    self.modalPageViewController.dataSource = self;
    
    
    [self.modalPageViewController setViewControllers:[NSArray arrayWithObject:[storyboard instantiateViewControllerWithIdentifier:@"SpiroModalChildViewControllerScene1"]]
                                           direction:UIPageViewControllerNavigationDirectionForward
                                            animated:YES
                                          completion:nil];
    
    
    
    [self addChildViewController:self.modalPageViewController];
    [self.view addSubview:self.modalPageViewController.view];
    [self.modalPageViewController didMoveToParentViewController:self];
    
    
    
    
    
    
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
    if([self.modalDelegate respondsToSelector:@selector(modalDismissedWithInfo:)])
    {
        [self.modalDismissInfo setObject:@"Returning from modal!" forKey:@"Notes"];
        [self.modalDelegate modalDismissedWithInfo:self.modalDismissInfo];
    }
}


#pragma mark - DATA SOURCE DELEGATION

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 2;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:@"SpiroModalChildViewControllerScene1"];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:@"SpiroModalChildViewControllerScene2"];
}


//TODO: Delegate functions for modal pages that save data (e.g., notes)



@end
