/*
 CustomBadge.h
 
 //  finaSearchData
 //
 //  Created by Wei Zhang on 04/07/2013.
 //  Copyright (c) 2013 Zhang Wei. All rights reserved.
 */


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomBadge : UIView {
	
	NSString *badgeText;
	UIColor *badgeTextColor;
	UIColor *badgeInsetColor;
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
}

@property(nonatomic,strong) NSString *badgeText;
@property(nonatomic,strong) UIColor *badgeTextColor;
@property(nonatomic,strong) UIColor *badgeInsetColor;
@property(nonatomic,strong) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
