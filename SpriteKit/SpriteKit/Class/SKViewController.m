//
//  SKViewController.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKViewController.h"

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //先创建一个skview. Configure the view.
    skView = (SKView *)self.view;
    
    
    baImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [baImgView setImage:[UIImage imageNamed:@"背景图片.png"]];
    [self.view addSubview:baImgView];
    
    buttonjindainmoshi = [[UIButton alloc]init];
    [buttonjindainmoshi setFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2.5,200,30)];
    //[button setCenter:backgroundView.center];
    [buttonjindainmoshi setTitle:@"经典模式" forState:UIControlStateNormal];
    [buttonjindainmoshi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonjindainmoshi.layer setBorderWidth:2.0];
    [buttonjindainmoshi.layer setCornerRadius:15.0];
    [buttonjindainmoshi.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttonjindainmoshi addTarget:self action:@selector(restartjingdian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonjindainmoshi];
    
    buttontiaozhan = [[UIButton alloc]init];
    [buttontiaozhan setFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2.5+50,200,30)];
    //[button setCenter:backgroundView.center];
    [buttontiaozhan setTitle:@"挑战模式" forState:UIControlStateNormal];
    [buttontiaozhan setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttontiaozhan.layer setBorderWidth:2.0];
    [buttontiaozhan.layer setCornerRadius:15.0];
    [buttontiaozhan.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttontiaozhan addTarget:self action:@selector(restarttiaozhan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttontiaozhan];
    
    buttonhistoryRecord = [[UIButton alloc]init];
    [buttonhistoryRecord setFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2.5+100,200,30)];
    //[button setCenter:backgroundView.center];
    [buttonhistoryRecord setTitle:@"历史战绩" forState:UIControlStateNormal];
    [buttonhistoryRecord setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonhistoryRecord.layer setBorderWidth:2.0];
    [buttonhistoryRecord.layer setCornerRadius:15.0];
    [buttonhistoryRecord.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttonhistoryRecord addTarget:self action:@selector(lishizhanji:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonhistoryRecord];
    
    //声音按钮
    UIImage *imageSoundOn = [UIImage imageNamed:@"sound-on"];
    UIImage *imageSoundOff = [UIImage imageNamed:@"sound-off"];
    buttonSoundOn = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc]init];
    [buttonSoundOn setFrame:CGRectMake(self.view.frame.size.width -imageSoundOn.size.width-10, self.view.frame.size.height-40, imageSoundOn.size.width,imageSoundOn.size.height)];
    //[buttonSoundOn setBackgroundImage:imageSoundOn forState:UIControlStateNormal];
    [buttonSoundOn setImage:imageSoundOn forState:UIControlStateNormal];
    [buttonSoundOn setImage:imageSoundOff forState:UIControlStateSelected];
    [buttonSoundOn addTarget:self action:@selector(nomusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSoundOn];
    
    NSString *bgMusicpath;
    // 设置音乐文件路径
    bgMusicpath = [[NSBundle mainBundle] pathForResource:@"game_music" ofType:@"mp3"];
    // 判断是否可以访问这个文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:bgMusicpath])
    {
        // 设置 player
        bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
                     [NSURL fileURLWithPath:bgMusicpath] error:nil];
        // 调节音量 (范围从0到1)
        //bgmPlayer.volume = 0.4f;
        
        // 准备buffer，减少播放延时的时间
        //[bgmPlayer prepareToPlay];
        
        // 设置播放次数，0为播放一次，负数为循环播放
        [bgmPlayer setNumberOfLoops:-1];
        
    }
    
    musicplayer = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver:) name:@"gameOverNotification" object:nil];
}

//禁止播放声音
- (void)nomusic:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        //NSLog(@"不播放游戏声音");
        musicplayer = NO;
    }else{
        //NSLog(@"播放游戏声音");
        musicplayer = YES;
    }
    
}

