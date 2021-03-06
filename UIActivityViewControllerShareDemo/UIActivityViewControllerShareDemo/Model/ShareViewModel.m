//
//  ShareViewModel.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import "ShareViewModel.h"
#import <LinkPresentation/LPLinkMetadata.h>

@interface ShareViewModel() <UIActivityItemSource>

@end

@implementation ShareViewModel
+ (instancetype)viewModelWithModel:(ShareModel *)model {
    ShareViewModel *vm = [ShareViewModel new];
    vm.model = model;
    return vm;
}
#pragma mark - UIActivityItemSource protocol procedures to support sharesheet
/**
 * 告诉系统分享的类型同类型的数据
 */
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.model.data;
}
/**
 * 真正操作时的回调，表示要操作什么数据
 */
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    // 真正分享的内容
    return self.model.data;
}

/**
 * UIActivityViewController弹窗上展示的icon、主标题、子标题配置
 */
- (LPLinkMetadata *)activityViewControllerLinkMetadata:(UIActivityViewController *)activityViewController  API_AVAILABLE(ios(13.0)){
    
    LPLinkMetadata * metaData = [[LPLinkMetadata alloc] init];
    // 只有分享的是URL或UIImage时，设置title才生效
    // text时，一直固定显示Plain Text
    if (self.model.showTitle) {
        metaData.title = self.model.showTitle;
    }
    
    if (self.model.showSubTitle) {
        metaData.originalURL = [NSURL fileURLWithPath:self.model.showSubTitle];
    }
    
    // 设置icon
    if (self.model.showIcon) {
        UIImage *iconImage = self.model.showIcon;
        NSItemProvider *iconProvider = [[NSItemProvider alloc] initWithObject:iconImage];
        metaData.iconProvider = iconProvider;
    }
    
    return metaData;
}
@end
