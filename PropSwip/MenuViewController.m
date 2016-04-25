//
//  MenuViewController.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/11/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "MenuViewController.h"
#import "PSUtils.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIImageView    *profileImageView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.profileImageView.clipsToBounds = YES;
    
    self.tableView.backgroundColor = [[PSUtils getThemeColor] colorWithAlphaComponent:0.5];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60.0f)];
    
//    [self.profileImageView setFrame:CGRectMake(20, 20, 80, 80)];
//    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
//    [self.profileImageView setImage:[UIImage imageNamed:@"dummy_contact"]];
//    
//    [headerView addSubview:self.profileImageView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuItemCell"];
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"RATE"];
            [cell.imageView setImage:[UIImage imageNamed:@"rate"]];
            break;
            
        case 1:
            [cell.textLabel setText:@"SHARE"];
            [cell.imageView setImage:[UIImage imageNamed:@"share"]];
            break;
            
        case 2:
            [cell.textLabel setText:@"CONTACT US"];
            [cell.imageView setImage:[UIImage imageNamed:@"email_dev"]];
            break;
            
        default:
            break;
    }

    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(0, cell.contentView.frame.size.height - 1.0f, cell.contentView.frame.size.width, 1.0f);
    borderLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [cell.contentView.layer addSublayer:borderLayer];
    
    return cell;
}
@end
