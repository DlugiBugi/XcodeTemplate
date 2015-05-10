//
//  NetworkLogger.m
//  XcodeTemplate
//
//  Created by Jakub Dlugosz on 10.05.2015.
//  Copyright (c) 2015 CodeSurf. All rights reserved.
//

#import "NetworkLogger.h"

#import "AFURLConnectionOperation.h"
#import "AFURLSessionManager.h"
#import <ReplayRequest/NSURLRequest+replayRequest.h>
static NetworkLogger* _logger;


static NSURLRequest * AFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    if ([[notification object] isKindOfClass:[AFURLConnectionOperation class]]) {
        request = [(AFURLConnectionOperation *)[notification object] request];
    } else if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    }
    
    return request;
}
@interface NetworkLogger()

- (void)networkRequestDidStart:(NSNotification *)notification;
- (void)networkRequestDidFinish:(NSNotification *)notification;
@end

@implementation NetworkLogger



+(NetworkLogger*)sharedLogger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _logger = [NetworkLogger new];
    });
    
    return _logger;
}


-(void)start
{
    [self stop];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
    
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
#endif
}
-(void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)networkRequestDidStart:(NSNotification *)notification
{
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    
     NSLog(@"%@",[request curlRequest]);
}

- (void)networkRequestDidFinish:(NSNotification *)notification
{
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    NSURLResponse *response = [notification.object response];
    NSError *error = [notification.object error];
    
    if (!request && !response) {
        return;
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    
    id responseObject = nil;
    if ([[notification object] respondsToSelector:@selector(responseString)]) {
        responseObject = [[notification object] responseString];
    } else if (notification.userInfo) {
        responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    }
    
    if (error)
    {
        NSLog(@"%@ \n\n [Error] %@ '%@' (%ld): %@",[request curlRequest], [request HTTPMethod], [[response URL] absoluteString], (long)responseStatusCode, error);
    }
    else
    {
        NSLog(@"%@ \n\n %ld '%@': %@ %@",[request curlRequest], (long)responseStatusCode, [[response URL] absoluteString], responseHeaderFields, responseObject);
    }
}


@end
