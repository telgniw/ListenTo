//
//  LTCardViewController.m
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTCardReviewViewController.h"
#import "LTDatabase.h"

@implementation LTCardReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"review_cards_background.png"]]];
    [self setTableViewController:self.childViewControllers[0]];
    
    [self updateImage];
    [self.tableViewController setErrorCards:[[LTDatabase instance] arrayWithErrorCardsForCard:self.cid afterDate:self.startDate]];
    [self.tableViewController setDelegate:self];
}

# pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playSound:(id)sender
{
    NSString *audioName = [[LTDatabase instance] cardNameForId:self.cid];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"]];
    NSError* error = nil;
    self.myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!url || error) {
        //錯誤處理常式
    }
    [self.myPlayer prepareToPlay]; //This is not always needed, but good to include
    [self.myPlayer play];
}

- (IBAction)reloadCards:(id)sender
{
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    NSNumber *selectedCid = [NSNumber numberWithInteger:[gesture.view tag]];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.tableViewController errorCards]];
    [array addObject:self.cid];
    [array removeObject:selectedCid];
    
    self.cid = selectedCid;
    [self.tableViewController setErrorCards:[NSArray arrayWithArray:array]];
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImage];
        [[self.tableViewController tableView] reloadData];
    });
}

#pragma mark - Utility Methods

- (void)updateImage
{
    NSDictionary *card = [[LTDatabase instance] cardForId:self.cid];
    [self.imageView setImage:[UIImage imageNamed:[card objectForKey:LT_DB_KEY_CARD_IMAGE]]];
    [self.label setText:[card objectForKey:LT_DB_KEY_CARD_NAME]];
}

@end
