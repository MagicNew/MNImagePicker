//
//  MNAssetViewCell.m
//  MNImagePicker
//
//  Created by NK on 15/7/9.
//
//

#import "MNAssetViewCell.h"

@interface MNAssetViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;

@end

@implementation MNAssetViewCell

- (void)setAssetImage:(UIImage *)assetImage {
    _assetImage = assetImage;
    self.assetImageView.image = assetImage;
}

@end
