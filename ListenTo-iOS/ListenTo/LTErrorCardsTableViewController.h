//
//  LTErrorCardsTableViewController.h
//  ListenTo
//
//  Created by Yi Huang on 13/6/14.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTErrorCardsViewDelegate <NSObject>

- (IBAction)reloadCards:(id)sender;

@end

@interface LTErrorCardsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<LTErrorCardsViewDelegate> delegate;
@property (strong, nonatomic) NSArray *errorCards;

@end
