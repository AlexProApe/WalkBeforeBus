//
//  KBPopupDrawableView.h
//  finaSearchData
//
//  Created by Wei Zhang on 12/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import "KBPopupBubbleView.h"

//
// (1) Works best if kKBArrowHeight matches kKBDefaultMargin
// (2) kKBPopupArrowAdjustment is a slight adjustment to make animations work more smoothly
//
#define kKBPopupArrowMargin     18.0f
#define kKBPopupArrowWidth      16.0f
#define kKBPopupArrowHeight     8.0f
#define kKBPopupArrowAdjustment 1.0f

#pragma mark -
#pragma mark Arrow Delegate
@protocol KBPopupDrawableChildDelegate <NSObject>

@optional
- (BOOL)useBorders;
- (CGFloat)borderWidth;
- (UIColor*)borderColor;
- (UIColor*)drawableColor;
- (NSUInteger)side;

@end

#pragma mark -
#pragma mark Arrow Interface
@interface  KBPopupArrowView : UIView

@property (nonatomic, KB_WEAK) id<KBPopupDrawableChildDelegate> delegate;

@end

#pragma mark -
#pragma mark Cover Interface
@interface KBPopupCoverView : UIView

@property (nonatomic, KB_WEAK) id<KBPopupDrawableChildDelegate> delegate;

@end

#pragma mark -
#pragma mark Drawable Interface
@interface KBPopupDrawableView : UIView

@property (nonatomic, strong) KBPopupArrowView *arrow;
@property (nonatomic, strong) KBPopupCoverView *cover;

@property (nonatomic, assign) BOOL useRoundedCorners;
@property (nonatomic, assign) BOOL useBorders;

@property (nonatomic, assign)   NSUInteger side;
@property (nonatomic, assign)   CGFloat position;
@property (nonatomic, assign)   CGFloat cornerRadius;
@property (nonatomic, assign)   CGFloat borderWidth;
@property (nonatomic, readonly) CGFloat workingWidth;
@property (nonatomic, readonly) CGFloat workingHeight;

@property (nonatomic, strong) UIColor *drawableColor;
@property (nonatomic, strong) UIColor *borderColor;

- (void)updateArrow;

- (void)updateCover;

@end
