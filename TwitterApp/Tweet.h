//
//  Tweet.h
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/6/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (assign, nonatomic) NSInteger tweet_id;
@property (copy, nonatomic) NSString* username;
@property (assign, nonatomic) BOOL isdeleted;
@property (copy, nonatomic) NSString* tweet;
@property (assign, nonatomic) NSDate* date;
@property (copy, nonatomic) NSAttributedString* tweetAttributedString;

@end
