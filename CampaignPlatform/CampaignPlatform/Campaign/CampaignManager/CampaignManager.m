//
//  CampaignManager.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "CampaignManager.h"
#import "CampaignAPIManager.h"

@interface CampaignManager() {
    NSMutableArray *analytics;
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
        analytics = [NSMutableArray new];
    }
    return self;
}

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost {
    NSString* deviceKey = @"CampaignDeviceID";
    if (![[NSUserDefaults standardUserDefaults] stringForKey:deviceKey])
        [[NSUserDefaults standardUserDefaults] setObject:NSUUID.UUID.UUIDString forKey:deviceKey];
    [[CampaignAPIManager sharedManager] setDeviceID:[[NSUserDefaults standardUserDefaults] stringForKey:deviceKey]];
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
    [analytics addObject:@{@"campaign_id":campaignID, @"type":@(type)}];
    if (analytics.count > 3) {
        [[CampaignAPIManager sharedManager] postAnalytics:kInformStr analytics:analytics success:^(NSURLSessionTask *task, id obj) {
            analytics = [NSMutableArray new];
        }];
    }
}

@end
