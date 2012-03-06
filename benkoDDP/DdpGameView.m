//
//  DdpGameView.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <time.h>
#import "DdpGameView.h"
#import "DdpMenu.h"
#import "SimpleAudioEngine.h"
#import "CJSONDeserializer.h"
@implementation DdpGameView

//ceshi
static int what = 0;
//游戏界面控制的静态常量
//道具出现的几率
static const int equipChance = 100;
static const float delay = 0.05f;
static const int elementSize = 37;
static const int leftWhite = 30;
static const int topWhite = 95;
static const int elementType = 6;

//游戏逻辑控制的静态常量
static const int INIT = 0;
static const int UPDATE = 1;
static const int MISSIONCLEAR = 2;
static const int MISSIONFAILED = 3;
static const int PAUSE = 4;

//游戏运行时的状态变量
@synthesize select;
@synthesize state;  
@synthesize lastState;  
@synthesize mission;    
@synthesize restart;   
@synthesize RowDone, ColumnDone;   
@synthesize hasFocus;      
@synthesize hasSelect;     
@synthesize change;        
@synthesize rechange;      
@synthesize scoreTimes;     
@synthesize playanimation;     
@synthesize lastX, lastY, desX, desY;       
@synthesize score, totalScore, desScore;       
@synthesize zoomtimes;
@synthesize isClear;
@synthesize bombstate;
@synthesize pro;

@synthesize progress;
@synthesize propCursor;
@synthesize gameObject;
@synthesize cancel;
@synthesize z_cancel;
@synthesize proplist;

