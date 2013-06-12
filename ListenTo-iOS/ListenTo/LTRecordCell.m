//
//  LTRecordCell.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTRecordCell.h"
#import "LTRecordErrorImageCell.h"
#import "LTDatabase.h"
#import "LTCardViewController.h"

@implementation LTRecordCell

#pragma mark - Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LTErrorCell";
    static UIColor *errorBackgroundImage;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        errorBackgroundImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"management-error-background.png"]];
    });
    
    NSNumber *cid = self.cardIds[indexPath.row];
    
    LTDatabase *db = [LTDatabase instance];
    self.card = [db cardForId:cid];
    
    LTRecordErrorImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:_card[@"image"]]];
    [cell.countLabel setInsets:UIEdgeInsetsMake(8.0f, 10.0f, 0.0f, 0.0f)];
    [cell.countLabel setBackgroundColor:errorBackgroundImage];
    [cell.countLabel setText:[self.cardErrors[indexPath.row] stringValue]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate){
        NSNumber *cid = self.cardIds[indexPath.row];
        [self.delegate cellSelectedWithIdentity:cid];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cardIds count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
