//
//  LTCardViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import <UIKit/UIKit.h>
#import <OBShapedButton/OBShapedButton.h>
#import "LTImageView.h"

@interface LTCardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *errCardTable;
@property (strong, nonatomic) IBOutlet OBShapedButton *backButton;

@property (strong, nonatomic) IBOutlet LTImageView *imgCard;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayStound;
@property (strong, nonatomic) IBOutlet UILabel *lblCardName;

@property (strong, nonatomic) NSDictionary *card;
@property (strong, nonatomic) NSArray *errorCards;
@property (strong, nonatomic) NSMutableArray *allCards;
@property (strong, nonatomic) NSNumber *cid;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) NSDate *dateAfter;


@property (strong, nonatomic) AVAudioPlayer *myPlayer;

# pragma mark - IBActions

- (IBAction)back:(id)sender;
- (IBAction)reloadCards:(id)sender;
- (IBAction)playSound:(id)sender;

@end
