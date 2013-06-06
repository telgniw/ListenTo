//
//  LTCardViewController.h
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import <UIKit/UIKit.h>

@interface LTCardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgCard;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayStound;
@property (strong, nonatomic) IBOutlet UILabel *lblCardName;

@property (strong, nonatomic) NSDictionary *card;
@property (strong, nonatomic) NSNumber *cid;
@property (strong, nonatomic) IBOutlet UIPageControl *paging;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) AVAudioPlayer *myPlayer;

- (IBAction)playSound:(id)sender;
@end
