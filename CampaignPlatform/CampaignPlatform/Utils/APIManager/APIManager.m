//
//  FBAPIManager.m
//
//  Created by hyeongyun on 2016. 7. 25..
//
//

#import "APIManager.h"

@interface APIManager() {
    AFHTTPSessionManager *manager;
    AFHTTPSessionManager *jsonSerializerManager;
    BOOL checkVersion;
    NSString *svr_host;
}

@end

@implementation APIManager

+ (APIManager *)sharedManager{
    static dispatch_once_t pred;
    static APIManager *sharedInstance = nil;

    dispatch_once(&pred, ^{
        sharedInstance = [[APIManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        // do init here
        svr_host = @"http://211.253.28.194/";
        svr_host = @"http://192.168.100.104:30022/";
        _alertcon = [UIAlertController
                     alertControllerWithTitle:NSLocalizedString(@"global_popup_title", nil)
                     message:NSLocalizedString(@"network_disconnected", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *goSetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"network_settings", nil) style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                            }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"global_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [_alertcon addAction:goSetAction];
        [_alertcon addAction:cancelAction];
        
        manager = [AFHTTPSessionManager manager];
        jsonSerializerManager = [AFHTTPSessionManager manager];
        
        jsonSerializerManager.requestSerializer = [AFJSONRequestSerializer serializer];
        jsonSerializerManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [[manager requestSerializer] setValue:[[[NSLocale preferredLanguages] valueForKey:@"description"] componentsJoinedByString:@","]
                           forHTTPHeaderField:@"Accept_Language"];
        [[jsonSerializerManager requestSerializer] setValue:[[[NSLocale preferredLanguages] valueForKey:@"description"] componentsJoinedByString:@","]
                                         forHTTPHeaderField:@"Accept_Language"];
    }
    return self;
}

- (void)failNetworking:(NSString*)inform {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_alertcon.presentingViewController) {
            UIViewController *vc = [UIApplication.sharedApplication.windows.firstObject.rootViewController my_visibleViewController];
            if ([vc isKindOfClass:[UIAlertController class]] && [[(UIAlertController*)vc title] isEqualToString:NSLocalizedString(@"global_popup_title", nil)])
                return;
            [vc presentViewController:_alertcon animated:YES completion:nil];
        }
    });
}

- (void)defaultGet:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
           success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    [[AFHTTPSessionManager manager] GET:url parameters:parameters progress:nil
                                success:^(NSURLSessionTask *task, id obj) {
                                    DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
                                    if (successCallback)
                                        successCallback(task, obj);
                                    if(completion)
                                        completion();
                                }
                                failure:^(NSURLSessionTask *operation, NSError *error){
                                    DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
                                    if(completion)
                                        completion();
                                    [self failNetworking:inform];
                                }];
}

- (void)get:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
    success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    
    [manager GET:[NSString stringWithFormat:@"%@%@",svr_host, url] parameters:parameters progress:nil
         success:^(NSURLSessionTask *task, id obj){
             DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
             if ([obj[@"code"] intValue]) {
                 if (failureCallback)
                     failureCallback(task, obj);
                 else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:url message:obj[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert DShow];
                 }
             }
             else {
                 if (successCallback)
                     successCallback(task, obj);
             }
             if(completion)
                 completion();
         }
         failure:^(NSURLSessionTask *operation, NSError *error){
             DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
             if(completion)
                 completion();
             [self failNetworking:inform];
         }];
}

- (void)post:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
    formData:(FormDataBlock)formDataCallback progress:(ProgressBlock)progressCallback
     success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    
    [manager POST:[NSString stringWithFormat:@"%@%@",svr_host, url] parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData){if(formDataCallback) formDataCallback(formData);}
         progress:^(NSProgress *uploadProgress){if(progressCallback) progressCallback(uploadProgress);}
          success:^(NSURLSessionTask *task, id obj){
              DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
              if ([obj[@"code"] intValue]) {
                  if (failureCallback)
                      failureCallback(task, obj);
                  else {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:url message:obj[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert DShow];
                  }
              }
              else {
                  if (successCallback)
                      successCallback(task, obj);
              }
              if(completion)
                  completion();
          }
          failure:^(NSURLSessionDataTask *operation, NSError *error){
              DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
              if(completion)
                  completion();
              [self failNetworking:inform];
          }];
}

- (void)postJsonSerializer:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
                   success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    [jsonSerializerManager POST:[NSString stringWithFormat:@"%@%@",svr_host, url] parameters:parameters
                       progress:nil
                        success:^(NSURLSessionTask *task, id obj){
                            DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
                            if ([obj[@"code"] intValue]) {
                                if (failureCallback)
                                    failureCallback(task, obj);
                                else {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:url message:obj[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alert DShow];
                                }
                            }
                            else {
                                if (successCallback)
                                    successCallback(task, obj);
                            }
                            if(completion)
                                completion();
                        }
                        failure:^(NSURLSessionTask *operation, NSError *error){
                            DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
                            if(completion)
                                completion();
                            [self failNetworking:inform];
                        }];
}

- (void)getCampaigns:(NSString*)inform locationID:(NSString *)locationID
             success:(NetworkSucBlock)success failFromServer:(NetworkSucBlock)failure completion:(SimpleBlock)completion; {
    [self get:[NSString stringWithFormat:@"api/apps/1/locations/%@/campaigns", locationID]
   parameters:nil inform:inform success:success failFromServer:failure completion:completion];
}
@end
