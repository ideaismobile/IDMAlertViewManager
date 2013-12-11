//
//  UIAlertView+ProxyDelegate.m
//  IDMAlertViewManager
//
//  Created by Flávio Caetano on 12/11/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import "UIAlertView+ProxyDelegate.h"

#import <objc/runtime.h>

static char _originalDelegate;
static char _priority;
static char _successBlock;
static char _failureBlock;

@implementation UIAlertView (ProxyDelegate)

#pragma mark - Original Delegate

- (id<UIAlertViewDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &_originalDelegate);
}

- (void)setOriginalDelegate:(id<UIAlertViewDelegate>)originalDelegate
{
    objc_setAssociatedObject(self, &_originalDelegate, originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Priority

- (IDMAlertPriority)priority
{
    id obj = objc_getAssociatedObject(self, &_priority);
    
    return (obj ? [obj integerValue] : INFINITY);
}

- (void)setPriority:(IDMAlertPriority)priority
{
    objc_setAssociatedObject(self, &_priority, @(priority), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Success Block

- (IDMAlertViewSuccessBlock)successBlock
{
    return objc_getAssociatedObject(self, &_successBlock);
}

- (void)setSuccessBlock:(IDMAlertViewSuccessBlock)successBlock
{
    objc_setAssociatedObject(self, &_successBlock, successBlock, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Failure Block

- (IDMAlertViewFailureBlock)failureBlock
{
    return objc_getAssociatedObject(self, &_failureBlock);
}

- (void)setFailureBlock:(IDMAlertViewFailureBlock)failureBlock
{
    objc_setAssociatedObject(self, &_failureBlock, failureBlock, OBJC_ASSOCIATION_RETAIN);
}

@end
