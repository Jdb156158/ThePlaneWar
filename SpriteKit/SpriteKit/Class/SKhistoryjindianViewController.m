//
//  SKhistoryjindianViewController.m
//  SpriteKit
//
//  Created by Jdb on 16/2/24.
//  Copyright © 2016年 CpSoft. All rights reserved.
//

#import "SKhistoryjindianViewController.h"

@interface SKhistoryjindianViewController ()

@end

@implementation SKhistoryjindianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSLog(@"但前分区有%lu行",(unsigned long)[self.mifiShebeiListarry count]);
    if ([self.mifiShebeiListarry count] == 0)
        return 0;
    //NSLog(@"namesection count[%i]",[self.shopTitle count]);
    return [self.mifiShebeiListarry count];
    
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
    NSDictionary *dict = [self.mifiShebeiListarry objectAtIndex:row];
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
