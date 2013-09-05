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
 *	Although this enum sets a cluster of priorities, any integer above zero may be used.
 */
typedef NS_ENUM(NSUInteger, IDMAlertPriority)
{
	/**
	 *  The highest priority (**0**). Use only in case of emergency.
	 */
	IDMAlertPriorityDEFCON	= 0,
	
	/**
	 *  High priority for the alerts (**5**)
	 */
	IDMAlertPriorityHigh	= 5,
	
	/**
	 *  The default priority (**10**)
	 */
	IDMAlertPriorityMedium	= 10,
	
	/**
	 *  Low priority (**20**)
	 */
	IDMAlertPriorityLow		= 20
};

/**
 *  Indicates the error codes for when alerts fail.
 */
typedef NS_ENUM(NSInteger, IDMAlertError)
{
	/**
	 *  Indicates that the alert failed because another with higher priority was popped.
	 */
	IDMAlertErrorHigherPriorityAlert
};

/**
 *  An `UIAlertView` manager to handle different priorities alerts. Also terminates with the problem of having multiple alerts being displayed above one another.
 *
 *	No more than one `UIAlertView` is visible at a time. If two alerts with the same priority pops, only the first arrived stay visible. The second one is dismissed calling the `errorBlock`, if any.
 *	If comes an alert with higher priority than the visible one, the old is dismissed and the new one is displayed.
 */
@interface IDMAlertViewManager : NSObject <UIAlertViewDelegate>

/**
 *  Sets the title and text for the default connection failure alert.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
 */
+ (void)setDefaultConnectionErrorTitle:(NSString *)title text:(NSString *)text;

/**
 *  Sets the title, text and dismiss buttons for the default connection failure alert.
 *
 *  @param title        The UIAlertView title
 *  @param text         The UIAlertView text message
 *  @param buttonsArray A NSArray of NSStrings with dismiss buttons for the UIAlertView
 */
+ (void)setDefaultConnectionErrorTitle:(NSString *)title text:(NSString *)text otherButtons:(NSArray *)buttonsArray;

#pragma mark - Displaying Alerts
/** @name Displaying Alerts */

/**
 *  Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
 *
 *  @see setDefaultConnectionErrorTitle:text:
 *  @see setDefaultConnectionErrorTitle:text:otherButtons:
 */
+ (void)showDefaultConnectionFailureAlert;

/**
 *  Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is popped, the `failureBlock` is called.
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
 *  @see setDefaultConnectionErrorTitle:text:
 *  @see setDefaultConnectionErrorTitle:text:otherButtons:
 */
+ (void)showDefaultConnectionAlertWithSuccess:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title` and `text` and the default priority `IDMAlertPriorityMedium`.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
 *
 *	@see showAlertWithTitle:text:priority:
 *	@see showAlertWithTitle:text:priority:success:failure:otherButtons:
 */
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text;

/**
 *  Shows an alert with the given `title`, `text` and `priority`. If an alert with lower priority than this is currently visible, it gets dismissed and this alert takes it's place.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
 *  @param priority The alert priority
 *
 *	@see showAlertWithTitle:text:priority:success:failure:otherButtons:
 */
+ (void)showAlertWithTitle:(NSString *)title text:(NSString *)text priority:(IDMAlertPriority)priority;

/**
 *  Shows an alert with the given `title` and `text` and the default priority `IDMAlertPriorityMedium`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is popped, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
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
 *	@see showAlertWithTitle:text:priority:success:failure:
 *	@see showAlertWithTitle:text:priority:success:failure:otherButtons:
 */
+ (void)showAlertWithTitle:(NSString *)title
					  text:(NSString *)text
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title`, `text` and `priority`.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is popped, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
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
 *	@see showAlertWithTitle:text:priority:success:failure:otherButtons:
 */
+ (void)showAlertWithTitle:(NSString *)title
					  text:(NSString *)text
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock;

/**
 *  Shows an alert with the given `title`, `text`, `priority` and `otherButtons` for dismissing the UIAlertView.
 *
 *  When dismissed, the `successBlock` is called with the index for the clicked button.
 *  If an alert with higher priority is popped, the `failureBlock` is called.
 *
 *  @param title The UIAlertView title
 *  @param text  The UIAlertView text message
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
					  text:(NSString *)text
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock
			  otherButtons:(NSArray *)buttonsArray;

#pragma mark - Dismissing Alerts
/** @name Dismissing Alerts */

/**
 *  Dismiss the visible UIAlertView, if any.
 *
 *  @param animated A BOOL indicating if the dismissal should be animated.
 */
+ (void)dismiss:(BOOL)animated;


@end
