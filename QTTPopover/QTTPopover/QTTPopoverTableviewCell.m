//
//  QTTPopoverTableviewCell.m
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/5.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import "QTTPopoverTableviewCell.h"

@implementation QTTPopoverTableviewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
