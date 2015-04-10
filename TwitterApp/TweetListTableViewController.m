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
#import "SSKeychain.h"

//#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin"
#define BaseURLString @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin"

@interface TweetListTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *tweetTableController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTweetButton;

@end

@implementation TweetListTableViewController

- (void)viewDidLoad {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    if (appDelegate.loginUser==nil) {
        self.addTweetButton.enabled=NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self refreshTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginUser:(NSString *)username WithPassword:(NSString *)password
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"username" : username,
                             @"password" : password,
                             @"action" : @"login"};
    
    [manager POST:@"login.cgi"
       parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"Login success");

              NSString *sessionToken=[responseObject objectForKey:@"session_token"];
              [SSKeychain setPassword:password forService:@"kWazzuTwitterPassword" account:username];
              [SSKeychain setPassword:sessionToken forService:@"kWazzuTwitterToken" account:username];
              appDelegate.loginUser=username;
              self.addTweetButton.enabled=YES;

          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              NSString *errorMessage =@"";
              
              if(error.code==NSURLErrorTimedOut)
              {
                  errorMessage = @"Timed Out";
              }
              else{
                  const int statuscode = (int)response.statusCode;
                  
                  
                  if (statuscode==404) {
                      errorMessage = @"No Such Username";
                  }
                  else if(statuscode==400){
                      errorMessage = @"Bad Request";
                  }
                  else if(statuscode==401)
                  {
                      errorMessage = @"Unauthorized";
                  }
                  else if(statuscode==500){
                      errorMessage = @"Server Error";
                  }
                  
              }
              UIAlertController *failAlertController = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                                           message:errorMessage
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
              [failAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
              [self presentViewController:failAlertController animated:YES completion:nil];
          }];
}

-(void)logoutUser:(NSString *)username
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSDictionary *params = @{@"username" : username,
                             @"password" : [SSKeychain passwordForService:@"kWazzuTwitterPassword" account:username],
                             @"action" : @"logout"};
    
    [manager POST:@"login.cgi"
       parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.tweetTableController.title=@"WSU-V Twitter";
              self.addTweetButton.enabled=NO;
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              NSString *errorMessage =@"";
              
              if(error.code==NSURLErrorTimedOut)
              {
                  errorMessage = @"Timed Out";
              }
              else{
                  const int statuscode = (int)response.statusCode;
                  
                  
                  if (statuscode==404) {
                      errorMessage = @"No Such Username";
                  }
                  else if(statuscode==400){
                      errorMessage = @"Bad Request";
                  }
                  else if(statuscode==401)
                  {
                      errorMessage = @"Unauthorized";
                  }
                  else if(statuscode==500){
                      errorMessage = @"Server Error";
                  }
                  
              }
              UIAlertController *failAlertController = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                                           message:errorMessage
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
              [failAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
              [self presentViewController:failAlertController animated:YES completion:nil];
          }];
}

- (void)registerUser:(NSString *)username WithPassword:(NSString *)password
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    
    NSDictionary *params = @{@"username" : username,
                             @"password" : password,
                             @"action" : @"register"};
    
    [manager POST:@"register.cgi"
       parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"register success");

              NSString *sessionToken=[responseObject objectForKey:@"session_token"];
              [SSKeychain setPassword:password forService:@"kWazzuTwitterPassword" account:username];
              [SSKeychain setPassword:sessionToken forService:@"kWazzuTwitterToken" account:username];
              appDelegate.loginUser=username;
              self.tweetTableController.title=username;
              self.addTweetButton.enabled=YES;

          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              NSString *errorMessage =@"";

              if(error.code==NSURLErrorTimedOut)
              {
                  errorMessage = @"Timed Out";
              }
              else{
                  const int statuscode = (int)response.statusCode;
                  
                  
                  if (statuscode==409) {
                      errorMessage = @"Username Already Exist";
                  }
                  else if(statuscode==400){
                      errorMessage = @"Bad Request";
                  }
                  else if(statuscode==500){
                      errorMessage = @"Server Error";
                  }
                  

              }
              UIAlertController *failAlertController = [UIAlertController alertControllerWithTitle:@"Register Failed"
                                                                                           message:errorMessage
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
              [failAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
              [self presentViewController:failAlertController animated:YES completion:nil];
          }
     
      ];
}

- (IBAction)userOptionPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"User Options"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    //=============================REGISTER===========================
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Register"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          UIAlertController *registerController =
                                                          [UIAlertController alertControllerWithTitle:@"Register"
                                                                                              message:@"Register with UID and password"
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                          
                                                          [registerController
                                                           addAction:[UIAlertAction actionWithTitle:@"Register"
                                                                                              style:UIAlertActionStyleDefault
                                                                                            handler:^(UIAlertAction *action) {
                                                                                                UITextField *usernameTextField = registerController.textFields[0];
                                                                                                UITextField *passwordTextField = registerController.textFields[1];
                                                                                                NSString *username = usernameTextField.text;
                                                                                                NSString *password = passwordTextField.text;
                                                                                                
                                                                                                // XXX Check for empty
                                                                                                
                                                                                                [self registerUser:username
                                                                                                   WithPassword:password];
                                                                                            }]];
                                                          [registerController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                                                              style:UIAlertActionStyleCancel
                                                                                                            handler:nil]];
                                                          [registerController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                              textField.placeholder=@"username";
                                                          }];
                                                          [registerController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                              textField.placeholder=@"password";
                                                              textField.secureTextEntry=YES;
                                                          }];
                                                          
                                                          [self presentViewController:registerController animated:YES completion:nil];
                                                      }]];

    //================================LOGIN=================================
    
    [alertController
        addAction:[UIAlertAction actionWithTitle:@"Login"
                                           style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action){
                                            
                                            UIAlertController *loginController =
                                                [UIAlertController alertControllerWithTitle:@"Login"
                                                                                    message:@"Log In Here"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                            [loginController
                                             addAction:[UIAlertAction actionWithTitle:@"Login"
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction *action) {
                                                                                  UITextField *usernameTextField = loginController.textFields[0];
                                                                                  UITextField *passwordTextField = loginController.textFields[1];
                                                                                  NSString *username = usernameTextField.text;
                                                                                  NSString *password = passwordTextField.text;
                                                                                  
                                                                                  // XXX Check for empty
                                                                                  
                                                                                  [self loginUser:username
                                                                                     WithPassword:password];
                                                                              }]];
                                            [loginController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                                                style:UIAlertActionStyleCancel
                                                                                              handler:nil]];
                                            [loginController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                textField.placeholder=@"username";
                                            }];
                                            [loginController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                textField.placeholder=@"password";
                                                textField.secureTextEntry=YES;
                                            }];
                                            [self presentViewController:loginController animated:YES completion:nil];
                                            
                                                      }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self logoutUser: appDelegate.loginUser];
                                                      }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil ];
}

-(void)refreshTweets {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *lastTweetDate = [appDelegate lastTweetDate];
    NSString *dateStr = [dateFormatter stringFromDate:lastTweetDate];
    NSDictionary *parameters = @{@"date" : dateStr};

    
    [manager GET:@"get-tweets.cgi"
      parameters:parameters
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
         }
     ];
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


@end
