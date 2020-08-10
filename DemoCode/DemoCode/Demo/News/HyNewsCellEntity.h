//
//  HyNewsCellEntity.h
//  DemoCode
//
//  Created by huangyi on 2017/8/9.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyNewsCellEntity : HyEntity

@property (nonatomic, copy)   NSString  *url;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSArray   *imgsrc;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic, assign) Class  cellClass;
@property (nonatomic, copy) NSString *imageUrlStr;
@property (nonatomic, copy) NSAttributedString *titleAttr;

@end

NS_ASSUME_NONNULL_END
