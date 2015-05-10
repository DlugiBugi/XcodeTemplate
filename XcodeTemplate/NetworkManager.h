//
//  NetworkManager.h
//  XcodeTemplate
//
//  Created by Jakub Dlugosz on 10.05.2015.
//  Copyright (c) 2015 CodeSurf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

/**
 *  Main network operations class - handles all API calls
 */
@interface NetworkManager : NSObject


/**
 *  Singleton accessor methof
 *
 *  @return An instance of a manager
 */
+(NetworkManager *)sharedManager;


/**
 *  Session manager used to call API with JSON request/esponse
 */
@property(strong,readonly)AFHTTPSessionManager* apiJSONSessionManager;


/**
 *  Session manager used to call  API with FORMS request/response
 */
@property(strong,readonly)AFHTTPSessionManager* apiFORMSSessionManager;

@end
