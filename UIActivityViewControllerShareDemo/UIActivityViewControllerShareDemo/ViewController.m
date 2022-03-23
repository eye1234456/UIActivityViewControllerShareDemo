//
//  ViewController.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import "ViewController.h"
#import "ShareDemoTableViewCell.h"
#import "MBProgressHUD+JDragon.h"
#import "UIImage+AppIcon.h"
#import "ShareModel.h"
#import "ShareViewModel.h"
#import "MyAlertView.h"

typedef NS_ENUM(NSInteger, StyleShowType) {
    StyleShowTypeSystem, // 使用系统默认的方式，只能配置分享内容的方式
    StyleShowTypeCustom, // 使用自定义的，可以自动配置icon、title、subtitle、分享内容的方式
    StyleShowTypeMix, // 混合模式
};

@interface ViewController ()
@property(nonatomic, assign) StyleShowType showType;
@property(nonatomic, assign) BOOL showAlertView;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIButton *rightBtn;


@property(nonatomic, weak) MyAlertView *alertView;
@property(nonatomic, weak) UIActivityViewController *activityVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];

    ///
    [self.tableView registerNib:[UINib nibWithNibName:@"ShareDemoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShareDemoTableViewCell"];
    [self initData];
    [self.tableView reloadData];
    
}

#pragma mark - UI

