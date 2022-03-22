//
//  ShareViewModel.h
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/22/22.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareViewModel : NSObject
@property(nonatomic, strong) ShareModel *model;
+ (instancetype)viewModelWithModel:(ShareModel *)model;
@end

NS_ASSUME_NONNULL_END
