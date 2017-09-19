//
//  CampaignManager.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "CampaignManager.h"
#import "CampaignAPIManager.h"

#define kdeviceKey @"CampaignDeviceID"
#define kanalyticsKey @"CampaignAnalytics"

@interface CampaignManager() {
//    NSMutableArray *analytics;
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
//        analytics = [NSMutableArray new];
    }
    return self;
}

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost {
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kdeviceKey])
        [[NSUserDefaults standardUserDefaults] setObject:NSUUID.UUID.UUIDString forKey:kdeviceKey];
    if (![[NSUserDefaults standardUserDefaults] arrayForKey:kanalyticsKey])
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kanalyticsKey];
    [[CampaignAPIManager sharedManager] setDeviceID:[[NSUserDefaults standardUserDefaults] stringForKey:kdeviceKey]];
    [[CampaignAPIManager sharedManager] setAppID:appID];
    [[CampaignAPIManager sharedManager] setServerHost:serverHost];
    [[CampaignAPIManager sharedManager] postDeviceInfo:kInformStr];
}

- (void)setFailNetworking:(SimpleBlock)failNetworking {
    [CampaignAPIManager.sharedManager setFailNetworking:failNetworking];
}

- (void)getCampaigns:(NSString *)locationID success:(NetworkSucBlock)success {
    [[CampaignAPIManager sharedManager] getCampaigns:kInformStr locationID:locationID success:success];
}

- (void)addAnalytics:(NSString *)campaignID type:(AnalyticsTypeTag)type {
    NSMutableArray* analyticsArr = [[[NSUserDefaults standardUserDefaults] arrayForKey:kanalyticsKey] mutableCopy];
    [analyticsArr addObject:@{@"campaign_id":campaignID, @"type":@(type)}];
    [[NSUserDefaults standardUserDefaults] setObject:analyticsArr forKey:kanalyticsKey];
    if (analyticsArr.count > 3) {
        [[CampaignAPIManager sharedManager] postAnalytics:kInformStr analytics:analyticsArr success:^(NSURLSessionTask *task, id obj) {
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kanalyticsKey];
        }];
    }
}

@end
