//
//  DKGalleryViewController.m
//  CheckList
//
//  Created by Dmitry Kulakov on 16.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKGalleryViewController.h"

@interface DKGalleryViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,getter=isFirstLoad) BOOL firstLoad;

@end

@implementation DKGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.isFirstLoad) {
        [self configureScrollView];
        self.firstLoad = NO;
    }
}

#pragma mark - Configure Elements

- (void)configureController {
    self.firstLoad = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Attachments";
}

- (void)configureScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    CGRect innerScrollFrame = self.scrollView.bounds;
    for (NSInteger i = 0; i < self.images.count; i++) {
        UIImageView *imageForZooming = [[UIImageView alloc] initWithImage:self.images[i]];
        CGFloat height = self.view.bounds.size.width * (imageForZooming.frame.size.height / imageForZooming.frame.size.width);
        CGFloat y = (self.scrollView.bounds.size.height/2) - (height/2);
        imageForZooming.frame = CGRectMake(0, y, self.view.bounds.size.width, height);
        imageForZooming.tag = 1;
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        imageForZooming.contentMode = UIViewContentModeScaleAspectFit;
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 3.0f;
        pageScrollView.zoomScale = 1.0f;
        pageScrollView.contentSize = imageForZooming.frame.size;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imageForZooming];
        [self.scrollView addSubview:pageScrollView];
        if (i < self.images.count - 1) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    self.scrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x + innerScrollFrame.size.width, self.scrollView.bounds.size.height);
}

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:1];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *contentView = [scrollView viewWithTag:1];
    CGSize boundsSize = scrollView.bounds.size;
    CGRect contentsFrame = contentView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    contentView.frame = contentsFrame;
}


@end