@synthesize musicVolumn;
@synthesize effectVolumn;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DdpGameView *layer = [DdpGameView node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if((self = [super init]))
    {
        //这里填入游戏界面初始化的东西
        //初始化元素的随机种子
        srand(time(0));
        //显示道具按钮
        CCSprite * equip1 = [CCSprite spriteWithFile:@"equip_1.png"];
        CCSprite * equip1_on = [CCSprite spriteWithFile:@"equip_1_on.png"];
        CCMenuItemImage *equipment1 = [CCMenuItemImage itemFromNormalSprite:equip1 selectedSprite:equip1_on target:self selector:@selector(clickEquip1:)];
        
        CCSprite * equip2 = [CCSprite spriteWithFile:@"equip_2.png"];
        CCSprite * equip2_on = [CCSprite spriteWithFile:@"equip_2_on.png"];
        CCMenuItemImage *equipment2 = [CCMenuItemImage itemFromNormalSprite:equip2 selectedSprite:equip2_on target:self selector:@selector(clickEquip2:)];
        
        CCSprite * equip3 = [CCSprite spriteWithFile:@"equip_3.png"];
        CCSprite * equip3_on = [CCSprite spriteWithFile:@"equip_3_on.png"];
        CCMenuItemImage *equipment3 = [CCMenuItemImage itemFromNormalSprite:equip3 selectedSprite:equip3_on target:self selector:@selector(clickEquip3:)];
        
        CCSprite * equip4 = [CCSprite spriteWithFile:@"equip_4.png"];
        CCSprite * equip4_on = [CCSprite spriteWithFile:@"equip_4_on.png"];
        CCMenuItemImage *equipment4 = [CCMenuItemImage itemFromNormalSprite:equip4 selectedSprite:equip4_on target:self selector:@selector(clickEquip4:)];
        
        
        CCMenu * equipmentList = [CCMenu menuWithItems:equipment1, equipment2, equipment3, equipment4, nil];
        equipmentList.anchorPoint = CGPointZero;
        equipmentList.scale = 0.6f;
        equipmentList.position = CGPointMake(163.0f, 25.0f);
        [equipmentList alignItemsInColumns:[NSNumber numberWithUnsignedInt:4], nil];
        
        [self addChild:equipmentList z:2 tag:1];
        
        /*
        CCSprite *gameView1 = [CCSprite spriteWithFile:@"wnd_game.png"];
        gameView1.anchorPoint = CGPointZero;
        [self addChild:gameView1 z:0 tag:1];
        */
        
        CCSprite *objectPool = [CCSprite spriteWithFile:@"gameobjectpool.png"];
        equipmentList.anchorPoint = CGPointZero;
        //[objectPool setPosition:CGPointMake(10.0f, 405.0f)];
        objectPool.position = CGPointMake(159.4f, 254.3f);
        [self addChild:objectPool z:-2 ];
        
        //存放背景图的Sprite
        CCSprite *gameView = [CCSprite spriteWithFile:@"wndgameback.png"];
        gameView.anchorPoint = CGPointZero;
        [self addChild:gameView z:1 tag:1];
        
        //初始化游戏的状态标志
        select = 0;
        RowDone = NO;
        ColumnDone = NO;
        hasFocus = NO;
        hasSelect = NO;
        change = NO;
        rechange = NO;
        scoreTimes = 1;
        playanimation = NO;
        lastX = 0;
        lastY = 0;
        desX = 0;
        desY = 0;
        zoomtimes = 0;
        isClear = NO;
        bombstate = NO;
        score = 0;
        
        //开始选中头像的图标
        cursorLas = [CCSprite spriteWithFile:@"cursor.png"];
        cursorLas.visible = NO;
        [self addChild:cursorLas z:1];
        
        //目标选中头像的图标
        cursorDes = [CCSprite spriteWithFile:@"cursor.png"];
        cursorDes.visible = NO;
        [self addChild:cursorDes z:1];
        
        //提示第一个标记
        cursor2Fir = [CCSprite spriteWithFile:@"cursor_2.png"];
        cursor2Fir.visible = NO;
        [self addChild:cursor2Fir z:1];
        
        //提示第二个标记
        cursor2Sed = [CCSprite spriteWithFile:@"cursor_2.png"];
        cursor2Sed.visible = NO;
        [self addChild:cursor2Sed z:1];
        
        //显示分数
        scoreStr = [NSString stringWithFormat:@"%d",score];
        showScore = [CCLabelTTF labelWithString:scoreStr fontName:@"Marker Felt" fontSize:20];
        showScore.color = ccBLACK;
        showScore.position = CGPointMake(230.0f, 64.0f);
        [self addChild:showScore z:2];
        
        //显示总分
        totalScore = 0;
        totalScoreStr = [NSString stringWithFormat:@"%d",totalScore];
        showTotalScore = [CCLabelTTF labelWithString:totalScoreStr fontName:@"Marker Felt" fontSize:20];
        showTotalScore.color = ccBLUE;
        showTotalScore.anchorPoint = CGPointZero;
        showTotalScore.position = CGPointMake(14.0f, 410.0f);
        [self addChild:showTotalScore z:2];
        
        //显示目标分数
        desScore = 20;
        desScoreStr = [NSString stringWithFormat:@"%d",desScore];
        showDesScore = [CCLabelTTF labelWithString:desScoreStr fontName:@"Marker Felt" fontSize:20];
        showDesScore.color = ccRED;
        showDesScore.anchorPoint = CGPointZero;
        showDesScore.position = CGPointMake(82.0f, 55.0f);
        [self addChild:showDesScore z:2];
        
        //显示关卡
        mission = 1;
        missionStr = [NSString stringWithFormat:@"%d",mission];
        showMission = [CCLabelTTF labelWithString:missionStr fontName:@"Marker Felt" fontSize:20];
        showMission.color = ccBLACK;
        showMission.anchorPoint = CGPointZero;
        showMission.position = CGPointMake(233.0f, 410.0f);
        [self addChild:showMission z:2];
        
        //设定一个任务，每经过delay的时间都调用一次step:
        [self schedule:@selector(step:) interval:delay];
        [self initGameObjects];
        [self initCancel];
        
        //?
        [self initZ_cancel];
        [self gameInit];
        [self initProplist];
        
        noDeath = [CheckDeathLoop new];
        [noDeath CheckDeathLoopWithSize:8 Block:gameObject];
        
        
        //初始化进度条
        pro = 0;
        progress = [[UIProgressView alloc]initWithFrame:CGRectMake(10.0f, 380.0f, 300.0f, 10.0f)];
        [progress setProgress:pro];
        [progress setAlpha:80.0f];
        [progress setProgressViewStyle:UIProgressViewStyleDefault];
        [progress setHidden:YES];
        [[[[CCDirector sharedDirector]openGLView]window] addSubview:progress];
        //在离开游戏界面的时候，应该把进度条也移除的，在确定退出的函数里面
        
        //之前考虑到将菜单与游戏界面分开，但现在发现是不好的，于是还是将菜单的东西移回游戏界面里面，下面是代码
        //暂停按钮
        CCSprite *pause = [CCSprite spriteWithFile:@"gamePause.png"];
        CCSprite *pause_on = [CCSprite spriteWithFile:@"gamePause_on.png"];
        CCMenuItemImage * gamePause = [CCMenuItemImage itemFromNormalSprite:pause selectedSprite:pause_on target:self selector:@selector(clickPause:)];
        CCMenu *pauseMenu = [CCMenu menuWithItems:gamePause, nil];
        pauseMenu.anchorPoint = CGPointZero;
        pauseMenu.scale = 0.6f;
        pauseMenu.position = CGPointMake(40.0f, 25.0f);
        [self addChild:pauseMenu z:1 tag:300];
        //退出按钮
        CCSprite *quit = [CCSprite spriteWithFile:@"gameQuit.png"];
        CCSprite *quit_on = [CCSprite spriteWithFile:@"gameQuit_on.png"];
        CCMenuItemImage *gameQuit = [CCMenuItemImage itemFromNormalSprite:quit selectedSprite:quit_on target:self selector:@selector(clickQuit:)];
        CCMenu *quitMenu = [CCMenu menuWithItems:gameQuit, nil];
        quitMenu.anchorPoint = CGPointZero;
        quitMenu.scale = 0.6f;
        quitMenu.position = CGPointMake(280.0f, 25.0f);
        [self addChild:quitMenu z:1 tag:400];
        //显示任务失败的图片
        CCSprite * gameOver = [CCSprite spriteWithFile:@"fail.png"];
        CCSprite * gameOver_on = [CCSprite spriteWithFile:@"fail.png"];
        CCMenuItemImage* gameOverItem = [CCMenuItemImage itemFromNormalSprite:gameOver selectedSprite:gameOver_on target:self selector:@selector(clickGameOver:)];
        gameOverMenu = [CCMenu menuWithItems:gameOverItem, nil];
        gameOverMenu.visible = NO;
        gameOverMenu.position = CGPointMake(160.0f, 280.0f);
        [self addChild:gameOverMenu z:1];
        
        dead_lock = [CCLabelTTF labelWithString:@"出现死锁，任务失败！！！" fontName:@"Marker Felt" fontSize:20];
        dead_lock.color = ccRED;
        dead_lock.visible = NO;
        dead_lock.position = CGPointMake(160.0f, 140.0f);
        [self addChild:dead_lock z:1];
        //显示任务成功的图片
        CCSprite * gameClear = [CCSprite spriteWithFile:@"pass.png"];
        CCSprite * gameClear_on = [CCSprite spriteWithFile:@"pass.png"];
        CCMenuItemImage* gameClearItem = [CCMenuItemImage itemFromNormalSprite:gameClear selectedSprite:gameClear_on target:self selector:@selector(clickGamePass:)];
        gameClearMenu = [CCMenu menuWithItems:gameClearItem, nil];
        gameClearMenu.position = CGPointMake(160.0f, 280.0f);
        gameClearMenu.visible = NO;
        [self addChild:gameClearMenu z:1];
        //暂停时候出现的菜单选项
        CCSprite *pauseBackground = [CCSprite spriteWithFile:@"pause.png"];
        pauseBackground.visible = NO;
        pauseBackground.anchorPoint = CGPointZero;
        pauseBackground.position = CGPointMake(10.0f, 105.0f);
        [self addChild:pauseBackground z:1 tag:500];
        
        CCSprite *resume = [CCSprite spriteWithFile:@"continue_off.png"];
        CCSprite *resume_on = [CCSprite spriteWithFile:@"continue_on.png"];
        CCMenuItemImage * pauseResume = [CCMenuItemImage itemFromNormalSprite:resume selectedSprite:resume_on target:self selector:@selector(clickResume:)];
        CCMenu *pauseResumeMenu = [CCMenu menuWithItems:pauseResume, nil];
        pauseResumeMenu.scale = 0.8f;
        pauseResumeMenu.visible = NO;
        pauseResumeMenu.anchorPoint = CGPointZero;
        pauseResumeMenu.position = CGPointMake(160.0f, 160.0f);
        [self addChild:pauseResumeMenu z:1 tag:600];
        
        //退出游戏时出现的菜单选项
        CCSprite *quitBackground = [CCSprite spriteWithFile:@"exit.png"];
        quitBackground.visible = NO;
        quitBackground.anchorPoint = CGPointZero;
        quitBackground.position = CGPointMake(10.0f, 105.0f);
        [self addChild:quitBackground z:1 tag:700];
        
        CCSprite *cancel_button = [CCSprite spriteWithFile:@"cancel_off.png"];
        CCSprite *cancel_on = [CCSprite spriteWithFile:@"cancel_on.png"];
        CCMenuItemImage *exitCancel = [CCMenuItemImage itemFromNormalSprite:cancel_button selectedSprite:cancel_on target:self selector:@selector(clickCancel:)];
        CCSprite *backMenu = [CCSprite spriteWithFile:@"backmenu_off.png"];
        CCSprite *backMenu_on = [CCSprite spriteWithFile:@"backmenu_on.png"];
        CCMenuItemImage *exitToMenu = [CCMenuItemImage itemFromNormalSprite:backMenu selectedSprite:backMenu_on target:self selector:@selector(clickQuitConfirm:)];
        CCMenu * exitMenu = [CCMenu menuWithItems:exitToMenu, exitCancel, nil];
        exitMenu.scale = 0.8f;
        exitMenu.visible = NO;
        exitMenu.anchorPoint = CGPointZero;
        exitMenu.position = CGPointMake(160.0f, 180.0f);
        [exitMenu alignItemsVertically];
        [self addChild:exitMenu z:1 tag:800];
        
//        //读取声音配置文件的信息
//        NSString *path  = [[NSBundle mainBundle]pathForResource:@"config" ofType:@"json"];
//        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];
//        CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
//        NSError *error = nil;
//        NSDictionary *jsonDict = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
//        if (error) {
//            //handle Error, didn't have here.
//            NSLog(@"chucuol");
//        }
//        //背景音乐的音量大小
//        NSNumber *mvalue = [jsonDict valueForKey:@"musicvolumn"];
//        NSAssert(mvalue, @"Didn't have a key named musicvolumn");
        //数据库操作
        sqldata = [[DdpData alloc]init];
        //打开数据库
        [sqldata openDB];
        [sqldata createTable];
        [sqldata createScorePlace];
        [sqldata selectLastName];
        musicVolumn = [sqldata gettingMvol];

//        NSNumber *evalue = [jsonDict valueForKey:@"effectvolumn"];
//        NSAssert(evalue, @"Didn't have a key named effectvolumn");
        
        effectVolumn = [sqldata gettingEvol];
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"playing.wav" loop:1];
        //设置背景音乐的音量大小
        [CDAudioManager sharedManager].backgroundMusic.volume = musicVolumn ;
        //--------------------------//
    }
    
    return self;
}


