//
//  LTDatabase.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTDatabase.h"

@implementation LTDatabase

+ (LTDatabase *)instance
{
    static LTDatabase *myInstance;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        myInstance = [[LTDatabase alloc] init];
    });
    
    return myInstance;
}

- (id)init
{
    if(self = [super init]) {
        NSFileManager *fileManager;
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[path objectAtIndex:0] stringByAppendingPathComponent:@"lt-user.sqlite3"];
        
        BOOL success = [fileManager fileExistsAtPath:dbPath];
        if(!success) {
            NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"sqlite3"];
            success = [fileManager copyItemAtPath:defaultPath toPath:dbPath error:nil];
            if(!success) {
                // Initialization failed.
                return nil;
            }
        }
    }
    
    return self;
}

@end
