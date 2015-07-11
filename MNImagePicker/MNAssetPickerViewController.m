//
//  MNAssetPickerViewController.m
//  MNImagePicker
//
//  Created by NK on 15/7/11.
//
//

#import "MNAssetPickerViewController.h"

@interface MNAssetPickerViewController ()

@end

@implementation MNAssetPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maximumNumberOfSelections = 4;
    self.selectedImages = [NSMutableArray array];
}

- (BOOL)bEnableAddSelect {
    if (self.selectedImages.count >= self.maximumNumberOfSelections) {
        return NO;
    }
    
    return YES;
}

@end
