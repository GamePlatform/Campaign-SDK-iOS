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
typedef void (^ServiceResponseBlock)(NSDictionary *response, NSError *error);

@interface APIManager : NSObject

@property (atomic, strong) UIAlertController *alertcon;

+ (APIManager *)sharedManager;

- (void)getCampaigns:(NSString*)inform appID:(NSString *)appID locationID:(NSString *)locationID
             success:(NetworkSucBlock)success failFromServer:(NetworkSucBlock)failure completion:(SimpleBlock)completion;

@end
