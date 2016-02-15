//
//  ViewController.m
//  forBinaryBlitz
//
//  Created by Roman Spirichkin on 15/02/16.
//  Copyright © 2016 rs. All rights reserved.
//

#import "RSUsersTableVC.h"
#import <AFNetworking/AFNetworking.h>


NSString *RSURL = @"http://test.binaryblitz.ru";

@interface RSUsersTableVC ()
@property (weak, nonatomic) IBOutlet UITableView *RSUsersTable;
@property (weak, nonatomic) IBOutlet UIButton *RSFetchButton;
@property (weak, nonatomic) IBOutlet UIButton *RSDetailsButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *RSActivity;
@end
@implementation RSUsersTableVC
@synthesize users;


// MARK: viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.RSUsersTable.dataSource = self;
    self.RSUsersTable.delegate = self;
    // set view
    self.RSUsersTable.layer.cornerRadius = 13;
    self.RSUsersTable.layer.borderColor = [UIColor blackColor].CGColor;
    self.RSUsersTable.layer.borderWidth = 1;
    self.RSFetchButton.layer.cornerRadius = 13;
    self.RSFetchButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.RSFetchButton.layer.borderWidth = 1;
    self.RSDetailsButton.layer.cornerRadius = 13;
    self.RSDetailsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.RSDetailsButton.layer.borderWidth = 1;
    self.RSActivity.center = self.view.center;
    [self.RSUsersTable addSubview: self.RSActivity];
    // init post
    [self postIdentifierForVendor];
}


// MARK: post IdentifierForVendor & msg
- (void) postIdentifierForVendor {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSDictionary *parameters = @{@"upload[imei]": [UIDevice currentDevice].identifierForVendor.UUIDString, @"upload[message]": @"hello world"};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/uploads", RSURL] parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"Response: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });
}


// MARK: Fetch Button Action
- (IBAction)touchDownFetchButton:(id)sender {
    [self.RSActivity startAnimating];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // download json
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"%@/users.json", RSURL] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            self.users = [[NSMutableArray alloc] init];
            // parse json to array
            for (NSDictionary * user in responseObject) {
                [self.users addObject: [[RSUser alloc] init:[user[@"id"] intValue] withName:user[@"name"] andSurname:user[@"surname"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //reload data
                [self.RSActivity stopAnimating];
                [self.RSUsersTable reloadData];
            });
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });
}


// MARK: Details Button Action
- (IBAction)touchDownDetailsButton:(id)sender {
    [self.RSActivity startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //download data
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"%@/users/%d.json", RSURL, [users[[self.RSUsersTable indexPathForSelectedRow].row] userID]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            // show details at old UIAlertView
            [self.RSActivity stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", responseObject[@"name"], responseObject[@"surname"]]
                                                            message:[NSString stringWithFormat:@"%@\n%@", responseObject[@"info"], responseObject[@"created_at"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });
}


// MARK: tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return users.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RSCell" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [users[indexPath.row]name], [users[indexPath.row]surname]];
    return cell;
}

@end
