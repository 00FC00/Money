//
//  LPRelationViewController.h
//  CircleTest
//
//  Created by 颜沛贤 on 14-7-10.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPRelationViewController : UIViewController
{
    UIView *bgScrollView;
    UIView *alertView;
    
    NSMutableDictionary *Datadic;
}
@property (nonatomic,retain) NSMutableArray * lpDataArray;

@property (nonatomic,assign) CGPoint tapPoint;

@end
