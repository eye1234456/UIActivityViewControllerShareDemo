//
//  BaseTableViewController.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataList[indexPath.row];
    NSString *title = dict[@"title"];
    cell.textLabel.text = title;
    return cell;
}

#pragma mark - getter
- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
@end
