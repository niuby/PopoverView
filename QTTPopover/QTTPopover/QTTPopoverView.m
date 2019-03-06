//
//  QTTPopoverView.m
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/4.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import "QTTPopoverView.h"
#import "QTTPopoverOption.h"


@interface QTTPopoverView()

@property (nonatomic, strong) UIControl *backOverlay;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint arrowShowPoint;
@property (nonatomic, assign) CGRect contentviewFrame;
@property (nonatomic, strong) QTTPopoverOption *popoverOption;

@end

@implementation QTTPopoverView


//MARK: 👊 Init
- (instancetype)init {
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityViewIsModal = YES;
    }
    
    return self;
}


- (instancetype)initWithShowhandle:(DidShowHandler)showhandler dismissHandle:(DidDismissHandler)dismisshandler {
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityViewIsModal = YES;
        self.popoverOption = [[QTTPopoverOption alloc]init];
        
        self.didShowHandler = showhandler;
        self.didDismissHandler = dismisshandler;
    }
    
    return self;
}

- (instancetype)initWithOption:(QTTPopoverOption *)option showHandle:(DidShowHandler)showhandler dismissHandle:(DidDismissHandler)dismisshandler {
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityViewIsModal = YES;
        if (option) {
            self.popoverOption = option;
        } else {
            self.popoverOption = [[QTTPopoverOption alloc]init];
        }
        
        self.didShowHandler = showhandler;
        self.didDismissHandler = dismisshandler;
    }
    
    return self;
}


//MARK: - 👉 👉 Show Function 👈 👈

- (void)showWith:(UIView*)contentView atPoint:(CGPoint)point {
    
    UIWindow *rootWindow = UIApplication.sharedApplication.keyWindow;
    if (rootWindow) {
        [self showWith:contentView atPoint:point inView:rootWindow];
    }
}

- (void)showWith:(UIView*)contentView fromView:(UIView*)fromview {
    UIWindow *rootWindow = UIApplication.sharedApplication.keyWindow;
    if (rootWindow) {
        [self showWith:contentView fromView:fromview inView:rootWindow];
    }
}

- (void)showWith:(UIView*)contentView fromView:(UIView*)fromview inView:(UIView*)inview {
    CGPoint point = CGPointZero;
    
    if (self.popoverOption.popoverType == PopoverTypeAuto) {
        CGPoint position = [fromview.superview convertPoint:fromview.frame.origin toView:nil];
        CGFloat totalHeight = position.y + fromview.frame.size.height + self.popoverOption.arrowSize.height + contentView.frame.size.height;
        
        if (totalHeight > inview.frame.size.height) {
            self.popoverOption.popoverType = PopoverTypeUp;
        } else {
            self.popoverOption.popoverType = PopoverTypeDown;
        }
    }
    
    switch (self.popoverOption.popoverType) {
        case PopoverTypeUp:
            point = [inview convertPoint: CGPointMake(fromview.frame.origin.x + (fromview.frame.size.width / 2), fromview.frame.origin.y) toView:fromview.superview];
            break;
        case PopoverTypeDown:
            point = [inview convertPoint:CGPointMake(fromview.frame.origin.x + (fromview.frame.size.width / 2), fromview.frame.origin.y + fromview.frame.size.height) toView:fromview.superview];
            break;
        default:
            break;
    }
    
    [self showWith:contentView atPoint:point inView:inview];
}

