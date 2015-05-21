//
//  SettingsViewController.m
//  MyMathGame
//
//  Created by Chris Pan on 5/21/15.
//  Copyright (c) 2015 Chris Pan. All rights reserved.
//

#import "SettingsViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet FBSDKLikeControl *likeControl;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation SettingsViewController

- (IBAction)inviteFriends:(id)sender {
  FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
  content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1092435857439142"];
  [FBSDKAppInviteDialog showWithContent:content delegate:nil];
}

- (IBAction)sharePhoto:(id)sender {
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://thecatapi.com/api/images/get?format=src"]]];
  FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
  FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:NO];
  content.photos = @[photo];
  [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

- (IBAction)getLikes:(id)sender {
  if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_likes"]){
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/likes" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
      NSLog(@"likes :%@", result);
    }];
  } else {
    [[[FBSDKLoginManager alloc] init] logInWithReadPermissions:@[@"user_likes"]
                                                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                         if ([result.grantedPermissions containsObject:@"user_likes"]) {
                                                           [self getLikes:sender];
                                                         } else {
                                                           NSLog(@"not granted, check for error and/or explain to user");
                                                         }
                                                       }];
  }
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.likeControl.objectID = @"fbseattle";
  self.likeControl.objectType = FBSDKLikeObjectTypePage;
  self.likeControl.likeControlStyle = FBSDKLikeControlStyleStandard;;

  self.loginButton.readPermissions = @[@"user_likes"];
}

@end
