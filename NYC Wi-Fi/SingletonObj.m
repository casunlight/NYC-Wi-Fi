//
//  SingletonObj.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/5/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "SingletonObj.h"

@implementation SingletonObj
@synthesize gblStr;

+(SingletonObj *)singleObj{
    
    static SingletonObj * single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[SingletonObj alloc] init];
            
        }
        
    }
    return single;
}
@end
