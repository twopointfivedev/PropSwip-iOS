//
//  MainViewController.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/6/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "MainViewController.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@interface MainViewController () <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) MDCSwipeToChooseView *swipeView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PropSwip";
    
    UIImage *menuImage = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * menuBtn = [[UIBarButtonItem alloc]initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuBtn;
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    _swipeView = [[MDCSwipeToChooseView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.width)
                                                                     options:options];
    _swipeView.imageView.image = [UIImage imageNamed:@"ps_logo"];
    [_swipeView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_swipeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu
{
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
//    if (direction == MDCSwipeDirectionLeft) {
//        return YES;
//    } else {
//        // Snap the view back and cancel the choice.
//        [UIView animateWithDuration:0.16 animations:^{
//            view.transform = CGAffineTransformIdentity;
//            view.center = [view superview].center;
//        }];
//        return NO;
//    }
    return YES;
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
    
    _swipeView.imageView.image = [UIImage imageNamed:@"dummy_contact"];
    _swipeView.transform = CGAffineTransformIdentity;
    _swipeView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 140);

}

@end
