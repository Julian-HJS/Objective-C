//
//  JSPerson.h
//  KVC底层实现原理探究
//
//  Created by jinsheng huang on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSPerson : NSObject{
    @public
   
//    NSString *_name;
//    NSString *name;
//    NSString *isName;
//    NSString *_isName;
//
//    NSString *age;
//    NSString *_age;
//    NSString *isAge;
//    NSString *_isAge;
}
@property (nonatomic, copy) NSString* name;
@end

NS_ASSUME_NONNULL_END
