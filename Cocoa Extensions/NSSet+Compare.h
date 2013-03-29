//
//  NSSet+Compare.h
//  MolodejjTV
//
//  Created by Павел Литвиненко on 29.03.13.
//
//

#import <Foundation/Foundation.h>

@interface NSSet (Compare)

- (BOOL)containsIdenticalObject:(NSObject*)object;
- (id)identicalObject:(NSObject*)object;

@end
