//
//  SnaplistCell.m
//  Tracker
//
//  Created by Macbook Pro on 14/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "RosterCell.h"

@implementation RosterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected)
    {
        self.imgCheck.image = [UIImage imageNamed:@"checkmark@2x.png"];
    }
    else
    {
        self.imgCheck.image = [UIImage imageNamed:@"."];
    }
}

@end
