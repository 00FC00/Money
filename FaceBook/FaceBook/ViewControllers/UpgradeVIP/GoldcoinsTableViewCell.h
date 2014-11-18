//
//  GoldcoinsTableViewCell.h
//  FaceBook
//
//  Created by HMN on 14-7-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldcoinsTableViewCell : UITableViewCell
{
    BOOL isSelected;
}
///金币
@property (nonatomic, strong) UILabel *goldcoinsLabel;

///价钱
@property (nonatomic, strong) UILabel *priceLabel;

///line
@property (nonatomic, strong) UIImageView *lineImageView;

//选择标记图片
@property (nonatomic,retain) UIImageView *selectedImageView;

- (void) setChecked:(BOOL)checked;

@end
