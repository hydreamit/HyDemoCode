//
//  HyNewsModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyNewsModel : HyModel

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
