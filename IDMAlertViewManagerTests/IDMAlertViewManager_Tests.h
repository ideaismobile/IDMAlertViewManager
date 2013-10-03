//
//  IDMAlertViewManager_Tests.h
//  IDMAlertViewManager
//
//  Created by Flavio Caetano on 10/3/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import "IDMAlertViewManager.h"

#define kDEFAULT_DISMISS_INDEX 17672

@interface IDMAlertViewManager ()

#pragma mark - Properties

/**
 *  The priority of the current alert visible. If there's none, it's `INFINITY`.
 */
@property (nonatomic) IDMAlertPriority currentPriority;

/**
 *  The success block to be called when the visible alert view gets dismissed.
 */
@property (nonatomic, strong) IDMAlertViewSuccessBlock successBlock;

/**
 *  The failure block to be called when the visible alert view gets dismissed by any reason different than the user.
 */
@property (nonatomic, strong) IDMAlertViewFailureBlock failureBlock;

/**
 *  The title for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureTitle;

/**
 *  The text message for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureText;

/**
 *  The "other buttons" array for dismissing the default connection failure alert.
 */
@property (nonatomic, strong) NSArray *buttonsArray;

/**
 *  The visible alert view.
 */
@property (nonatomic, strong) UIAlertView *alertView;

/**
 *  Indicates if the current alert view is visible. Necessary because [UIAlertView show] might be called, but it's `isVisible` is yet `NO`.
 */
@property (nonatomic) BOOL isAlertViewVisible;

#pragma mark - Private Methods Declaration

/**
 *  Initializes the shared instance for the singleton.
 */
- (id)initSuper;

/**
 *  Clears the volatile properties like `successBlock`, `failureBlock` and `currentPriority`.
 */
- (void)clearVolatileProperties;

/**
 *  Check the importance of the current alert priority, if any, against the given one. If this priority is higher, dismiss the current alert.
 *
 *  @param priority A IDMAlertPriority
 */
- (BOOL)isMoreImportantThanPriority:(IDMAlertPriority)priority;

/**
 *  Returns the shared instance for the singleton. Initializes it if it's nil.
 */
+ (IDMAlertViewManager *)sharedInstance;

/**
 *  Inits another IDMAlertViewManager
 */
+ (void)_reinit;

/**
 *  Simulates the user clicking to dismiss a alert view.
 *
 *  @warning For testing purposes only!
 */
+ (void)simulateDismissalClick;

@end
