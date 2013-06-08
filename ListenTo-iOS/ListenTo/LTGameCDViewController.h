//
//  GameViewController.h
//  Listen2
//
//  Created by 林 奇賦 on 13/5/24.
//  Copyright (c) 2013年 林 奇賦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLockOverlay.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface LTGameCDViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate>
{
    NSMutableArray *pointArray;
    NSMutableArray *errorPointArray;
    NSMutableArray *levelSettingArray;
    NSArray *cardsArray;
    int anserPoint;
    BOOL anserRight;
    AVAudioPlayer *myPlayer;
}

@property (nonatomic, strong) SPLockOverlay *overLay;

@property (strong, nonatomic) IBOutlet UIScrollView *GameView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) UIImageView *errorImageView;

@property (strong, nonatomic) NSNumber *level;

#pragma mark - IBActions

- (IBAction)back:(id)sender;
- (IBAction)btnSetLocation:(id)sender;
- (IBAction)btnRestart:(id)sender;
- (IBAction)btnPlayAudio:(id)sender;
- (IBAction)btnChooseImageCard:(id)sender;

@end
