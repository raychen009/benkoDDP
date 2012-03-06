//
//  DdpData.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DdpData.h"

@implementation DdpData
//打开数据库
-(void) openDB
{
    //数据表名称
    userTableName =[[NSString alloc] init];
    userTableName = @"lin4";
    scorePlace = [[NSString alloc]init];
    scorePlace = @"scorelin48";
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask 
                                                                , YES); 
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"mydb"];
    
    if (sqlite3_open([databaseFilePath UTF8String], &database)==SQLITE_OK) { 
        NSLog(@"open sqlite db ok."); 
    }
    currentEvol = 0.5f;
    currentMvol = 0.5f;
}
//创建表
- (void) createTable
{
    char *errorMsg;    
    NSString * createSql = [NSString stringWithFormat:@"create table if not exists %@ (name text, mvol real, evol real, score integer, use integer)", userTableName];
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) { 
        NSLog(@"create ok."); 
    }
}

//创建分数排名的表
-(void) createScorePlace
{
    char *errorMsg;    
    NSString * createSql = [NSString stringWithFormat:@"create table if not exists %@ (name text,score integer)", scorePlace];
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) { 
        NSLog(@"create scoreplace ok."); 
    }
}

//添加分数记录
-(void) insertScoreName:(NSString *)name score:(int)x
{
    char* errorMsg;
    NSString * sql = [NSString stringWithFormat:@"INSERT OR ROLLBACK INTO '%@'('%@','%@') VALUES ('%@','%d')", scorePlace, @"name",@"score",name, x];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) { 
        NSLog(@"insert score ok."); 
    }else{
        NSLog(@"insert score faild."); 
    }
}

-(void) deleteScore:(int)x
{
    char * errorMsg;
    NSString * deleteSql = [NSString stringWithFormat:@"delete from %@ where score<'%d'", scorePlace, x];
    if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete score ok");
    }else
    {
        NSLog(@"delete score failed");
    }
}
//插入数据，如果有重复，则不插入数据
- (void) insertUserWithName:(NSString*) name
{
    char* errorMsg;
    //先判断数据是否有重复
    NSString * selectSql = [NSString stringWithFormat:@"select name from %@ where name='%@'",userTableName , name];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }else{
        NSLog(@"select failed");
    }
    if (sqlite3_step(statement) == SQLITE_ROW) {
        NSLog(@"已有相同的用户名");
    }else{
        NSLog(@"创建新的用户名");
        NSString * sql = [NSString stringWithFormat:@"INSERT OR ROLLBACK INTO '%@'('%@','%@', '%@','%@','%@') VALUES ('%@', '%f', '%f', '%d', '%d')", userTableName, @"name",@"mvol",@"evol",@"score",@"use" ,name, 0.5, 0.5, 1, 1];
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) { 
            NSLog(@"insert ok."); 
        }else{
            NSLog(@"insert faild."); 
        }
    }
}

//获取下一位用户的名字
-(NSString *) nextUser
{
    NSString * selectSql = [NSString stringWithFormat:@"select name, mvol, evol, score, use from %@ order by name asc", userTableName];
    
    if (sqlite3_step(nextStatement) == SQLITE_ROW) {
        double mvol = sqlite3_column_double(nextStatement, 1);
        double evol = sqlite3_column_double(nextStatement, 2);
        int score = sqlite3_column_int(nextStatement, 3);
        int use = sqlite3_column_int(nextStatement, 4);
//        mvol = 100;
        
        currentMvol = mvol;
        currentEvol = evol;
        NSLog(@"mvol = %f", currentMvol);
        NSLog(@"evol = %f", currentEvol);
        NSLog(@"score=%d", score);
        NSLog(@"use=%d", use);
        return [[NSString alloc] initWithCString:(char *)sqlite3_column_text(nextStatement, 0) encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"最后一位了");
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &nextStatement, nil) == SQLITE_OK) {
            NSLog(@"select ok");
        }
        if (sqlite3_step(nextStatement) == SQLITE_ROW) {
            NSLog(@"zailai");
            double mvol = sqlite3_column_double(nextStatement, 1);
            double evol = sqlite3_column_double(nextStatement, 2);
            int score = sqlite3_column_int(nextStatement, 3);
            int use = sqlite3_column_int(nextStatement, 4);
//            mvol = 100;
            currentMvol = mvol;
            currentEvol = evol;
            NSLog(@"mvol = %f", currentMvol);
            NSLog(@"evol = %f", currentEvol);
            NSLog(@"score=%d", score);
            NSLog(@"use=%d", use);
            return [[NSString alloc] initWithCString:(char *)sqlite3_column_text(nextStatement, 0) encoding:NSUTF8StringEncoding];
        }else{
            return nil;
        }
    }
}

