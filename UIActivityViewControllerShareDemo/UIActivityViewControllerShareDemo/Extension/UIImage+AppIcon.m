//
//  UIImage+AppIcon.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import "UIImage+AppIcon.h"

@implementation UIImage (AppIcon)
/** 获取app的icon图标名称 */
+ (UIImage *)getAppIcon {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    UIImage *icon = [UIImage imageNamed:iconLastName];
    return icon;
}
@end