//点击第一个道具按钮 （提示道具）
-(void) clickEquip1: (id) sender
{
    if(state == UPDATE && playanimation == NO && bombstate == NO)
    {
    NSNumber* prop = [proplist objectAtIndex:0]; 
    int propnum = [prop intValue];
    if(propnum >= 1)
    {
        propnum--;
        [proplist replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:propnum]];
        
        equip1Str = [NSString stringWithFormat:@"%d",propnum];
        [showEquip1 setString:equip1Str];
        
        NSMutableArray* coordinate = [noDeath getprompt];
    
        NSNumber* nsx1 = [[coordinate objectAtIndex:0]objectAtIndex:1];
        int x1 = [nsx1 intValue];
        NSNumber* nsy1 = [[coordinate objectAtIndex:0]objectAtIndex:0];
        int y1 = [nsy1 intValue];
        NSNumber* nsx2 = [[coordinate objectAtIndex:1]objectAtIndex:1];
        int x2 = [nsx2 intValue];
        NSNumber* nsy2 = [[coordinate objectAtIndex:1]objectAtIndex:0];
        int y2 = [nsy2 intValue];
    
        [cursor2Fir setPosition:CGPointMake(x1 * elementSize + leftWhite, 480.0f - y1 * elementSize -topWhite)];
        cursor2Fir.visible = YES;
        [cursor2Sed setPosition:CGPointMake(x2 * elementSize + leftWhite, 480.0f - y2 * elementSize -topWhite)];
        cursor2Sed.visible = YES;
    }
    }
}

//点击第二个道具按钮 （炸弹道具）
-(void) clickEquip2: (id) sender
{
    if(state == UPDATE && playanimation == NO && bombstate == NO)
    {
    NSNumber* prop = [proplist objectAtIndex:1]; 
    int propnum = [prop intValue];
    if(propnum >= 1)
    {
        bombstate = YES;
        propnum--;
        [proplist replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:propnum]];
        
        equip2Str = [NSString stringWithFormat:@"%d",propnum];
        [showEquip2 setString:equip2Str];
    }
    }
}

//点击第三个道具按钮 （重排道具）
-(void) clickEquip3: (id) sender
{
    if(state == UPDATE && playanimation == NO && bombstate == NO)
    {
    NSNumber* prop = [proplist objectAtIndex:2]; 
    int propnum = [prop intValue];
    if(propnum >= 1)
    {
        [self reRange];
        [self placeObject];
        playanimation = YES;
        propnum--;
        [proplist replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:propnum]];
        
        equip3Str = [NSString stringWithFormat:@"%d",propnum];
        [showEquip3 setString:equip3Str];
    }
    }
}


//点击第四个道具按钮 （钻石道具）
-(void) clickEquip4: (id) sender
{
    if(state == UPDATE && playanimation == NO && bombstate == NO)
    {
    NSNumber* prop = [proplist objectAtIndex:3]; 
    int propnum = [prop intValue];
    if(propnum >= 1)
    {
        [self eliminate];
        isClear = YES;
        propnum--;
        [proplist replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:propnum]];
        
        equip4Str = [NSString stringWithFormat:@"%d",propnum];
        [showEquip4 setString:equip4Str];
    } 
    }
}


//初始化游戏元素
-(void) initGameObjects
{
    gameObject = [[NSMutableArray alloc]init];
    for (int i = 0; i < 8; i ++) 
    {
        NSMutableArray * column = [[NSMutableArray alloc]init];
        for (int j = 0; j < 8; j ++) 
        {
            [column addObject:[[GameObject alloc]initObjectWithType:rand()%6]];
        }
        [gameObject addObject:column];
    }
    
    //添加道具图标
    propCursor = [[NSMutableArray alloc]init];
    for(int i=0; i<8; i++)
    {
        NSMutableArray* column = [[NSMutableArray alloc]init];
        for(int j=0; j<8; j++)
        {
            int pType = 0;
            int random = rand()%equipChance;
            
            if(random >= 0 && random <= 3)
            {
                pType = 2;
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setHasprop:YES];
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setProp_type:pType];
                [column addObject:[[CCSprite alloc]initWithFile:@"equip_3_1.png"]];
                
            }
            else if(random == 4 || random == 7 || random == 8)
            {
                pType = 0;
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setHasprop:YES];
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setProp_type:pType];
                [column addObject:[[CCSprite alloc]initWithFile:@"equip_1_1.png"]];
                
            }
            else if(random == 5)
            {
                pType = 1;
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setHasprop:YES];
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setProp_type:pType];
                [column addObject:[[CCSprite alloc]initWithFile:@"equip_2_1.png"]];
            }
            else if(random == 6)
            {
                pType = 3;
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setHasprop:YES];
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setProp_type:pType];
                [column addObject:[[CCSprite alloc]initWithFile:@"equip_4_1.png"]];
            }
            else
            {
                [[[gameObject objectAtIndex:i]objectAtIndex:j] setHasprop:NO];
                [column addObject:[[CCSprite alloc]initWithFile:@"equip_1_1.png"]];
                //[[[propCursor objectAtIndex:i]objectAtIndex:j] setVisible:NO];
            }
        }
        [propCursor addObject:column];
    }
    
    
    //将对象添加进入层的子列表
    int n = 0;
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {
            [self addChild:[[self.gameObject objectAtIndex:i] objectAtIndex:j] z:-2 tag:3
                + n ];
            if([[[gameObject objectAtIndex:i]objectAtIndex:j]hasprop])
            {
                [self addChild:[[self.propCursor objectAtIndex:i]objectAtIndex:j] z:-2 tag:3];
            }
            n = n++;
        }
    }
    //按照位置摆好元素
    //[self placeObject];
    [self firPlaceObject];
}

//初始化道具列表
- (void) initProplist
{
    proplist = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i ++) 
    {
        [proplist addObject:[NSNumber numberWithInt:0]]; 
    }
    
    //显示道具1数目
    NSNumber* equip = [proplist objectAtIndex:0];
    int equipnum = [equip intValue];
    equip1Str = [NSString stringWithFormat:@"%d", equipnum];
    showEquip1 = [CCLabelTTF labelWithString:equip1Str fontName:@"Marker Felt" fontSize:10];
    showEquip1.color = ccBLACK;
    showEquip1.anchorPoint = CGPointZero;
    showEquip1.position = CGPointMake(120.0f, 10.0f);
    [self addChild:showEquip1 z:2];
    //显示道具2数目
    equip = [proplist objectAtIndex:1];
    equipnum = [equip intValue];
    equip2Str = [NSString stringWithFormat:@"%d", equipnum];
    showEquip2 = [CCLabelTTF labelWithString:equip1Str fontName:@"Marker Felt" fontSize:10];
    showEquip2.color = ccBLACK;
    showEquip2.anchorPoint = CGPointZero;
    showEquip2.position = CGPointMake(160.0f, 10.0f);
    [self addChild:showEquip2 z:2];
    //显示道具3数目
    equip = [proplist objectAtIndex:2];
    equipnum = [equip intValue];
    equip3Str = [NSString stringWithFormat:@"%d", equipnum];
    showEquip3 = [CCLabelTTF labelWithString:equip1Str fontName:@"Marker Felt" fontSize:10];
    showEquip3.color = ccBLACK;
    showEquip3.anchorPoint = CGPointZero;
    showEquip3.position = CGPointMake(200.0f, 10.0f);
    [self addChild:showEquip3 z:2];
    //显示道具4数目
    equip = [proplist objectAtIndex:3];
    equipnum = [equip intValue];
    equip4Str = [NSString stringWithFormat:@"%d", equipnum];
    showEquip4 = [CCLabelTTF labelWithString:equip1Str fontName:@"Marker Felt" fontSize:10];
    showEquip4.color = ccBLACK;
    showEquip4.anchorPoint = CGPointZero;
    showEquip4.position = CGPointMake(240.0f, 10.0f);
    [self addChild:showEquip4 z:2];
}

