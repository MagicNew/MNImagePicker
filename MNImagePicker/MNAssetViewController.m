/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A view controller displaying an asset full screen.
  
 */

#import "MNAssetViewController.h"
#import "MNAssetViewCell.h"

@interface MNAssetViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@end


@implementation MNAssetViewController

static NSString * const AssetCellReuseIdentifier = @"AssetCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageSelectButtonPressed:(id)sender {
    UIButton *imageSelectButton = (UIButton *)sender;
    imageSelectButton.selected = !imageSelectButton.selected;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL needHidden = !self.topBarView.hidden;
    
    self.topBarView.hidden = needHidden;
    self.bottomBarView.hidden = needHidden;
    self.view.backgroundColor = needHidden?[UIColor blackColor]:[UIColor colorWithRed:(244.0f/255.0f) green:(244.0f/255.0f) blue:(244.0f/255.0f) alpha:1.0f];
}

@end


