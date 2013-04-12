//
//  NSObject+AWHSwizzle.h
//  MolodejjTV
//
//  Created by Павел Литвиненко on 01.04.13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (void)swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel;

@end
