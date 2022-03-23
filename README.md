# UIActivityShareDemo
UIActivityShareDemo

> 前言
> 之前在app内做跨app分享内容时，一般都会引入各种常见三方app的开发sdk，或者使用已经集成了各种三方分享的sdk如友盟啥的，但是现在越来越多的app开始使用苹果系统自带的分享功能，其中用到的类是`UIActivityViewController`

demo: 
https://github.com/eye1234456/UIActivityViewControllerShareDemo

![普通分享](https://raw.githubusercontent.com/eye1234456/UIActivityViewControllerShareDemo/main/snapshots/normal.gif)

![自定义分享](https://raw.githubusercontent.com/eye1234456/UIActivityViewControllerShareDemo/main/snapshots/custom.gif)

####一、普通使用方式
优点：调用简单，系统会自动根据分享的内容展示不同的UI样式及可分享的三方app和系统功能

缺点：展示出的系统UI弹窗内容固定，自定义差

```
- (void) showNormalActivityShare {
	NSArray *activityItems = @[];
	// 分享的是普通文本
	activityItems = @[@"hello world"];
	// 分享的是链接
	//activityItems = @[[NSURL URLWithString:@"http://www.baidu.com"]];
	// 分享的是图片
	//activityItems = @[[UIImage imageNamed:@"xxx"]];
	// 分享多个内容
	//activityItems = @[[UIImage imageNamed:@"xxx"],[NSURL URLWithString:@"http://www.baidu.com"],@"hello world"];
	
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	__weak typeof(self) weakself = self;
	activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
	  if (activityType == nil && activityError == nil && completed == NO) {
	      NSLog(@"关闭分享弹窗");
	   }else if (activityType != nil && completed) {
	           // 分享成功
	           
	  }else if (activityType != nil && activityError != nil) {
	           // 操作失败];
	  }else if (activityType != nil && completed == NO) {
	           // 操作失败
	           // 备忘录取消操作
	  }else {
	
	   }
	};
	    
	[self presentViewController:activityVC animated:YES completion:^{
	    
	}];
}
```

####二、`LinkPresentation`、`LPLinkMetadata`自定义分享头部的icon、主标题、子标题方式
优点：调用相对复杂，但能自定义头部的icon、主标题、子标题，适合大部分应用常见

缺点：相对复杂

原理：对默认分享的字符串、链接或图片等内容进行下包装，分享一个包装的内容，包装的类要实现`UIActivityItemSource`协议

具体实现如下：

1、UI及数据model

```
@interface ShareModel : NSObject
/// 用于展示分享弹出顶部左侧的图片
@property(nonatomic, strong) UIImage * __nullable showIcon;
/// 用于展示分享弹窗顶部的大标题
@property(nonatomic, copy) NSString * __nullable showTitle;
/// 用于展示分享弹出顶部大标题下面的小标题
@property(nonatomic, copy) NSString * __nullable showSubTitle;
/// 真正分享的内容（如果没有配置show的三个字段，直接使用data进行自动分享展示）
/// NSURL、NSString、UIImage。。。
@property(nonatomic, strong) id data;
@end

@implementation ShareModel
@end
```

2、封装的实现`UIActivityItemSource`分享Model

```
#import <UIKit/UIKit.h>
#import "ShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareViewModel : NSObject
@property(nonatomic, strong) ShareModel *model;
+ (instancetype)viewModelWithModel:(ShareModel *)model;
@end

NS_ASSUME_NONNULL_END
```

```
#import "ShareViewModel.h"
#import <UIKit/UIKit.h>
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
```

3、真正分享

```
- (void)showCustomActivityShare {
	      NSArray *activityItems = @[];
		// 分享的是普通文本,指定icon、主标题、子标题、分享的文本
		ShareModel *originShareTextModel = [ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:shareText];
		ShareViewModel *wrapShareShareTextModel = [ShareViewModel viewModelWithModel: originShareText];
		activityItems = @[wrapShareShareTextModel];
		// 分享的是链接
		//ShareModel *originShareURLModel = [ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:[NSURL URLWithString:@"http://www.baidu.com"]];
		//ShareViewModel *wrapShareShareURLModel = [ShareViewModel viewModelWithModel: originShareURLModel];
		//activityItems = @[wrapShareShareURLModel];
		// 分享的是图片
		//activityItems = @[[UIImage imageNamed:@"xxx"]];
			//ShareModel *originShareImageModel = [ShareModel modelWithShowIcon:icon showTitle:@"主标题" showSubTitle:@"子标题" data:[UIImage imageNamed:@"xxx"]];
		//ShareViewModel *wrapShareShareImageModel = [ShareViewModel viewModelWithModel: originShareImageModel];
		//activityItems = @[wrapShareShareImageModel];
		// 分享多个内容
		
		
		UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
		__weak typeof(self) weakself = self;
		activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
		  if (activityType == nil && activityError == nil && completed == NO) {
		      NSLog(@"关闭分享弹窗");
		   }else if (activityType != nil && completed) {
		           // 分享成功
		           
		  }else if (activityType != nil && activityError != nil) {
		           // 操作失败];
		  }else if (activityType != nil && completed == NO) {
		           // 操作失败
		           // 备忘录取消操作
		  }else {
		
		   }
		};
		    
		[self presentViewController:activityVC animated:YES completion:^{
		    
		}];
	}
}
```


-----
过程中遇到的问题
> 1、在模拟器运行时，分享的弹窗一直展示英文，没有根据模拟器设置成中文展示成中文，这是需要在`Info.plist`里设置语言根据设备来展示

增加 `Localized resources can be mixed`设置成`YES`

---

> 2、在分享图片时没有出现`存储图像`的操作，这是因为我创建的demo项目没有配置使用相册的权限，在`Info.plist`里配置下就好了

增加 `Privacy - Photo Library Additions Usage Description`设置成`$(DISPLAY_NAME)需要你的同意，才能添加图片到相册`

增加 `Privacy - Photo Library Usage Description`设置成`$(DISPLAY_NAME)想要访问您的相册,请允许`

![info.plist配置](https://raw.githubusercontent.com/eye1234456/UIActivityViewControllerShareDemo/main/snapshots/info.png)