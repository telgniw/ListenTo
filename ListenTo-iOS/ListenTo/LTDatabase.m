//
//  LTDatabase.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTDatabase.h"

@implementation LTDatabase

- (id)init
{
    if(self = [super init]) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[path objectAtIndex:0] stringByAppendingPathComponent:@"lt-user.sqlite3"];
    }
    
    return self;
}

@end
