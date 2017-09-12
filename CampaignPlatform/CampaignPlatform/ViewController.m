//
//  ViewController.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 11..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "ViewController.h"
#import "CampaignViewController.h"

@interface ViewController () {
    NSMutableArray *campaigns;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getCampaigns];
}

- (IBAction)getCampaigns {
    [[APIManager sharedManager] getCampaigns:kInformStr locationID:@"main" success:^(NSURLSessionTask *task, id obj) {
        campaigns = [obj[@"campaigns"] mutableCopy];
        campaigns = [[campaigns sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            return [obj2[@"campaign_order"] compare:obj1[@"campaign_order"]];
        }] mutableCopy];
        [self presentCampaigns];
        
    } failFromServer:nil completion:nil];
}

- (UIViewController* )getPresentedVC {
    UIViewController *vc = self;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)presentCampaigns {
    if (campaigns.count) {
        CampaignViewController *vc = [CampaignViewController new];
        [vc setInfo:campaigns.lastObject];
        [campaigns removeLastObject];
        [vc setModalPresentationStyle:(UIModalPresentationOverCurrentContext)];
        [self.getPresentedVC presentViewController:vc animated:YES completion:^{
            [self presentCampaigns];
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
