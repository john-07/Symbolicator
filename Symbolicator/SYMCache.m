//
//  SYMCache.m
//  Symbolicator
//
//  Created by Sergey Sedov on 04/12/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMCache.h"

static NSMutableDictionary *dict;

@implementation SYMCache

+ (void) cacheFodler: (NSURL *) folderURL {
    dict = [@{} mutableCopy];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

    NSDate *date = [NSDate date];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:folderURL includingPropertiesForKeys:keys options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
        return YES;
    }];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        BOOL res = [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
        if (!res) {
            // handle error - skip
        } else if ([isDirectory boolValue]) {
            if ([url.pathExtension isEqualToString:@"dSYM"]) {
                NSURL *infoURL = [[url URLByAppendingPathComponent:@"Contents"] URLByAppendingPathComponent:@"Info.plist"];
                NSDictionary *info = [NSDictionary dictionaryWithContentsOfURL:infoURL];
                NSString *version = info[@"CFBundleVersion"];
                NSString *shortVersion = info[@"CFBundleShortVersionString"];
                if (version) {
                    dict[version] = url;
                }
                
                if (shortVersion) {
                    dict[shortVersion] = url;
                }
                
                [enumerator skipDescendants];
            } else if ([url.lastPathComponent isEqualToString:@"Products"]) {
                [enumerator skipDescendants];
            }
        }
    }
    
    NSLog(@"timing: %f", [[NSDate date] timeIntervalSinceDate:date]);
    
}

+ (NSURL *) valueForVersion: (NSString *) version {
    return dict[version];
}


@end
