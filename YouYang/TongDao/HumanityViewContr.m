//
//  HumanityViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "HumanityViewContr.h"
#import "SimpleHumanityView.h"


@interface HumanityViewContr ()

@end

@implementation HumanityViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#define PageSize 4
- (void)didReceiveMemoryWarning
{
    if (AllScrollView.contentOffset.y >= 768*4 && AllScrollView.contentOffset.y < 768*6)
    {
        
    }
    else
    {
        int currentPage = contentScrolV.contentOffset.x/1024 + 1;
        for(UIView *view in [contentScrolV subviews])
        {
            if (view.tag == 0)
                continue;
            if (view.tag <= PageSize*(currentPage-1) || view.tag > PageSize*(currentPage+1))
            {
                [view removeFromSuperview];
            }
        }
    }
    [super didReceiveMemoryWarning];
}

#define HeighTopOne 450
#define HeighTopTwo 100
#define HeighTopThr 1200
- (void)rootscrollViewDidScrollToPointY:(int)pointY
{
    if (pointY > 10)
    {
        int positionYOne = 600 - (pointY - 10)/5;
        positionYOne = positionYOne < HeighTopOne ? HeighTopOne:positionYOne;
        int positionYTwo = 700 - (pointY - 10)/3;
        positionYTwo = positionYTwo < HeighTopTwo ? HeighTopTwo:positionYTwo;
        [animaImageViewOne setFrame:CGRectMake(animaImageViewOne.frame.origin.x, positionYOne, animaImageViewOne.frame.size.width, animaImageViewOne.frame.size.height)];
        [animaImageViewTwo setFrame:CGRectMake(animaImageViewTwo.frame.origin.x, positionYTwo, animaImageViewTwo.frame.size.width, animaImageViewTwo.frame.size.height)];
    }
    if (pointY > 350)
    {
        int positionYThr = 1400 - (pointY - 450)/5;
        positionYThr = positionYThr < HeighTopThr ? HeighTopThr:positionYThr;
        [animaImageViewThr setFrame:CGRectMake(animaImageViewThr.frame.origin.x, positionYThr, animaImageViewThr.frame.size.width, animaImageViewThr.frame.size.height)];
    }
}

#define StartX 112
#define StartY 200
- (void)loadSubview:(NSArray*)ary
{
    initAry = [[NSArray alloc] initWithArray:ary];
    
    int page = initAry.count/PageSize;
    if (initAry.count%PageSize)
        page++;
    if (page == 0)
        page = 1;
    pageControl.numberOfPages = page;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    
    [contentScrolV setContentSize:CGSizeMake(page*1024, contentScrolV.frame.size.height)];
    
    for (int i = 0; i < initAry.count; i++)
    {
        page = i/PageSize;
        if (i%PageSize && i != (initAry.count-1))
        {
            UILabel *midLb = [[UILabel alloc] initWithFrame:CGRectMake(page*1024 + StartX + (i%PageSize)*200 -1, StartY + 15, 1, 400 - 50)];
            midLb.backgroundColor = RedLineOneColor;
            [contentScrolV addSubview:midLb];
        }
    }
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        page = i/PageSize;
        SimpleHumanityView *simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
        simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
        simpleHimanView.tag = i + 1;
        [contentScrolV addSubview:simpleHimanView];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    int startI = (midPage-2)*PageSize;
    if (startI < 0)
        startI = 0;
    for (int i = startI; i < initAry.count && i <= (midPage+2)*PageSize; i++)
    {
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%PageSize)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    if (initAry.count < PageSize*3)
        return;
    int startI = (currentPage-2)*PageSize;
    if (startI < 0)
        startI = 0;
    for (int i = startI; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
            
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for(UIView *view in [contentScrolV subviews])
    {
        if ((view.tag < (midPage - 2)*PageSize  || view.tag > (midPage + 3)*PageSize) && view.tag != 0)
        {
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc
{
    
}


- (IBAction)nextPage:(UIButton*)sender
{
    [AllScrollView setContentOffset:CGPointMake(0, (sender.tag*2-1)*768) animated:YES];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        NSInteger page = (scrollView.contentOffset.x+100)/1024 + 1;
        [self rebulidCurrentPage:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/1024;
    pageControl.currentPage = currentPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x+100)/1024 + 1;
    [self rebulidCurrentPage:page];

}


@end
