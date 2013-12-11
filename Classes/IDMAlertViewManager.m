//
//  IDMAlertViewManager.m
//  IDMAlertViewManager
//
//  Created by Flavio Caetano on 9/5/13.
//  Copyright (c) 2013 Ideais. All rights reserved.
//

// random num
#define kDEFAULT_DISMISS_INDEX	17672
#define kFAILED_DISMISS_INDEX	94836

#define kHIGHER_ALERT_MESSAGE	@"Higher Priority Alert: %d"
#define kNIL_OUTPUTS_MESSAGE    @"Message and Title cannot be nil"
#define kFAILED_DISMISS_MESSAGE	@"Programmatically Dismissed Alert"

#import "IDMAlertViewManager.h"

#import "UIAlertView+ProxyDelegate.h"

/**
 *  The singleton's shared instance.
 */
static IDMAlertViewManager *_sharedInstance;

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

#pragma mark - Implementation

@implementation IDMAlertViewManager

// init
- (id)init
{
	[NSException raise:@"Singleton Implemantation" format:@"Can't instantiate %@", NSStringFromClass([self class])];
	return nil;
}

// Initializes the shared instance for the singleton.
- (id)initSuper
{
	if (self = [super init])
	{
		[self clearVolatileProperties];
		self.defaultDismissalButtonText = @"OK";
	}
	
	return self;
}

#pragma mark - Class Methods

// Sets the title and message for the default connection failure alert.
+ (BOOL)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message
{
	return [IDMAlertViewManager setDefaultConnectionErrorTitle:title message:message buttons:@[]];
}

// Sets the title, message and dismiss buttons for the default connection failure alert.
+ (BOOL)setDefaultConnectionErrorTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttonsArray
{
    if ((message == nil && title == nil) || buttonsArray == nil)
    {
		return NO;
    }
    
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	avm.defaultConnectionFailureTitle	= title;
	avm.defaultConnectionFailureMessage	= message;
	avm.buttonsArray					= buttonsArray;
    
    return YES;
}

// Changes the default message for the main dismissal button. If this mehod is not called, the message is `OK`
+ (BOOL)setDefaultDismissalButton:(NSString *)dismissButtonMessage
{
    if (dismissButtonMessage == nil)
    {
        return NO;
    }
    
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	avm.defaultDismissalButtonText = dismissButtonMessage;
    
    return YES;
}

#pragma mark - Displaying Alerts

// Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
+ (BOOL)showDefaultConnectionFailureAlert
{
	return [IDMAlertViewManager showDefaultConnectionAlertWithSuccess:nil failure:nil];
}

// Shows the default connection error alert. This alert is displayed with the default priority `IDMAlertPriorityMedium`.
+ (BOOL)showDefaultConnectionAlertWithSuccess:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	return [IDMAlertViewManager showAlertWithTitle:avm.defaultConnectionFailureTitle
                                           message:avm.defaultConnectionFailureMessage
                                          priority:IDMAlertPriorityMedium
                                           success:successBlock
                                           failure:failureBlock
                                           buttons:avm.buttonsArray];
}

// Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
	return [IDMAlertViewManager showAlertWithTitle:title message:message priority:IDMAlertPriorityMedium];
}

// Shows an alert with the given `title`, `message` and `priority`. If an alert with lower priority than this is currently visible, it gets dismissed and this alert takes it's place.
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message priority:(IDMAlertPriority)priority
{
	return [IDMAlertViewManager showAlertWithTitle:title
                                           message:message
                                          priority:priority
                                           success:nil
                                           failure:nil];
}

// Shows an alert with the given `title` and `message` and the default priority `IDMAlertPriorityMedium`.
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	return [IDMAlertViewManager showAlertWithTitle:title
                                           message:message
                                          priority:IDMAlertPriorityMedium
                                           success:successBlock
                                           failure:failureBlock];
}

// Shows an alert with the given `title`, `message` and `priority`.
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message priority:(IDMAlertPriority)priority success:(IDMAlertViewSuccessBlock)successBlock failure:(IDMAlertViewFailureBlock)failureBlock
{
	return [IDMAlertViewManager showAlertWithTitle:title
                                           message:message
                                          priority:priority
                                           success:successBlock
                                           failure:failureBlock
                                           buttons:nil];
}

