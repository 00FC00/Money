//
//  GoldcoinsViewController.h
//  FaceBook
//
//  Created by HMN on 14-7-10.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixLibService.h"


@interface GoldcoinsItem : NSObject

@property (nonatomic, assign) int goldcoinsId;
@property (nonatomic, copy)	NSString *goldcoins;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) BOOL checked;

+ (GoldcoinsItem *) goldcoinsItem;

@end


@interface GoldcoinsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *goldcoinsTableView;
    NSMutableArray *goldcoinsArray;
    
    NSMutableArray *selectArray;
    
    NSInteger goldcoins;
}

@property (nonatomic, strong) NSString *moneyString;

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

-(void)paymentResult:(NSString *)result;

@end
