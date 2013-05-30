//
//  LTRecordCell.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTRecordCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *cardIds;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *cardVoiceLabel;

@end
