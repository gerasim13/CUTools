//
//  CUPropertiesViewController.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 25.05.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUPropertiesViewCell.h"

@protocol CUPropertiesViewControllerDelegate;

@interface CUPropertiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CUPropertiesViewCellDelegate> {
    id<CUPropertiesViewControllerDelegate> delegate;
    UITableView    *optionsView;
    NSString       *plistName;
    NSMutableArray *parametersList;
}

@property (nonatomic, assign) id<CUPropertiesViewControllerDelegate> delegate;

- (id)initWithPlistName:(NSString*)parametersListName;
- (void)updateTableView:(NSNotification*)notification;
- (void)reloadTableView:(NSNotification*)notification;
- (void)closeView;

@end

@protocol CUPropertiesViewControllerDelegate <NSObject>
- (void)propertiesViewControllerWillHide:(CUPropertiesViewController*)controller;
@end
