//
//  MyBannerView.h
//  Peer
//
//  Created by Guo Grey on 2019/5/31.
//  Copyright © 2019 Grey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBannerView : UIView <UIScrollViewDelegate>
@property(nonatomic, strong)NSArray *urlArray;
@property(nonatomic, strong)NSArray *fileArray;

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;

@property(nonatomic, strong)NSTimer *time;
@property(nonatomic, assign)NSInteger timeIndex;
@property(nonatomic, strong)NSArray *imageArray;
@end

NS_ASSUME_NONNULL_END
