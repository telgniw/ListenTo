//
//  LTCardManagementController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTDatabaseViewController.h"

@interface LTDatabaseViewController ()

@end

@implementation LTDatabaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create and add a search bar to navigation bar.
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 240.0f, 44.0f)];
    self.searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    [self.navigationItem setRightBarButtonItem:self.searchBarItem];

    [self.searchBar setDelegate:self];
}

@end
