//
//  ViewController.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 11..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[APIManager sharedManager] getCampaigns:kInformStr appID:@"1" locationID:@"main" success:^(NSURLSessionTask *task, id obj) {
        DLog(@"%@", obj);
    } failFromServer:nil completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
