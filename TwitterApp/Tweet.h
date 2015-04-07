//
//  Tweet.h
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/6/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property NSInteger tweet_id;
@property NSString* username;
@property BOOL isdeleted;
@property NSString* tweet;
@property NSDate* date;
@property NSAttributedString* tweetAttributedString;

@end