//游戏结束
- (void)gameOver:(NSNotification*) notification{
    
    NSLog(@"当前游戏得分%@",[notification object]);
    //数据库名
    NSString *dbName = @"spritekitgame";
    NSString *tbSystemMessage = nil;
    if (gameovertype) {
        tbSystemMessage = @"tiaozhan";
    }else{
        tbSystemMessage = @"jindian";
    }
    //表名
    //初始化数据库
    SqlightAdapter *systemMessageSqlight = [SqlightAdapter database:dbName AndTable:tbSystemMessage];
    if (nil == systemMessageSqlight) {
        //数据库文件或表不在，初始化失败，就创建一个
        systemMessageSqlight = [SqlightAdapter database:dbName];//文件名
        [systemMessageSqlight createTable:tbSystemMessage Info:[NSMutableArray arrayWithObjects:@"id INTEGER PRIMARY KEY ASC", @"gameovertime", @"record", @"Expand3", @"Expand4",nil]];
        systemMessageSqlight.tableName = tbSystemMessage;//表名设置
    }
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    //插入数据
    SqlightResult * inserSystemMessage = [systemMessageSqlight insertData:[NSDictionary dictionaryWithObjectsAndKeys:locationString,@"gameovertime", [notification object],@"record",nil]];
    //做个信息打印
    NSLog(@"插入:%@ code:%ld data:%@", inserSystemMessage.msg, (long)inserSystemMessage.code, inserSystemMessage.data);
    
    
    
    UIView *backgroundView =  [[UIView alloc]initWithFrame:self.view.bounds];
    
    UIButton *button = [[UIButton alloc]init];
    //[button setBounds:CGRectMake(0,0,200,30)];
    //[button setCenter:backgroundView.center];
    [button setFrame:CGRectMake(self.view.frame.size.width/2 - 100,self.view.frame.size.height/2,200,30)];
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button.layer setBorderWidth:2.0];
    [button.layer setCornerRadius:15.0];
    [button.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [button addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    
    UIButton *button1 = [[UIButton alloc]init];
    //[button1 setBounds:CGRectMake(0,50,200,30)];
    //[button1 setCenter:backgroundView.center];
    [button1 setFrame:CGRectMake(self.view.frame.size.width/2 - 100,self.view.frame.size.height/2+50,200,30)];
    button1.backgroundColor = [UIColor yellowColor];
    [button1 setTitle:@"返回主页" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button1.layer setBorderWidth:2.0];
    [button1.layer setCornerRadius:15.0];
    [button1.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [button1 addTarget:self action:@selector(BankHome:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button1];
    
    [backgroundView setCenter:self.view.center];
    
    [self.view addSubview:backgroundView];
}

//游戏暂停
- (void)pause:(UIButton *)btn{
    btn.selected = !btn.selected;
    buttonpause.userInteractionEnabled = NO;//按钮禁止点击
    
    ((SKView *)self.view).paused = YES;
    
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    
    buttonContinue = [[UIButton alloc]init];
    [buttonContinue setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,50,200,30)];
    buttonContinue.backgroundColor = [UIColor yellowColor];
    [buttonContinue setTitle:@"继续" forState:UIControlStateNormal];
    [buttonContinue setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonContinue.layer setBorderWidth:2.0];
    [buttonContinue.layer setCornerRadius:15.0];
    [buttonContinue.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttonContinue addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:buttonContinue];
    
    buttonStartAgain = [[UIButton alloc]init];
    [buttonStartAgain setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,100,200,30)];
    buttonStartAgain.backgroundColor = [UIColor yellowColor];
    [buttonStartAgain setTitle:@"重新开始" forState:UIControlStateNormal];
    [buttonStartAgain setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonStartAgain.layer setBorderWidth:2.0];
    [buttonStartAgain.layer setCornerRadius:15.0];
    [buttonStartAgain.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttonStartAgain addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:buttonStartAgain];
    
    buttonBankHome = [[UIButton alloc]init];
    [buttonBankHome setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,150,200,30)];
    buttonBankHome.backgroundColor = [UIColor yellowColor];
    [buttonBankHome setTitle:@"返回主页" forState:UIControlStateNormal];
    [buttonBankHome setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonBankHome.layer setBorderWidth:2.0];
    [buttonBankHome.layer setCornerRadius:15.0];
    [buttonBankHome.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [buttonBankHome addTarget:self action:@selector(BankHome:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:buttonBankHome];
    
    pauseView.center = self.view.center;
    
    [self.view addSubview:pauseView];
    
}

//游戏开始
- (void)restart:(UIButton *)button{
    buttonpause.userInteractionEnabled = YES;//按钮禁止点击
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

//游戏继续
- (void)continueGame:(UIButton *)button{
    buttonpause.userInteractionEnabled = YES;//按钮禁止点击
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
}

//返回到主页
-(void)BankHome:(UIButton *)button{
    [button.superview removeFromSuperview];
    //关掉背景音乐
    if (bgmPlayer != nil)
    {
        if (bgmPlayer.isPlaying == YES)
            [bgmPlayer stop];
    }
    //添加主页
    [self.view addSubview:baImgView];
    [self.view addSubview:buttonSoundOn];
    [self.view addSubview:buttonjindainmoshi];
    [self.view addSubview:buttontiaozhan];
    [self.view addSubview:buttonhistoryRecord];
}

//经典模式开启
- (void)restartjingdian:(UIButton *)button{
    gameovertype = NO;
    [self removeview];
    // Configure the view.
    //skView = (SKView *)self.view;
    
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKMainScene * scene = [SKMainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    if (bgmPlayer != nil && musicplayer)
    {
        [bgmPlayer play];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nomusicplayer" object:@"1"];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"moshi" object:@"0"];
    //暂停按钮
    UIImage *imagepause = [UIImage imageNamed:@"BurstAircraftPause"];
    buttonpause = [[UIButton alloc]init];
    [buttonpause setFrame:CGRectMake(10, 25, imagepause.size.width,imagepause.size.height)];
    [buttonpause setBackgroundImage:imagepause forState:UIControlStateNormal];
    [buttonpause setImage:[UIImage imageNamed:@"BurstAircraftPauseOff"] forState:UIControlStateSelected];
    [buttonpause addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonpause];
    
}

//挑战模式开启
- (void)restarttiaozhan:(UIButton *)button{
    gameovertype = YES;
    [self removeview];

    // Configure the view.
    //skView = (SKView *)self.view;
    
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKMainScene * scene = [SKMainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    if (bgmPlayer != nil && musicplayer)
    {
        [bgmPlayer play];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nomusicplayer" object:@"1"];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"moshi" object:@"1"];
    //暂停按钮
    UIImage *imagepause = [UIImage imageNamed:@"BurstAircraftPause"];
    buttonpause = [[UIButton alloc]init];
    [buttonpause setFrame:CGRectMake(10, 25, imagepause.size.width,imagepause.size.height)];
    [buttonpause setBackgroundImage:imagepause forState:UIControlStateNormal];
    [buttonpause setImage:[UIImage imageNamed:@"BurstAircraftPauseOff"] forState:UIControlStateSelected];
    [buttonpause addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonpause];
}

//历史战绩开启
- (void)lishizhanji:(UIButton *)button{
    SKhistoryViewController * historyview = [[SKhistoryViewController alloc] init];
    [self presentViewController:historyview animated:NO completion:^{}];
}
-(void)removeview{
    //移除主页
    [baImgView removeFromSuperview];
    [buttonSoundOn removeFromSuperview];
    [buttonjindainmoshi removeFromSuperview];
    [buttontiaozhan removeFromSuperview];
    [buttonhistoryRecord removeFromSuperview];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
