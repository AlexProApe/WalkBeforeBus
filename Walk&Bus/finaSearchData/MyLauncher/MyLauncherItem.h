//
//  MyLauncherItem.h
//  
//  finaSearchData
//
//  Created by Wei Zhang on 04/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class CustomBadge;

@protocol MyLauncherItemDelegate <NSObject>
-(void)didDeleteItem:(id)item;
@end

@interface MyLauncherItem : UIControl {	
	BOOL dragging;
	BOOL deletable;
    BOOL titleBoundToBottom;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *iPadImage;
@property (nonatomic, retain) NSString *controllerStr;
@property (nonatomic, retain) NSString *controllerTitle;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) CustomBadge *badge;
@property (nonatomic,retain) NSString *busName;
-(id)initWithTitle:(NSString *)title image:(NSString *)image target:(NSString *)targetControllerStr deletable:(BOOL)_deletable busName:(NSString *)busName;
-(id)initWithTitle:(NSString *)title iPhoneImage:(NSString *)image iPadImage:(NSString *)iPadImage target:(NSString *)targetControllerStr targetTitle:(NSString *)targetTitle deletable:(BOOL)_deletable busName:(NSString *)busName;
-(void)layoutItem;
-(void)setDragging:(BOOL)flag;
-(BOOL)dragging;
-(BOOL)deletable;

-(BOOL)titleBoundToBottom;
-(void)setTitleBoundToBottom:(BOOL)bind;

-(NSString *)badgeText;
-(void)setBadgeText:(NSString *)text;
-(void)setCustomBadge:(CustomBadge *)customBadge;

@end
