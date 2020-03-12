//
//  HyPhotoLibraryTool.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyPhotoLibraryTool.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


@implementation HyPhotoLibraryTool

+ (void)saveImage:(UIImage *)image
        assetName:(NSString * _Nullable)assetName
       completion:(void(^_Nullable)(UIImage *image, NSError *error))completion {
    
    if (!image) { return; }
    
    NSString *photoAssetName = assetName ?: @"视频相册";
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    __block NSString *assetID = nil;
    __block PHAssetCollection *assetCollection = nil;
    [library performChanges:^{
        
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        assetCollection = [self findAssetCollectionWithName:photoAssetName];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
            NSError *err = nil;
            [library performChangesAndWait:^{
                [self addAssetWithAssetID:assetID assetCollection:assetCollection];
            } error:&err];
            
            !completion ?: completion(err ? nil : image, err);
        } else {
            !completion ?: completion(nil, error);
        }
    }];
}

+ (void)saveVideoWithUrl:(NSURL *)url
               assetName:(NSString *_Nullable)assetName
              completion:(void(^_Nullable)(NSURL *url, NSError *error))completion {
    
    NSString *photoAssetName = assetName ?: @"视频相册";
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError *error = nil;
        
        __block NSString *assetID = nil;
        [library performChangesAndWait:^{
            assetID = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
        } error:&error];
        
        PHAssetCollection *assetCollection = nil;
        if (!error) {
            assetCollection = [self findAssetCollectionWithName:photoAssetName];
        }
        
        if (assetID && assetCollection) {
            [library performChangesAndWait:^{
                [self addAssetWithAssetID:assetID assetCollection:assetCollection];
            } error:&error];
        }
        
        !completion ?: completion(error ? url : nil, error);
    });
}

+ (PHAssetCollection *)findAssetCollectionWithName:(NSString *)name {
        
    PHFetchResult <PHAssetCollection*> *assetCollections =
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                             subtype:PHAssetCollectionSubtypeAlbumRegular
                                             options:nil];
    
    __block PHAssetCollection *assetCollection = nil;
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.localizedTitle isEqualToString:name]) {
            assetCollection = obj;
            *stop = YES;
        }
    }];
    
    if (!assetCollection) {
        NSError *error = nil;
        __block NSString *assetCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            assetCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        
        if (assetCollectionID) {
            assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionID] options:nil].firstObject;
        }
    }
    
    return assetCollection;
}

+ (void)addAssetWithAssetID:(NSString *)assetID
            assetCollection:(PHAssetCollection *)assetCollection {
    
    if (assetID && assetCollection) {
        PHFetchResult<PHAsset *> *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [assetCollectionChangeRequest addAssets:asset];
    }
}

@end
