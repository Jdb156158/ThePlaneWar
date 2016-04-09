//
//  SKViewController.h
//  SpriteKit
//

//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SKMainScene.h"
#import <QuartzCore/QuartzCore.h>

#import <AVFoundation/AVFoundation.h> 

#import "SKhistoryViewController.h"
#import "Sqlite.h"//数据库语句封装类
@interface SKViewController : UIViewController{
    SKView * skView;
    UIButton *buttonpause;//游戏暂停
    UIButton *buttonContinue;//游戏继续
    UIButton *buttonStartAgain;//重新开始
    UIImageView *baImgView;//游戏背景
    UIButton *buttonSoundOn;//游戏声音
    UIButton *buttonjindainmoshi;//游戏经典模式
    UIButton *buttontiaozhan;//游戏挑战模式
    UIButton *buttonhistoryRecord;//游戏历史战绩
    UIButton *buttonBankHome;//返回主页
    
    AVAudioPlayer *bgmPlayer;
    BOOL musicplayer;//默认播放音乐
    BOOL gameovertype;//哪种游戏结束模式
}

@end
