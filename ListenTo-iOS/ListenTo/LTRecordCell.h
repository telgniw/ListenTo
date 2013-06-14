//
//  LTRecordCell.h
//  ListenTo
//
//  Created by Yi Huang on 13/5/28.
//  Copyright (c) 2013年 Rabbit Wears Pants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTRecordCellDelegate <NSObject>

- (void)cellSelectedWithIdentity:(NSNumber*)theID;

@end

@interface LTRecordCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *cardIds;
@property (strong, nonatomic) NSArray *cardErrors;
@property (strong, nonatomic) NSDictionary *card;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *cardVoiceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak,   nonatomic) id<LTRecordCellDelegate> delegate;

@end
