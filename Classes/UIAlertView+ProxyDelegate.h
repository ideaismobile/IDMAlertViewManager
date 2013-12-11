//
//  UIAlertView+ProxyDelegate.h
//  IDMAlertViewManager
//
//  Created by Flávio Caetano on 12/11/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDMAlertViewManager.h"

/**
 *  This category extends UIAlertView in a manner that it now may have a priority, completion blocks, etc.
 */
@interface UIAlertView (ProxyDelegate)

/**
 *  The original delegate before proxying.
 */
@property (nonatomic, strong) id<UIAlertViewDelegate> originalDelegate;

/**
 *  The alertview priority
 */
@property (nonatomic) IDMAlertPriority priority;

/**
 *  The success block to be called when the visible alert view gets dismissed.
 */
@property (nonatomic, strong) IDMAlertViewSuccessBlock successBlock;

/**
 *  The failure block to be called when the visible alert view gets dismissed by any reason different than the user.
 */
@property (nonatomic, strong) IDMAlertViewFailureBlock failureBlock;

@end
