//
//  ChatImageScrollViewController.h
//  ChuMian
//
//  Created by 颜 沛贤 on 13-10-29.
//
//

#import <UIKit/UIKit.h>

@interface ChatImageScrollViewController : UIViewController <UIScrollViewDelegate>


@property (nonatomic, assign) NSInteger indexrow;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) UIScrollView * mainScrollView;

@end
