//
//  NSDictionary+Archive.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 05.08.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Archive)
- (NSString*)archive;
+ (NSDictionary*)unacrhive:(NSString*)path;
@end
