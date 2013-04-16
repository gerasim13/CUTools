//
//  CUMacros.h
//  MolodejjTV
//
//  Created by Павел Литвиненко on 30.03.13.
//
//

#ifndef MolodejjTV_CUMacros_h
#define MolodejjTV_CUMacros_h

// System version
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] floatValue] <= v)
#define IS_IOS5_OR_LESS SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(5.9)
#define IS_IOS5_OR_GREATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(5.0)
#define IS_IOS6_OR_GREATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(6.0)

#endif
