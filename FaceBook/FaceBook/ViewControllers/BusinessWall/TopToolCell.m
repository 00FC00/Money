//
//  TopToolCell.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "TopToolCell.h"

@implementation TopToolCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self toolsCell];
    }
    return self;
}
- (void)toolsCell
{
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:152.0f/255.0f green:152.0f/255.0f blue:152.0f/255.0f alpha:1];
    
    self.accessoryType =UITableViewCellAccessoryNone;
    
    _markTitleLabel = [[UILabel alloc]init];
    _markTitleLabel.backgroundColor= [UIColor clearColor];
    _markTitleLabel.font = [UIFont systemFontOfSize:18];
    _markTitleLabel.textAlignment = NSTextAlignmentCenter;
    _markTitleLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:201.0f/255.0f blue:237.0f/255.0f alpha:1.0];
    //_markTitleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.contentView addSubview:_markTitleLabel];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
