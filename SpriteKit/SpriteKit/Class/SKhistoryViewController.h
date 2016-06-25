//
//  SKhistoryViewController.h
//  SpriteKit
//
//  Created by Jdb on 16/2/23.
//  Copyright © 2016年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"//数据库语句封装类
#import "YFViewPager.h"//左右滑动控件
@interface SKhistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    YFViewPager *viewPager;
}
@property (nonatomic,retain)NSMutableArray *mifiShebeiListarry;//经典模式的数组
@property (retain, nonatomic)UITableView *mifiShebeiTable;//经典模式的数据列表
@property (nonatomic,retain)NSMutableArray *mifiShebeiListarry1;//挑战模式的数组
@property (retain, nonatomic)UITableView *mifiShebeiTable1;//挑战模式的数据列表

@end
