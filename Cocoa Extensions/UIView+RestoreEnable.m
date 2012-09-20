//
//  UIView+RestoreEnable.m
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 21.08.12.
//
//

#import "UIView+RestoreEnable.h"

@implementation UIView (RestoreEnable)

- (void)restoreEnable
{
    NSArray *views = [self subviews];
    if ([self respondsToSelector:@selector(enableToRestore)]) {
        self.userInteractionEnabled = YES;
    }
    
    for (UIView *aView in views) {
        if ([aView respondsToSelector:@selector(restoreEnable)]) {
            [aView restoreEnable];
        }
    }
}

@end
