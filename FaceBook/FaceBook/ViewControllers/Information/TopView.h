//
//  TopView.h
//  CircleTest
//
//  Created by 颜沛贤 on 14-6-25.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

- (void)getTopDetailViewWith:(NSDictionary*)dict;
- (void)deleteDetailViewWith:(NSDictionary*)dict;

@end

@interface TopView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UILabel * _titleLabel;
    UITableView * _contentTableView;
    NSMutableArray * _contentArray;
    
    UIButton * _deleteButton;
}

@property (nonatomic,strong) NSDictionary * mainContentDict;
@property (nonatomic,strong) id <TopViewDelegate> delegate;


- (void)setDataWithDict:(NSDictionary*)dict;

@end
