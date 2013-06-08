//
//  LTGameViewController.m
//  Listen2
//
//  Created by 林 奇賦 on 13/5/24.
//  Copyright (c) 2013年 林 奇賦. All rights reserved.
//

#import <OBShapedButton/OBShapedButton.h>
#import <QuartzCore/QuartzCore.h>
#import "LTGameCDViewController.h"
#import "LTDatabase.h"
#import "LTUtility.h"

static NSString *const X = @"x";
static NSString *const Y = @"y";
static const int IMAGE_BUTTON_SIZE = 175;

@implementation LTGameCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a new record when each time the game is started.
    LTDatabase *db = [LTDatabase instance];
    [db newRecordWithType:0];
    
	// Do any additional setup after loading the view, typically from a nib.
    levelSettingArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"level-settings" ofType:@"plist"]];
    anserRight = false;
    int cardTag = 0;
    
    [self.GameView setDelegate:self];
    
    NSString *plistPath = [[NSBundle mainBundle]
                           pathForResource:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"connect"] ofType:@"plist"];
    
    pointArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    plistPath = [[NSBundle mainBundle]
                 pathForResource:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"connect-fuzzy"]  ofType:@"plist"];
    errorPointArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    cardsArray = [db arrayWithAllCards];

    //create correct cards list
    for (NSDictionary *position in pointArray) {
        CGPoint point = CGPointMake([[position objectForKey:X] floatValue], [[position objectForKey:Y] floatValue]);
        OBShapedButton *imageButton = [self imageButtonWithIndex:cardTag position:point];
        
        if(cardTag == 0) {
            [imageButton setImage:[UIImage imageNamed:@"connectdots-startpoint.png"] forState:UIControlStateNormal];
        }
        else {
            [self addBorderToButton:imageButton];
        }
        
        [self.GameView addSubview:imageButton];
        cardTag++;
    }
    //create error cards list
    for (NSDictionary *position in errorPointArray) {
        CGPoint point = CGPointMake([[position objectForKey:X] floatValue], [[position objectForKey:Y] floatValue]);
        OBShapedButton *imageButton = [self imageButtonWithIndex:cardTag position:point];
        [self addBorderToButton:imageButton];
        
        [self.GameView addSubview:imageButton];
        cardTag++;
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"background"]];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:backgroundImage]];
    
    self.overLay = [[SPLockOverlay alloc]initWithFrame:CGRectMake(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)];
	[self.overLay setUserInteractionEnabled:NO];
	[self.GameView addSubview:self.overLay];
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.playButton];
    
    float s_x =[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"scrollview-start"] objectForKey:X] floatValue];
    float s_y =[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"scrollview-start"] objectForKey:Y] floatValue];
    [self.GameView setContentSize:backgroundImage.size];
    [self.GameView setContentOffset:CGPointMake(s_x, s_y) animated:YES];
    
    [self setErrorImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-error.png"]]];
    
    [myPlayer setDelegate:self];
    anserPoint = 1;
    
    //play game start animation
    UIImageView *startView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-start.png"]];
    [self animatedPopOutImageView:startView completion:^(BOOL finished) {
        [self playAudio:[db cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
    }];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSetLocation:(id)sender
{
    [self.GameView setContentOffset:CGPointMake(320, 2360) animated:YES];

}

- (IBAction)btnRestart:(id)sender
{
    anserPoint = 1;
    [self.overLay.pointsToDraw removeAllObjects];
    [self.overLay setNeedsDisplay];
    [self.GameView setContentOffset:CGPointMake(0, 1105/2) animated:YES];
}

- (void)playAudio:(NSString *)filleName fileType:(NSString *)type
{
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:filleName ofType:type]];
    NSError* error = nil;
    myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!url || error) {
        //錯誤處理常式
    }
    [myPlayer setDelegate:self];
    [myPlayer prepareToPlay]; //This is not always needed, but good to include
    [myPlayer play];
}

