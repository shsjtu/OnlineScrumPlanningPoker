//
//  OSMeetingBoardCellTableViewCell.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 5/3/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSMeetingBoardCellTableViewCell.h"

@implementation OSMeetingBoardCellTableViewCell

- (void)awakeFromNib {
    self.nameLabel.layer.cornerRadius = 4.0f;
    self.nameLabel.clipsToBounds = YES;
    self.statusLabel.layer.cornerRadius = 4.0f;
    self.statusLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
