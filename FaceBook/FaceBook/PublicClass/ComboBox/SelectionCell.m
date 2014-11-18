//
//  SelectionCell.m
//  ComboBox
//
//  Created by Eric Che on 7/17/13.
//  Copyright (c) 2013 Eric Che. All rights reserved.
//

#import "SelectionCell.h"

@implementation SelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addTocell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addTocell
{
    self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 186/2, 70.0/2)];
    [self.contentView addSubview:self.background];
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 186/2, 70.0/2)];
    self.lb.font = [UIFont systemFontOfSize:16];
    self.lb.textColor = [UIColor whiteColor];
    self.lb.textAlignment = NSTextAlignmentCenter;
//    self.lb.backgroundColor = [UIColor colorWithRed:57/255.0 green:128 /255.0 blue:236/255.0 alpha:1];
    
    [self.contentView addSubview:self.lb];
}

@end