- (IBAction)btnPlayAudio:(id)sender
{
    if(anserPoint == pointArray.count)
        return;
    [self playAudio:[[LTDatabase instance] cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
}


- (IBAction)btnChooseImageCard:(id)sender
{
    if ([sender tag]==0) {
        return;
    }
    LTDatabase *db = [LTDatabase instance];
    NSNumber *cid_voice = cardsArray[anserPoint];
    NSNumber *cid_image = cardsArray[[sender tag]];
    
    //答對
    if ([sender tag] == anserPoint) {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_voice];
        
        anserRight = true;
        int tag=[[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:@"tag"] intValue];
        float t_x = [[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:X] floatValue];
        float t_y = [[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:Y] floatValue];
        //level-1:4, level-2:7
        if ([sender tag]==tag) {
            [self.GameView setContentOffset:CGPointMake(t_x, t_y) animated:YES];
        }
        anserPoint++;
        NSDictionary *previousP = [pointArray objectAtIndex:[sender tag]-1];
        CGPoint previousPoint = CGPointMake([[previousP objectForKey:X] floatValue], [[previousP objectForKey:Y] floatValue]);
        NSDictionary *currentP = [pointArray objectAtIndex:[sender tag]];
        CGPoint currentPoint = CGPointMake([[currentP objectForKey:X] floatValue], [[currentP objectForKey:Y] floatValue]);
        
        [self drawLineFromPoint:previousPoint toPoint:currentPoint];
        [self playAudio:@"correct" fileType:@"mp3"];
        
        UIButton *childView =sender;
        childView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            childView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished){
        }];
        
        //過關
        if(anserPoint == pointArray.count) {
            NSDictionary *startP = [pointArray objectAtIndex:0];
            CGPoint startPoint = CGPointMake([[startP objectForKey:X] floatValue], [[startP objectForKey:Y] floatValue]);
            
            [self drawLineFromPoint:currentPoint toPoint:startPoint];
            
            self.overLay.transform = CGAffineTransformMakeScale(1.0, 1.0);
            UIImage *passimage = [UIImage imageNamed:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"pass-image"]];
            UIImageView *passView = [[UIImageView alloc] initWithImage:passimage];
            passView.frame = CGRectMake(0, 0, 1024, 768);
            passView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            [self.view addSubview:passView];
            [passView addSubview:self.overLay];

            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.overLay.transform = CGAffineTransformMakeScale(0.5, 0.5);
                passView.transform = CGAffineTransformMakeScale(1, 1);
                self.overLay.frame = CGRectMake(270,100, self.overLay.frame.size.width, self.overLay.frame.size.height);
            
            } completion:^(BOOL finished){
                [NSThread sleepForTimeInterval:2.0];
                [self.overLay removeFromSuperview];
                
                passView.alpha = 0.9;
                passView.backgroundColor = [UIColor blackColor];
                UIImage *image = [UIImage imageNamed:@"end-3"];
                UIImageView *passView = [[UIImageView alloc] initWithImage:image];
                passView.frame = CGRectMake(0, 0, 1024, 768);
                [self.view addSubview:passView];
                
                //disabled all cards buttom
                UIScrollView *tempView = [self.view.subviews objectAtIndex:0];
                for (UIButton *cards in tempView.subviews) {
                    [cards setEnabled:NO];
                }
                
            }];

        }
        
    }
    //答錯,將錯誤記錄到資料庫,並秀出錯誤訊息
    else {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_image];
        
        [self playAudio:@"error" fileType:@"mp3"];
        
        //play animation
        [self animatedPopOutImageView:self.errorImageView completion:nil];

    }
}

#pragma mark - Utility Methods

- (void)animatedPopOutImageView:(UIImageView *)imageView completion:(void (^)(BOOL finished))completion
{
    [self.view addSubview:imageView];
    [imageView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [imageView setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    } completion:^(BOOL finished){
        [NSThread sleepForTimeInterval:0.7];
        [imageView removeFromSuperview];
        
        if(completion != nil) {
            completion(finished);
        }
    }];
}

- (void)drawLineFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
    SPLine *aLine = [[SPLine alloc]initWithFromPoint:CGPointMake(p1.x + IMAGE_BUTTON_SIZE * 0.5, p1.y + IMAGE_BUTTON_SIZE * 0.5)
                                             toPoint:CGPointMake(p2.x + IMAGE_BUTTON_SIZE * 0.5, p2.y + IMAGE_BUTTON_SIZE * 0.5)
                                     AndIsFullLength:NO];
    [self.overLay.pointsToDraw addObject:aLine];
    [self.overLay setNeedsDisplay];
}

- (OBShapedButton *)imageButtonWithIndex:(int)idx position:(CGPoint)point
{
    NSDictionary *card = [[LTDatabase instance] cardForId:cardsArray[idx]];
    
    OBShapedButton *imageButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:CGRectMake(point.x, point.y, IMAGE_BUTTON_SIZE, IMAGE_BUTTON_SIZE)];
    [imageButton addTarget:self action:@selector(btnChooseImageCard:) forControlEvents:UIControlEventTouchUpInside];
    [imageButton setTag:idx];
    [imageButton setImage:[UIImage imageNamed:card[LT_DB_KEY_CARD_IMAGE]] forState:UIControlStateNormal];
    
    return imageButton;
}

- (void)addBorderToButton:(UIButton *)button
{
    [button.layer setBorderColor:[[LTUtility cardBorderColor] CGColor]];
    [button.layer setCornerRadius:IMAGE_BUTTON_SIZE * 0.5];
    [button.layer setBorderWidth:CARD_BORDER_WIDTH];
    [button.layer setMasksToBounds:YES];
}

#pragma mark - Audio Player Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(anserRight) {
        if(anserPoint == pointArray.count)
            return;
        [self playAudio:[[LTDatabase instance] cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
        anserRight = false;
    }
}
@end
