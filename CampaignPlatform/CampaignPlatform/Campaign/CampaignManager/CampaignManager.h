//
//  CampaignManager.h
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnalyticsTypeTag) {
    AnalyticsTypeExposure = 1,
    AnalyticsTypeClick,
    AnalyticsTypePurchase
};

@interface CampaignManager : NSObject

+ (CampaignManager *)sharedManager;

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost;
- (void)addAnalytics:(NSString *)campaignID type:(AnalyticsTypeTag)type;

@end
