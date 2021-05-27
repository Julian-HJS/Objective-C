//
//  JSTeather.h
//  KVC底层实现原理探究一
//
//  Created by jinsheng huang on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    float x, y, z;
} ThreeFloats;

@interface JSTeather : NSObject
@property (nonatomic, copy)   NSString          *name;
@property (nonatomic, copy)   NSString          *subject;
@property (nonatomic, copy)   NSString          *nick;
@property (nonatomic, assign) int               age;
@property (nonatomic, assign) int               height;
@property (nonatomic, strong) NSMutableArray    *penArr;
@property (nonatomic)         ThreeFloats       threeFloats;
@end

NS_ASSUME_NONNULL_END
