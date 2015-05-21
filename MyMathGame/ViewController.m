//
//  ViewController.m
//  MyMathGame
//
//  Created by Chris Pan on 5/21/15.
//  Copyright (c) 2015 Chris Pan. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController () {
  NSInteger _currentLevel;
}

@property (nonatomic, assign) NSInteger currentLevel;

@end

@implementation ViewController

- (void)viewDidLoad
{
  _currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
}

- (void)setCurrentLevel:(NSInteger)currentLevel
{
  _currentLevel = currentLevel;
  [[NSUserDefaults standardUserDefaults] setInteger:_currentLevel forKey:@"currentLevel"];
}

- (NSInteger)currentLevel
{
  return _currentLevel;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"levelCell"];
  UILabel *label = (UILabel *)[cell viewWithTag:7];
  label.text = [NSString stringWithFormat:@"Level %d", (int) indexPath.row +1];
  if (indexPath.row < self.currentLevel) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.userInteractionEnabled = YES;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *title = [NSString stringWithFormat:@"Level %d", (int) self.currentLevel+1];
  int r = arc4random_uniform((uint) (10 * self.currentLevel));
  int r2 = arc4random_uniform((uint) (10 * self.currentLevel));
  int answer = r + r2;
  NSString *message = [NSString stringWithFormat:@"What is %d + %d ?", r, r2];
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addTextFieldWithConfigurationHandler:NULL];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    int userAnswer = (int) [((UITextField*)alertController.textFields[0]).text integerValue];
    if (userAnswer == answer) {
      self.currentLevel = self.currentLevel + 1;
      [self.tableView reloadData];
      [FBSDKAppEvents logEvent:FBSDKAppEventNameAchievedLevel parameters:@{
                                                                           FBSDKAppEventParameterNameLevel : @(self.currentLevel)
                                                                           }];
      [FBSDKAppEvents flush];
    }
  }];
  [alertController addAction:action];
  [self presentViewController:alertController animated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.currentLevel + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"Levels";
}

@end
