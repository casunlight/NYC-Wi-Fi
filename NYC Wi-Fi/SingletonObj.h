//
//  SingletonObj.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonObj : NSObject

@property(nonatomic, strong) NSString * gblStr;

+(SingletonObj *)singleObj;

@end
