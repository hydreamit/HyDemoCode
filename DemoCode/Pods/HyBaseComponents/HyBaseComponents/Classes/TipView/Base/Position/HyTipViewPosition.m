//
//  HyTipViewPosition.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewPosition.h"
#import "HyTipViewProtocol.h"

@interface HyTipViewPosition ()
@property (nonatomic,strong) id parameter;
@property (nonatomic,copy) void(^positonBlock)(UIView<HyTipViewProtocol> *);
@end

@implementation HyTipViewPosition

+ (id<HyTipViewPositionProtocol> (^)(id _Nullable parameter))position {
    return ^id<HyTipViewPositionProtocol> (id _Nullable parameter){
        HyTipViewPosition *position = [[self alloc] init];
        position.parameter = parameter;
        return position;
    };
}

+ (id<HyTipViewPositionProtocol>)positionWithBlock:(void(^)(UIView<HyTipViewProtocol> *tipView))block {
    HyTipViewPosition *position = [[self alloc] init];
    position.positonBlock = [block copy];
    return position;
}

- (void (^)(UIView<HyTipViewProtocol> *tipView))positionAction {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView) {
        __strong typeof(_self) self = _self;
                
        if (self.positonBlock) {
            self.positonBlock(tipView);
        } else {
            CGRect rect = tipView.contentView.frame;
                            
            if ([self.parameter isKindOfClass:NSString.class]) {
                 NSString *type = ((NSString *)self.parameter).lowercaseString;
                if ([type isEqualToString:@"top"]) {
                    
                    rect.origin.x = (tipView.bounds.size.width -  rect.size.width) / 2;
                    rect.origin.y = 0;
                    
                } else if ([type isEqualToString:@"left"]) {
                    
                    rect.origin.x = 0;
                    rect.origin.y = (tipView.bounds.size.height -  rect.size.height) / 2;
                    
                } else if ([type isEqualToString:@"bottom"]) {
                    
                   rect.origin.x = (tipView.bounds.size.width -  rect.size.width) / 2;
                   rect.origin.y = tipView.bounds.size.height - tipView.contentView.bounds.size.height;
                    
                } else if ([type isEqualToString:@"right"]) {
                    
                   rect.origin.x = tipView.bounds.size.width - tipView.contentView.bounds.size.width;
                   rect.origin.y = (tipView.bounds.size.height -  rect.size.height) / 2;
                    
                } else if ([type isEqualToString:@"center"]) {
                    
                   rect.origin.x = (tipView.bounds.size.width -  rect.size.width) / 2;
                   rect.origin.y = (tipView.bounds.size.height -  rect.size.height) / 2;
                }
            }
            tipView.contentView.frame = rect;
        }
    };
}

@end
