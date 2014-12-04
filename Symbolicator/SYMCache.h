//
//  SYMCache.h
//  Symbolicator
//
//  Created by Sergey Sedov on 04/12/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMCache : NSObject

+ (void) cacheFodler: (NSURL *) folderURL;
+ (NSURL *) valueForVersion: (NSString *) version;

@end
