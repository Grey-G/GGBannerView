//
//  MyBannerView.m
//  Peer
//
//  Created by Guo Grey on 2019/5/31.
//  Copyright © 2019 Grey. All rights reserved.
//

#import "MyBannerView.h"

#define SELFVIEWWIDTH self.width

@implementation MyBannerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBasic];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setBasic];
    }
    return self;
}

-(void)dealloc
{
    if(self.time)
    {
        [self.time invalidate];
    }
}

-(void)setBasic
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

-(void)setUrlArray:(NSArray *)urlArray
{
    NSMutableArray *imageMutableArray = [NSMutableArray array];
    for(NSString *imageUrlStr in urlArray)
    {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ImageCDN, imageUrlStr]];
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
        [imageMutableArray addObject:imageView];
    }
    self.imageArray = imageMutableArray;
    [self setScrollViewContentView];
}

-(void)setFileArray:(NSArray *)fileArray
{
    NSMutableArray *imageMutableArray = [NSMutableArray array];
    for(NSString *imageName in fileArray)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.masksToBounds = YES;
        [imageMutableArray addObject:imageView];
    }
    self.imageArray = imageMutableArray;
    [self setScrollViewContentView];
}

-(void)setScrollViewContentView
{
    UIView *backgroundView = [UIView new];
    [self.scrollView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.height.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.imageArray.count * SELFVIEWWIDTH);
    }];
    for(int i = 0;i < self.imageArray.count;i++)
    {
        UIImageView *imageView = self.imageArray[i];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(backgroundView);
            make.width.mas_equalTo(SELFVIEWWIDTH);
            make.left.mas_equalTo(i * SELFVIEWWIDTH);
        }];
    }
    self.pageControl.numberOfPages = self.imageArray.count;
    [self setTimer];
}

-(void)setTimer
{
    if(self.imageArray.count > 1)
    {
        self.timeIndex = 0;
        self.time = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.time forMode:NSRunLoopCommonModes];
    }
    else
    {
        [self.scrollView setScrollEnabled:NO];
    }
}

-(void)autoScroll
{
    self.timeIndex += 1;
    if (self.timeIndex == self.imageArray.count)
    {
        self.timeIndex = 0;
    }
    self.pageControl.currentPage = self.timeIndex;
    [self.scrollView setContentOffset:CGPointMake(SELFVIEWWIDTH * self.timeIndex, 0) animated:true];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.time)
    {
        [self.time invalidate];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / SELFVIEWWIDTH;
    self.timeIndex = scrollView.contentOffset.x / SELFVIEWWIDTH;
    self.time = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(autosaveWithCompletionHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.time forMode:NSRunLoopCommonModes];
}

#pragma mark - Lazy Load

-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if(!_pageControl)
    {
        _pageControl = [UIPageControl new];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

-(NSArray *)imageArray
{
    if(!_imageArray)
    {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

@end
