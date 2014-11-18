//
//  WCChatSelectionView.m
//  微信
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCChatSelectionView.h"
#define CHAT_BUTTON_SIZE 71
#define INSETS 7.2


@implementation WCChatSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0]];
        
        
        // Initialization code
        //相册按钮
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"chatxiangce@2x.png"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoButton];
        UILabel * photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, INSETS+CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 18)];
        photoLabel.textColor = [UIColor colorWithRed:130.0/255 green:130.0/255 blue:130.0/255 alpha:1.0];
        photoLabel.backgroundColor = [UIColor clearColor];
        photoLabel.text = @"相册";
        photoLabel.textAlignment = NSTextAlignmentCenter;
        photoLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:photoLabel];
        //拍照按钮
        _cameraButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setFrame:CGRectMake(INSETS*2+CHAT_BUTTON_SIZE, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_cameraButton setImage:[UIImage imageNamed:@"chatpaizhao@2x.png"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(pickCameraPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraButton];
        UILabel * cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSETS*2+CHAT_BUTTON_SIZE, INSETS+CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 18)];
        cameraLabel.textColor = [UIColor colorWithRed:130.0/255 green:130.0/255 blue:130.0/255 alpha:1.0];
        cameraLabel.backgroundColor = [UIColor clearColor];
        cameraLabel.text = @"拍照";
        cameraLabel.textAlignment = NSTextAlignmentCenter;
        cameraLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:cameraLabel];

//        //位置按钮
//        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_locationButton setFrame:CGRectMake(INSETS*3+CHAT_BUTTON_SIZE*2, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_locationButton setImage:[UIImage imageNamed:@"chatweizhi@2x.png"] forState:UIControlStateNormal];
//        [_locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_locationButton];
//        UILabel * locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSETS*3+CHAT_BUTTON_SIZE*2, INSETS+CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 18)];
//        locationLabel.textColor = [UIColor colorWithRed:130.0/255 green:130.0/255 blue:130.0/255 alpha:1.0];
//        locationLabel.backgroundColor = [UIColor clearColor];
//        locationLabel.text = @"位置";
//        locationLabel.textAlignment = NSTextAlignmentCenter;
//        locationLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:locationLabel];
//
//        //名片按钮
//        _vcardButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_vcardButton setFrame:CGRectMake(INSETS*4+CHAT_BUTTON_SIZE*3, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_vcardButton setImage:[UIImage imageNamed:@"chatmingpian@2x.png"] forState:UIControlStateNormal];
//        [_vcardButton addTarget:self action:@selector(vcardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_vcardButton];
//        UILabel * vcardLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSETS*4+CHAT_BUTTON_SIZE*3, INSETS+CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 18)];
//        vcardLabel.textColor = [UIColor colorWithRed:130.0/255 green:130.0/255 blue:130.0/255 alpha:1.0];
//        vcardLabel.backgroundColor = [UIColor clearColor];
//        vcardLabel.text = @"名片";
//        vcardLabel.textAlignment = NSTextAlignmentCenter;
//        vcardLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:vcardLabel];

    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)pickPhoto
{
    [_delegate pickPhoto];
    
}


- (void)pickCameraPhoto
{
    [_delegate pickCameraPhoto];
}

- (void)locationButtonClicked
{
    [_delegate locationViewShow];
}

- (void)vcardButtonClicked
{
    
}

//-(UIImage *)imageDidFinishPicking
//{
//    
//}
//-(UIImage *)cameraDidFinishPicking
//{
//    
//}
//-(CLLocation *)locationDidFinishPicking
//{
//    
//}


@end
