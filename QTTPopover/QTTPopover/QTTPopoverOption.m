//
//  QTTPopoverOption.m
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/5.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import "QTTPopoverOption.h"

@implementation QTTPopoverOption

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.animationIn = 0.6;
        self.animationOut = 0.3;
        self.arrowSize = CGSizeMake(16.0, 10.0);
        self.backOverlayColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
//        self.overlayBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.popoverColor = [UIColor whiteColor];
        self.dismissOnBlackOverlayTap = YES;
        self.popoverType = PopoverTypeDown;
        self.showBlackOverlay = YES;
        self.springDamping = 0.7;
        self.initialSpringVelocity = 3.0;
        self.cornerRadius = 6.0;
        self.sideEdge = 20.0;
        
    }
    
    return self;
}

@end
