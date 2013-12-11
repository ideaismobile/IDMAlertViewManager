//
//  IDMAlertViewManager.h
//  IDMAlertViewManager
//
//  Created by Flavio Caetano on 9/5/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The block gets called when the user dismisses a `UIAlertView`. `Similar to alertView:clickedButtonAtIndex:`
 *
 *  @param selectedIndex The index of the clicked button.
 */
typedef void (^IDMAlertViewSuccessBlock)(NSUInteger selectedIndex);

/**
 *  The error block that's called when a `UIAlertView` is dissmissed by any reason other than the user's interaction. Will be called if an alert with higher priority than the visible one gets called.
 *
 *  @param error The error that occurred.
 *
 *	@see IDMAlertError
 */
typedef void (^IDMAlertViewFailureBlock)(NSError *error);

/**
 *  An enum of unsigned integers to assing alerts' priorities. The lower the integer, the higher the priority.
 *
 *  Although this enum sets a cluster of priorities, any integer above or equal to zero may be used.
 */
typedef NS_ENUM(NSUInteger, IDMAlertPriority)
{
	/**
	 *  The highest priority. Use only in case of emergency.
	 */
	IDMAlertPriorityDEFCON	= 0,
	
	/**
	 *  High priority for the alerts
	 */
	IDMAlertPriorityHigh	= 10,
	
	/**
	 *  The default priority
	 */
	IDMAlertPriorityMedium	= 25,
	
	/**
	 *  Low priority
	 */
	IDMAlertPriorityLow		= 50
};

/**
 *  Indicates the error codes for when alerts fail.
 */
typedef NS_ENUM(NSInteger, IDMAlertError)
{
	/**
	 *  Indicates that the alert failed because another with higher priority was prompted.
	 */
	IDMAlertErrorHigherPriorityAlert,
	/**
	 *  When the alert is dismissed programmatically.
	 */
	IDMAlertErrorFailedDismiss
};

/**
 *  An `UIAlertView` manager to handle different priorities alerts. Also terminates the problem of having multiple alerts being displayed above one another.
 *
 *	No more than one `UIAlertView` is visible at a time. If two alerts with the same priority pops, only the first arrived stay visible. The second one is dismissed calling the `errorBlock`, if any.
 *	If comes an alert with higher priority than the visible one, the old is dismissed and the new one is displayed.
 */
@interface IDMAlertViewManager : NSObject <UIAlertViewDelegate>

/**
 *  Sets the title and message for the default connection failure alert.
 *
 *  @param title	The UIAlertView title
 *  @param message  The UIAlertView text message
 */
+ (void)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message;

/**
 *  Sets the title, message and dismiss buttons for the default connection failure alert.
 *
 *  @param title        The UIAlertView title
 *  @param message      The UIAlertView text message
 *  @param buttonsArray A NSArray of NSStrings with dismiss buttons for the UIAlertView
 */
+ (void)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttonsArray;

/**
 *  Changes the default message for the main dismissal button. If not set, the default value is "OK"
 *
 *  @param dismissButtonMessage The new text for the main dismissal button.
 */
+ (void)setDefaultDismissalButton:(NSString *)dismissButtonMessage;

#pragma mark - Displaying Alerts
/** @name Displaying Alerts */

/**
 *  Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
 *
 *  @see setDefaultConnectionErrorTitle:message:
 *  @see setDefaultConnectionErrorTitle:message:buttons:
 */
+ (void)showDefaultConnectionFailureAlert;

/**
 *  Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is prompted, the `failureBlock` is called.
 *
 *  @param successBlock The block gets called when the user dismisses a `UIAlertView`. `Similar to alertView:clickedButtonAtIndex:`
 *
 *  - *selectedIndex*: The index of the clicked button.
 *
 *  @param failureBlock The error block that's called when a `UIAlertView` is dissmissed by any reason other than the user's interaction. Will be called if an alert with higher priority than the visible one gets called.
 *
 *  - *error*: The error that occurred.
 *
 *	@see IDMAlertError
 *
 *  @see setDefaultConnectionErrorTitle:message:
 *  @see setDefaultConnectionErrorTitle:message:buttons:
 */
+ (void)showDefaultConnectionAlertWithSuccess:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
 *
 *  @param title The UIAlertView title
 *  @param message  The UIAlertView text message
 *
 *	@see showAlertWithTitle:message:priority:
 *	@see showAlertWithTitle:message:priority:success:failure:buttons:
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  Shows an alert with the given `title`, `message` and `priority`. If an alert with lower priority than this is currently visible, it gets dismissed and this alert takes it's place.
 *
 *  @param title The UIAlertView title
 *  @param message  The UIAlertView text message
 *  @param priority The alert priority
 *
 *	@see showAlertWithTitle:message:priority:success:failure:buttons:
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message priority:(IDMAlertPriority)priority;

/**
 *  Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is prompted, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param message  The UIAlertView text message
 *
 *  @param successBlock The block gets called when the user dismisses a `UIAlertView`. `Similar to alertView:clickedButtonAtIndex:`
 *
 *  - *selectedIndex*: The index of the clicked button.
 *
 *  @param failureBlock The error block that's called when a `UIAlertView` is dissmissed by any reason other than the user's interaction. Will be called if an alert with higher priority than the visible one gets called.
 *
 *  - *error*: The error that occurred.
 *
 *	@see IDMAlertError
 *
 *	@see showAlertWithTitle:message:priority:success:failure:
 *	@see showAlertWithTitle:message:priority:success:failure:buttons:
 */
+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title`, `message` and `priority`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is prompted, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param message  The UIAlertView text message
 *	@param priority The alert priority
 *
 *  @param successBlock The block gets called when the user dismisses a `UIAlertView`. `Similar to alertView:clickedButtonAtIndex:`
 *
 *  - *selectedIndex*: The index of the clicked button.
 *
 *  @param failureBlock The error block that's called when a `UIAlertView` is dissmissed by any reason other than the user's interaction. Will be called if an alert with higher priority than the visible one gets called.
 *
 *  - *error*: The error that occurred.
 *
 *	@see IDMAlertError
 *
 *	@see showAlertWithTitle:message:priority:success:failure:buttons:
 */
+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title`, `message`, `priority` and `buttons` for dismissing the UIAlertView.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is prompted, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param message  The UIAlertView text message
 *	@param priority The alert priority
 *
 *  @param successBlock The block gets called when the user dismisses a `UIAlertView`. `Similar to alertView:clickedButtonAtIndex:`
 *
 *  - *selectedIndex*: The index of the clicked button.
 *
 *  @param failureBlock The error block that's called when a `UIAlertView` is dissmissed by any reason other than the user's interaction. Will be called if an alert with higher priority than the visible one gets called.
 *
 *  - *error*: The error that occurred.
 *
 *	@see IDMAlertError
 *  @param buttonsArray A NSArray of NSStrings with dismiss buttons for the UIAlertView
 */
+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock
				   buttons:(NSArray *)buttonsArray;

/**
 *  Shows a custom alert view with the given priority.
 *
 *  @param alertView An instance of UIAlertView
 *  @param priority  The alert priority
 */
+ (BOOL)showAlertView:(UIAlertView *)alertView priority:(IDMAlertPriority)priority;

#pragma mark - Dismissing Alerts
/** @name Dismissing Alerts */

/**
 *  Dismiss the visible UIAlertView, if any.
 *
 *  @param animated A BOOL indicating if the dismissal should be animated.
 */
+ (void)dismiss:(BOOL)animated;


@end