- (void)initData {
    
    UIImage *icon = [UIImage imageNamed:@"myicon"];
    // text
    NSString *shareText = @"hello world";
    [self.dataList addObject:[ShareModel modelWithData:shareText]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:nil showSubTitle:nil data:shareText]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:@"主标题" showSubTitle:nil data:shareText]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:nil showSubTitle:@"子标题" data:shareText]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:shareText]];
    // url
    NSURL *shareUrl = [NSURL URLWithString:@"http://www.baidu.com"];
    [self.dataList addObject:[ShareModel modelWithData:shareUrl]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:nil showSubTitle:nil data:shareUrl]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:@"主标题" showSubTitle:nil data:shareUrl]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:nil showSubTitle:@"子标题" data:shareUrl]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:shareUrl]];
    // image
    UIImage *shareImage = [UIImage imageNamed:@"img"];
    [self.dataList addObject:[ShareModel modelWithData:shareImage]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:nil showSubTitle:nil data:shareImage]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:@"主标题" showSubTitle:nil data:shareImage]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:nil showTitle:nil showSubTitle:@"子标题" data:shareImage]];
    [self.dataList addObject:[ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:shareImage]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareDemoTableViewCell" forIndexPath:indexPath];
    ShareModel *model = self.dataList[indexPath.row];
    
    cell.iconImageView.image = model.showIcon ?: [UIImage imageNamed:@"placeholder"];
    cell.titleLabel.text = model.showTitle ?: @"NULL";
    cell.subTitleLabel.text = model.showSubTitle ?: @"NULL";
    
    cell.dataImageView.hidden = YES;
    cell.dataLabel.hidden = YES;
    if (model.type == ShareModelTypeText) {
        cell.dataLabel.text = model.data;
        cell.dataLabel.hidden = NO;
    }else if (model.type == ShareModelTypeURL) {
        NSString *subTitle = [((NSURL *)model.data) absoluteString];
        cell.dataLabel.text = subTitle;
        cell.dataLabel.hidden = NO;
    }else if (model.type == ShareModelTypeImage) {
        UIImage *image = model.data;
        cell.dataImageView.image = image;
        cell.dataImageView.hidden = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareModel *model = self.dataList[indexPath.row];
    // 展示一个弹窗来做获取高的demo
    if (self.showAlertView) {
        MyAlertView *redView = [[MyAlertView alloc] initWithFrame:self.view.bounds];
        self.alertView = redView;
        [self.view addSubview:redView];
    }
    [self showNormalActivityWithModel:model];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - actions
- (void)showNormalActivityWithModel:(ShareModel *)model {
    // 分享的内容一定有
    // 固定保存一张图片+保存其他的
    NSArray *activityItems = @[];
    if (self.showType == StyleShowTypeSystem) {
        // 只能使用系统提供的默认方式的分享格式
        activityItems = @[model.data];
    }else if (self.showType == StyleShowTypeCustom) {
        // 任何类型都可以配置（展示用的【icon+title+subtitle】+ 分享的内容）
        activityItems = @[[ShareViewModel viewModelWithModel:model]];
    }else if (self.showType == StyleShowTypeMix){
        // 混合模式，可以同时分享多个内容
        activityItems = @[[UIImage imageNamed:@"img"],[ShareViewModel viewModelWithModel:model]];
    }else {
        activityItems = @[model.data];
    }
    
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    self.activityVC = activityVC;
    __weak typeof(self) weakself = self;
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (activityType == nil && activityError == nil && completed == NO) {
            NSLog(@"关闭分享弹窗");
        }else if (activityType != nil && completed) {
           // 分享成功
           [MBProgressHUD showSuccessMessage:@"操作成功"];
       }else if (activityType != nil && activityError != nil) {
           // 操作失败
           [MBProgressHUD showErrorMessage:activityError.localizedDescription];

       }else if (activityType != nil && completed == NO) {
           // 操作失败
           // 备忘录取消操作
           // 短信操作
       }else {

       }
        // 有弹窗时，activity出现，需要把弹窗提高
        if (weakself.showAlertView) {
            [weakself updateShareFrameChangeWithType:activityType completed:completed returnedItems:returnedItems activityError:activityError];
        }
        
    };
    
    [self presentViewController:activityVC animated:YES completion:^{
        // 有弹窗时，activity出现，需要把弹窗提高
        if (weakself.showAlertView) {
            [weakself updateAlertShow];
        }
    }];
}

- (void)updateAlertShow {
    // 默认中心点在view的中心上
    CGFloat oldCenterY = self.view.bounds.size.height/2;
    // 升起后中心底部靠近弹窗，中心点=底部弹窗高度+redView高度/2
    CGFloat newCenterY = self.activityVC.view.bounds.size.height + self.alertView.redView.bounds.size.height/2;
    CGFloat offsetY = oldCenterY - newCenterY;
    // 最高移动是redView顶部与self.view顶部碰在一起
    CGFloat maxOffset = -(self.view.bounds.size.height-self.alertView.redView.bounds.size.height)/2;
    if (offsetY > 0) {
        offsetY = 0;
    }
    if (offsetY < maxOffset) {
        offsetY = maxOffset;
    }
    [self.alertView setOffsetY:offsetY];
}

- (void)updateShareFrameChangeWithType:(UIActivityType)activityType
                             completed:(BOOL)completed
                         returnedItems:(NSArray *)returnedItems
                         activityError:(NSError *)activityError {
    if (activityType == nil && activityError == nil && completed == NO) {
        // 关闭了，需要展示
        [self.alertView setOffsetY:0];
    }else if (activityType != nil && completed) {
       // 分享成功,
        [self.alertView setOffsetY:0];
   }else if (activityType != nil && activityError != nil) {
       // 操作失败
   }else if (activityType != nil && completed == NO) {
       // 操作失败
       // 备忘录取消操作
       // 短信操作
   }else {

   }
}

- (void)changeIndex {
    self.showType = self.segmentedControl.selectedSegmentIndex;
}
- (void)rightBtnClick {
    self.rightBtn.selected = !self.rightBtn.isSelected;
    self.showAlertView = self.rightBtn.isSelected;
}

#pragma mark - getter
- (UISegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"系统",@"自定义",@"混合"]];
        _segmentedControl.tintColor = [UIColor redColor];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(changeIndex) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = UIColor.lightGrayColor;
        _rightBtn.frame = CGRectMake(0, 0, 70, 40);
        [_rightBtn setTitle:@"不展示Alert" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"展示Alert" forState:UIControlStateSelected];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
