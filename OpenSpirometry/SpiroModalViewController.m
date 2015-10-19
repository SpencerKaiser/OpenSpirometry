//
//  SpiroModalViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 9/17/15.
//  Copyright © 2015 Eric Larson. All rights reserved.
//

#import "SpiroModalViewController.h"
#import "ModalActionPageViewController.h"

@interface SpiroModalViewController()
@property (strong, nonatomic) NSMutableDictionary* modalDismissInfo;
@property (strong, nonatomic) UIStoryboard* modalPagesStoryboard;
@property (strong, nonatomic) NSMutableArray* pageViewControllers;

@end


@implementation SpiroModalViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Prevent modal creation without data
    if (!self.modalData) {
        [NSException raise:@"Data was not passed to Modal" format:@"SpiroModalViewController.modalData was null."];
    }
    
    // Instantiate page VC as a scrolling with horizontal orientation
    self.modalPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                          options:nil];
    self.modalPageViewController.dataSource = self;
    
    
    // Create the array of modal pages (including action page)
    [self createPageSet];
    
    
    // Set initial view controller
    // Initial view controller is the first VC in the pageViewControllers array
    // The rest of the array contains the additional pages, in their appropriate order
    [self.modalPageViewController setViewControllers:[NSArray arrayWithObject:self.pageViewControllers[0]]
                                           direction:UIPageViewControllerNavigationDirectionForward
                                            animated:YES
                                          completion:nil];
    
    [self addChildViewController:self.modalPageViewController];
    [self.view addSubview:self.modalPageViewController.view];
    [self.modalPageViewController didMoveToParentViewController:self];
}

-(void) createPageSet {
    
    // Instantiate array to contain page view controllers
    self.pageViewControllers = [[NSMutableArray alloc] init];
    
    // Grab reference to the storyboard containing modal pages
    self.modalPagesStoryboard = [UIStoryboard storyboardWithName:@"SpiroModalPages" bundle:nil];
    
    // Instantiate the actionViewController, which is the first item in the array
    ModalActionPageViewController* actionViewController = [self.modalPagesStoryboard instantiateViewControllerWithIdentifier:@"ModalActionPageViewControllerScene"];
    actionViewController.actionPageDelegate = self;
    
    // Instantiate dictionary to hold actionViewController parameters
    NSMutableDictionary* configParams = [[NSMutableDictionary alloc] init];
    
    NSInteger modalType = [self.modalData[@"ModalType"] integerValue];
    
    switch (modalType) {
        case SpiroIntroModal:
//            self.statusLabel.text = @"SpiroIntroModal";
            break;
            
        case SpiroEffortResultsModal:
            configParams[@"Label"] = @"Effort Complete";
            configParams[@"Description"] = @"You completed 1 effort. You still need at least 2 more to complete the test, however, it may take up to 4 additional efforts. When you're ready, hit the continue button below.";
            configParams[@"Button"] = @"Continue to Next Effort";
            break;
            
        case SpiroTestResultsModal:
//            self.actionLabel.text = @"SpiroTestResultsModal";
            
        default:
            break;
    }
    
    // Set params for actionViewController and insert into index 0
    actionViewController.pageConfig = configParams;
    [self.pageViewControllers insertObject:actionViewController atIndex:0];
    
    
    [self.pageViewControllers addObject:[self.modalPagesStoryboard instantiateViewControllerWithIdentifier:@"ModalNotePageViewControllerScene"]];
}

-(void)userActionTaken {
    [self dismissViewControllerAnimated:YES completion:^{
        [self returnToPresenter];
    }];
}


-(void)returnToPresenter{
    if([self.modalDelegate respondsToSelector:@selector(modalDismissedWithInfo:)])
    {
        // Check all data objects of the currentPages object and grab any relevant data
        // Use object watches?
        
        
        // Create modal dismiss info object
        self.modalDismissInfo = [[NSMutableDictionary alloc] init];
        
        
        [self.modalDismissInfo setObject:@"Returning from modal!" forKey:@"Notes"];
        [self.modalDelegate modalDismissedWithInfo:self.modalDismissInfo];
    }
}


#pragma mark - DATA SOURCE DELEGATION

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.pageViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger idx = [self.pageViewControllers indexOfObject:viewController];
    if (self.pageViewControllers.count == 1) {
        return nil;
    } else if (idx == 0) {
        idx = self.pageViewControllers.count - 1;
        return self.pageViewControllers[idx];
    } else {
        idx -= 1;
        return self.pageViewControllers[idx];
    }
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger idx = [self.pageViewControllers indexOfObject:viewController];
    if (self.pageViewControllers.count == 1) {
        return nil;
    } else if (idx == self.pageViewControllers.count - 1) {
        idx = 0;
        return self.pageViewControllers[idx];
    } else {
        idx += 1;
        return self.pageViewControllers[idx];
    }
}


//TODO: Delegate functions for modal pages that save data (e.g., notes)



@end
