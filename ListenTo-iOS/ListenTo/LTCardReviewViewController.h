//
//  LTCardViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import <OBShapedButton/OBShapedButton.h>
#import <UIKit/UIKit.h>
#import "LTErrorCardsTableViewController.h"
#import "LTImageView.h"

@interface LTCardReviewViewController : UIViewController <LTErrorCardsViewDelegate>

@property (strong, nonatomic) LTErrorCardsTableViewController *tableViewController;

@property (strong, nonatomic) IBOutlet OBShapedButton *backButton;
@property (strong, nonatomic) IBOutlet OBShapedButton *playButton;

@property (strong, nonatomic) IBOutlet LTImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSNumber *cid;
@property (strong, nonatomic) NSDate *startDate;

@property (strong, nonatomic) AVAudioPlayer *myPlayer;

# pragma mark - IBActions

- (IBAction)back:(id)sender;
- (IBAction)playSound:(id)sender;
- (IBAction)reloadCards:(id)sender;

@end
