//
//  NSSet+NSUserDefaults.h
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 23.09.12.
//
//

#import <Foundation/Foundation.h>

@interface NSSet (Archive)

+ (id)setWithIdentifier:(NSString*)identifier;
+ (id)unarchiverSetWithIdentifier:(NSString*)identifier;

+ (BOOL)addObject:(id)object toSetWithIdentifier:(NSString*)identifier;
+ (BOOL)removeObject:(id)object fromSetWithIdentifier:(NSString*)identifier;
+ (BOOL)updateObject:(id)object inSetWithIdentifier:(NSString*)identifier;
- (void)archiveWithIdentifier:(NSString*)identifier;

@end
