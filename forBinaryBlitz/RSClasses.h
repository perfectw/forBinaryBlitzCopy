//
//  RSUser.h
//  forBinaryBlitz
//
//  Created by Roman Spirichkin on 15/02/16.
//  Copyright © 2016 rs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSUser : NSObject
{
    int ID;
    NSString *name, *surname;
}

@property(nonatomic, retain) NSString *name, *surname;
- (id)init:(int)aID withName:(NSString *)aName andSurname:(NSString *)aSurname;
- (int)userID;

@end
