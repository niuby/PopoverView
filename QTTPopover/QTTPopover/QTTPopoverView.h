//
//  QTTPopoverView.h
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/4.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WillShowHandler)(void);
typedef void(^WillDismissHandler)(void);
typedef void(^DidShowHandler)(void);
typedef void(^DidDismissHandler)(void);


@class QTTPopoverOption;

@interface QTTPopoverView : UIView

@property (nonatomic, copy) WillShowHandler willShowHandler;
@property (nonatomic, copy) WillDismissHandler willDismissHandler;
@property (nonatomic, copy) DidShowHandler didShowHandler;
@property (nonatomic, copy) DidDismissHandler didDismissHandler;

- (instancetype)initWithShowhandle:(_Nullable DidShowHandler)showhandler dismissHandle:(_Nullable DidDismissHandler)dismisshandler;

- (instancetype)initWithOption:(QTTPopoverOption* _Nullable )option showHandle:(_Nullable DidShowHandler)showhandler dismissHandle:(_Nullable DidDismissHandler)dismisshandler;

- (void)showWith:(UIView*)contentView atPoint:(CGPoint)point;
- (void)showWith:(UIView*)contentView fromView:(UIView*)fromview;
- (void)showWith:(UIView*)contentView fromView:(UIView*)fromview inView:(UIView*)inview;
- (void)showWith:(UIView *)contentView atPoint:(CGPoint)point inView:(UIView*)inview;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
