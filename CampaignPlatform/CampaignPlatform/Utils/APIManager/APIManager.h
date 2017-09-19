//
//  APIManager.h
//
//  Created by hyeongyun on 2016. 7. 25..
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^FormDataBlock)(id<AFMultipartFormData> formData);
typedef void (^ProgressBlock)(NSProgress *uploadProgress);
typedef void (^NetworkSucBlock)(NSURLSessionTask *task, id obj);
typedef void (^SimpleBlock)();
typedef void (^ServiceResponseBlock)(NSDictionary *response, NSError *error);

@interface APIManager : NSObject

@property (atomic, strong) UIAlertController *alertcon;
@property (atomic, strong) NSString *serverHost;
@property (atomic, strong) NSString *appID;
@property (atomic, strong) NSString *deviceID;
@property (atomic, strong) SimpleBlock failNetworking;

+ (APIManager *)sharedManager;

- (void)postDeviceInfo:(NSString*)inform;

- (void)getCampaigns:(NSString*)inform locationID:(NSString *)locationID
             success:(NetworkSucBlock)success failFromServer:(NetworkSucBlock)failure completion:(SimpleBlock)completion;

- (void)postAnalytics:(NSString*)inform analytics:(NSArray *)analytics success:(NetworkSucBlock)success;

@end
