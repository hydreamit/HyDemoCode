//
//  HyAVWriterTypedef.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#ifndef HyAVWriterTypedef_h
#define HyAVWriterTypedef_h


typedef NS_ENUM(NSUInteger, HyAVWriterType) {
    HyAVWriterTypeAudio,
    HyAVWriterTypeVideo,
    HyAVWriterTypeAudioVideo
};

typedef NS_ENUM(NSUInteger, HyAVWriterStatus) {
    HyAVWriterStatusNoRecording,
    HyAVWriterStatusRecording,
    HyAVWriterStatusPauseing,
    HyAVWriterStatusResuming
};



#endif /* HyAVWriterTypedef_h */