- (void)showWith:(UIView *)contentView atPoint:(CGPoint)point inView:(UIView*)inview {
    
    if (self.popoverOption.showBlackOverlay || self.popoverOption.dismissOnBlackOverlayTap) {
        self.backOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth&UIViewAutoresizingFlexibleHeight;
        self.backOverlay.frame = inview.bounds;
        [inview addSubview:self.backOverlay];
        
        if (self.popoverOption.showBlackOverlay) {
            if (self.popoverOption.overlayBlur) {
                UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:self.popoverOption.overlayBlur];
                effectview.frame = self.backOverlay.bounds;
                effectview.userInteractionEnabled = NO;
                [self.backOverlay addSubview:effectview];
            } else {
                self.backOverlay.backgroundColor = self.popoverOption.backOverlayColor;
                self.backOverlay.alpha = 0;
            }
        }
        
        if (self.popoverOption.dismissOnBlackOverlayTap) {
            [self.backOverlay addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.containerView = inview;
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = self.popoverOption.cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.arrowShowPoint = point;
    
    [self show];
}


- (void)show {
    
    [self setNeedsDisplay];
    
    CGRect contentFrame = self.contentView.frame;
    
    switch (self.popoverOption.popoverType) {
        case PopoverTypeUp:
            contentFrame.origin.y = 0.0;
            break;
        case PopoverTypeDown:
            contentFrame.origin.y = self.popoverOption.arrowSize.height;
            break;
        default:
            break;
    }
    
    self.contentView.frame = contentFrame;
    [self addSubview:self.contentView];
    [self.containerView addSubview:self];
    
    [self setPopoverViewFrame];
    
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);

    [UIView animateWithDuration:self.popoverOption.animationIn delay:0 usingSpringWithDamping:self.popoverOption.springDamping initialSpringVelocity:self.popoverOption.initialSpringVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:self.popoverOption.animationIn/3 animations:^{
        self.backOverlay.alpha = 1;
    }];
}

- (void)dismiss {
    
    if (self.subviews != nil) {
        [UIView animateWithDuration:self.popoverOption.animationOut delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            self.backOverlay.alpha = 0;
        } completion:^(BOOL finished) {
            [self.contentView removeFromSuperview];
            [self.backOverlay removeFromSuperview];
            [self removeFromSuperview];
            self.transform = CGAffineTransformIdentity;
            
        }];
    }
}


//MARK: - 👉 👉 Frame Set 👈 👈

- (void)setPopoverViewFrame {
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5;
    
    CGFloat outerSideEdge = CGRectGetMaxX(frame) - self.containerView.bounds.size.width;
    
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge + self.popoverOption.sideEdge);
    } else {
        if (CGRectGetMinX(frame) < 0) {
            frame.origin.x += fabs(CGRectGetMinX(frame)) + self.popoverOption.sideEdge;
        }
    }

    self.frame = frame;
    
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toCoordinateSpace:self];
    
    CGPoint anchorPoint = CGPointZero;

    switch (self.popoverOption.popoverType) {
        case PopoverTypeUp:
            frame.origin.y = self.arrowShowPoint.y - frame.size
            .height- self.popoverOption.arrowSize.height;
            anchorPoint = CGPointMake(arrowPoint.x/frame.size.width, 1);
            break;
        case PopoverTypeDown:
            frame.origin.y = self.arrowShowPoint.y;
            anchorPoint = CGPointMake(arrowPoint.x/frame.size.width, 0);
            break;
        default:
            break;
    }

    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    
    CGFloat x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width;
    CGFloat y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height;
    
    self.layer.position = CGPointMake(x, y);
    frame.size.height += self.popoverOption.arrowSize.height;
    
    self.frame = frame;
}


//MARK: - 👉 👉 Override 👈 👈

-(BOOL)accessibilityPerformEscape {
    [self dismiss];
    return YES;
}

//MARK: - 👉 👉 绘制 👈 👈

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    switch (self.popoverOption.popoverType) {
        case PopoverTypeUp:
            [self drawUpArrow];
            break;
        case PopoverTypeDown:
            [self drawDownArrow];
            break;
        default:
            break;
    }
}

