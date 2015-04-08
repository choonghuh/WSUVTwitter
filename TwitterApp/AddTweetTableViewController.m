//
//  AddTweetTableViewController.m
//  TwitterApp
//
//  Created by Choong Choong Huh Huh on 4/7/15.
//  Copyright (c) 2015 Choong Huh. All rights reserved.
//

#import "AddTweetTableViewController.h"

@interface AddTweetTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation AddTweetTableViewController
- (IBAction)donePressed:(id)sender {
    
    NSLog(self.tweetTextView.text);
}
- (IBAction)cancelPressed:(id)sender {
    [self.tweetTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tweetTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
