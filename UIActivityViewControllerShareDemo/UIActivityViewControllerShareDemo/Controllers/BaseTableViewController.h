//
//  BaseTableViewController.h
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

NS_ASSUME_NONNULL_END
