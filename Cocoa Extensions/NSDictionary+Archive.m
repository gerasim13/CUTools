//
//  NSDictionary+Archive.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 05.08.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "NSDictionary+Archive.h"

@implementation NSDictionary (Archive)

- (NSString*)tempPath
{
    NSString *tmpPath = [NSString stringWithFormat:@"%@nsdictionary", NSTemporaryDirectory()];
    // Cleanup
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:NULL];
    return tmpPath;
}

- (NSString*)archiveToFile
{
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

+ (NSDictionary*)unacrhiveFromFile:(NSString*)path
{
    NSData            *data       = [[NSMutableData alloc]initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary      *dictionaty = [unarchiver decodeObjectForKey:@"NSDictionary"];
    [unarchiver finishDecoding];
    [unarchiver release];
    [data release];
    
    return dictionaty;
}

- (void)archiveWithIdentifier:(NSString*)identifier
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:identifier];
}

+ (NSDictionary*)unarchiverWithIdentifier:(NSString*)identifier
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    if (data != nil) {
        NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]) {
            return [NSDictionary dictionaryWithDictionary:dictionary];
        }
    }
    return [NSDictionary dictionary];
}


@end
