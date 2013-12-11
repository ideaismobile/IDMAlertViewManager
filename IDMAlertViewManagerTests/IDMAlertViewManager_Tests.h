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
 *  The title for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureTitle;

/**
 *  The text message for the default connection failure alert.
 */
@property (nonatomic, strong) NSString *defaultConnectionFailureMessage;

/**
 *  The default text of the dismissal button. If not set, the default value is `OK`
 */
@property (nonatomic, strong) NSString *defaultDismissalButtonText;

/**
 *  The buttons array for dismissing the default connection failure alert.
 */
@property (nonatomic, strong) NSArray *buttonsArray;

/**
 *  The visible alert view.
 */
@property (nonatomic, strong) UIAlertView *alertView;

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