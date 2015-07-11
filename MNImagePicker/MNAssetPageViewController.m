//
//  MNAssetPageViewController.m
//  MNImagePicker
//
//  Created by Magic Niu on 15/7/11.
//
//

#import "MNAssetPageViewController.h"
#import "MNAssetItemViewController.h"
#import "MNAssetScrollView.h"
#import "MNAssetPickerViewController.h"

@interface MNAssetPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, MNAssetItemViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, assign, getter = isStatusBarHidden) BOOL statusBarHidden;

@end

@implementation MNAssetPageViewController

- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    self.view.backgroundColor   = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotificationObserver];
    
    [self addBottomView];
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)addBottomView {
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    self.bottomView.image = [UIImage imageNamed:@"toolbar_background"];
    [self.view addSubview:self.bottomView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.bottomView.bounds.size.width-70-15, (self.bottomView.bounds.size.height-25)/2.0f, 70, 25);
    finishButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"round_orange"] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishCollectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:finishButton];
}

- (BOOL)prefersStatusBarHidden {
    return self.isStatusBarHidden;
}

- (IBAction)selectButtonPressed:(id)sender {
//    self.selectButton.selected = !self.selectButton.selected;
    MNAssetItemViewController *vc   = (MNAssetItemViewController *)self.viewControllers[0];
    PHAsset *asset = [self assetAtIndex:vc.pageIndex];
    __weak typeof(self) weakSelf = self;
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            MNAssetPickerViewController *picker = (MNAssetPickerViewController *)weakSelf.navigationController;
            [picker.selectedImages addObject:result];
            [weakSelf updateCurrentSelectState:result];
        }
    }];
}

- (void)finishCollectButtonPressed:(id)sender {
    MNAssetPickerViewController *picker = (MNAssetPickerViewController *)self.navigationController;
    if ([picker.pickerDelegate respondsToSelector:@selector(assetsPickerController:didFinishPickingImages:)]) {
        [picker.pickerDelegate assetsPickerController:picker didFinishPickingImages:picker.selectedImages];
    }
}

#pragma mark - Page Index

- (NSInteger)pageIndex
{
    return ((MNAssetItemViewController *)self.viewControllers[0]).pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.assets.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        MNAssetItemViewController *page = [MNAssetItemViewController assetItemViewControllerForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

#pragma mark - Notification Observer

- (void)addNotificationObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(scrollViewTapped:)
                   name:MNAssetScrollViewTappedNotification
                 object:nil];
}

- (void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MNAssetScrollViewTappedNotification object:nil];
}


#pragma mark - Tap Gesture

- (void)scrollViewTapped:(NSNotification *)notification
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)notification.object;
    
    if (gesture.numberOfTapsRequired == 1)
        [self toogleNavigationBar:gesture];
}

#pragma mark - Fade in / away navigation bar

- (void)toogleNavigationBar:(id)sender
{
    if (self.isStatusBarHidden)
        [self fadeNavigationBarIn];
    else
        [self fadeNavigationBarAway];
}

- (void)fadeNavigationBarAway
{
    self.statusBarHidden = YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         
                         self.navigationController.navigationBarHidden = YES;
                         self.view.backgroundColor = [UIColor blackColor];
                         self.bottomView.hidden = YES;
                     }];
}

- (void)fadeNavigationBarIn
{
    self.statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         self.navigationController.navigationBarHidden = NO;
                         self.view.backgroundColor = [UIColor whiteColor];
                         self.bottomView.hidden = NO;
                     }];
}

- (void)updateCurrentSelectState:(UIImage *)image {
    MNAssetPickerViewController *picker = (MNAssetPickerViewController *)self.navigationController;
    if ([picker.selectedImages containsObject:image]) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((MNAssetItemViewController *)viewController).pageIndex;
    
    if (index > 0) {
        MNAssetItemViewController *page = [MNAssetItemViewController assetItemViewControllerForPageIndex:(index - 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger count = self.assets.count;
    NSInteger index = ((MNAssetItemViewController *)viewController).pageIndex;
    
    if (index < count - 1) {
        MNAssetItemViewController *page = [MNAssetItemViewController assetItemViewControllerForPageIndex:(index + 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed)
    {
        MNAssetItemViewController *vc   = (MNAssetItemViewController *)pageViewController.viewControllers[0];
        PHAsset *asset = [self assetAtIndex:vc.pageIndex];
        __weak typeof(self) weakSelf = self;
        CGSize targetSize = [UIScreen mainScreen].bounds.size;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                [weakSelf updateCurrentSelectState:result];
            }
        }];
        
        [self.view bringSubviewToFront:self.bottomView];
    }
}

#pragma mark - CTAssetItemViewControllerDataSource

- (PHAsset *)assetAtIndex:(NSUInteger)index;
{
    return [self.assets objectAtIndex:index];
}

@end
