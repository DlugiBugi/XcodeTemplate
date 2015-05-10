//
//  NetworkLogger.h
//  XcodeTemplate
//
//  Created by Jakub Dlugosz on 10.05.2015.
//  Copyright (c) 2015 CodeSurf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkLogger : NSObject

+(NetworkLogger*)sharedLogger;

-(void)start;
-(void)stop;

@end