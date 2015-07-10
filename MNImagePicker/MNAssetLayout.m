//
//  MNAssetLayout.m
//  MNImagePicker
//
//  Created by NK on 15/7/10.
//
//

#import "MNAssetLayout.h"

@implementation MNAssetLayout

- (id)init {
    self = [super init];
    if (self) {
        self.itemSize = [UIScreen mainScreen].bounds.size;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = .0f;
    }
    return self;
}

- (void)awakeFromNib {
    self.itemSize = [UIScreen mainScreen].bounds.size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = .0f;
}



@end
