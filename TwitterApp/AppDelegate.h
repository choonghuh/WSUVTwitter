//
//  AppDelegate.h
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/3/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (NSDate *)lastTweetDate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (copy, nonatomic) NSString *loginUser;
@property (copy, nonatomic) NSString *userPassword;
@property (copy, nonatomic) NSString *session_token;
@property (assign, nonatomic)BOOL loggedIn;

@end

