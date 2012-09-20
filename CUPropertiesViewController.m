//
//  CUPropertiesViewController.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 25.05.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "CUPropertiesViewController.h"

@implementation CUPropertiesViewController
@synthesize delegate;

- (id)initWithPlistName:(NSString*)parametersListName {
    if ((self = [self init])) {
        plistName = parametersListName;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        // Create navigation controller for sync view
        UINavigationController *nCnrl = [[[UINavigationController alloc] initWithRootViewController:self] autorelease];
        // Set navigation bar style
        nCnrl.modalPresentationStyle = UIModalPresentationFormSheet;
        nCnrl.navigationBar.barStyle = UIBarStyleBlackOpaque;
        // Add close button to view
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
        self.navigationItem.rightBarButtonItem = closeButton;
        [closeButton release];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Create new table view
    optionsView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    optionsView.dataSource = self;
    optionsView.delegate = self;
    
    [self.view addSubview:optionsView];
    
    // Update content of table
    [self reloadTableView:nil];
}

- (void)dealloc {
    // Release array with buttons
    [parametersList release];
    // Release table view
    [optionsView release];
    [super dealloc];
}


#pragma mark Public methods

- (void)updateTableView:(NSNotification*)notification {
    [optionsView reloadData];
}

- (void)reloadTableView:(NSNotification*)notification {
    if (parametersList!=nil) {
        [parametersList release];
    }
    // Load list with buttons
    NSString            *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    parametersList            = [[dict objectForKey:@"Properties"] retain];
    [dict release];
    // Update content of table
    [self updateTableView:nil];
}

- (void)closeView {
    [delegate propertiesViewControllerWillHide:self];
}


#pragma mark Private methods

- (NSObject*)objectFromSelector:(SEL)selector forCellData:(NSDictionary*)cellData {
    if ([self respondsToSelector:selector]) {
        NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
        NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setSelector:selector];
        if ([signature numberOfArguments] > 2 && cellData!=nil) [invocation setArgument:&cellData atIndex:2];
        [invocation invokeWithTarget:self];
        
        // Check return value type
        const char *returnType = [signature methodReturnType];
        if (IS_BOOL(returnType)) {
            // BOOL value
            BOOL returnVal;
            [invocation getReturnValue:&returnVal];
            return [NSNumber numberWithBool:returnVal];
        } else if (IS_ANY_OF_INT(returnType)) {
            // int value
            int returnVal;
            [invocation getReturnValue:&returnVal];
            return [NSNumber numberWithInt:returnVal];
        } else {
            // Object
            id returnObj;
            [invocation getReturnValue:&returnObj];
            return returnObj;
        }
    }
    return [NSNull null];
}

- (NSObject*)updateValue:(NSObject*)value forCellData:(NSDictionary*)cellData {
    NSString *valSuperclass = NSStringFromClass([value superclass]);
    if (([valSuperclass isEqualToString:@"NSMutableString"] || [valSuperclass isEqualToString:@"__NSCFString"])) {
        NSRange startRange = [(NSString*)value rangeOfString:@"@selector("];
        NSRange endRange   = [(NSString*)value rangeOfString:@")"];
        int lengt    = endRange.location - startRange.location - startRange.length;
        int location = startRange.location + startRange.length;

        if (startRange.location != NSNotFound) {
            NSString *selString = [(NSString*)value substringWithRange:NSMakeRange(location, lengt)];
            SEL       selector  = NSSelectorFromString(selString);
            // Get from Selector
            NSObject *retValue = [self objectFromSelector:selector forCellData:cellData];
            NSString *retSuper = NSStringFromClass([retValue superclass]);
            if (!([retSuper isEqualToString:@"NSMutableString"] || [retSuper isEqualToString:@"__NSCFString"])) {
                return retValue;
            } else {
                // Clean string from selector and garbage
                NSCharacterSet *garbage = [NSCharacterSet characterSetWithCharactersInString:@"@()"];
                value = [(NSString*)value stringByReplacingOccurrencesOfString:selString withString:@""];
                value = [(NSString*)value stringByReplacingOccurrencesOfString:@"selector" withString:@""];
                value = [[(NSString*)value componentsSeparatedByCharactersInSet:garbage] componentsJoinedByString:@""];
                // Append returned string
                value = [(NSString*)value stringByAppendingString:(NSString*)retValue];
            }
        }
    }
    return value;
}

