//
//  NSObject+PerformBlock.h
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 31.08.12.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)
- (void)performBlock:(void (^)())block afterDelay:(double)delay;
- (void)performBlock:(void (^)(id arg))block withObject:(id)object afterDelay:(double)delay;
- (void)performBlock:(void (^)())block;
@end
