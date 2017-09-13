//
//  CampaignManager.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "CampaignManager.h"

@interface CampaignManager() {
    NSMutableDictionary *exposure;
    NSMutableDictionary *purchase;
}

@end

@implementation CampaignManager

+ (CampaignManager *)sharedManager {
    static dispatch_once_t pred;
    static CampaignManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[CampaignManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // do init here
        exposure = [NSMutableDictionary new];
        purchase = [NSMutableDictionary new];
    }
    return self;
}

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost {
    [[APIManager sharedManager] setAppID:appID];
    [[APIManager sharedManager] setServerHost:serverHost];
    [self performSelector:@selector(sendReport) withObject:nil afterDelay:300.f];
}

- (void)sendReport {
    [[APIManager sharedManager] postReport:kInformStr reportDictionary:@{@"exposure":exposure, @"purchase":purchase} success:^(NSURLSessionTask *task, id obj) {
        exposure = [NSMutableDictionary new];
        purchase = [NSMutableDictionary new];
    }];
    [self performSelector:@selector(sendReport) withObject:nil afterDelay:300.f];
}

- (void)addExposure:(NSString *)campaignID {
    exposure[campaignID] = @([exposure[campaignID] integerValue] + 1);
}

- (void)addPurchase:(NSString *)campaignID {
    purchase[campaignID] = @([purchase[campaignID] integerValue] + 1);
}

@end