//初始化删除标记数组
-(void) initCancel
{
    cancel = [[NSMutableArray alloc]init];
    for (int i = 0; i < 8; i ++) 
    {
        NSMutableArray * column = [[NSMutableArray alloc]init];
        for (int j = 0; j < 8; j ++) 
        {
            [column addObject:[NSNumber numberWithBool:NO]];
        }
        [cancel addObject:column];
    }
}

- (void) initZ_cancel
{
    z_cancel = [[NSMutableArray alloc]init];
    for (int i = 0; i < 8; i ++)
    {
        NSMutableArray * column = [[NSMutableArray alloc]init];
        for (int j = 0; j < 8; j ++)
        {
            [column addObject:[NSNumber numberWithBool:NO]];
        }
        [z_cancel addObject:column];
    }
}

//放置元素
-(void) firPlaceObject
{
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] settingDes:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)];
            
            if([[[gameObject objectAtIndex:i]objectAtIndex:j]hasprop])
            {
                [[[self.propCursor objectAtIndex:i]objectAtIndex:j]runAction:[CCPlace actionWithPosition:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];
            }
            
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCPlace actionWithPosition:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];            
        }
    }
}

//按下标放置元素
- (void) placeObject
{
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {            
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] settingDes:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)];
            
            if([[[gameObject objectAtIndex:i]objectAtIndex:j]hasprop])
            {
                [[[self.propCursor objectAtIndex:i]objectAtIndex:j]runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];
            }
            
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];            
        }
    }
}

//按下标放置元素
- (void) deletePlaceObject
{
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {            
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] settingDes:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)];
            
            if([[[gameObject objectAtIndex:i]objectAtIndex:j]hasprop])
            {
                [[[self.propCursor objectAtIndex:i]objectAtIndex:j]runAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];
            }
            
            [[[self.gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCMoveTo actionWithDuration:0.5f position:CGPointMake(j * elementSize + leftWhite, 480.0f - i * elementSize -topWhite)]];            
        }
    }
}

//游戏初始化的函数
- (void) gameInit
{
    while (![self getDone])
    {
        [self checkCancel];
        [self deleteObject];
        [self checkCancel];
    }
    [self firPlaceObject];
    state = UPDATE;
}

/*
 * 记分的规则
 */
- (void) scoreCountRuleCount:(int) howMany andTimes:(int) times
{
    switch(howMany)
    {
		case 3: score += 1 *times; totalScore += 1*times;break;
		case 4: score += 2 * times; totalScore += 2*times;break;
		case 5: score += 4 * times; totalScore += 4*times;break;
		case 6: score += 5 * times; totalScore += 5*times;break;
		case 7: score += 6 * times; totalScore += 6*times;break;
		default: break;
    }
}

/*
 * 处理玩家得分的信息
 */

-(void) scoreCheck: (int) times
{
    //同一行或者同一列有多少个被消除的对象
    int howMany = 0;
    //判断列消除了多少个对象，并加分
    for(int i = 0; i < 8; i ++)
    {
        howMany = 0;
        for(int j = 0; j < 8; j ++)
        {
            if([[[self.cancel objectAtIndex:i] objectAtIndex:j] boolValue])
            {
                howMany ++;
            }
            else
            {
                [self scoreCountRuleCount:howMany andTimes:times];
                howMany = 0;
            }
            if([[[cancel objectAtIndex:i] objectAtIndex:7] boolValue])
			{
				[self scoreCountRuleCount:howMany andTimes:times];
			}
        }
    }
    //判断行消除了多少个对象，并加分
    for(int j = 0; j < 8; j ++)
    {
        howMany = 0;
        for(int i = 0; i < 8; i ++)
        {
            if([[[self.cancel objectAtIndex:i] objectAtIndex:j]boolValue])
            {
                howMany ++;
            }
            else
            {
                [self scoreCountRuleCount:howMany andTimes:times];
                howMany = 0;
            }				
        }
        if([[[self.cancel objectAtIndex:7]objectAtIndex:j]boolValue])
        {
            [self scoreCountRuleCount:howMany andTimes:times];
        }
    }
}

/**
 * 返回玩家的得分
 * @return  
 */
- (int) getScore
{
    return score;
}

//需要修改
/**
 * 当玩家有新的指令动作时执行的函数
 */
- (void) game_run
{
    //是否需要交换选取的两个位置的游泳池元素的位置
    if(change)
    {
        scoreTimes = 1;
        change = NO;
        playanimation = YES;         
        
        cursorLas.visible = NO;
        cursorDes.visible = NO;
        

        
        //从数组存储位置上交换两个方块
        [self changeAdjacentCoorx:lastX CoorY:lastY desX:desX desY:desY];
        [self placeObject];
        //[self moveTwoObject];
        self.playanimation = YES;
        //检测行匹配
        //检测列匹配
        [self checkCancel];
        [self placeObject];
        //有没有可以消除的游泳池对象元素
        if([self getDone])
        {
            //没有，则将两个元素的位置复位
            rechange = YES; 
            

        }
        else
        {
            //有，则不需要将两个元素的位置复位
            rechange = NO;
        }
    }
}


- (BOOL) getDone
{
    if(restart)
    {
        restart = NO;
        return NO;
    }
    if(ColumnDone && RowDone)
    {
        return YES;
    }
    return NO;
}

/**
 * 检测行匹配的函数
 */
