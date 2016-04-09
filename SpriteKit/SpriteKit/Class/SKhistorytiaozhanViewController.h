//
//  SKhistorytiaozhanViewController.h
//  SpriteKit
//
//  Created by Jdb on 16/2/24.
//  Copyright © 2016年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"//数据库语句封装类
@interface SKhistorytiaozhanViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
}

@property (nonatomic,retain)NSMutableArray *mifiShebeiListarry;//字典数组
@property (retain, nonatomic)UITableView *mifiShebeiTable;

@end