- (void) deleteUser:(NSString *) name
{
    char * errorMsg;
    NSString * deleteSql = [NSString stringWithFormat:@"delete from %@ where name='%@'", userTableName, name];
    if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete ok");
    }else
    {
        NSLog(@"delete failed");
    }
}

//测试，用于显示所有的数据
-(void) displayRecord
{
//    const char *selectSqla="select name from persons1"; 
    NSString *selectSql = [NSString stringWithFormat:@"select name from %@", userTableName];
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }
    while (sqlite3_step(statement)==SQLITE_ROW) { 
//        int _id=sqlite3_column_int(statement, 0); 
        NSString *name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]; 
        NSLog(@"row>>, name %@",name); 
    }
    sqlite3_finalize(statement);
}

-(sqlite3_stmt *) scoreStatement
{
    NSString *selectSql = [NSString stringWithFormat:@"select name, score from %@ order by score desc", scorePlace];
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }
    return statement;
}

-(float) gettingMvol
{
    return currentMvol;
}

-(float) gettingEvol
{
    return currentEvol;
}

-(int) gettingScore
{
    return currentScore;
}
//更新声音数据
- (void) updateUser:(NSString *) name withMvol:(float) mvol andEvol:(float) evol
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update '%@' set mvol='%f', evol='%f' where name='%@'",userTableName, mvol, evol, name];
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"update ok");
    }else
    {
        NSLog(@"update failed");
    }
}

//更新用户的分数
-(void) updateSelectUserScore:(NSString *)name score:(int)x
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update '%@' set score='%d' where name='%@'", userTableName, x,name];
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"update ok");
    }else
    {
        NSLog(@"update failed");
    }
}
//使用用户名
-(void)useName:(NSString *)name
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update '%@' set use='%d'",userTableName, 1];
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"use update ok");
    }else
    {
        NSLog(@"use update failed");
    }
    NSString * useSql = [NSString stringWithFormat:@"update '%@' set use='%d' where name='%@'", userTableName, 0, name];
    if (sqlite3_exec(database, [useSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"use ok");
    }else
    {
        NSLog(@"use failed");
    }
}

//选择上次使用的用户名
-(NSString *) selectLastName
{
    NSString * selectSql = [NSString stringWithFormat:@"select name, mvol, evol, score from %@ where use='%d'", userTableName, 0];
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }
    NSString *name = nil;
    if (sqlite3_step(statement)==SQLITE_ROW) {
        name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]; 
        NSLog(@"row>>, name %@",name);
        currentMvol = sqlite3_column_double(statement, 1);
        currentEvol = sqlite3_column_double(statement, 2);
        currentScore = sqlite3_column_int(statement, 3);
        NSLog(@"score=%d", currentScore);
    }
    sqlite3_finalize(statement);
    return name;
}



//关闭数据库
-(void) closeDB
{
    //释放查询的sql文资源，如果没有释放，下次打开数据库的时候将不能写入
    sqlite3_finalize(nextStatement);
    //关闭数据库
    sqlite3_close(database); 
    NSLog(@"close db");
}
@end
