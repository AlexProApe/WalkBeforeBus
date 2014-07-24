//
//  MyLauncherPageControl.h
//  finaSearchData
//
//  Created by Wei Zhang on 04/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.

#import <UIKit/UIKit.h>

@interface MyLauncherPageControl : UIPageControl {
	NSInteger currentPage;
	NSInteger numberOfPages;
    NSInteger maxNumberOfPages;
	BOOL hidesForSinglePage;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger maxNumberOfPages;
@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic, strong) UIColor *inactivePageColor;
@property (nonatomic, strong) UIColor *activePageColor;

@end
