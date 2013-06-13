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
@implementation LTCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *cardId = self.cid;
    [self fetchCardInfo:cardId ];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"review_cards_background.png"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCardInfo:(NSNumber *)id {
    LTDatabase *db = [LTDatabase instance];
    self.card = [db cardForId:id];
    self.errorCards = [db arrayWithErrorCardsForCard:id afterDate:self.dateAfter];
    
    // Reload data immediately after data set is updated.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.card = [NSDictionary dictionaryWithDictionary:self.card];
        
        NSString *image = [self.card valueForKey:@"image"];
        NSString *name = [self.card valueForKey:@"name"];
        UIImage *card = [UIImage imageNamed:image];
        
        [self.imgCard setImage:card];
        [self.lblCardName setText:name];
    });
}

//# pramga mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.errorCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSNumber *cid = self.errorCards[indexPath.row];
    [self.allCards addObject:cid];
    LTDatabase *db = [LTDatabase instance];
    NSDictionary *errCard = [db cardForId:cid];
    [cell setTag:[cid intValue]];
    cell.textLabel.text = @"";
    [cell.textLabel setTag:15];
    UIImage *image = [UIImage imageNamed:errCard[@"image"]];
    LTImageView *imgErrCard = [[LTImageView alloc] initWithFrame:CGRectMake(20, 0, 180, 180)];
//    [imgErrCard setTag:self.errorCards[indexPath.row]];
    UILabel *imgName = [[UILabel alloc] initWithFrame:CGRectMake(25, imgErrCard.frame.size.height-45, imgErrCard.frame.size.width-10, imgErrCard.frame.size.height*0.15)];
    [imgErrCard setTag:10];
    [imgName setTag:20];
    
    UITapGestureRecognizer *tapGestureOnCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadCards:)];
    [cell addGestureRecognizer:tapGestureOnCard];

    [imgName setBackgroundColor:[UIColor colorWithRed:181/255.f green:181/255.f blue:181/255.f alpha:0.5]];
    [imgName setText:errCard[@"name"]];
    [imgName setTextAlignment:NSTextAlignmentCenter];
    [imgName setTextColor:[UIColor colorWithRed:240/255.f green:168/255.f blue:48/255.f alpha:1]];
    [imgName setFont:[UIFont fontWithName:@"Heiti TC" size:25.f]];
    [imgErrCard setImage:image];
    [cell.contentView addSubview:imgErrCard];
    [cell.contentView addSubview:imgName];
    
    return cell;
}


# pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reloadCards:(id)sender
{
     UIGestureRecognizer *cell = (UIGestureRecognizer *) sender;
     LTDatabase *db = [LTDatabase instance];
     NSInteger *selectedCardId = cell.view.tag;
    
     LTImageView *img = (LTImageView*) [cell.view viewWithTag:10];
    [self.imgCard setImage:img.image];
     UILabel *lbl = (UILabel *) [cell.view viewWithTag:20];
    [self.lblCardName setText:lbl.text];
    UILabel *cellLabel = (UILabel *) [cell.view viewWithTag:15];
    [cellLabel setText:@""];
    
    [img setImage:[UIImage imageNamed:self.card[@"image"]]];
    [lbl setText:self.card[@"name"]];
    [cell.view setTag: [self.card[@"id"] intValue]];
    
     self.card = [db cardForId:[NSNumber numberWithInt:selectedCardId]];
}

- (IBAction)playSound:(id)sender
{
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
