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


@interface TweetListTableViewController ()

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TweetNotification" object:self queue:nil usingBlock:^(NSNotification *note) {
         [self.tableView reloadData];
     }];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
