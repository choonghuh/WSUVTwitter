//
//  AddTweetTableViewController.m
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/7/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import "AddTweetTableViewController.h"
#import "AppDelegate.h"
#import "SSKeychain.h"
#import "AFNetworking.h"

//#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin"
#define BaseURLString @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin"

@interface AddTweetTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;

@end

@implementation AddTweetTableViewController
- (IBAction)donePressed:(id)sender {
    
    //XXX make sure logged in
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    NSDictionary *params = @{@"username" : appDelegate.loginUser,
                             @"session_token" : [SSKeychain passwordForService:@"kWazzuTwitterToken"
                                                                       account:appDelegate.loginUser],
                             @"tweet" : self.tweetTextView.text};
    
    [manager POST:@"add-tweet.cgi"
       parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              
              [self.tweetTextView resignFirstResponder];
              [self dismissViewControllerAnimated:YES completion:nil];

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
- (IBAction)cancelPressed:(id)sender {
    [self.tweetTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textViewDidChange:(UITextView *)textView{
    self.wordCount.text = [NSString stringWithFormat:@"%ld/140",self.tweetTextView.text.length];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length - range.length +text.length > 140) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tweetTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
