//
//  NSSet+Filter.h
//  MolodejjTV
//
//  Created by Павел Литвиненко on 29.03.13.
//
//

#import <Foundation/Foundation.h>

@interface NSSet (Filter)

- (id)filteredObjectWithPredicate:(NSPredicate*)predicate;

@end