- (void)drawUpArrow {
    
    UIBezierPath *arrow = [[UIBezierPath alloc]init];
    
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toCoordinateSpace:self];
    
    ///
    [arrow moveToPoint:CGPointMake(arrowPoint.x, self.bounds.size.height)];
    if ([self isLeftCornerArrow]) {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x - self.popoverOption.arrowSize.width/2, self.popoverOption.arrowSize.height)];
    } else {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x - self.popoverOption.arrowSize.width/2, self.bounds.size.height - self.popoverOption.arrowSize.height)];
    }

    ///
    [arrow addLineToPoint:CGPointMake(self.popoverOption.cornerRadius, self.bounds.size.height - self.popoverOption.arrowSize.height)];
    [arrow addArcWithCenter:CGPointMake(self.popoverOption.cornerRadius, self.bounds.size.height-self.popoverOption.arrowSize.height - self.popoverOption.cornerRadius) radius:_popoverOption.cornerRadius startAngle:[self getRadians:90] endAngle:[self getRadians:180] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(0, self.popoverOption.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(self.popoverOption.cornerRadius, self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:180] endAngle:[self getRadians:270] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, 0)];
    [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:270] endAngle:[self getRadians:0] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-self.popoverOption.arrowSize.height - self.popoverOption.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, self.bounds.size.height-self.popoverOption.arrowSize.height - self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:0] endAngle:[self getRadians:90] clockwise:true];
    
    ///
    if ([self isRightCornerArrow]) {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x + self.popoverOption.arrowSize.width/2, self.popoverOption.arrowSize.height)];
    } else {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x + self.popoverOption.arrowSize.width/2, self.bounds.size.height - self.popoverOption.arrowSize.height)];
    }
    
    [self.popoverOption.popoverColor setFill];
    [arrow fill];
}


- (void)drawDownArrow {
    
    UIBezierPath *arrow = [[UIBezierPath alloc]init];
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toCoordinateSpace:self];
    
    ///
    [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
    if ([self isRightCornerArrow]) {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x + self.popoverOption.arrowSize.width/2, self.bounds.size.height - self.popoverOption.arrowSize.height)];
    } else {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x + self.popoverOption.arrowSize.width/2, self.popoverOption.arrowSize.height)];
    }
    
    ///
    [arrow addLineToPoint:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, self.popoverOption.arrowSize.height)];
    [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, self.popoverOption.arrowSize.height + self.popoverOption.cornerRadius) radius:_popoverOption.cornerRadius startAngle:[self getRadians:270] endAngle:[self getRadians:0] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - self.popoverOption.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - self.popoverOption.cornerRadius, self.bounds.size.height - self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:0] endAngle:[self getRadians:90] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [arrow addArcWithCenter:CGPointMake(self.popoverOption.cornerRadius, self.bounds.size.height - self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:90] endAngle:[self getRadians:180] clockwise:true];
    
    ///
    [arrow addLineToPoint:CGPointMake(0, self.popoverOption.arrowSize.height + self.popoverOption.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(self.popoverOption.cornerRadius, self.popoverOption.arrowSize.height + self.popoverOption.cornerRadius) radius:self.popoverOption.cornerRadius startAngle:[self getRadians:180] endAngle:[self getRadians:270] clockwise:true];
    
    ///
    if ([self isLeftCornerArrow]) {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x - self.popoverOption.arrowSize.width/2, self.bounds.size.height + self.popoverOption.arrowSize.height)];
    } else {
        [arrow addLineToPoint:CGPointMake(arrowPoint.x - self.popoverOption.arrowSize.width/2, self.popoverOption.arrowSize.height)];
    }
    
    [self.popoverOption.popoverColor setFill];
    [arrow fill];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
}

//MARK: - 👉 👉 Private Func 👈 👈

- (BOOL)isLeftCornerArrow {
    return self.arrowShowPoint.x == self.frame.origin.x;
}

- (BOOL)isRightCornerArrow {
    return self.arrowShowPoint.y == self.frame.origin.x + self.bounds.size.width;
}

- (CGFloat)getRadians:(CGFloat)degress {
    return M_PI * degress / 180;
}


//MARK: - 👉 👉 Property Init 👈 👈

-(UIControl *)backOverlay {
    
    if (!_backOverlay) {
        _backOverlay = [[UIControl alloc]init];
    }
    return _backOverlay;
}


@end
