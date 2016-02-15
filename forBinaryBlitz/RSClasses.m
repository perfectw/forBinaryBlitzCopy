//
//  RSUser.m
//  forBinaryBlitz
//
//  Created by Roman Spirichkin on 15/02/16.
//  Copyright © 2016 rs. All rights reserved.
//

#import "RSClasses.h"


@implementation RSUser
@synthesize name, surname;

- (instancetype) init:(int)aID withName:(NSString *)aName andSurname:(NSString *)aSurname {
    self = [super init];
    if (!self) { return nil;}
    self->ID = aID;
    self.name = aName;
    self.surname = aSurname;
    return self;
}

- (int) userID {
    return self->ID;
}
@end


