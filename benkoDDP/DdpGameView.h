//
//  DdpGameView.h
//  benkoDDP
//
//  Created by kwan terry on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "CheckDeathLoop.h"
#import "DdpData.h"
@interface DdpGameView : CCLayer
{
    //新添加
    int select;
    int state;                  //游戏的状态
    int lastState;              //游戏的上一个状态
    int mission;                //游戏的关卡
    BOOL restart;               //游戏是否重新开始
    BOOL RowDone, ColumnDone;   //行列是否被消除的标记
    BOOL hasFocus;              //玩家是否选中了一个游泳池的元素的标记
    BOOL hasSelect;             //玩家是否选中了一个游泳池元素的标记，用来拖动图标
    BOOL change;                //是否交换两个元素的位置
    BOOL rechange;              //是否需要把上次交换的两个元素的位置复位
    int scoreTimes;             //积分的倍数
    BOOL playanimation;                     //当前游戏是否正在播放动画
    int lastX, lastY, desX, desY;           //玩家第一次，和第二次选择游泳池元素的坐标编号
    int score, totalScore, desScore;        //玩家进行游戏时获得的分数的变量
    int zoomtimes;
    BOOL isClear;               //是否正在缩放元素
    BOOL bombstate;             //判断是否使用了“炸弹”的道具
    
    BOOL dead;                  //判断是否死亡
    BOOL goon;                  //判断是否继续下一关
    
    CheckDeathLoop* noDeath;     //检测死亡的循环
    
    CCSprite* cursorLas;        //第一次选中标记
    CCSprite* cursorDes;        //第二次选中标记
    CCSprite* cursor2Fir;       //提示第一个标记
    CCSprite* cursor2Sed;       //提示第二个标记
    
    CCLabelTTF* showTotalScore; //用来显示总分的label
    CCLabelTTF* showDesScore;   //用来显示目标分数的label
    CCLabelTTF* showScore;      //用来显示分数的label
    CCLabelTTF* showMission;    //用来显示关卡的label
    
    CCLabelTTF* showEquip1;
    CCLabelTTF* showEquip2;
    CCLabelTTF* showEquip3;
    CCLabelTTF* showEquip4;    
    
    NSString* scoreStr;         //用来显示分数的字符串
    NSString* totalScoreStr;
    NSString* desScoreStr;
    NSString* missionStr;
    
    NSString* equip1Str;
    NSString* equip2Str;
    NSString* equip3Str;
    NSString* equip4Str;
    
    int array[4];
    
    float pro;
    UIProgressView* progress;       //显示进度条
    
    //下面的很重要的一些数组
    //游泳池元素的数组
    NSMutableArray * gameObject;
    //标记消除的位置的数组
    NSMutableArray * cancel;
    //道具图标的数组
    NSMutableArray* propCursor;
    //道具列表的数组
    NSMutableArray * proplist;
    //肥哥写的数组
    NSMutableArray * z_cancel;
    
    //用户信息
    DdpData *sqldata;
    NSString *name;
    int userScore;
    //控制背景音乐和音效的变量
    float musicVolumn;
    float effectVolumn;
    //显示过关和失败的图片
    CCMenu * gameOverMenu;
    CCMenu * gameClearMenu;
    CCLabelTTF * dead_lock ;
}
//
@property (readwrite)int select;
//
@property (readwrite)int state;  
@property (readwrite)int lastState;  
@property (readwrite)int mission;    
@property (readwrite)BOOL restart;   
@property (readwrite)BOOL RowDone, ColumnDone;   
@property (readwrite)BOOL hasFocus;      
@property (readwrite)BOOL hasSelect;     
@property (readwrite)BOOL change;        
@property (readwrite)BOOL rechange;      
@property (readwrite)int scoreTimes;     
@property (readwrite)BOOL playanimation;     
@property (readwrite)int lastX, lastY, desX, desY;       
@property (readwrite)int score, totalScore, desScore;       
@property (readwrite)int zoomtimes;
@property (readwrite)BOOL isClear;   
@property (readwrite)BOOL bombstate;
@property (readwrite)float pro;

@property (retain)UIProgressView *progress;
@property (retain)NSMutableArray *propCursor;
@property (retain)NSMutableArray *gameObject;
@property (retain)NSMutableArray *cancel;
@property (retain)NSMutableArray *proplist;
@property (retain)NSMutableArray *z_cancel;

@property (readwrite)float musicVolumn;
@property (readwrite)float effectVolumn;

+(CCScene *) scene;
- (void) gameInit;
- (BOOL) getDone;
- (void) firPlaceObject;
- (void) placeObject;
- (void) deleteObject;
- (void) deletePlaceObject;
- (void) gameUpdate;
- (void) step:(ccTime) time;
- (void) initGameObjects;
- (void) initProplist;
-(void) initCancel;
-(void) checkCancel;
- (void) initZ_cancel;
-(BOOL)getDesCoorx:(float) x y:(float)y;
-(void) getLastCoorx:(float) x y:(float)y;
-(void) changeAdjacentCoorx:(int) coorx CoorY:(int) coory desX:(int) desx desY:(int) desy;
-(void) reRange;
-(void) eliminate;
-(void) bombrow:(int)row col:(int)column;
-(void) reInitGame;
-(void) setEmptyCancel;
- (void) runObjectNormalAnimation;
- (void) runBombAnimation;
- (void) runThunderAnimation;


@end
