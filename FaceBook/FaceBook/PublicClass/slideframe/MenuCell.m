//
//  MenuCell.m
//  DongDong
//
//  Created by LanLing on 13-10-16.
//  Copyright (c) 2013年 LanLing. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize titleLabel,markImageView;
@synthesize xianImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.contentView.backgroundColor=[UIColor colorWithRed:44/255.0f green:47/255.0f blue:54/255.0f alpha:1.0];
        [self addTocell];
    }
    return self;
}
-(void)addTocell
{
    //title
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(78/2, 27/2, 300/2, 34/2)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithRed:56.0f/255.0f green:56.0f/255.0f blue:58.0f/255.0f alpha:1];
    [self.contentView addSubview:titleLabel];
    
    //markImageView
//    markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22/2, 20/2, 50/2, 50/2)];
    
    markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22/2, 20/2 + 5, 28/2, 29/2)];
    markImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:markImageView];
    
    //bottomXian
    xianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78/2, 640/2, 1)];
    [self.contentView addSubview:xianImageView];
    
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(200, 30/2, 40/2, 40/2);
    [self.contentView addSubview:_deleteButton];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
