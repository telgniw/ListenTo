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
#import "LTGameEndView.h"
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
    self.settings = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"connect-level-settings" ofType:@"plist"]];
    
    UIImage *backgroundImage = [UIImage imageNamed:[[self.settings objectAtIndex:_level.intValue-1] objectForKey:@"background"]];
    [self.scrollView setBackgroundColor:[[UIColor alloc] initWithPatternImage:backgroundImage]];
    
    [self.scrollView setContentSize:backgroundImage.size];
    [self.scrollView setDelegate:self];
    
    NSString *plistPath = [[NSBundle mainBundle]
                           pathForResource:[[self.settings objectAtIndex:_level.intValue-1] objectForKey:@"connect"] ofType:@"plist"];
    
    NSMutableArray *pointsArray;
    
    self.points = [NSArray arrayWithContentsOfFile:plistPath];
    plistPath = [[NSBundle mainBundle]
                 pathForResource:[[self.settings objectAtIndex:_level.intValue-1] objectForKey:@"connect-fuzzy"]  ofType:@"plist"];
    self.errorPoints = [NSArray arrayWithContentsOfFile:plistPath];
    self.cardIds = [db arrayWithAllCards];

    // Select random start point.
    int start = arc4random() % [self.points count];
    if(start > 0) {
        pointsArray = [NSMutableArray arrayWithArray:[self.points subarrayWithRange:NSMakeRange(start, [self.points count] - start)]];
        [pointsArray addObjectsFromArray:[self.points subarrayWithRange:NSMakeRange(0, start)]];
        
        self.points = [NSArray arrayWithArray:pointsArray];
    }
    
    if(arc4random() % 2 == 1) {
        // Reverse the whole array.
        self.points = [[self.points reverseObjectEnumerator] allObjects];
    }
    
    pointsArray = [NSMutableArray arrayWithCapacity:[self.points count] + [self.errorPoints count]];
    [pointsArray addObjectsFromArray:self.points];
    [pointsArray addObjectsFromArray:self.errorPoints];
    
    minY = 0, maxY = [backgroundImage size].height;
    
    // Create card buttons.
    int cardTag = 0;
    for(NSDictionary *p in pointsArray) {
        CGPoint point = CGPointMake([[p objectForKey:X] floatValue], [[p objectForKey:Y] floatValue]);
        OBShapedButton *imageButton = [self imageButtonWithIndex:cardTag position:point];
        
        // Update y bounds.
        if(point.y < minY)
            minY = point.y;
        if(point.y > maxY)
            maxY = point.y;
        
        // Handle the start image.
        if(cardTag > 0) {
            [self addBorderToButton:imageButton];
        }
        else {
            UIImage *startImage = [UIImage imageNamed:@"connectdots-startpoint.png"];
            [imageButton setImage:startImage forState:UIControlStateNormal];
            [imageButton setAdjustsImageWhenHighlighted:NO];
        }
        
        [self.scrollView addSubview:imageButton];
        cardTag++;
    }
    
    self.overLay = [[SPLockOverlay alloc]initWithFrame:CGRectMake(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)];
	[self.overLay setUserInteractionEnabled:NO];
	[self.scrollView addSubview:self.overLay];
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.playButton];
    
    anserPoint = 1;
    [self adjustScrollPosition];
    
    [self setErrorImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-error.png"]]];
    
    [self.player setDelegate:self];
    shouldContinuePlayingCard = NO;
    errorCount = 0;
    [self toggleTouchable:NO];
    
    // Switch the width/height for landscape orientation.
    screenBounds = [[UIScreen mainScreen] bounds];
    screenBounds.size = CGSizeMake(screenBounds.size.height, screenBounds.size.width);
    
    [self setDisableViewOverlay:[[UIView alloc] initWithFrame:screenBounds]];
    [self.disableViewOverlay setBackgroundColor:[UIColor blackColor]];
    
    // Play game start animation
    UIImageView *startView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-start.png"]];
    [self animatedPopOutImageView:startView completion:^(BOOL finished) {
        [self playAudio:[db cardForId:self.cardIds[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3" withDelay:YES];
    }];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playAudio:(id)sender
{
    if(anserPoint == self.points.count)
        return;
    
    [self playAudio:[[LTDatabase instance] cardForId:self.cardIds[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3"];
}

- (IBAction)replayGame:(id)sender
{
    // TODO: restart game.
}

- (IBAction)selectImageButton:(id)sender
{
    if ([sender tag]==0) {
        return;
    }
    
    [self toggleTouchable:NO];
    
    LTDatabase *db = [LTDatabase instance];
    NSNumber *cid_voice = self.cardIds[anserPoint];
    NSNumber *cid_image = self.cardIds[[sender tag]];
    
    //答對
    if([sender tag] == anserPoint) {
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_voice];
        
        anserPoint++;
        [self adjustScrollPosition];
        
        NSDictionary *previousP = [self.points objectAtIndex:[sender tag]-1];
        CGPoint previousPoint = CGPointMake([[previousP objectForKey:X] floatValue], [[previousP objectForKey:Y] floatValue]);
        NSDictionary *currentP = [self.points objectAtIndex:[sender tag]];
        CGPoint currentPoint = CGPointMake([[currentP objectForKey:X] floatValue], [[currentP objectForKey:Y] floatValue]);
        
        [self drawLineFromPoint:previousPoint toPoint:currentPoint];
        [self playAudio:@"correct" fileType:@"mp3" shouldContinuePlayingCard:YES];
        
        UIButton *childView =sender;
        childView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            childView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
        
        //過關
        if(anserPoint == [self.points count]) {
            [self toggleTouchable:YES];
            
            [self playAudio:@"level-complete" fileType:@"mp3"];
            
            NSDictionary *startP = [self.points objectAtIndex:0];
            CGPoint startPoint = CGPointMake([[startP objectForKey:X] floatValue], [[startP objectForKey:Y] floatValue]);
            
            [self drawLineFromPoint:currentPoint toPoint:startPoint];
            
            self.overLay.transform = CGAffineTransformMakeScale(1.0, 1.0);
            UIImage *passimage = [UIImage imageNamed:[[self.settings objectAtIndex:_level.intValue-1] objectForKey:@"pass-image"]];
            UIImageView *passView = [[UIImageView alloc] initWithImage:passimage];
            [passView setFrame:screenBounds];
            [passView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
            [self.view addSubview:passView];
            [passView addSubview:self.overLay];

            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.overLay.transform = CGAffineTransformMakeScale(0.5, 0.5);
                passView.transform = CGAffineTransformMakeScale(1, 1);
                self.overLay.frame = CGRectMake(270,100, self.overLay.frame.size.width, self.overLay.frame.size.height);
            } completion:^(BOOL finished){
                [NSThread sleepForTimeInterval:2.0];
                [self.overLay removeFromSuperview];
                
                // Disabled all card buttons.
                UIScrollView *tempView = [self.view.subviews objectAtIndex:0];
                for (UIButton *cards in tempView.subviews) {
                    [cards setEnabled:NO];
                }
                
                [passView setAlpha:0.9f];
                [passView setBackgroundColor:[UIColor blackColor]];
                
                LTGameEndView *passView = [[LTGameEndView alloc] initWithFrame:screenBounds];
                [passView setAlpha:0.0f];
                [self.view addSubview:passView];
                
                [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
                    [passView setAlpha:1.0f];
                } completion:^(BOOL finished) {
                    int carrots = 0;
                    if(errorCount < [self.points count]) {
                        carrots++;
                        if(errorCount < [self.points count] * 0.2) {
                            carrots++;
                            if(errorCount == 0) {
                                carrots++;
                            }
                        }
                    }
                    [passView showCarrots:carrots];
                    
                    // Change the "play sound" button to "replay button".
                    [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon-restart.png"] forState:UIControlStateNormal];
                    [self.playButton setBackgroundImage:[UIImage imageNamed:@"icon-restart-selected.png"] forState:UIControlStateHighlighted];
                    [self.playButton removeTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                    [self.playButton addTarget:self action:@selector(replayGame:) forControlEvents:UIControlEventTouchUpInside];
                    
                    // Brings the buttons up.
                    [self.view bringSubviewToFront:self.backButton];
                    [self.view bringSubviewToFront:self.playButton];
                }];
            }];

        }
        
    }
    //答錯,將錯誤記錄到資料庫,並秀出錯誤訊息
    else {
        errorCount++;
        
        // Insert a row into database.
        [db insertRowWithVoiceCard:cid_voice andImageCard:cid_image];
        
        [self playAudio:@"error" fileType:@"mp3"];
        
        //play animation
        [self animatedPopOutImageView:self.errorImageView completion:^(BOOL finished) {
            [self replayCurrentCard];
        }];

    }
}

#pragma mark - Utility Methods

- (void)animatedPopOutImageView:(UIImageView *)imageView completion:(void (^)(BOOL finished))completion
{
    //add dark overlay
    [self.disableViewOverlay setAlpha:0.0f];
    [self.view addSubview:self.disableViewOverlay];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    [self.disableViewOverlay setAlpha:0.6f];
    [UIView commitAnimations];
    
    // image animation
    [imageView setAlpha:1.0f];
    [imageView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
    [self.view addSubview:imageView];
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [imageView setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    } completion:^(BOOL finished){
        [NSThread sleepForTimeInterval:0.7f];
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            [imageView setAlpha:0.0f];
            [self.disableViewOverlay setAlpha:0.0f];
        } completion:^(BOOL finished) {
            // remove overlay and image
            [imageView removeFromSuperview];
            [self.disableViewOverlay removeFromSuperview];
            
            if(completion != nil) {
                completion(finished);
            }
        }];
    }];
}

- (void)adjustScrollPosition
{
    CGRect bounds = self.scrollView.bounds;
    
    // For landscape orientation.
    bounds.size = screenBounds.size;
    
    if(anserPoint >= [self.points count]) {
        // Game end.
        return;
    }
    
    NSDictionary *p = [self.points objectAtIndex:anserPoint];
    CGPoint point = CGPointMake([[p objectForKey:X] floatValue], [[p objectForKey:Y] floatValue]);
    
    if(CGRectContainsPoint(bounds, point)) {
        if(CGRectContainsPoint(bounds, CGPointMake(point.x + IMAGE_BUTTON_SIZE, point.y + IMAGE_BUTTON_SIZE))) {
            // No need to adjust.
            return;
        }
    }
    
    CGPoint newPoint = CGPointMake(0.0f, 0.0f);
    if(bounds.origin.y > point.y) {
        // Move up.
        newPoint.y = MAX(minY, point.y + 1.5 * IMAGE_BUTTON_SIZE - bounds.size.height);
    }
    else {
        // Move down.
        newPoint.y = MIN(maxY - bounds.size.height, point.y - 0.5 * IMAGE_BUTTON_SIZE);
    }
    
    [self.scrollView setContentOffset:newPoint animated:YES];
}

- (void)playAudio:(NSString *)filleName fileType:(NSString *)type
{
    return [self playAudio:filleName fileType:type withDelay:NO];
}

- (void)playAudio:(NSString *)filleName fileType:(NSString *)type shouldContinuePlayingCard:(BOOL)shouldContinue
{
    shouldContinuePlayingCard = shouldContinue;
    return [self playAudio:filleName fileType:type withDelay:NO];
}

- (void)playAudio:(NSString *)filleName fileType:(NSString *)type withDelay:(BOOL)shouldDelay
{
    if(shouldDelay) {
        [NSThread sleepForTimeInterval:1.0f];
    }
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:filleName ofType:type]];
    NSError* error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!url || error) {
        //錯誤處理常式
    }
    [self.player setDelegate:self];
    [self.player prepareToPlay]; //This is not always needed, but good to include
    [self.player play];
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
    NSDictionary *card = [[LTDatabase instance] cardForId:self.cardIds[idx]];
    
    OBShapedButton *imageButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:CGRectMake(point.x, point.y, IMAGE_BUTTON_SIZE, IMAGE_BUTTON_SIZE)];
    [imageButton addTarget:self action:@selector(selectImageButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)toggleTouchable:(BOOL)touchable
{
    if(touchable == NO)
        [self.scrollView setUserInteractionEnabled:NO];
    else
        [self.scrollView setUserInteractionEnabled:YES];
}

- (void)replayCurrentCard
{
    [self playAudio:[[LTDatabase instance] cardForId:self.cardIds[anserPoint]][LT_DB_KEY_CARD_NAME] fileType:@"mp3" withDelay:YES];
}

#pragma mark - Audio Player Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(shouldContinuePlayingCard) {
        // Playing the "correct" sound.
        if(anserPoint == self.points.count)
            return;
        [self replayCurrentCard];
        
        shouldContinuePlayingCard = NO;
    }
    else {
        // Playing the "card" sound.
        [self toggleTouchable:YES];
    }
}
@end
