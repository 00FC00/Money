//
//  InstitutionsMemberViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-8-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PSCollectionViewCell.h"

@interface InstitutionsMemberViewController : UIViewController<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>
{
    
    
    
//    NSInteger pageNumber;
//    EGORefreshTableHeaderView *_refreshHeaderView;
//    EGORefreshTableFooterView *_refreshFooterView;
//    BOOL _reloading;
    
}
@property (nonatomic, strong) PSCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *InstitutionsArray;
@end
