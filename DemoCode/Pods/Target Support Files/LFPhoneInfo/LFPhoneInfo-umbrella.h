#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LFPhoneDefine.h"
#import "LFPhoneInfo.h"
#import "LFReachability.h"
#import "UIDevice+LFDeviceInfo.h"

FOUNDATION_EXPORT double LFPhoneInfoVersionNumber;
FOUNDATION_EXPORT const unsigned char LFPhoneInfoVersionString[];

