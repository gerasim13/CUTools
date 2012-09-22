//
//  NSSet+NSUserDefaults.h
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 23.09.12.
//
//

#import <Foundation/Foundation.h>

@interface NSSet (Archive)
- (void)addObject:(NSObject*)object toSetWithIdentifier:(NSString*)identifier;
- (void)archiveWithIdentifier:(NSString*)identifier;
+ (NSSet*)unarchiverSetWithIdentifier:(NSString*)identifier;
@end
