//
//  ShareModel.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import "ShareModel.h"

@implementation ShareModel

+ (instancetype)modelWithData:(id __nonnull)data {
    return [self modelWithShowIcon:nil showTitle:nil showSubTitle:nil data:data];
}

+ (instancetype)modelWithShowIcon:(UIImage *__nullable)showIcon
                        showTitle:(NSString * __nullable)showTitle
                     showSubTitle:(NSString *__nullable)showSubTitle
                             data:(id __nonnull)data {
    ShareModel *model = [self new];
    model.showIcon = showIcon;
    model.showTitle = showTitle;
    model.showSubTitle = showSubTitle;
    model.data = data;
    return model;
}

- (ShareModelType)type {
    if ([self.data isKindOfClass:NSString.class]) {
        return ShareModelTypeText;
    }else if ([self.data isKindOfClass:NSURL.class]) {
        return ShareModelTypeURL;
    }else if ([self.data isKindOfClass:UIImage.class]) {
        return ShareModelTypeImage;
    }
    return ShareModelTypeUnknow;
}

- (NSString *)shareTypeDesc {
    if (self.type == ShareModelTypeText) {
        return @"share-text";
    }else if (self.type == ShareModelTypeURL) {
        return @"share-url";
    }else if (self.type == ShareModelTypeImage) {
        return @"share-image";
    }
    return @"share-unknown";
}
@end
