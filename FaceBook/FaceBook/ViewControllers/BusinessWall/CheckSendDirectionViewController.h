//
//  checkSendDirectionViewController.h
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallGroupItem : NSObject

@property (nonatomic, assign) int friendId;
@property (nonatomic, copy)	NSString *name;
@property (nonatomic, copy) NSString *headLogo;
@property (nonatomic, assign) BOOL checked;

+ (WallGroupItem*) wallGroupItem;

@end


@interface CheckSendDirectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *sendDirectionTabelView;
    NSMutableArray *sendDirectionArray;
    NSMutableArray *selectDirectionArray;
    UIScrollView *bgScrollView;
    //UIView *alertView;
    UIButton *sendButton;
    NSString *groupId;
}

@property (nonatomic, strong) NSMutableDictionary *wallInformationDic;

@end
