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
    
	// Do any additional setup after loading the view, typically from a nib.
    anserRight = false;
    int cardTag = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level-1.png"]];
    self.GameView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"connect-level-1" ofType:@"plist"];
    pointArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    plistPath = [[NSBundle mainBundle] pathForResource:@"connect-level-1-fuzzy" ofType:@"plist"];
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
    [self.GameView setContentOffset:CGPointMake(0, 1105/2) animated:YES];
    
    self.overLay = [[SPLockOverlay alloc]initWithFrame:imageView.frame];
	[self.overLay setUserInteractionEnabled:NO];
	[self.GameView addSubview:self.overLay];
    
    anserPoint = 1;
    [self playAudio:[db cardForId:cardsArray[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
    [myPlayer setDelegate:self];
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
        if ([sender tag]==4) {
            [self.GameView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        anserPoint++;
        float prev_point_x= [[[pointArray objectAtIndex:[sender tag]-1]objectForKey:@"x"]floatValue];
        float prev_point_y= [[[pointArray objectAtIndex:[sender tag]-1]objectForKey:@"y"]floatValue];
        float curr_point_x= [[[pointArray objectAtIndex:[sender tag]]objectForKey:@"x"]floatValue];
        float curr_point_y= [[[pointArray objectAtIndex:[sender tag]]objectForKey:@"y"]floatValue];
        
        SPLine *aLine = [[SPLine alloc]initWithFromPoint:CGPointMake(prev_point_x+imageCard_width/2, prev_point_y+imageCard_height/2)
                                                 toPoint:CGPointMake(curr_point_x+imageCard_width/2, curr_point_y+imageCard_height/2)
                                         AndIsFullLength:NO];
        //[self.overLay.pointsToDraw removeAllObjects];
        [self.overLay.pointsToDraw addObject:aLine];
        [self.overLay setNeedsDisplay];
        [self playAudio:@"correct" fileType:@"mp3"];
        
        UIButton *childView =sender;
        childView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];//動畫委配
        childView.transform = CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        
    }
    //答錯,將錯誤記錄到資料庫,並秀出錯誤訊息
    else {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_image];
        
        [self playAudio:@"error" fileType:@"mp3"];
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

@end
