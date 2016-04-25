//
//  PropSwipRootViewController.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/11/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PropSwipRootViewController.h"

@interface PropSwipRootViewController ()

@end

@implementation PropSwipRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainContainerVCId"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVCId"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
