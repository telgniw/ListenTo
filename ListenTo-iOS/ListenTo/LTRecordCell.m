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

@implementation LTRecordCell

#pragma mark - Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LTErrorCell";
    
    NSNumber *cid = self.cardIds[indexPath.row];
    
    LTDatabase *db = [LTDatabase instance];
    NSDictionary *card = [db cardForId:cid];
    
    LTRecordErrorImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:card[@"image"]]];
    [cell.countLabel setText:[self.cardErrors[indexPath.row] stringValue]];
    
    return cell;
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
