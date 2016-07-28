//
//  ViewController.m
//  Demo_Block
//
//  Created by wangpanpan on 16/7/21.
//  Copyright © 2016年 wangpanpan. All rights reserved.
//

#import "ViewController.h"
typedef int (^mathBlock2)(int ,int );

@interface ViewController ()
@property (nonatomic,copy)void (^myBlock)();//block作为属性
@property (nonatomic,copy)int (^mathBlock)(int,int );
@property (nonatomic,copy)mathBlock2 mathBlock2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
}

#pragma mark - Block 的定义 -

- (void)blockDefine{
    /*
     //1.无参数 无返回值的block的定义
     void (^myBlock1)() = ^(){
     NSLog(@"over");
     };
     myBlock1();
     
     //2.有参数 有返回值的block的定义
     int (^myBlock2)(int ,int ) = ^(int a,int b){
     return a+b;
     };
     NSLog(@"创业邦--------%d",myBlock2(1,1));
     */

}
#pragma mark - Block的3种类型 -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /*
     Block的3种类型
     不管在ARC还是MRC环境下，block内部如果没有访问外部变量，这个block是全局block__NSGlobalBlock__，形式类似函数，存储在内存中的代码区。
     在MRC下，block内部如果访问外部变量，这个block是栈block__NSStackBlock__，存储在内存中的栈上。
     在MRC下，block内部访问外部变量，同时对该block做一次copy操作，这个block是堆block__NSMallocBlock__，存储在内存中的堆上。
     在ARC下，block内部如果访问外部变量，这个block是堆block__NSMallocBlock__，存储在内存中的堆上，因为在ARC下，默认对block做了一次copy操作。
     */
    
    /*
    //block内部没有访问外部变量，全局Block  __NSGlobalBlock__
    void (^myBlock1)() = ^{
    };
    
    //MRC下 block内部访问外部变量，栈block __NSStackBlock__
    int a = 10;
    void (^myBlock2)() = ^{
        NSLog(@"%d",a);
    };
    
    //MRC下 block内部访问外部变量，对block做一次copy，堆block __NSMallocBlock__
    void(^myBlock3)() = ^{
        NSLog(@"%d",a);
    };
    NSLog(@"%@",[myBlock3 copy]);
    */
    
    
    [self blockAsPara1:^{
        NSLog(@"block作为参数");
    }];
    
    [self blockAsPara2:^(int a, int b) {
        NSLog(@"block作为参数");
    }];
}

#pragma mark - Block作为方法的参数 -

//将block作为方法的参数，可以用block来封装代码块。
- (void)blockAsPara1:(void (^)())block{
    block();//执行block内部的代码
}

- (void)blockAsPara2:(void (^)(int a,int b))paraBlock{
    paraBlock(1,2);
}

/*
 -(void)doMathWithBlock:(int (^)(int, int))mathBlock {
 self.label.text = [NSString stringWithFormat:@"%d", mathBlock(3, 5)];
 }
 
 // 如何调用
 -(IBAction)buttonTapped:(id)sender {
 [self doMathWithBlock:^(int a, int b) {
 return a + b;
 }];
 }
*/
#pragma mark - Block作为属性 -

- (void)blockAsProperty{
    [self setMyBlock:^{//给myBlock赋值
        NSLog(@"Block作为属性");
    }];
    NSLog(@"%@",self.myBlock);
    self.myBlock();//myBlock作为属性时的调用
}

/**************** ****************** ***************** *************** *************/

- (void)doMathWithBlock:(int (^)(int ,int)) mathBlock{
    self.mathBlock = mathBlock;
}
- (void)buttonClick{
    [self doMathWithBlock:^int(int a, int b) {
        return a+b;
    }];
}
- (void)button2Click{
    NSString *str = [NSString stringWithFormat:@"%d",self.mathBlock(1,1)];
}

#pragma mark - Block的方式遍历数组\字典 -

- (void)blockBianli{
    //1.利用block遍历数组
    NSArray *array = @[@"1",@"1",@"1",@"1"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%lu--%@",idx,obj);
    }];
    
    //2.利用block遍历字典
    NSDictionary *dict = @{@"a":@"a",@"a":@"a",@"a":@"a"};
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"创业邦--------%@:%@",key,obj);
    }];
}

#pragma mark - Block访问外部变量 -

/*
 block内部可以访问外部的变量，block默认是将其复制到其数据结构中来实现访问的。
 默认情况下，block内部不能修改外面的局部变量，因为通过block进行闭包的变量是const的。
 给局部变量加上__block关键字，这个局部变量就可以在block内部修改，block是复制其引用地址来实现访问的。
*/

- (void)blockYinYong{
    int a = 10;
    __block int b = 20;
    NSLog(@"创业邦--------a=%d:%p,b=%d:%p",a,&a,b,&b);
    void(^myBlock)() = ^{
        b = 10;
        NSLog(@"创业邦--------a=%d:%p,b=%d:%p",a,&a,b,&b);

    };
    myBlock();
    NSLog(@"创业邦--------a=%d:%p,b=%d:%p",a,&a,b,&b);

}

#pragma mark - Block作为属性应该用copy修饰 -

/*
 当用weak、assign修饰block属性时，block访问外部变量，此时block的类型是栈block。保存在栈中的block，当block所在函数\方法返回\结束，该block就会被销毁。在其他方法内部调用访问该block，就会引发野指针错误EXC_BAD_ACCESS。
 当用copy、strong修饰block属性时，block访问外部变量，此时block的类型是堆block。保存在堆中的block，当引用计数器为0时被销毁，该类型block是由栈类型的block从栈中复制到堆中形成的，因此可以在其他方法内部调用该block。在ARC下，strong和copy都可以用来修饰block，但是建议修饰block属性使用copy。
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
