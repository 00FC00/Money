//
//  TopView.m
//  CircleTest
//
//  Created by 颜沛贤 on 14-6-25.
//  Copyright (c) 2014年 颜沛贤. All rights reserved.
//

#import "TopView.h"
#import "TopTableViewCell.h"

#define SpaceHeight 32.0
#define LineStart 91.0


@implementation TopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120.0/2)];
    _titleLabel.backgroundColor = [UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:1.0];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height-60) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(240, (60-36.0/2)/2, 36/2, 36/2);
    [_deleteButton setImage:[UIImage imageNamed:@"emotionstore_progresscancelbtn"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonClicked:(id)sender
{
    if (self.mainContentDict != nil) {
        //
        [self.delegate deleteDetailViewWith:self.mainContentDict];
    }
}

- (void)setDataWithDict:(NSDictionary*)dict
{
    
    self.mainContentDict = dict;
    
    _titleLabel.text = [dict objectForKey:@"name"];
    
    
    if ([[[dict objectForKey:@"news"] class] isSubclassOfClass:[NSArray class]] == YES) {
        _contentArray = [dict objectForKey:@"news"];
    }
    
//    if ([[[dict objectForKey:@"news"] class] isSubclassOfClass:[NSArray class]] == YES) {
//        //
//        for (NSInteger i = 0; i < [[dict objectForKey:@"news"] count]; i++) {
//            //
//            UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 64+SpaceHeight*i, self.frame.size.width-66, 20)];
//            contentLabel.backgroundColor = [UIColor whiteColor];
//            contentLabel.font = [UIFont systemFontOfSize:13];
//            contentLabel.text = [[[dict objectForKey:@"news"] objectAtIndex:i] objectForKey:@"title"];
//            [self addSubview:contentLabel];
//        }
//    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
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
    
    //第五条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight*4);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight*4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //第六条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight*5);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight*5);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //第七条线
    CGContextMoveToPoint(ctx, 0, LineStart+SpaceHeight*6);
    CGContextAddLineToPoint(ctx, self.frame.size.width, LineStart+SpaceHeight*6);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"contentcell";
    TopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (IS_IOS_7) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.contentLabel.text = [[_contentArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.leaveWordLabel.text = [NSString stringWithFormat:@"%@",[[_contentArray objectAtIndex:indexPath.row] objectForKey:@"comments"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate getTopDetailViewWith:[_contentArray objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    
    return footerView;
}

@end
