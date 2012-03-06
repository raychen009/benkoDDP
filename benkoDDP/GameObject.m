//
//  GameObject.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize type;
@synthesize hasadd;
@synthesize hasprop;
@synthesize objectMoving;
@synthesize scale;
@synthesize scaleTimes;
@synthesize prop_type;
@synthesize frameCount;
@synthesize destination;
@synthesize isfading;


- (int) gettingType
{
    return type;
}

//游戏对象初始化，根据对象的类型和位置来初始化
-(id) initObjectWithType:(int)objectType
{
    
    switch(objectType)
    {
        case 0:{
            self = [self initWithFile:@"spite_1.png"];
        }break;
        case 1:{
            self = [self initWithFile:@"spite_2.png"];
        }break;
        case 2:{
            self = [self initWithFile:@"spite_3.png"];
        }break;
        case 3:{
            self = [self initWithFile:@"spite_4.png"];
        }break;
        case 4:{
            self = [self initWithFile:@"spite_5.png"];
        }break;
        case 5:{
            self = [self initWithFile:@"spite_6.png"];
        }break;
        default:{
            self = [self initWithFile:@"spite_1.png"];
        }break;
    }
    self.scale = NO;
    self.scaleTimes = 10;
    self.objectMoving = NO;
    self.frameCount = 0;
    self.hasprop = NO;
    self.hasadd = NO;
    self.prop_type = 0;
    self.type = objectType;
    self.isfading = NO;
    return self;
    //将坐标赋值给对象
}
- (void) settingFading:(BOOL)b
{
    isfading = b;
}

-(BOOL) gettingFading
{
    return isfading;
}
//对象是否在运动当中
- (BOOL) playingAnimation
{
    return self.objectMoving;
}

- (CGPoint) gettingDes
{
    return destination;
}

- (void) settingDes:(CGPoint) xy
{
    destination = xy;
}


- (void) update
{
//    if ((self.position.x - destination.x <-0.1f && self.position.x - destination.x > 0.1f) || (self.position.y - destination.y < -0.1f && self.position.y - destination.y > 0.1f)) 
//    {
//        self.objectMoving = YES;
//    }
//    else
//    {
//        self.objectMoving = NO;
//    }
    
    //这里是消除时候用到的
    if (isfading) {
        frameCount ++;
    }
    
    //-----------------//
    if (self.position.x == destination.x) {
        if (self.position.y == destination.y) {
            if (isfading == NO) {
                self.objectMoving = NO;
            }else{
                if (frameCount >= 20) {
                    self.objectMoving = NO;
                }else{
                    self.objectMoving = YES;
                }
            }
        }else{
            self.objectMoving = YES;
        }
    }else{
        self.objectMoving = YES;
    }
     
}
@end
