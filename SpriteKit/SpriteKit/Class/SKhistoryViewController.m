//
//  SKhistoryViewController.m
//  SpriteKit
//
//  Created by Jdb on 16/2/23.
//  Copyright © 2016年 CpSoft. All rights reserved.
//

#import "SKhistoryViewController.h"

@interface SKhistoryViewController ()

@end

@implementation SKhistoryViewController
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    UINavigationBar *nav = [[UINavigationBar alloc]init];
    nav.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
    nav.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:204/255.0 alpha:1.0];
    [self.view addSubview:nav];
    
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:204/255.0 alpha:1.0];
    backview.frame = nav.frame;
    [nav addSubview:backview];
    
    UIButton * BackBtn = [[UIButton alloc]init];
    BackBtn.tag = 9;
    BackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [BackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [BackBtn setFrame:CGRectMake(5, 60-40, 50, 40)];
    BackBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [BackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [BackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //替换相应位置/////////////
    UIImage *butonImg2 = [UIImage imageNamed:@"nagivation_back"];
    butonImg2 = [butonImg2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//按照原图片颜色来渲染
    CGSize uncheckedsize = CGSizeMake(10.0f, 18.0f);
    UIGraphicsBeginImageContext(CGSizeMake(uncheckedsize.width, uncheckedsize.height));
    [butonImg2 drawInRect:CGRectMake(0, 0, uncheckedsize.width, uncheckedsize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    reSizeImage = [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//按照原图片颜色来渲染
    UIGraphicsEndImageContext();
    [BackBtn setImage:reSizeImage forState:UIControlStateNormal];
    [nav addSubview:BackBtn];
   
    
    UILabel * titlename = [[UILabel alloc]init];
    //titlename.backgroundColor = [UIColor yellowColor];
    [titlename setText:@"历史战绩"];
    titlename.textColor = [UIColor whiteColor];
    titlename.font = [UIFont systemFontOfSize:15.0f];
    titlename.textAlignment = NSTextAlignmentCenter;
    [titlename setFrame:CGRectMake((CGRectGetWidth(self.view.frame)-100)/2, 60-30, 120, 20)];
    [backview addSubview:titlename];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)back:(UIButton *)secoint
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initjindian];
    [self inittiaozhan];
    
    //添加分段视图
    NSArray *titles = [[NSArray alloc] initWithObjects:
                       @"经典模式",
                       @"挑战模式",
                       nil];
    NSArray *views = [[NSArray alloc] initWithObjects:
                      _mifiShebeiTable,
                      _mifiShebeiTable1, nil];
    
    viewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0,60, [UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height-60)
                                             titles:titles
                                              icons:nil
                                      selectedIcons:nil
                                              views:views];
    [viewPager setTabSelectedTitleColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:204/255.0 alpha:1.0]];
    [viewPager setTabSelectedArrowBgColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:204/255.0 alpha:1.0]];
    [self.view addSubview:viewPager];
    
    [viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
        switch (index) {
            case 0:
            {
                NSLog(@"点击第一个菜单");
            }
                break;
            case 1:
            {
                NSLog(@"点击第二个菜单");
            }
                break;
            case 2:
            {
                NSLog(@"点击第三个菜单");
            }
                break;
                
            default:
                break;
        }
    }];
    

}

-(void)initjindian{
    // 字典数组初始化
    self.mifiShebeiListarry = [NSMutableArray array];
    self.mifiShebeiTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.mifiShebeiTable.delegate = self;
    self.mifiShebeiTable.dataSource = self;
    self.mifiShebeiTable.tag = 1;
    [self.mifiShebeiTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.mifiShebeiTable];
    
    //数据库名
    NSString *dbName = @"spritekitgame";
    NSString *tbSystemMessage = @"jindian";
    //数据库消息读取
    SqlightAdapter *systemMessage = [SqlightAdapter database:dbName AndTable:tbSystemMessage];
    //查询数据
    SqlightResult *systemMessageinfo = [systemMessage selectFields:[NSArray arrayWithObjects:@"id", @"gameovertime", @"record",@"Expand3",@"Expand4",nil]ByCondition:nil Bind:nil];
    
    NSLog(@"系统消息 Result msg:%@ code:%ld data:%@", systemMessageinfo.msg, (long)systemMessageinfo.code, systemMessageinfo.data);
    
    for (int i = 0; i < (unsigned long)[systemMessageinfo.data count]; i++) {
        NSDictionary *dictifon = [NSDictionary dictionaryWithObjectsAndKeys:systemMessageinfo.data[i][1],@"gameovertime", systemMessageinfo.data[i][2],@"record",nil];
        [self.mifiShebeiListarry addObject:dictifon];
    }
}

