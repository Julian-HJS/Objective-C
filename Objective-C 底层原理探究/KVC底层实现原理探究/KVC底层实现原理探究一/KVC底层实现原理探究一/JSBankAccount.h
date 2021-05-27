//
//  JSBankAccount.h
//  KVC底层实现原理探究
//
//  Created by jinsheng huang on 2021/5/22.
//

#import <Foundation/Foundation.h>
#import "JSPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBankAccount : NSObject
@property (nonatomic, copy) NSString* bankName;         // An attribute
@property (nonatomic, strong) JSPerson* owner;          // A to-one relation
@property (nonatomic, strong) NSArray* dayArray;        // A to-many relation
@property (nonatomic, strong) NSSet* mySet;
@property (nonatomic, strong) NSOrderedSet* orderSet;

@end

NS_ASSUME_NONNULL_END
