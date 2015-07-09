/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A view controller displaying an asset full screen.
  
 */

#import "MNAssetViewController.h"
#import "MNAssetViewCell.h"

@implementation CIImage (Convenience)
- (NSData *)aapl_jpegRepresentationWithCompressionQuality:(CGFloat)compressionQuality {
	static CIContext *ciContext = nil;
	if (!ciContext) {
		EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		ciContext = [CIContext contextWithEAGLContext:eaglContext];
	}
	CGImageRef outputImageRef = [ciContext createCGImage:self fromRect:[self extent]];
	UIImage *uiImage = [[UIImage alloc] initWithCGImage:outputImageRef scale:1.0 orientation:UIImageOrientationUp];
	if (outputImageRef) {
		CGImageRelease(outputImageRef);
	}
	NSData *jpegRepresentation = UIImageJPEGRepresentation(uiImage, compressionQuality);
	return jpegRepresentation;
}
@end


@interface MNAssetViewController () <PHPhotoLibraryChangeObserver>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end


@implementation MNAssetViewController

static NSString * const AssetCellReuseIdentifier = @"AssetCell";

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self updateImage];
//}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    if (!CGSizeEqualToSize(self.imageView.bounds.size, self.lastImageViewSize)) {
//        [self updateImage];
//    }
//}

//- (void)updateImage
//{
//    self.lastImageViewSize = self.imageView.bounds.size;
//    
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.imageView.bounds) * scale, CGRectGetHeight(self.imageView.bounds) * scale);
//    
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    
//    // Download from cloud if necessary
//    options.networkAccessAllowed = YES;
//    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = progress;
//            self.progressView.hidden = (progress <= 0.0 || progress >= 1.0);
//        });
//    };
//    
//    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
//        if (result) {
//            self.imageView.image = result;
//        }
//    }];
//}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        // check if there are changes to the album we're interested on (to its metadata, not to its collection of assets)
//        PHObjectChangeDetails *changeDetails = [changeInstance changeDetailsForObject:self.asset];
//        if (changeDetails) {
            // it changed, we need to fetch a new one
//            self.asset = [changeDetails objectAfterChanges];
//            
//            if ([changeDetails assetContentChanged]) {
//                [self updateImage];
//                
//                if (self.playerLayer) {
//                    [self.playerLayer removeFromSuperlayer];
//                    self.playerLayer = nil;
//                }
//            }
//        }
        
//    });
}

#pragma mark - Actions

- (void)applyFilterWithName:(NSString *)filterName
{
//    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
//    [options setCanHandleAdjustmentData:^BOOL(PHAdjustmentData *adjustmentData) {
//        return [adjustmentData.formatIdentifier isEqualToString:AdjustmentFormatIdentifier] && [adjustmentData.formatVersion isEqualToString:@"1.0"];
//    }];
//    [self.asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
//        // Get full image
//        NSURL *url = [contentEditingInput fullSizeImageURL];
//        int orientation = [contentEditingInput fullSizeImageOrientation];
//        CIImage *inputImage = [CIImage imageWithContentsOfURL:url options:nil];
//        inputImage = [inputImage imageByApplyingOrientation:orientation];
//
//        // Add filter
//        CIFilter *filter = [CIFilter filterWithName:filterName];
//        [filter setDefaults];
//        [filter setValue:inputImage forKey:kCIInputImageKey];
//        CIImage *outputImage = [filter outputImage];
//
//        // Create editing output
//        NSData *jpegData = [outputImage aapl_jpegRepresentationWithCompressionQuality:0.9f];
//        PHAdjustmentData *adjustmentData = [[PHAdjustmentData alloc] initWithFormatIdentifier:AdjustmentFormatIdentifier formatVersion:@"1.0" data:[filterName dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        PHContentEditingOutput *contentEditingOutput = [[PHContentEditingOutput alloc] initWithContentEditingInput:contentEditingInput];
//        [jpegData writeToURL:[contentEditingOutput renderedContentURL] atomically:YES];
//        [contentEditingOutput setAdjustmentData:adjustmentData];
//        
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:self.asset];
//            request.contentEditingOutput = contentEditingOutput;
//        } completionHandler:^(BOOL success, NSError *error) {
//            if (!success) {
//                NSLog(@"Error: %@", error);
//            }
//        }];
//    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.assetsFetchResults.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNAssetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AssetCellReuseIdentifier forIndexPath:indexPath];
    
//    // Increment the cell's tag
//    NSInteger currentTag = cell.tag + 1;
//    cell.tag = currentTag;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    CGSize targetSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            cell.assetImage = result;
        }
    }];
    
    return cell;
}

@end


