//
//  ThemeMainMembersViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-8-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PSCollectionViewCell.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@interface ThemeMainMembersViewController : UIViewController<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate,EGORefreshTableDelegate>
{
    
    NSMutableArray *themeArray;
    
    NSInteger pageNumber;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    
}
@property (nonatomic, strong) PSCollectionView *collectionView;
//主题群id
@property (nonatomic, strong) NSString *themeIdString;
@end
