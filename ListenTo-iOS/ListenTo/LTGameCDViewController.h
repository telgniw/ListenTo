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
    int anserPoint;
    BOOL shouldContinuePlayingCard;
    
    int errorCount;
    
    CGRect screenBounds;
}

@property (nonatomic, strong) SPLockOverlay *overLay;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSArray *cardIds;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSArray *errorPoints;
@property (nonatomic, strong) NSArray *settings;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) UIImageView *errorImageView;
@property (strong, nonatomic) UIView *disableViewOverlay;

@property (strong, nonatomic) NSNumber *level;

#pragma mark - IBActions

- (IBAction)back:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)replayGame:(id)sender;
- (IBAction)selectImageButton:(id)sender;

@end
