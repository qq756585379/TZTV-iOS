//
//  DBManager.m
//  TZTV
//
//  Created by Luosa on 2016/11/23.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@interface DBManager()

@end

@implementation DBManager

static FMDatabase *_db;

+ (void)initialize{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tuzi_data.db"];
    YJLog(@"%@",file);
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS tz_gouwuche(id integer PRIMARY KEY, model blob NOT NULL, model_id text NOT NULL);"];
}

//+ (void)addToShopCart:(ShopCartModel *)deal{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
//    [_db executeUpdateWithFormat:@"INSERT INTO tz_gouwuche(model, model_id) VALUES(%@, %@);", data, deal.goods_id];
//}
//
//+ (void)removeShopCart:(ShopCartModel *)deal{
//    [_db executeUpdateWithFormat:@"DELETE FROM tz_gouwuche WHERE model_id = %@;", deal.goods_id];
//}

+ (NSMutableArray *)getShopCartArray{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM tz_gouwuche;"];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        ShopCartModel *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"model"]];
        [deals addObject:deal];
    }
    return deals;
}

@end