-(void)inittiaozhan{
    // 字典数组初始化
    self.mifiShebeiListarry1 = [NSMutableArray array];
    self.mifiShebeiTable1 =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.mifiShebeiTable1.delegate = self;
    self.mifiShebeiTable1.dataSource = self;
    self.mifiShebeiTable1.tag = 1;
    [self.mifiShebeiTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.mifiShebeiTable1];
    
    //数据库名
    NSString *dbName = @"spritekitgame";
    NSString *tbSystemMessage = @"tiaozhan";
    //数据库消息读取
    SqlightAdapter *systemMessage = [SqlightAdapter database:dbName AndTable:tbSystemMessage];
    //查询数据
    SqlightResult *systemMessageinfo = [systemMessage selectFields:[NSArray arrayWithObjects:@"id", @"gameovertime", @"record",@"Expand3",@"Expand4",nil]ByCondition:nil Bind:nil];
    
    NSLog(@"系统消息 Result msg:%@ code:%ld data:%@", systemMessageinfo.msg, (long)systemMessageinfo.code, systemMessageinfo.data);
    
    for (int i = 0; i < (unsigned long)[systemMessageinfo.data count]; i++) {
        NSDictionary *dictifon = [NSDictionary dictionaryWithObjectsAndKeys:systemMessageinfo.data[i][1],@"gameovertime", systemMessageinfo.data[i][2],@"record",nil];
        [self.mifiShebeiListarry1 addObject:dictifon];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //告诉TableView有几个分区
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //告诉Tableview当前分区有几行
    if (tableView.tag == 1) {
        NSLog(@"但前分区有%lu行",(unsigned long)[self.mifiShebeiListarry count]);
        if ([self.mifiShebeiListarry count] == 0)
            return 0;
        //NSLog(@"namesection count[%i]",[self.shopTitle count]);
        return [self.mifiShebeiListarry count];
    }else{
        NSLog(@"但前分区有%lu行",(unsigned long)[self.mifiShebeiListarry1 count]);
        if ([self.mifiShebeiListarry1 count] == 0)
            return 0;
        //NSLog(@"namesection count[%i]",[self.shopTitle count]);
        return [self.mifiShebeiListarry1 count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSUInteger section = [indexPath section];
    NSLog(@"section[%lu]",(unsigned long)section);
    
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    //错误写法，先不赋值
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //正确写法
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    //2.添加标题Label
    NSDictionary *dict = nil;
    if (tableView.tag == 1) {
        dict = [self.mifiShebeiListarry objectAtIndex:row];
    }else{
        dict = [self.mifiShebeiListarry1 objectAtIndex:row];
    }
    CGRect titleLabelF  = CGRectMake(5, 45/2-12, cell.frame.size.width/2-15, 24);
    UILabel *lable1 = [[UILabel alloc] initWithFrame:titleLabelF];
    //lable1.backgroundColor = [UIColor redColor];
    lable1.font = [UIFont boldSystemFontOfSize:13.0f];//字体大小
    lable1.textColor = [UIColor grayColor];
    lable1.text = [dict objectForKey:@"gameovertime"];
    [cell addSubview:lable1];
    
    CGRect titleLabelF2  = CGRectMake(cell.frame.size.width/2, 45/2-12, cell.frame.size.width-45-15, 24);
    UILabel *lable2 = [[UILabel alloc] initWithFrame:titleLabelF2];
    //lable2.backgroundColor = [UIColor redColor];
    lable2.font = [UIFont systemFontOfSize:18.0f];//字体大小
    lable2.textColor = [UIColor blackColor];
    lable2.text = [NSString stringWithFormat:@"%@分",[dict objectForKey:@"record"]];
    [cell addSubview:lable2];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;//后边有小箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无风格
    return cell;
    
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
//头部高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 1;
}
//尾部部高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//分组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
//点击每行的事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;//当前分区
    NSInteger row=indexPath.row;//当前行
    NSLog(@"当前第%li组第%li行",(long)section,(long)row);
    //    self.mifiShebeiTable.editing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