- (NSDictionary*)updatedCellDataFromData:(NSDictionary*)cellData {
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:cellData];
    
    NSObject *label = [mutDic objectForKey:@"Label"];
    if (label != nil) {
        label = [self updateValue:label forCellData:cellData];
        [mutDic setObject:label forKey:@"Label"];
    }
    
    NSObject *value = [mutDic objectForKey:@"Value"];
    if (value != nil) {
        value = [self updateValue:value forCellData:cellData];
        [mutDic setObject:value forKey:@"Value"];
    }
    
    return [NSDictionary dictionaryWithDictionary:mutDic];
}

- (NSDictionary*)cellDataAtIndexPath:(NSIndexPath*)indexPath {
    // Set detail text
    NSDictionary *sectionDic = [parametersList objectAtIndex:indexPath.section];
    NSArray      *datasArr   = [sectionDic objectForKey:@"Items"];
    NSDictionary *cellData   = [datasArr objectAtIndex:indexPath.row];
    return [self updatedCellDataFromData:cellData];
}


#pragma mark UITableViewController delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    CUPropertiesViewCell *cell = (CUPropertiesViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.type == CellPropertiesTypeBlank && [self respondsToSelector:cell.targetSel]) {
        [self performSelector:cell.targetSel withObject:cell.data];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UITableViewController data source

- (void)configureCell:(CUPropertiesViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.delegate = self;
    // Load data
    NSDictionary *cellData = [self cellDataAtIndexPath:indexPath];
    [cell setData:cellData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [parametersList count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *sectionDic = [parametersList objectAtIndex:section];
    NSObject            *buttonsArr = [sectionDic objectForKey:@"Items"];
    if (buttonsArr!=nil) {
        NSString *arrSuperclass = NSStringFromClass([buttonsArr superclass]);
        if ([arrSuperclass isEqualToString:@"NSMutableArray"] || [arrSuperclass isEqualToString:@"NSArray"]) {
            return [(NSArray*)buttonsArr count];
        } else if ([arrSuperclass isEqualToString:@"NSMutableString"]) {
            // Get number of objects from selector
            NSMutableArray *newArr = (NSMutableArray*)[self objectFromSelector:NSSelectorFromString((NSString*)buttonsArr) forCellData:nil];
            if ((NSObject*)newArr != [NSNull null]) {
                [sectionDic setObject:newArr forKey:@"Items"];
                return [newArr count];
            } else {
                // Remove section from plist
                [parametersList removeObject:sectionDic];
                // Update content of table
                [optionsView reloadData];
            }
        }
    }
    return 0;
}

- (NSString*)footerForSection:(NSInteger)section {
    if (section < (int)parametersList.count) {
        NSDictionary *sectionDic = [parametersList objectAtIndex:section];
        NSString     *footer     = [sectionDic valueForKey:@"Footer"];
        if (footer!=nil) {
            return footer;
        }
    }
    return nil;
}

- (NSString*)headerForSection:(NSInteger)section {
    if (section < (int)parametersList.count) {
        NSDictionary *sectionDic = [parametersList objectAtIndex:section];
        NSString     *header     = [sectionDic valueForKey:@"Header"];
        if (header!=nil) {
            return header;
        }
    }
    return nil;
}

- (NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section {
    return [self footerForSection:section];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return [self headerForSection:section];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self headerForSection:section]!=nil) {
        return 40.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if ([self footerForSection:section]!=nil) {
        return 70.0;
    }
    return 0.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"PropertiesViewCell";
    CUPropertiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[CUPropertiesViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
