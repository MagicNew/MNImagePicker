//
//  MNAssetPickerViewController.h
//  MNImagePicker
//
//  Created by NK on 15/7/11.
//
//

#import <UIKit/UIKit.h>

@protocol MNAssetPickerViewControllerDelegate;

@interface MNAssetPickerViewController : UINavigationController

@property (nonatomic, weak) id <MNAssetPickerViewControllerDelegate> pickerDelegate;
@property (nonatomic, assign) NSInteger maximumNumberOfSelections;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, readonly) BOOL bEnableAddSelect;

@end


@protocol MNAssetPickerViewControllerDelegate <NSObject>

- (void)assetsPickerController:(MNAssetPickerViewController *)picker didFinishPickingImages:(NSArray *)images;

@end