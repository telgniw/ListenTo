//
//  LTGameViewController.m
//  Listen2
//
//  Created by 林 奇賦 on 13/5/24.
//  Copyright (c) 2013年 林 奇賦. All rights reserved.
//

#import "LTGameViewController.h"
#import "LTDatabase.h"

#define imageCard_width     175
#define imageCard_height    175

@interface LTGameViewController ()
@property (nonatomic, strong) SPLockOverlay *overLay;

@end

@implementation LTGameViewController
@synthesize overLay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a new record when each time the game is started.
    LTDatabase *db = [LTDatabase instance];
    [db newRecordWithType:0];
    NSLog(@"level:%i",_level.intValue);
    
	// Do any additional setup after loading the view, typically from a nib.
    levelSettingArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"level-settings" ofType:@"plist"]];
    NSLog(@"%@",[levelSettingArray objectAtIndex:_level.intValue-1]);
    anserRight = false;
    int cardTag = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"background"]]];
    self.GameView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle]
                           pathForResource:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"connect"] ofType:@"plist"];
    
    pointArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    plistPath = [[NSBundle mainBundle]
                 pathForResource:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"connect-fuzzy"]  ofType:@"plist"];
    errorPointArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    cardsArray = [db arrayWithAllCards];

    //create correct cards list
    for (NSDictionary *point in pointArray) {
        UIButton *ImageCard = [UIButton buttonWithType:UIButtonTypeCustom];
        ImageCard.frame = CGRectMake([[point objectForKey:@"x"] floatValue], [[point objectForKey:@"y"] floatValue], imageCard_width, imageCard_height);
        [ImageCard addTarget:self action:@selector(btnChooseImageCard:) forControlEvents:UIControlEventTouchUpInside];
        ImageCard.tag = cardTag;
        if(ImageCard.tag == 0) {
            [ImageCard setImage:[UIImage imageNamed:@"start.png"]
                       forState:UIControlStateNormal];
        }
        else {
            NSDictionary *card = [db cardForId:cardsArray[ImageCard.tag]];
            [ImageCard setImage:[UIImage imageNamed:card[LT_DB_KEY_CARD_IMAGE]]
                       forState:UIControlStateNormal];
        }
        [self.GameView addSubview:ImageCard];
        cardTag++;
    }
    //create error cards list
    for (NSDictionary *point in errorPointArray) {
        UIButton *ImageCard = [UIButton buttonWithType:UIButtonTypeCustom];
        ImageCard.frame = CGRectMake([[point objectForKey:@"x"] floatValue], [[point objectForKey:@"y"] floatValue], imageCard_width, imageCard_height);
        [ImageCard addTarget:self action:@selector(btnChooseImageCard:) forControlEvents:UIControlEventTouchUpInside];
        ImageCard.tag = cardTag;
        NSDictionary *card = [db cardForId:cardsArray[ImageCard.tag]];
        [ImageCard setImage:[UIImage imageNamed:card[LT_DB_KEY_CARD_IMAGE]]
                   forState:UIControlStateNormal];
        [self.GameView addSubview:ImageCard];
        cardTag++;
    }
    
    [self.GameView insertSubview:imageView atIndex:0];
    //[self.GameView setContentSize:imageView.frame.size];
    [self.GameView setContentSize:imageView.frame.size];
    
    float s_x =[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"scrollview-start"] objectForKey:@"x"] floatValue];
    float s_y =[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"scrollview-start"] objectForKey:@"y"] floatValue];
    [self.GameView setContentOffset:CGPointMake(s_x, s_y) animated:YES];
    
    self.overLay = [[SPLockOverlay alloc]initWithFrame:imageView.frame];
	[self.overLay setUserInteractionEnabled:NO];
	[self.GameView addSubview:self.overLay];
    
    anserPoint = 1;
    //play game start animation
    UIImage *image = [UIImage imageNamed:@"game-start"];
    UIImageView *startView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:startView];
    startView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        startView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished){
        [startView removeFromSuperview];
        [self playAudio:[db cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
        [myPlayer setDelegate:self];
    }];    
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
    NSLog(@"[sender tag]:%d",[sender tag]);
    LTDatabase *db = [LTDatabase instance];
    NSNumber *cid_voice = cardsArray[anserPoint];
    NSNumber *cid_image = cardsArray[[sender tag]];
    NSLog(@"[self.GameView.subviews objectAtIndex:0]:%@",[self.GameView.subviews objectAtIndex:0]);
    
    //答對
    if ([sender tag] == anserPoint) {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_voice];
        
        anserRight = true;
        int tag=[[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:@"tag"] intValue];
        float t_x = [[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:@"x"] floatValue];
        float t_y = [[[[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"transition"] objectAtIndex:0] objectForKey:@"y"] floatValue];
        //level-1:4, level-2:7
        if ([sender tag]==tag) {
            [self.GameView setContentOffset:CGPointMake(t_x, t_y) animated:YES];
        }
        anserPoint++;
        float prev_point_x= [[[pointArray objectAtIndex:[sender tag]-1]objectForKey:@"x"]floatValue];
        float prev_point_y= [[[pointArray objectAtIndex:[sender tag]-1]objectForKey:@"y"]floatValue];
        float curr_point_x= [[[pointArray objectAtIndex:[sender tag]]objectForKey:@"x"]floatValue];
        float curr_point_y= [[[pointArray objectAtIndex:[sender tag]]objectForKey:@"y"]floatValue];
        
        SPLine *aLine = [[SPLine alloc]initWithFromPoint:CGPointMake(prev_point_x+imageCard_width/2, prev_point_y+imageCard_height/2)
                                                 toPoint:CGPointMake(curr_point_x+imageCard_width/2, curr_point_y+imageCard_height/2)
                                         AndIsFullLength:NO];
        [self.overLay.pointsToDraw addObject:aLine];
        [self.overLay setNeedsDisplay];
        [self playAudio:@"correct" fileType:@"mp3"];
        
        UIButton *childView =sender;
        childView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            childView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished){
        }];
        
        //過關
        if(anserPoint == pointArray.count) {
            UIImage *passimage = [UIImage imageNamed:[[levelSettingArray objectAtIndex:_level.intValue-1] objectForKey:@"pass-image"]];
            UIImageView *passView = [[UIImageView alloc] initWithImage:passimage];
            passView.frame = CGRectMake(0, 0, 1024, 768);
            [self.view addSubview:passView];
            
            passView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                passView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished){
                
                UIImage *image = [UIImage imageNamed:@"end-3"];
                UIImageView *passView = [[UIImageView alloc] initWithImage:image];
                passView.frame = CGRectMake(0, 0, 1024, 768);
                [self.view addSubview:passView];
                
                passView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                [UIView animateWithDuration:0.4 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    passView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished){
                    //disabled all cards buttom
                    UIScrollView *tempView = [self.view.subviews objectAtIndex:0];
                    for (UIButton *cards in tempView.subviews) {
                        [cards setEnabled:NO];
                    }
                }];

            }];
        }
        
    }
    //答錯,將錯誤記錄到資料庫,並秀出錯誤訊息
    else {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_image];
        
        [self playAudio:@"error" fileType:@"mp3"];
        
        //play animation
        UIImage *image = [UIImage imageNamed:@"error"];
        UIImageView *errorView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:errorView];
        errorView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            errorView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished){
            [errorView removeFromSuperview];
        }];

    }
}

//This is the delegate method called after the sound finished playing, there are also other methods be sure to implement them for avoiding possible errors
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(anserRight) {
        if(anserPoint == pointArray.count)
            return;
        [self playAudio:[[LTDatabase instance] cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
        anserRight = false;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

@end
