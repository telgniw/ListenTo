//
//  LTFlipcardViewController.m
//  ListenTo
//
//  Created by Yi Huang on 13/5/21.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import "LTFlipcardViewController.h"
#import "LTFlipcardCell.h"

@interface LTFlipcardViewController ()

@end

@implementation LTFlipcardViewController

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nCardPairs * 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LTFlipcardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlipcardCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Collection View Delegate

@end