-(void) checkRowCancel
{
    BOOL doneYet = YES;
    for(int i = 0; i < 8; i ++)
    {
        for(int j = 0; j < 7; j ++)
        {
            //判断每一行元素是否可以匹配
            //判断当前j列与j+1列的值，相等的情况
            if(j< 7 &&[[[gameObject objectAtIndex:i] objectAtIndex:j] type]== [[[gameObject objectAtIndex:i] objectAtIndex:j + 1] type] )
            {
                //判断当前j+1列与j+2列的值，相等的情况
                if((j + 1)< 7 && [[[gameObject objectAtIndex:i] objectAtIndex: j + 1] type] == [[[gameObject objectAtIndex:i] objectAtIndex:j +2] type] )
                {
                    //将j，j+1，j+2设置为需要消除的
                    [[cancel objectAtIndex:i] replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
                    [[cancel objectAtIndex:i] replaceObjectAtIndex:j + 1 withObject:[NSNumber numberWithBool:YES]];
                    [[cancel objectAtIndex:i] replaceObjectAtIndex:j + 2 withObject:[NSNumber numberWithBool:YES]];
                    doneYet = NO;
                    //将j的值指向j+2
                    j = j + 2;
                    //当j没有到达最后一个的时候，判断j与j+1的值
                    while(j < 7)
                    {
                        if([[[gameObject objectAtIndex:i] objectAtIndex:j] type] == [[[gameObject objectAtIndex:i] objectAtIndex:j + 1] type])
                        {
                            //如果j与j+1的值相等，将j+1的设置为需要消去的。
                            [[cancel objectAtIndex:i] replaceObjectAtIndex:j + 1 withObject:[NSNumber numberWithBool:YES]];
                            //j指向下一个。
                            j = j +1;
                        }
                        else
                        {
                            //否则，中断内循环
                            break;
                        }
                    }
                }
                else
                {
                    //当只有前两个元素相同，而第三个元素不相同的时候，
                    //将j指向j+1，在for循环中，j将会继续+1，知道j+2继续循环
                    j = j + 1;
                }
            }
            else
            {
                //当前两个元素都不相同的时候,不需要对j做动作，因为在for循环中已经做出
            }
        }//这里完成一行的判断，进入下一行
    }//这里完成所有行的判断，结束行判断
    RowDone = doneYet;
}

/**
 * 检测列匹配的函数
 */
-(void) checkColumnCancel
{
    BOOL doneYet = YES;
    for(int i = 0; i < 8; i ++){
        for(int j = 0; j < 7; j ++){
            //判断每一行元素是否可以匹配
            //判断当前j列与j+1列的值，相等的情况
            if(j< 7 &&[[[gameObject objectAtIndex:j] objectAtIndex:i] type]== [[[gameObject objectAtIndex:j + 1] objectAtIndex:i] type] ){
                //判断当前j+1列与j+2列的值，相等的情况
                if((j + 1)< 7 && [[[gameObject objectAtIndex:j + 1] objectAtIndex: i] type] == [[[gameObject objectAtIndex:j + 2] objectAtIndex:i] type] ){
                    //将j，j+1，j+2设置为需要消除的
                    /*
                     cancle[i][j] = this.cancle[i][j +1] = this.cancle[i][j+2] = true;
                     */
                    [[cancel objectAtIndex:j] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                    [[cancel objectAtIndex:j + 1] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                    [[cancel objectAtIndex:j + 2] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                    doneYet = NO;
                    //将j的值指向j+2
                    j = j +2;
                    //当j没有到达最后一个的时候，判断j与j+1的值
                    while(j < 7){
                        if([[[gameObject objectAtIndex:j] objectAtIndex:i] type] == [[[gameObject objectAtIndex:j + 1] objectAtIndex:i] type]){
                            //如果j与j+1的值相等，将j+1的设置为需要消去的。
                            [[cancel objectAtIndex:j + 1] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                            //j指向下一个。
                            j = j +1;
                        }
                        else{
                            //否则，中断内循环
                            break;
                        }
                    }
                }
                else{
                    //当只有前两个元素相同，而第三个元素不相同的时候，
                    //将j指向j+1，在for循环中，j将会继续+1，知道j+2继续循环
                    j = j + 1;
                }
            }
            else{
                //当前两个元素都不相同的时候,不需要对j做动作，因为在for循环中已经做出
            }
        }//这里完成一行的判断，进入下一行
    }//这里完成所有行的判断，结束行判断
    ColumnDone = doneYet;
}

/**
 * 判断行列是否已经被消除
 */
-(void) checkCancel
{
    [self checkColumnCancel];
    [self checkRowCancel];
}

/**
 * 删除匹配的元素
 */
- (void) deleteObject
{
    //对每一列进行消除添加元素的判断
//    BOOL isplace = ![self getDone];
    for(int i = 0; i< 8; i++)
    {
        for(int j = 7; j > -1; j--)
        {
            if([[[self.cancel objectAtIndex:j] objectAtIndex:i]boolValue] )
            {
                //遇到可以消除的位置，忽略，继续往上访问元素
                //2011-7-16小裕添加-------//
                if([[[gameObject objectAtIndex:j] objectAtIndex:i]hasprop])
                {
                    NSNumber* a = [proplist objectAtIndex:[[[gameObject objectAtIndex:j] objectAtIndex:i]prop_type]];
                    int b = [a intValue];
                    b++;
                    [proplist replaceObjectAtIndex:[[[gameObject objectAtIndex:j] objectAtIndex:i]prop_type]  withObject:[NSNumber numberWithInt:b]];
                    
                    array[[[[gameObject objectAtIndex:j] objectAtIndex:i]prop_type]] = b;
                    
                    //添加道具数目
                    switch ([[[gameObject objectAtIndex:j] objectAtIndex:i]prop_type]) 
                    {
                        case 0:
                            equip1Str = [NSString stringWithFormat:@"%d",b];
                            [showEquip1 setString:equip1Str];
                            break;
                        case 1:
                            equip2Str = [NSString stringWithFormat:@"%d",b];
                            [showEquip2 setString:equip2Str];
                            break;
                        case 2:
                            equip3Str = [NSString stringWithFormat:@"%d",b];
                            [showEquip3 setString:equip3Str];
                            break;
                        case 3:
                            equip4Str = [NSString stringWithFormat:@"%d",b];
                            [showEquip4 setString:equip4Str];
                            break;
                            
                        default:
                            break;
                    }
                    
                    b=0;
                }
                //----------------------------//
            }
            else
            {
                //遇到需要不消除的位置，往下访问元素，如果下面的元素是被消除的位置，
                //则交换两个消除位置的标识，并把元素往下放，将当前指向的元素的值置为-1
                for(int temp = j; temp < 7; temp ++)
                {
                    //如果下一个元素是被消除的时候
                    if([[[cancel objectAtIndex:temp + 1] objectAtIndex: i]boolValue])
                    {
                        //交换cancle两个元素的位置
                        BOOL btemp = [[[cancel objectAtIndex:temp] objectAtIndex: i]boolValue];
                        [[cancel objectAtIndex:temp] replaceObjectAtIndex:i withObject:[[cancel objectAtIndex:temp + 1] objectAtIndex: i]];
                        [[cancel objectAtIndex:temp +1] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:btemp]];
                        //将gameObject的不用消除的元素往下沉；
                        [self changeAdjacentCoorx:temp + 1 CoorY:i desX:temp desY:i];
                    }
                    else
                    {
                        //如果下一个元素不是被消除，中断循环
                        break;
                    }
                }
            }
        }
        //将新的被删除的位置的对象池的值置为-1
        for(int depth = 7; depth > -1; depth --)
        {
            if([[[cancel objectAtIndex:depth] objectAtIndex: i] boolValue])
            {
                //删除并且添加新元素
                [[[gameObject objectAtIndex:depth] objectAtIndex:i] removeFromParentAndCleanup:YES];
                [[[propCursor objectAtIndex:depth] objectAtIndex:i] removeFromParentAndCleanup:YES];
                [[self.gameObject objectAtIndex:depth] replaceObjectAtIndex:i withObject:[[GameObject alloc]initObjectWithType:rand()%6]];
                [self addChild:[[gameObject objectAtIndex:depth] objectAtIndex:i]];
                //添加新的工具图标
                int random = rand()%equipChance;
                int pType = 0;
                if(random >= 0 && random <= 3)
                {
                    pType = 2;
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setHasprop:YES];
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setProp_type:pType];
                    [[propCursor objectAtIndex:depth]replaceObjectAtIndex:i withObject:[[CCSprite alloc]initWithFile:@"equip_3_1.png"]];
                    [self addChild:[[propCursor objectAtIndex:depth]objectAtIndex:i]];
                }
                else if(random == 4 || random == 7 || random == 8)
                {
                    pType = 0;
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setHasprop:YES];
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setProp_type:pType];
                    [[propCursor objectAtIndex:depth]replaceObjectAtIndex:i withObject:[[CCSprite alloc]initWithFile:@"equip_1_1.png"]];
                    [self addChild:[[propCursor objectAtIndex:depth]objectAtIndex:i]];
                }
                else if(random == 5)
                {
                    pType = 1;
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setHasprop:YES];
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setProp_type:pType];
                    [[propCursor objectAtIndex:depth]replaceObjectAtIndex:i withObject:[[CCSprite alloc]initWithFile:@"equip_2_1.png"]];
                    [self addChild:[[propCursor objectAtIndex:depth]objectAtIndex:i]];
                }
                else if(random == 6)
                {
                    pType = 3;
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setHasprop:YES];
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setProp_type:pType];
                    [[propCursor objectAtIndex:depth]replaceObjectAtIndex:i withObject:[[CCSprite alloc]initWithFile:@"equip_4_1.png"]];
                    [self addChild:[[propCursor objectAtIndex:depth]objectAtIndex:i]];
                }
                else
                {
                    [[[gameObject objectAtIndex:depth]objectAtIndex:i] setHasprop:NO];
                    [[propCursor objectAtIndex:depth]replaceObjectAtIndex:i withObject:[[CCSprite alloc]initWithFile:@"equip_1_1.png"]];
                    //[[[propCursor objectAtIndex:i]objectAtIndex:j] setVisible:NO];
                }
                //[[[propCursor objectAtIndex:depth]objectAtIndex:i] setPosition:CGPointMake(0, 480.0f - i * elementSize -topWhite)];
                
                //放置新元素的位置在上方
                //[[[gameObject objectAtIndex:depth] objectAtIndex:i]setPosition:CGPointMake(i * elementSize + leftWhite, 300.0f + 480.0f - depth * elementSize -topWhite)];
                //[[[propCursor objectAtIndex:depth] objectAtIndex:i]setPosition:CGPointMake(i * elementSize + leftWhite, 300.0f + 480.0f - depth * elementSize -topWhite)];
                
                //放置新元素的位置在上方
                [[[gameObject objectAtIndex:depth] objectAtIndex:i]setPosition:CGPointMake(i * elementSize + leftWhite, 480.0f -topWhite + 400.0f )];
                [[[propCursor objectAtIndex:depth] objectAtIndex:i]setPosition:CGPointMake(i * elementSize + leftWhite, 480.0f -topWhite + 400.0f )];
                
                //同时将cancel的标记置为NO
                [[cancel objectAtIndex:depth] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                
            }
        }
        
    }
    if (state == UPDATE) 
        [self placeObject];
    else
        [self firPlaceObject];
}

