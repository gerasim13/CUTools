//
//  NSDictionary+Archive.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 05.08.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "NSDictionary+Archive.h"

@implementation NSDictionary (Archive)
- (NSString*)tempPath {
    NSString *tmpPath = [NSString stringWithFormat:@"%@nsdictionary", NSTemporaryDirectory()];
    // Cleanup
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:NULL];
    return tmpPath;
}

- (NSString*)archive {
    NSMutableData   *data     = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    NSString        *path     = [self tempPath];
    [archiver encodeObject:self forKey:@"NSDictionary"];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
    [data release];
    [archiver release];
    
    return path;
}

+ (NSDictionary*)unacrhive:(NSString*)path {
    NSData            *data       = [[NSMutableData alloc]initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary      *dictionaty = [unarchiver decodeObjectForKey:@"NSDictionary"];
    [unarchiver finishDecoding];
    [unarchiver release];
    [data release];
    
    return dictionaty;
}



@end
