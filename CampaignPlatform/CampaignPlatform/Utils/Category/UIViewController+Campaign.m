//
//  UIViewController+Campaign.m
//
//  Created by hyeongyun on 2016. 7. 26..
//
//

#import "UIViewController+Campaign.h"

@implementation UIViewController (Campaign)

- (void)dismissAllPresentedViewController:(UIViewController*)originalVC completion:(SimpleBlock)completion {
    DLog(@"self: %@\nself.presentedViewController: %@", self, self.presentedViewController);
    
    if (self.presentedViewController)
        [self.presentedViewController dismissAllPresentedViewController:originalVC completion:completion];
    
    if (self != originalVC)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if (![self.presentedViewController isBeingDismissed]) {
        DLog(@"self: %@\n!isBeingDismissed", self);
        [originalVC dismissViewControllerAnimated:YES completion:completion];
    }
    else
        DLog(@"isBeingDismissed");
    /*
    NSMutableArray* VCArr = [@[] mutableCopy];
    UIViewController *VC = originalVC;
    while (VC) {
        [VCArr addObject:VC];
        VC = VC.presentedViewController;
    }
    for (NSInteger i = VCArr.count-1; i > 0; i--)
        [(UIViewController*)VCArr[i] dismissViewControllerAnimated:YES completion:nil];
    [originalVC dismissViewControllerAnimated:YES completion:completion];
     */
}

- (UIViewController *)my_visibleViewController {
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        // do not use method visibleViewController as the presentedViewController could beingDismissed
        return [[(UINavigationController *)self topViewController] my_visibleViewController];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [[(UITabBarController *)self selectedViewController] my_visibleViewController];
    }
    
    if (self.presentedViewController == nil || self.presentedViewController.isBeingDismissed) {
        return self;
    }
    
    return [self.presentedViewController my_visibleViewController];
}

@end