-(void) changeAdjacentCoorx:(int) coorx CoorY:(int) coory desX:(int) desx desY:(int) desy
{
    id temp = [[gameObject objectAtIndex:coorx] objectAtIndex:coory];
    [[gameObject objectAtIndex:coorx] replaceObjectAtIndex:coory withObject:[[gameObject objectAtIndex:desx] objectAtIndex:desy]];
    [[gameObject objectAtIndex:desx]replaceObjectAtIndex:desy withObject:temp];
    
    temp = [[propCursor objectAtIndex:coorx] objectAtIndex:coory];
    [[propCursor objectAtIndex:coorx]replaceObjectAtIndex:coory withObject:[[propCursor objectAtIndex:desx] objectAtIndex:desy]];
    [[propCursor objectAtIndex:desx]replaceObjectAtIndex:desy withObject:temp];

}

- (BOOL) isEmpty_Cancel
{
    for(int i=0;i<8;i++)
    {
        for(int j=0;j<8;j++)
        {
            if([[[cancel objectAtIndex:i] objectAtIndex:j]boolValue]) 
            {
                isClear=YES;
            }		
        }
    }
    if(isClear)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//游戏更新的函数
- (void) gameUpdate
{
    [self checkCancel];
    if ([self getDone]) 
    {
        scoreTimes = 1;
    }
    
    //改动，防止在重新初始化的时候，updategame会生效
    if(goon)
    {
        goon = NO;
        return;
    }
    if(dead)
    {
        dead = NO;
        return;
    }
    //肥哥的代码
    /*
    if (isClear) 
     {
        return;
    }
     */
    //换了顺序
    //这里图像会自动更新
    //播放普通消除的特效动画
    
    [self runObjectNormalAnimation];
    //-----------//
    //这里更新的是数据
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {
            [[[gameObject objectAtIndex:i] objectAtIndex:j] update];
        }
    }
    //等待动画完成
    playanimation = NO;
    int allfinish = 0;
    int fadeCount = 0;
    for (int i = 0; i < 8; i ++) 
    {
        for (int j = 0; j < 8; j ++) 
        {
            if(![[[gameObject objectAtIndex:i] objectAtIndex:j]playingAnimation])
            {
                allfinish ++;
            }else
            {
                playanimation = YES;
            }
            if([[[gameObject objectAtIndex:i] objectAtIndex:j] isfading])
            {
                fadeCount ++;
            }
        }
    }
    
    //动画播放完成，检测是否上次的交换不成立
    if (allfinish == 64) 
    {
        if (rechange) 
        {         
            //需要重新交换，则重新交换
            [self changeAdjacentCoorx:desX CoorY:desY desX:lastX desY:lastY];
            [self placeObject];
            //独自移动两个元素
            //[self moveTwoObject];
            //------------------//
            playanimation = YES;
            rechange = NO;
        }
    }
    
    if (fadeCount == 0) 
    {
        //改动，进度条的递增
        pro = pro++;
        progress.hidden = NO;
        [progress setProgress:(pro/900.0f)];
    }
    
    //------------------//
    if (!playanimation) 
    {
        if (![self getDone]) 
        {
            //这里播放消除音乐
            [[SimpleAudioEngine sharedEngine] playEffect:@"fade.wav" pitch:1.0f pan:1.0f gain:effectVolumn];
        }

        //计算分数
        [self scoreCheck:scoreTimes];
        scoreTimes *=2;         
        //改动，显示分数
        scoreStr = [NSString stringWithFormat:@"%d",score];
        [showScore setString:scoreStr];
        totalScoreStr = [NSString stringWithFormat:@"%d",totalScore];
        [showTotalScore setString:totalScoreStr];
        
        //改动，删除元素，并且添加新的元素
        [self deleteObject];
        
        //改动，检测循环和过关
        [noDeath CheckDeathLoopWithSize:8 Block:gameObject];
        BOOL deadthNode = [noDeath isdead];
        //出现死锁或者时间到了
        if(deadthNode || pro>900)
        {
//            state = INIT;
//            dead  = YES;
//            goon  = NO;
//            [self reInitGame];
            if (deadthNode) {
                dead_lock.visible = YES;
            }
            //检测分数有没有大于目标分数
            if(score < desScore)
            {
                state = MISSIONFAILED;
                //显示任务失败的图片
                gameOverMenu.visible = YES;
                dead = NO;
                goon = YES;
            }
        }
        if(score >= desScore)
        {
            state = MISSIONCLEAR;
            dead = NO;
            goon = YES;
            //显示任务成功的图片
            gameClearMenu.visible = YES;
        }
    }
    //动画全部放完了,再进行缩放的判断
    if (!playanimation) 
    {
        if ([self isEmpty_Cancel])
        {
            isClear = YES;
            return;
        }
    }
    //更新游戏的状态
    //state = UPDATE;
}

//触摸时间：点击开始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //将提示的图标设置为不可见
    cursor2Sed.visible = NO;
    cursor2Fir.visible = NO;
    CGPoint touchPoint = [touch locationInView:[touch view]];
    NSLog(@"x = %f, y = %f", touchPoint.x, touchPoint.y);
    if(touchPoint.x>10 && touchPoint.x<310 && touchPoint.y>75 && touchPoint.y<376)
    {
    //小裕修改-8-14
    if(bombstate)
    {
        [self getLastCoorx:touchPoint.x y:touchPoint.y];
        [self bombrow:lastX col:lastY];
        bombstate = NO;
        //这里播放炸弹的声音
        [[SimpleAudioEngine sharedEngine] playEffect:@"bomb.wav" pitch:1.0f pan:1.0f gain:effectVolumn];
        //[[SimpleAudioEngine sharedEngine] playEffect:@"bomb.wav" pitch:1.0f pan:1.0f gain:10];
        //----------//
    }
    if (state == UPDATE) {
        if (!self.playanimation) {
            if (self.hasFocus) {
                self.hasFocus = NO;
                //隐藏选中的图标
                cursorLas.visible = NO;
                [self getDesCoorx:touchPoint.x y:touchPoint.y];
            }
            if (!self.hasSelect) {
                [self getLastCoorx:touchPoint.x y:touchPoint.y];
                //显示选中的图标
                [cursorLas setPosition:CGPointMake([self lastY] * elementSize + leftWhite, 480.0f - [self lastX] * elementSize -topWhite)]; 
                cursorLas.visible = YES;
                self.hasSelect = YES;
                self.hasFocus = YES;
            }
            if (!self.change) {
                self.hasFocus = YES;
                [self getLastCoorx:touchPoint.x y:touchPoint.y];
                [cursorLas setPosition:CGPointMake([self lastY] * elementSize + leftWhite, 480.0f - [self lastX] * elementSize -topWhite)]; 
                cursorLas.visible = YES;
            }
        }
    }
    [self game_run];
    }
    return YES;
}

