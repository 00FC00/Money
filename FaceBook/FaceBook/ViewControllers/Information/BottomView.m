//
//  BottomView.m
//  CircleTest
//
//  Created by 颜沛贤 on 14-6-25.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import "BottomView.h"

#define BottomViewWidth 246.0/2
#define BottomViewHeight 269.0/2

#define SpaceHeight 22.0
#define LineStart 50.0

@implementation BottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];

        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
    _titleLabel.backgroundColor = [UIColor colorWithRed:163.0/255 green:191.0/255 blue:234.0/255 alpha:1.0];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}

- (void)setDataWithDict:(NSDictionary*)dict
{
    _titleLabel.text = [dict objectForKey:@"name"];
    
    if ([[[dict objectForKey:@"news"] class] isSubclassOfClass:[NSArray class]] == YES) {
        //
        for (NSInteger i = 0; i < [[dict objectForKey:@"news"] count]; i++) {
            //
            UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 29+SpaceHeight*i, self.frame.size.width-6, 20)];
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.text = [[[dict objectForKey:@"news"] objectAtIndex:i] objectForKey:@"title"];
            [self addSubview:contentLabel];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1.0] CGColor]);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);
    //第一条线
    CGContextMoveToPoint(ctx, 0, LineStart);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //第二条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    //第三条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight*2);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight*2);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    //第四条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight*3);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight*3);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);


}


@end
