//
//  KBPopupHeaders.h
//  finaSearchData
//
//  Created by Wei Zhang on 12/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#ifndef KB_WEAK
#if __has_feature(objc_arc_weak)
#define KB_WEAK weak
#elif __has_feature(objc_arc)
#define KB_WEAK unsafe_unretained
#else
#define KB_WEAK assign
#endif
#endif // KB_WEAK

#ifndef KB_WEAK_REF
#if __has_feature(obj_arc_weak)
#define KB_WEAK_REF __weak
#else
#define KB_WEAK_REF __unsafe_unretained
#endif
#endif // KB_WEAK_REF

//
// Macros for hardware detection
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)

//
// Macros for debugging
//
#ifndef DLog
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif // DEBUG
#endif // DLog

#ifndef ALog
#define ALog(...) NSLog(__VA_ARGS__)
#endif // ALog