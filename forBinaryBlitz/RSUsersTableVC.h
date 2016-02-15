//
//  ViewController.h
//  forBinaryBlitz
//
//  Created by Roman Spirichkin on 15/02/16.
//  Copyright © 2016 rs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSClasses.h"


@interface RSUsersTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *users;
}
@property(nonatomic,retain)NSMutableArray *users;

- (void) postIdentifierForVendor;


@end

