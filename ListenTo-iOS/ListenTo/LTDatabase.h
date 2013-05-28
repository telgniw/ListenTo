//
//  LTDatabase.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "FMDatabase.h"

@interface LTDatabase: NSObject

@property (nonatomic, strong) FMDatabase *database;

+ (LTDatabase *)instance;

@end
