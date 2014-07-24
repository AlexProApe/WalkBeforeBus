//
//  MyLauncherView.h
//  finaSearchData
//
//  Created by Wei Zhang on 04/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLauncherItem.h"
#import "MyLauncherPageControl.h"
#import "MyLauncherScrollView.h"
#import "MBProgressHUD.h"

@protocol MyLauncherViewDelegate <NSObject>
-(void)launcherViewItemSelected:(MyLauncherItem*)item;
-(void)launcherViewDidBeginEditing:(id)sender;
-(void)launcherViewDidEndEditing:(id)sender;
@end

@interface MyLauncherView : UIView <UIScrollViewDelegate, MyLauncherItemDelegate,UIAlertViewDelegate> {
    UIDeviceOrientation currentOrientation;
	BOOL itemsAdded;
	BOOL editing;
	BOOL dragging;
    BOOL editingAllowed;
	NSInteger numberOfImmovableItems;
    MBProgressHUD *HUD;
	int columnCount;
	int rowCount;
	CGFloat itemWidth;
	CGFloat itemHeight;
    CGFloat minX;
    CGFloat minY;
    CGFloat paddingX;
    CGFloat paddingY;
}

@property (nonatomic) BOOL editingAllowed;
@property (nonatomic) NSInteger numberOfImmovableItems;
@property (nonatomic, strong) id <MyLauncherViewDelegate> delegate;
@property (nonatomic, strong) MyLauncherScrollView *pagesScrollView;
@property (nonatomic, strong) MyLauncherPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pages;

// Default for animation below is YES

-(void)setPages:(NSMutableArray *)pages animated:(BOOL)animated;
-(void)setPages:(NSMutableArray *)pages numberOfImmovableItems:(NSInteger)items;
-(void)setPages:(NSMutableArray *)pages numberOfImmovableItems:(NSInteger)items animated:(BOOL)animated;

-(void)viewDidAppear:(BOOL)animated;
-(void)setCurrentOrientation:(UIInterfaceOrientation)newOrientation;
-(void)layoutLauncher;
-(void)layoutLauncherAnimated:(BOOL)animated;
-(int)maxItemsPerPage;
-(int)maxPages;

@end
