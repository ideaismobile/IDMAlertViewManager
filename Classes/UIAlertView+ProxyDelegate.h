//
//  UIAlertView+ProxyDelegate.h
//  IDMAlertViewManager
//
//  Created by Flávio Caetano on 12/11/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDMAlertViewManager.h"

@interface UIAlertView (ProxyDelegate)

@property (nonatomic, strong) id<UIAlertViewDelegate> originalDelegate;

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
