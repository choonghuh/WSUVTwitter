//
//  TweetListTableViewController.m
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/3/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import "TweetListTableViewController.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "AFNetworking.h"
#import "AddTweetTableViewController.h"

//#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin"
#define BaseURLString @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin"

@interface TweetListTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [self refreshTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userOptionPressed:(id)sender {
}

-(void)refreshTweets {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"date" : @""};
    
    [manager GET:@"get-tweets.cgi"
      parameters:params
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
             
             for (int i = 0; i < arrayOfDicts.count; i++) {
                 Tweet *tweet = [[Tweet alloc] init];
                 
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                 dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
                 tweet.date = [dateFormatter dateFromString:[[arrayOfDicts objectAtIndex:i] objectForKey:@"time_stamp"]];
                 tweet.tweet_id = [[[arrayOfDicts objectAtIndex:i] objectForKey:@"tweet_id"] integerValue];
                 tweet.tweet = [[arrayOfDicts objectAtIndex:i] objectForKey:@"tweet"];
                 tweet.username = [[arrayOfDicts objectAtIndex:i] objectForKey:@"username"];
                 tweet.isdeleted = [[arrayOfDicts objectAtIndex:i] objectForKey:@"isdeleted"];
                 [appDelegate.tweets insertObject:tweet atIndex:0];
             }
             [self.tableView reloadData];
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"failed");
             if (error.code == NSURLErrorTimedOut) {
                 //
                 // Display alert for network timeout.
                 //
             } else {
                 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                 const int statuscode = response.statusCode;
                 //
                 // Display AlertView with appropriate error message.
                 //
             }
             [self.refreshControl endRefreshing];
         }];
}
- (IBAction)refreshControl:(id)sender {
    NSLog(@"Pulled");
    [self refreshTweets];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.tweets count];
    // Return the number of rows in the section.
}


-(NSAttributedString*)tweetAttributedStringFromTweet:(Tweet*)tweet {
    if (tweet.tweetAttributedString == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:tweet.date];
        NSString *title = [NSString stringWithFormat:@"%@ - %@\n",
                           tweet.username, dateString];
        NSDictionary *titleAttributes =
        @{NSFontAttributeName : [UIFont systemFontOfSize:14],
          NSForegroundColorAttributeName: [UIColor blueColor]};
        NSMutableAttributedString *tweetWithAttributes =
        [[NSMutableAttributedString alloc] initWithString:title
                                               attributes:titleAttributes];
        NSMutableParagraphStyle *textStyle =
        [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *bodyAttributes =
        @{NSFontAttributeName : [UIFont systemFontOfSize:17],
          NSForegroundColorAttributeName: [UIColor blackColor],
          NSParagraphStyleAttributeName : textStyle};
        NSAttributedString *bodyWithAttributes =
        [[NSAttributedString alloc] initWithString:tweet.tweet
                                        attributes:bodyAttributes];
        [tweetWithAttributes appendAttributedString:bodyWithAttributes];
        tweet.tweetAttributedString = tweetWithAttributes;
    }
    return tweet.tweetAttributedString;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = appDelegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    CGRect tweetRect =
    [tweetAttributedString
     boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width,1000.0)
     options:NSStringDrawingUsesLineFragmentOrigin
     context:nil];
    return ceilf(tweetRect.size.height) + 1 + 20; // add marginal space
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TwitterCell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = appDelegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    cell.textLabel.numberOfLines = 0; // multi-line label
    cell.textLabel.attributedText = tweetAttributedString;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"addTweetSegue"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        AddTweetTableViewController *addController = segue.destinationViewController;
    }
}

@end