// Shows an alert with the given `title`, `message`, `priority` and `buttons` for dismissing the UIAlertView.
+ (BOOL)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
				  priority:(IDMAlertPriority)priority
				   success:(IDMAlertViewSuccessBlock)successBlock
				   failure:(IDMAlertViewFailureBlock)failureBlock
				   buttons:(NSArray *)buttonsArray
{
    if (message == nil && title == nil)
    {
		if (failureBlock)
		{
			NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:kNIL_OUTPUTS_MESSAGE] code:IDMAlertErrorNilOutputs userInfo:nil];
			failureBlock(error);
		}
		
		return NO;
    }
    
    UIAlertView *alertView  = [UIAlertView new];
	alertView.title         = title;
	alertView.message       = message;
    alertView.successBlock  = successBlock;
    alertView.failureBlock  = failureBlock;
    
    if (buttonsArray == nil || buttonsArray.count == 0)
    {
        IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
        buttonsArray = @[avm.defaultDismissalButtonText];
    }
	
	for (NSString *buttonTitle in buttonsArray)
	{
		[alertView addButtonWithTitle:buttonTitle];
	}
    
    return [IDMAlertViewManager showAlertView:alertView priority:priority];
}

//  Shows a custom alert view with the given priority.
+ (BOOL)showAlertView:(UIAlertView *)alertView priority:(IDMAlertPriority)priority
{
    IDMAlertViewManager *avm    = [IDMAlertViewManager sharedInstance];
    alertView.priority          = priority;
    
    if (avm.alertView == nil || alertView.priority < avm.alertView.priority)
    {
        [avm.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:NO];
        
        if (avm.alertView.failureBlock)
        {
            NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:kHIGHER_ALERT_MESSAGE, avm.alertView.priority] code:IDMAlertErrorHigherPriorityAlert userInfo:nil];
            avm.alertView.failureBlock(error);
        }
    }
    else
    {
		if (alertView.failureBlock)
		{
			NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:kHIGHER_ALERT_MESSAGE, alertView.priority] code:IDMAlertErrorHigherPriorityAlert userInfo:nil];
			alertView.failureBlock(error);
		}
        
        return NO;
    }
    
    if (alertView.delegate != avm)
    {
        alertView.originalDelegate = alertView.delegate;
    }
    alertView.delegate = avm;
    
    avm.alertView = alertView;
    [avm.alertView show];
    
    return YES;
}

#pragma mark - Dismissing Alerts

// Dismiss the visible UIAlertView, if any.
+ (void)dismiss:(BOOL)animated
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	
	[avm.alertView dismissWithClickedButtonIndex:kFAILED_DISMISS_INDEX animated:animated];
	[avm clearVolatileProperties];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self clearVolatileProperties];
    
	if (alertView.successBlock)
	{
		alertView.successBlock(buttonIndex);
	}
    
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self clearVolatileProperties];
    
	if (alertView.failureBlock && buttonIndex == kFAILED_DISMISS_INDEX)
	{
		NSError *error = [[NSError alloc] initWithDomain:kFAILED_DISMISS_MESSAGE code:IDMAlertErrorFailedDismiss userInfo:nil];
		alertView.failureBlock(error);
	}
    
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate alertViewCancel:alertView];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        return [alertView.originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    
    return YES;
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate didPresentAlertView:alertView];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.originalDelegate && [alertView.originalDelegate respondsToSelector:_cmd])
    {
        [alertView.originalDelegate willPresentAlertView:alertView];
    }
}

#pragma mark - Private Methods

// Clears the volatile properties like `successBlock`, `failureBlock` and `currentPriority`.
- (void)clearVolatileProperties
{
    self.alertView = nil;
}

// Returns the shared instance for the singleton. Initializes it if it's nil.
+ (IDMAlertViewManager *)sharedInstance
{
	if (_sharedInstance == nil)
	{
		[IDMAlertViewManager _reinit];
	}
	
	return _sharedInstance;
}

+ (void)_reinit
{
	_sharedInstance = [[IDMAlertViewManager alloc] initSuper];
}

+ (void)simulateDismissalClick
{
	IDMAlertViewManager *avm = [IDMAlertViewManager sharedInstance];
	[avm.alertView dismissWithClickedButtonIndex:kDEFAULT_DISMISS_INDEX animated:NO];
}

@end
