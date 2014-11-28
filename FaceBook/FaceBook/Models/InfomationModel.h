//
//  InfomationModel.h
//  FaceBook
//
//  Created by lichaowei on 14/11/22.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "BaseModel.h"

@interface InfomationModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *type_id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *praiseNums;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *logo_id;
@property(nonatomic,retain)NSString *logo;
@property(nonatomic,retain)NSString *comments_count;
@property(nonatomic,retain)NSArray *comments;
@property(nonatomic,retain)NSString *isPraise;
@property(nonatomic,retain)NSArray *praiseList;


@end
