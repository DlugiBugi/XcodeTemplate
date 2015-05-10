//
//  NetworkManager.m
//  XcodeTemplate
//
//  Created by Jakub Dlugosz on 10.05.2015.
//  Copyright (c) 2015 CodeSurf. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkConstants.h"
@implementation NetworkManager

static NetworkManager* _instance;

+(NetworkManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NetworkManager new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _apiJSONSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURLPath]];
        _apiFORMSSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURLPath]];
        
        
        [_apiJSONSessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_apiJSONSessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        
        [_apiFORMSSessionManager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [_apiFORMSSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }
    
    return self;
}

@end
