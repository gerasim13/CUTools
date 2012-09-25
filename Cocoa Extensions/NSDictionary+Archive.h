//
//  NSDictionary+Archive.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 05.08.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Archive)
- (NSString*)archiveToFile;
+ (NSDictionary*)unacrhiveFromFile:(NSString*)path;
- (void)archiveWithIdentifier:(NSString*)identifier;
+ (NSDictionary*)unarchiverWithIdentifier:(NSString*)identifier;

@end
