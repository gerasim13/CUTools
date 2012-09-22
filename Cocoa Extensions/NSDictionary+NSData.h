//
//  NSDictionary+NSData.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSData)
+ (NSDictionary*)dictionaryWithContentsOfData:(NSData*)data;
@end
