//
//  MNAssetPageViewController.h
//  MNImagePicker
//
//  Created by Magic Niu on 15/7/11.
//
//

@import UIKit;
@import Photos;

@interface MNAssetPageViewController : UIPageViewController

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) PHFetchResult *assets;

@end