//触摸事件：点击结束
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}


//触摸事件：移动
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //小裕修改
    CGPoint touchPoint = [touch locationInView:[touch view]];
//    NSLog(@"x = %f, y = %f", touchPoint.x, touchPoint.y);
    
    if (state == UPDATE && !bombstate) {
        if (!self.playanimation) {
            if (hasSelect) {
                BOOL done = [self getDesCoorx:touchPoint.x y:touchPoint.y];
                if (done) {
                    self.hasFocus = NO;
                }
            }
        }
    }
    
    [self game_run];
    return;
}


//获得选择的第二个元素的坐标
-(BOOL)getDesCoorx:(float) x y:(float)y
{
		desY = (int)(x - 5)/elementSize;
		desX = (int)(y - 70)/elementSize;
		BOOL done = false;
		//防止越界
		if(desX < 0){
			desX = 0;
		}
		if(desX > 7){
			desX = 7;
		}
		if(desY < 0){
			desY = 0;
		}
		if(desY > 7){
			desY =7;
		}
		if(desY - lastY == 0){
			if(desX - lastX == 1){
				change = true;
				done = true;
			}
			else if(desX - lastX ==- 1){
				change = true;
				done = true;
			}
		}
		if(desX - lastX== 0){
			if(desY - lastY == 1){
				change = true;
				done = true;
			}
			else if(desY -lastY == -1){
				change = true;
				done = true;
			}
		}
//    NSLog(@"desx = %d desy = %d", desX, desY);
		return done;
	}

//获得选择的第一个元素的坐标
-(void) getLastCoorx:(float) x y:(float)y
{
		lastY = (int)(x - 5)/elementSize;
		lastX = (int)(y - 70)/elementSize;
    
		//mGame.hasFocus = true;
		if(lastX < 0){
			lastX = 0;
		}
		if(lastX > 7){
			lastX = 7;
		}
		if(lastY < 0){
			lastY = 0;
		}
		if(lastY > 7){
			lastY =7;
		}
//    NSLog(@"lastX = %d lastY = %d", lastX, lastY);
	}

//道具使用
//将对象池重新排列
-(void) reRange
{
    for (int i=0; i<5; i++)
    {
        for (int j=0; j<5; j=j+2)
        {
            int row = rand()%8;
            int column = rand()%8;
            GameObject* temp = [[gameObject objectAtIndex:i]objectAtIndex:j];
            [[gameObject objectAtIndex:i]replaceObjectAtIndex:j withObject:[[gameObject objectAtIndex:row]objectAtIndex:column]];
            [[gameObject objectAtIndex:row]replaceObjectAtIndex:column withObject:temp];
            
            CCSprite* temp1 = [[propCursor objectAtIndex:i]objectAtIndex:j];
            [[propCursor objectAtIndex:i]replaceObjectAtIndex:j withObject:[[propCursor objectAtIndex:row]objectAtIndex:column]];
            [[propCursor objectAtIndex:row]replaceObjectAtIndex:column withObject:temp1];
        }
    }
}

//使用道具“炸弹”将周围相邻的一格的元素都消去
-(void) bombrow:(int)row col:(int)column
{
    [[cancel objectAtIndex:row]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
    if(row == 0 && column == 0)
    {
        //处于左上角的情况
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        /////////////////////////////////////////
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
    }
    if(row == 0 && column == 7)
    {
        //处于右上角的情况
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        /////////////////////////////////////////
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
    }
    if(row == 7 && column == 0)
    {
        //处于左下角的情况
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        ///////////////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(row == 7 && column == 7)
    {
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        ////////////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(row == 0 && column != 0 && column != 7)
    {
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        //////////////////////////////////////////
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(row == 7 && column != 0 && column != 7)
    {
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        ////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(column == 0 && row != 0 && row != 7)
    {
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column+1] setHasprop:NO];
        /////////////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(column == 7 && row != 0 && row != 7)
    {
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column-1] setHasprop:NO];
        ///////////////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
    }
    if(row > 0 && row < 7 && column > 0 && column < 7)
    {
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row-1]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row]objectAtIndex:column-1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column+1] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column] setHasprop:NO];
        [[[gameObject objectAtIndex:row+1]objectAtIndex:column-1] setHasprop:NO];
        /////////////////////////////////////////
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row-1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column+1 withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];
        [[cancel objectAtIndex:row+1]replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:YES]];
    }
    [self runBombAnimation];
}

//消除相同种类的元素
-(void) eliminate
{
    int type = rand()%6;
    int count = 0;
    for(int i=0; i<8; i++)
    {
        for(int j=0; j<8; j++)
        {
            if(type == [[[gameObject objectAtIndex:i]objectAtIndex:j]gettingType])
            {
                [[cancel objectAtIndex:i]replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
                
                [[[gameObject objectAtIndex:i]objectAtIndex:j]setHasprop:NO];
                
                count++;
            }
        }
    }
    [self runThunderAnimation];
    score += count;
    totalScore += count;
}

//更新工具列表，增加工具
-(void) update_proplist
{
    for(int i=0; i<8; i++)
    {
        for(int j=0; j<8; j++)
            if([[[cancel objectAtIndex:i]objectAtIndex:j]boolValue] && [[[gameObject objectAtIndex:i]objectAtIndex:j] hasprop])
            {
                NSNumber* numTemp0 = [proplist objectAtIndex:0];
                int num0 = [numTemp0 intValue];
                NSNumber* numTemp1 = [proplist objectAtIndex:1];
                int num1 = [numTemp1 intValue];
                NSNumber* numTemp2 = [proplist objectAtIndex:2];
                int num2 = [numTemp2 intValue];
                NSNumber* numTemp3 = [proplist objectAtIndex:3];
                int num3 = [numTemp3 intValue];
                
                switch([[[gameObject objectAtIndex:i]objectAtIndex:j]prop_type])
                {
                case 0:
                        if(num0 <= 5)
                        {
                            num0++;
                            [proplist replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:num0]];
                            break;
                        }
                case 1:
                        if(num1 <= 5)
                        {
                            num1++;
                            [proplist replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:num1]];
                            break;
                        }
                case 2:
                        if(num2 <= 5)
                        {
                            num2++;
                            [proplist replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:num2]];
                            break;
                        }
                case 3:
                        if(num3 <= 5)
                        {
                            num3++;
                            [proplist replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:num3]];
                            break;
                        }
                }
            }
    }
}

//减少工具
-(void) reduceProplist:(int)type
{
    NSNumber* numTemp = [proplist objectAtIndex:0];
    int num = [numTemp intValue];
    num--;
    [proplist replaceObjectAtIndex:type withObject:[NSNumber numberWithInt:num]];
}

//注册事件
- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}

//注销事件
- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (void) step:(ccTime) time
{
//  NSLog(@"time = %d" , what);
    if (state == UPDATE) 
    {
        [self gameUpdate];
    }
}

