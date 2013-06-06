//
//  LTCardViewController.m
//  ListenTo
//
//  Created by Johnny Bee on 13/6/5.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTCardViewController.h"
#import "LTDatabase.h"
#import "LTChartViewController.h"

@interface LTCardViewController ()

@end

@implementation LTCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializati
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *cardId = self.cid;
    [self fetchCardInfo:cardId ];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chart.png"]]];
    
    LTChartViewController *chart = [LTChartViewController alloc];
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCardInfo:(NSNumber *)id {
    LTDatabase *db = [LTDatabase instance];
    NSDictionary *card = [db cardForId:id];

    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.card = [NSDictionary dictionaryWithDictionary:card];
        
        NSString *image = [card valueForKey:@"image"];
        NSString *name = [card valueForKey:@"name"];
        UIImage *card = [UIImage imageNamed:image];
        
        [self.imgCard setImage:card];
        [self.lblCardName setText:name];
    });
}

- (IBAction)playSound:(id)sender {
    NSString *audioName = [self.card valueForKey:@"name"];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"]];
    NSError* error = nil;
    self.myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!url || error) {
        //錯誤處理常式
    }
    [self.myPlayer prepareToPlay]; //This is not always needed, but good to include
    [self.myPlayer play];
}
@end
