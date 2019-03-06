//
//  QTTPopoverOption.h
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/5.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, PopoverType) {
    PopoverTypeUp,
    PopoverTypeDown,
    PopoverTypeAuto,
};


@interface QTTPopoverOption : NSObject

@property (nonatomic, assign) NSTimeInterval animationIn;
@property (nonatomic, assign) NSTimeInterval animationOut;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, strong) UIColor *popoverColor;
@property (nonatomic, strong) UIColor *backOverlayColor;
@property (nonatomic, strong) UIBlurEffect *overlayBlur;
@property (nonatomic, assign) PopoverType popoverType;
@property (nonatomic, assign) BOOL dismissOnBlackOverlayTap;
@property (nonatomic, assign) BOOL showBlackOverlay;
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat initialSpringVelocity;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat sideEdge;

@end


NS_ASSUME_NONNULL_END
