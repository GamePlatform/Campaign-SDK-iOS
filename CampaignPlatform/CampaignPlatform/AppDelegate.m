//
//  AppDelegate.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 11..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *serverHost;
    serverHost = @"http://211.253.28.194/";
    serverHost = @"http://192.168.100.104:30022/";
    [[CampaignManager sharedManager] startCampaignAdvisor:@"1" withServer:serverHost];
    [[APIManager sharedManager] setFailNetworking:^{
        DLog(@"");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertController *alertcon = [UIAlertController
//                                           alertControllerWithTitle:NSLocalizedString(@"global_popup_title", nil)
//                                           message:NSLocalizedString(@"network_disconnected", nil) preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *goSetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"network_settings", nil) style:UIAlertActionStyleDefault
//                                                                handler:^(UIAlertAction *action){
//                                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                                                                }];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"global_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
//            [alertcon addAction:goSetAction];
//            [alertcon addAction:cancelAction];
//
//            UIViewController *vc = [UIApplication.sharedApplication.windows.firstObject.rootViewController my_visibleViewController];
//            if ([vc isKindOfClass:[UIAlertController class]] && [[(UIAlertController*)vc title] isEqualToString:NSLocalizedString(@"global_popup_title", nil)])
//                return;
//
//            [vc presentViewController:alertcon animated:YES completion:nil];
//        });
    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DLog(@"");
}


@end
