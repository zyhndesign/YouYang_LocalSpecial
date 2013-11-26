//
//  StoryViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "StoryViewContr.h"
#import "SimpleTrationSmallView.h"
#import <QuartzCore/QuartzCore.h>


@interface StoryViewContr ()

@end

@implementation StoryViewContr

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

#define PageSize 3
- (void)didReceiveMemoryWarning
{
    //NSLog(@"didReceiveMemoryWarning");
    if (AllScrollView.contentOffset.y >= 768*6 && AllScrollView.contentOffset.y < 768*8)
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

#define HeighTopOne 800
#define HeighTopTwo 1200
- (void)rootscrollViewDidScrollToPointY:(int)pointY
{
    if (pointY > 400 && pointY < 768)
    {
        int positionYOne = 1050 - (pointY - 400)*2/3;
       // positionYOne = positionYOne < HeighTopOne ? HeighTopOne:positionYOne;
        int positionYTwo = 1500 - (pointY - 400)/3;
        positionYTwo = positionYTwo < HeighTopTwo ? HeighTopTwo:positionYTwo;
        [animaImageViewOne setFrame:CGRectMake(animaImageViewOne.frame.origin.x, positionYOne, animaImageViewOne.frame.size.width, animaImageViewOne.frame.size.height)];
        [animaImageViewTwo setFrame:CGRectMake(animaImageViewTwo.frame.origin.x, positionYTwo, animaImageViewTwo.frame.size.width, animaImageViewTwo.frame.size.height)];
    }
    if (pointY > 768)
    {
        int positionYOne = 1050 - (768 - 400)*2/3 - (pointY - 768)*2/5;
        // positionYOne = positionYOne < HeighTopOne ? HeighTopOne:positionYOne;
        int positionYTwo = 1500 - (768 - 400)/3 - (pointY - 768)/5;
        positionYTwo = positionYTwo < HeighTopTwo ? HeighTopTwo:positionYTwo;
        [animaImageViewOne setFrame:CGRectMake(animaImageViewOne.frame.origin.x, positionYOne, animaImageViewOne.frame.size.width, animaImageViewOne.frame.size.height)];
        [animaImageViewTwo setFrame:CGRectMake(animaImageViewTwo.frame.origin.x, positionYTwo, animaImageViewTwo.frame.size.width, animaImageViewTwo.frame.size.height)];
    }
}

- (IBAction)nextPage:(UIButton*)sender
{
    [AllScrollView setContentOffset:CGPointMake(0, (sender.tag*2-1)*768) animated:YES];
}

#define StartX 122
#define StartY 264
#define Gap 30
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
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        page = i/PageSize;
        int row = i%PageSize;
        SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
        simpleTraSmalView.tag = i + 1;
        [contentScrolV addSubview:simpleTraSmalView];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    int startI = (midPage-2)*PageSize;
    if (startI < 0)
        startI = 0;
    for (int i = (midPage-2)*PageSize; i < initAry.count && i < (midPage+3)*PageSize; i++)
    {
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
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
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            int row = i%PageSize;
            
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartX + row*simpleTraSmalView.frame.size.width + row*Gap, StartY, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*PageSize || view.tag > (midPage + 3)*PageSize)
        {
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc
{
 
}



#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/1024;
    pageControl.currentPage = currentPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
}


@end
