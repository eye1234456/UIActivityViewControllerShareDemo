//
//  ShareModel.h
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ShareModelType) {
    ShareModelTypeUnknow = 0, // 未知
    ShareModelTypeText, // 纯文本
    ShareModelTypeURL, // URL地址
    ShareModelTypeImage, // 图片
    ShareModelTypeOther, // 其他
};

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
@property(nonatomic, assign, readonly) ShareModelType type;

+ (instancetype)modelWithData:(id __nonnull)data;
+ (instancetype)modelWithShowIcon:(UIImage *__nullable)showIcon
                        showTitle:(NSString * __nullable)showTitle
                     showSubTitle:(NSString *__nullable)showSubTitle
                             data:(id __nonnull)data;


- (NSString *)shareTypeDesc;
@end

NS_ASSUME_NONNULL_END
