//
//  UIViewController+Campaign.h
//
//  Created by hyeongyun on 2016. 7. 26..
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Campaign)

- (void)dismissAllPresentedViewController:(UIViewController*)presentedViewController completion:(SimpleBlock)completion;
- (UIViewController *)my_visibleViewController;

@end