-(void) reInitGame
{
    //初始化游戏的状态标志
    select = 0;
    RowDone = NO;
    ColumnDone = NO;
    hasFocus = NO;
    hasSelect = NO;
    change = NO;
    rechange = NO;
    scoreTimes = 1;
    playanimation = NO;
    lastX = 0;
    lastY = 0;
    desX = 0;
    desY = 0;
    zoomtimes = 0;
    isClear = NO;
    bombstate = NO;
//    desScore += 20;
    state = PAUSE;
    
    [self setEmptyCancel];
    //[self gameInit];
    
    while (![self getDone])
    {
        [self checkCancel];
        [self deleteObject];
        [self checkCancel];
    }
    [self firPlaceObject];
    
    if(dead)
    {
        //dead = NO;
        
        mission = 1;
        missionStr = [NSString stringWithFormat:@"%d",mission];
        [showMission setString:missionStr];
        
        [proplist replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:0]];
        equip1Str = [NSString stringWithFormat:@"%d",0];
        [showEquip1 setString:equip1Str];
        
        [proplist replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:0]];
        equip2Str = [NSString stringWithFormat:@"%d",0];
        [showEquip2 setString:equip2Str];
        
        [proplist replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:0]];
        equip3Str = [NSString stringWithFormat:@"%d",0];
        [showEquip3 setString:equip3Str];
        
        [proplist replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:0]];
        equip4Str = [NSString stringWithFormat:@"%d",0];
        [showEquip4 setString:equip4Str];
        
        desScore = 20;
        desScoreStr = [NSString stringWithFormat:@"%d",desScore];
        [showDesScore setString:desScoreStr];
    }
    if(goon)
    {
        //goon = NO;
        
        mission = mission + 1;
//        NSLog(@"%d",mission);
        missionStr = [NSString stringWithFormat:@"%d",mission];
        [showMission setString:missionStr];
        
        [proplist replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:0]];
        equip1Str = [NSString stringWithFormat:@"%d",0];
        [showEquip1 setString:equip1Str];
        
        [proplist replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:0]];
        equip2Str = [NSString stringWithFormat:@"%d",0];
        [showEquip2 setString:equip2Str];
        
        [proplist replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:0]];
        equip3Str = [NSString stringWithFormat:@"%d",0];
        [showEquip3 setString:equip3Str];
        
        [proplist replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:0]];
        equip4Str = [NSString stringWithFormat:@"%d",0];
        [showEquip4 setString:equip4Str];
        
        desScore += 20;
        desScoreStr = [NSString stringWithFormat:@"%d",desScore];
        [showDesScore setString:desScoreStr];
    }
    
    score = 0;
    scoreStr = [NSString stringWithFormat:@"%d",score];
    [showScore setString:scoreStr];
    
    [noDeath CheckDeathLoopWithSize:8 Block:gameObject];
    
    //初始化进度条
    pro = 0;
    [progress setProgress:pro];
    
    state = UPDATE;
}

-(void) setEmptyCancel
{
    for(int i=0; i<8; i++)
        for(int j=0; j<8; j++)
        {
            [[cancel objectAtIndex:i]replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
        }
}

//响应菜单的一些函数

//点击暂停
-(void) clickPause: (id) sender
{
    if (![self getChildByTag:700].visible) {
        [self getChildByTag:500].visible = YES;
        [self getChildByTag:600].visible = YES;
        state = PAUSE;
    }
}

//点击退出
-(void) clickQuit: (id) sender
{
    [self getChildByTag:700].visible = YES;
    [self getChildByTag:800].visible = YES;
    [self getChildByTag:500].visible = NO;
    [self getChildByTag:600].visible = NO;
    state = PAUSE;
}

//点击继续
-(void) clickResume: (id) sender
{
    [self getChildByTag:500].visible = NO;
    [self getChildByTag:600].visible = NO;
    state = UPDATE;
}

//点击取消
-(void) clickCancel:(id) sender
{
    [self getChildByTag:700].visible = NO;
    [self getChildByTag:800].visible = NO;
    state = UPDATE;
}

//点击确定退出
-(void) clickQuitConfirm: (id) sender
{
    //检测用户是否超过了自己的最高分，有的话更新数据库的信息
    name = [sqldata selectLastName];
    if (totalScore > [sqldata gettingScore]) {
        [sqldata updateSelectUserScore:name score:totalScore];
    }
    [sqldata insertScoreName:name score:totalScore];
    //退出之前关闭shujk
    [sqldata closeDB];
    //这里关闭背景音乐
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    //这里移除进度条。
    [progress removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5 scene:[DdpMenu scene]]];
    
}

-(void) clickGameOver:(id) sender
{
    NSLog(@"gameOver");
    gameOverMenu.visible = NO;
    dead_lock.visible = NO;
    //检测用户是否超过了自己的最高分，有的话更新数据库的信息
    name = [sqldata selectLastName];
    if (totalScore > [sqldata gettingScore]) {
        [sqldata updateSelectUserScore:name score:totalScore];
    }
    [sqldata insertScoreName:name score:totalScore];
    //---------------//
    dead  = YES;
    goon  = NO;
    [self reInitGame];
    totalScore = 0;
}

-(void) clickGamePass:(id) sender
{
    NSLog(@"gamePass");
    gameClearMenu.visible = NO;
    dead  = NO;
    goon  = YES;
    [self reInitGame];

}
//普通消除元素的特效
- (void) runObjectNormalAnimation
{
    for (int i = 0; i < 8; i ++) {
        for (int j = 0; j < 8; j ++) {
            if ([[[cancel objectAtIndex:i] objectAtIndex:j] boolValue]) {
                if ([[[gameObject objectAtIndex:i] objectAtIndex:j] gettingFading] == NO) {
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] settingFading:YES];
                    id act1 = [CCRotateTo actionWithDuration:0.2f angle:180.0f];
                    id act2 = [CCRotateTo actionWithDuration:0.2f angle:360.0f];
                    id act3 = [CCScaleTo actionWithDuration:0.3f scale:1.2f];
                    id act4 = [CCScaleTo actionWithDuration:0.4f scale:0.5f];
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCSequence actions:act1, act2, act3, act4, nil]];
                }
            }
        }
    }
}

//炸弹消除元素的特效
-(void) runBombAnimation
{
    for (int i = 0; i < 8; i ++) {
        for (int j = 0; j < 8; j ++) {
            if ([[[cancel objectAtIndex:i] objectAtIndex:j] boolValue]) {
                if ([[[gameObject objectAtIndex:i] objectAtIndex:j] gettingFading] == NO) {
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] settingFading:YES];
                    id act1 = [CCRotateTo actionWithDuration:0.1f angle:180.0f];
                    id act2 = [CCRotateTo actionWithDuration:0.1f angle:360.0f];
                    id act3 = [CCRotateTo actionWithDuration:0.1f angle:180.0f];
                    id act4 = [CCRotateTo actionWithDuration:0.1f angle:360.0f];
                    id act5 = [CCScaleTo actionWithDuration:0.3f scale:1.2f];
                    id act6 = [CCScaleTo actionWithDuration:0.4f scale:0.5f];
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCSequence actions:act1, act2, act3, act4, act5, act6,nil]];
                }
            }
        }
    }
}


//钻石的特效
-(void) runThunderAnimation
{
    for (int i = 0; i < 8; i ++) {
        for (int j = 0; j < 8; j ++) {
            if ([[[cancel objectAtIndex:i] objectAtIndex:j] boolValue]) {
                if ([[[gameObject objectAtIndex:i] objectAtIndex:j] gettingFading] == NO) {
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] settingFading:YES];
                    id act1 = [CCRotateTo actionWithDuration:0.1f angle:180.0f];
                    id act2 = [CCRotateTo actionWithDuration:0.1f angle:360.0f];
                    id act5 = [CCScaleTo actionWithDuration:0.5f scale:1.2f];
                    id act6 = [CCScaleTo actionWithDuration:0.6f scale:0.5f];
                    id seq1 = [CCSequence actions:act1, act2, act1, act2, act1, act2, act1, act2, 
                              act1, act2, act1, act2, act1, act2, act1, act2, act1, act2, act1, act2,nil];
                    id seq2 = [CCSequence actions:act5, act6, nil];
                    [[[gameObject objectAtIndex:i] objectAtIndex:j] runAction:[CCSpawn actions:seq1, seq2, nil]];
                }
            }
        }
    }
}

- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
