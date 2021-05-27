//
//  ViewController.m
//  KVC底层实现原理探究一
//
//  Created by jinsheng huang on 2021/5/26.
//

#import "ViewController.h"
#import "JSPerson.h"
#import "JSBankAccount.h"
#import "JSTeather.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JSBankAccount *methodTest = [[JSBankAccount alloc] init];
    //属性直接赋值，调用setter方法
    methodTest.bankName = @"工商银行";
    methodTest.owner = [[JSPerson alloc] init];
    methodTest.owner.name = @"Julian";
    /*
     使用秘钥访问属性的方法
     */
    //1.valueForKey访问
    NSLog(@"name =%@", [methodTest valueForKey:@"bankName"]);
    //2.valueForKeyPath 访问
    NSLog(@"%@",[methodTest valueForKeyPath:@"owner.name"]);
    //3.dictionaryWithValuesForKeys 方法访问
    NSArray * arr = @[@"bankName",@"owner"];
    NSLog(@"%@",[methodTest dictionaryWithValuesForKeys:arr]);
    
    /*
     使用密钥设置属性值方法探究
     */
    //1.setValue:forKey:方法设置
    [methodTest setValue:@"中国银行" forKey:@"bankName"];
    NSLog(@"bankName@setValue:%@",methodTest.bankName);
    //2.setValue:forKeyPath:方法设置
    [methodTest setValue:@"xiaoming" forKeyPath:@"owner.name"];
    NSLog(@"owner.name@setValue:forKeyPath:===%@",methodTest.owner.name);
    //2.setValuesForKeysWithDictionary:方法设置
    NSDictionary *keyValuesDic = @{@"bankName":@"广发银行"};
    [methodTest setValuesForKeysWithDictionary:keyValuesDic];
    NSLog(@"setValuesForKeysWithDictionary:===%@",methodTest.bankName);
    
    //访问数组
    [methodTest setValue:@[@1,@2,@3,@4,@5] forKey:@"dayArray"];
    NSLog(@"dayArray:===%@",[methodTest valueForKey:@"dayArray"]);
    NSLog(@"dayArray@mutableArrayValueForKeyPath:===%@",[methodTest mutableArrayValueForKey:@"dayArray"]);
    
   
    // 聚合运算符测试
//    [self aggregation_operators_test];
    //数组运算符测试
//    [self arrayOperator];
    //嵌套数组
//    [self arrayNesting];
    //嵌套set
//    [self setNesting];
    //结构体
    JSTeather *myT = [[JSTeather alloc] init];
    ThreeFloats floats = {1.,2.,3.};
    NSValue *value     = [NSValue valueWithBytes:&floats objCType:@encode(ThreeFloats)];
    [myT setValue:value forKey:@"threeFloats"];
    NSValue *value1    = [myT valueForKey:@"threeFloats"];
    NSLog(@"结构体@valueForKey===%@",value1);
    
    ThreeFloats th;
    [value1 getValue:&th];
    NSLog(@"结构体@getValue===%f-%f-%f",th.x,th.y,th.z);
    
    // Do any additional setup after loading the view.
}

//聚合运算符 @avg、@count、@max、@min、@sum
- (void)aggregation_operators_test{
    NSMutableArray *testArray = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        JSTeather *teather = [[JSTeather alloc]init];
        NSDictionary *dic = @{
            @"name":[NSString stringWithFormat:@"酷走天涯_%d",i],
            @"age":@(18+i),
            @"nick":[NSString stringWithFormat:@"Julian_%d",i],
            @"height":@(170 + i),
        };
        [teather setValuesForKeysWithDictionary:dic];
        [testArray addObject:teather];
    }
    NSLog(@"testArray====%@", testArray);
    //返回一个数组，包含对每个接收方的元素调用-valueForKey:的结果
    NSLog(@"height===%@", [testArray valueForKey:@"height"]);
    
    //身高平均值
    float avg =[[testArray valueForKeyPath:@"@avg.height"] floatValue];
    NSLog(@"avg height===%f",avg);
    //元素个数
    int count = [[testArray valueForKeyPath:@"@count"] intValue];
    NSLog(@"@count.height===%d", count);
    //求和敏
    int sum = [[testArray valueForKeyPath:@"@sum.height"] intValue];
    NSLog(@"%d", sum);
    //最大值
    int max = [[testArray valueForKeyPath:@"@max.height"] intValue];
    NSLog(@"@max.height===%d", max);
    //最小值
    int min = [[testArray valueForKeyPath:@"@min.height"] intValue];
    NSLog(@"@max.height===%d", min );
}

