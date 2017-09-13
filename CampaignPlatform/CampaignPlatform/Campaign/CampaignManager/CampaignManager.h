//
//  CampaignManager.h
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampaignManager : NSObject

+ (CampaignManager *)sharedManager;

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost;
- (void)addExposure:(NSString *)campaignID;
- (void)addPurchase:(NSString *)campaignID;

@end