// 数组操作符 @distinctUnionOfObjects @unionOfObjects
- (void)arrayOperator{
    NSMutableArray *teatherArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        JSTeather *teather = [[JSTeather alloc] init];
            NSDictionary* dic = @{
                @"name":[NSString stringWithFormat:@"酷走天涯_%d",i],
                @"age":@(18+i),
                @"nick":[NSString stringWithFormat:@"Julian_%d",i],
                @"height":@(170 + i%3),
            };
        [teather setValuesForKeysWithDictionary:dic];
        [teatherArray addObject:teather];
    }
    NSLog(@"testArray====%@", teatherArray);
    NSLog(@"height====%@", [teatherArray valueForKey:@"height"]);
    // 返回操作对象指定属性的集合, 不去重
    NSArray* arr1 = [teatherArray valueForKeyPath:@"@unionOfObjects.height"];
    NSLog(@"@unionOfObjects.height== %@", arr1);
    // 返回操作对象指定属性的集合 -- 去重
    NSArray* arr2 = [teatherArray valueForKeyPath:@"@distinctUnionOfObjects.height"];
    NSLog(@"@distinctUnionOfObjects.height== %@", arr2);
    
}

// 嵌套集合(array&set)操作 @distinctUnionOfArrays @unionOfArrays @distinctUnionOfSets
- (void)arrayNesting{
    NSMutableArray *teatherArray1 = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        JSTeather *teather = [[JSTeather alloc] init];
            NSDictionary* dic = @{
                @"name":[NSString stringWithFormat:@"酷走天涯_%d",i],
                @"age":@(18+i),
                @"nick":[NSString stringWithFormat:@"Julian_%d",i],
                @"height":@(170 + i),
            };
        [teather setValuesForKeysWithDictionary:dic];
        [teatherArray1 addObject:teather];
    }
    
    NSMutableArray *teatherArray2 = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        JSTeather *teather = [[JSTeather alloc] init];
            NSDictionary* dic = @{
                @"name":[NSString stringWithFormat:@"酷酷_%d",i],
                @"age":@(18+i),
                @"nick":[NSString stringWithFormat:@"Son_%d",i],
                @"height":@(180 + i%3),
            };
        [teather setValuesForKeysWithDictionary:dic];
        [teatherArray2 addObject:teather];
    }
    
    // 嵌套数组
    NSArray* nestArr = @[teatherArray1, teatherArray2];
    //嵌套数组执行valueForKey方法，返回结果也是嵌套数组
    NSArray *test = [nestArr valueForKey:@"height"];
    NSLog(@"嵌套数组height===%@",test);
    //不去重
    NSArray* arr = [nestArr valueForKeyPath:@"@distinctUnionOfArrays.height"];
    NSLog(@"@distinctUnionOfArrays.height== %@", arr);
    // 去重
    NSArray* arr1 = [nestArr valueForKeyPath:@"@unionOfArrays.height"];
    NSLog(@"@unionOfArrays.height== %@", arr1);
}

- (void)setNesting{
    NSMutableSet *teatherSet1 = [NSMutableSet set];
    for (int i = 0; i < 10; i++) {
        JSTeather *teather = [[JSTeather alloc]init];
        NSDictionary* dic = @{
            @"name":[NSString stringWithFormat:@"酷走天涯_%d",i],
            @"age":@(18+i),
            @"nick":[NSString stringWithFormat:@"Julian_%d",i],
            @"height":@(170 + i),
        };
        [teather setValuesForKeysWithDictionary:dic];
        [teatherSet1 addObject:teather];
    }
    NSLog(@"personSet1== %@", [teatherSet1 valueForKey:@"height"]);
    
    NSMutableSet *teatherSet2 = [NSMutableSet set];
    for (int i = 0; i < 10; i++) {
        JSTeather *teather = [[JSTeather alloc]init];
        NSDictionary* dic = @{
            @"name":[NSString stringWithFormat:@"酷走天涯_%d",i],
            @"age":@(18+i),
            @"nick":[NSString stringWithFormat:@"Julian_%d",i],
            @"height":@(180 + i%3),
        };
        [teather setValuesForKeysWithDictionary:dic];
        [teatherSet2 addObject:teather];
    }
    //NSSet会自动合并相同项
    NSSet *test =[teatherSet2 valueForKey:@"height"];
    NSLog(@"personSet2=== %@", test);
    // 嵌套set
    NSSet* nestSet = [NSSet setWithObjects:teatherSet1, teatherSet2, nil];
    // 交集
    NSArray* arr1 = [nestSet valueForKeyPath:@"@distinctUnionOfSets.height"];
    NSLog(@"@distinctUnionOfSets.height== %@", arr1);
}


@end
