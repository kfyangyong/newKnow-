//
//  ViewController.m
//  NewRead
//
//  Created by qingyun on 16/3/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeViewController.h"
#import "comment.h"
#import "HomeCell.h"
#import "HomeModels.h"
#import "DataManager.h"
#import "DetailVC.h"
#import "UINavigationController+Notifion.h"
#import "DataNetWorking.h"

#define btnW [UIScreen mainScreen].bounds.size.width/5
#define scrollH ([UIScreen mainScreen].bounds.size.height - 94)
#define rowHight 100;
@interface HomeViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,AboutNetData>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *titleArr;//标题
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *middlTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) NSArray *leftModels;
@property (nonatomic,strong) NSArray *midleModels;
@property (nonatomic,strong) NSArray *rightModels;

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger lasterContentOfset;//上次偏移量
@property(nonatomic,strong)UIRefreshControl *freshControl1;
@property(nonatomic,strong)UIRefreshControl *freshControl2;
@property(nonatomic,strong)UIRefreshControl *freshControl3;
@property(nonatomic,assign)BOOL isRefrsh;//标示是否是下拉刷新；
@property (nonatomic,strong) NSString *lastId;
//@property (nonatomic,strong) NSString *currentTitle;
@property (nonatomic,strong) DataNetWorking *dataNet;
@end

@implementation HomeViewController

static NSString *identifer = @"homeCell";

- (NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = @[@"热点",@"财经",@"美食",@"旅游",@"运动", @"时尚",@"健康",@"阅读",@"情感",@"科技",@"军事",@"星座",@"电影"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScroll];
    [self addTitleBtn];
    [self addTableView];
    
    UIButton *btn = [self.titleScroll viewWithTag:100];
    [self btnClick:btn];
    self.dataNet = [[DataNetWorking alloc] init];
    self.dataNet.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestNetworkingWithTableView:_leftTableView];
}

#pragma mark - 创建界面

- (void)setScroll{
    
    self.titleScroll.delegate = self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.contentSize = CGSizeMake(btnW * self.titleArr.count, 30);

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenW * 3, scrollH);
    self.titleScroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.backgroundColor = [UIColor orangeColor];
}

- (void)addTitleBtn{
    
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, 0, btnW, 30);
        btn.tag = i + 100;
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
             [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [self.titleScroll addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addTableView{
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, scrollH) style:UITableViewStylePlain];
    _middlTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, scrollH) style:UITableViewStylePlain];
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW * 2, 0, ScreenW, scrollH) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tag = 1;
    [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:identifer];
    
    _middlTableView.dataSource = self;
    _middlTableView.delegate = self;
    _middlTableView.tag = 2;
    [_middlTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:identifer];
    
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tag = 3;
    [_rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:identifer];
    
    [self.scrollView addSubview:_leftTableView];
    [self.scrollView addSubview:_middlTableView];
    [self.scrollView addSubview:_rightTableView];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //添加刷新
    _freshControl1 = [[UIRefreshControl alloc] init];
    _freshControl1.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_freshControl1 addTarget:self action:@selector(refreshStart) forControlEvents:UIControlEventValueChanged];
    [_leftTableView addSubview:_freshControl1];
    
    _freshControl2 = [[UIRefreshControl alloc] init];
    _freshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_freshControl2 addTarget:self action:@selector(refreshStart) forControlEvents:UIControlEventValueChanged];
    [_middlTableView addSubview:_freshControl2];
    
    _freshControl3 = [[UIRefreshControl alloc] init];
    _freshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_freshControl3 addTarget:self action:@selector(refreshStart) forControlEvents:UIControlEventValueChanged];
    [_rightTableView addSubview:_freshControl3];
}

#pragma mark - set btn

- (void)btnClick:(UIButton*)sender{
    [self endRefresh];
    _currentIndex = sender.tag - 100;
    [self scrollChange];
    [self btnScrollWithBtn:sender];
    [[[DataNetWorking alloc] init] getNewsWithCateId:_currentIndex];
    if (_currentIndex==0) {
        [_leftTableView reloadData];
    }else if(_currentIndex == self.titleArr.count - 1){
        [_rightTableView reloadData];
    }else{
        [_middlTableView reloadData];
    }
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        [self.middlTableView reloadData];

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getMessage) userInfo:nil repeats:NO];
}

- (void)getMessage{
    if ( (_currentIndex > 0 && _currentIndex<self.titleArr.count) && _midleModels.count == 0) {
        [self.navigationController showNavigationViewWithTitle:@"没有内容,下拉刷新下试试"];
    }
}

//title偏移
- (void)btnScrollWithBtn:(UIButton *)sender{
    //btn 颜色
    NSArray *arr = self.titleScroll.subviews;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [obj setFont:[UIFont systemFontOfSize:15]];
        };
    }];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sender setFont:[UIFont systemFontOfSize:20]];
    //titleScroll的偏移
    NSInteger i = sender.tag - 100;
    
    if (i > 2 && i < self.titleArr.count - 3) {
        [self.titleScroll setContentOffset:CGPointMake(btnW * (i-2), 0) animated:YES];
    }else if (i > self.titleArr.count-4){
        [self.titleScroll setContentOffset:CGPointMake(btnW * (self.titleArr.count-5), 0) animated:YES];
    }else{
         [self.titleScroll setContentOffset:CGPointMake( 0, 0) animated:YES];
    }
}
//scroll偏移
- (void)scrollChange{
    if (_currentIndex == 0) {
        self.scrollView.contentOffset =CGPointMake(0, 0);
    }else if(_currentIndex >self.titleArr.count-2){
        self.scrollView.contentOffset =CGPointMake(ScreenW *2, 0);
    }else{
        self.scrollView.contentOffset =CGPointMake(ScreenW, 0);
    }
//    NSLog(@"刷新时的偏移量 %f",self.scrollView.contentOffset.x);
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self.middlTableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断 ——currentIndex 为0 ：0 1 2 ，大于2： 234 小于14   ，13 14 15；
    if (_currentIndex >0 && _currentIndex<self.titleArr.count-1) {
        switch (tableView.tag) {
            case 1:
            {
                self.leftModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex-1];
                return self.leftModels.count;
            }
                break;
            case 2:
            {
                self.midleModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
                return [self.midleModels count];
            }
                break;
            case 3:
            {
                self.rightModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex +1];
                return [self.rightModels count];
            }
                break;
            default:
                break;
        }
    }else if(_currentIndex == 0){
        switch (tableView.tag) {
            case 1:
            {
                self.leftModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
                return self.leftModels.count;
            }
                break;
            case 2:
            {
                self.midleModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex +1];
                return [self.midleModels count];
            }
                break;
            case 3:
            {
                self.rightModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex +2];
                return [self.rightModels count];
            }
                break;
            default:
                break;
        }
    }else{
        switch (tableView.tag) {
            case 1:
            {
                self.leftModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex - 2];
                return self.leftModels.count;
            }
                break;
            case 2:
            {
                self.midleModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex - 1];
                return [self.midleModels count];
            }
                break;
            case 3:
            {
                self.rightModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
                return [self.rightModels count];
            }
                break;
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self getMessage];
    HomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    //判断 ——currentIndex 为0 ：0 1 2 ，大于2： 234 小于14   ，13 14 15；
    if (_currentIndex == 0) {
        _rightModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
    }else if (_currentIndex == self.titleArr.count - 1){
        _rightModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
    }else{
        _midleModels = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
    }
    switch (tableView.tag) {
        case 1:
            homeCell.model = self.leftModels[indexPath.row];
            break;
        case 2:
            homeCell.model = self.midleModels[indexPath.row];
            break;
        case 3:
            homeCell.model = self.rightModels[indexPath.row];
            break;
        default:
            break;
    }
    return homeCell;
}
#pragma mark - 加载更多
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ayy = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex];
  
    if (ayy.count - indexPath.row == 5) {
        if (!_isRefrsh) {
            if (_isRefrsh){
                return;
            }
            _isRefrsh = YES;
            [self.dataNet getMoreWithCateId:_currentIndex];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailVC *detailvc = [[DetailVC alloc] init];
    HomeModels *model = [[DataManager shareDB] getDataFromdDatabaseWithMsg:_currentIndex][indexPath.row];
    detailvc.aid = model.aid;
    [self.navigationController pushViewController:detailvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHight;
}

#pragma mark - tableScroll
//将要滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
         _lasterContentOfset = self.scrollView.contentOffset.x;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //关于scrollView的
    if (!decelerate && [scrollView isEqual:self.scrollView]) {
        [self changeScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        [self changeScroll];
   }
}

- (void)changeScroll{
    [self endRefresh];
  //  NSLog(@"滑动前序号 %ld",(long)_currentIndex);
    //判断向左 向右
    if (self.scrollView.contentOffset.x >= self.lasterContentOfset + ScreenW) { //左滑
        _currentIndex ++;
    }else if(self.scrollView.contentOffset.x <= self.lasterContentOfset - ScreenW){
        _currentIndex --;
    }
    //校正当前标号
    [self checkIndex:_currentIndex];
    
    [self scrollChange];
    //关于titleScroll
    UIButton *button = (UIButton *)[self.titleScroll viewWithTag:_currentIndex + 100];
    [self btnScrollWithBtn:button];
}

- (NSInteger)checkIndex:(NSInteger)index{
    _currentIndex = index;
    if (self.currentIndex > self.titleArr.count) {
        self.currentIndex = self.titleArr.count;
    }
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    return _currentIndex;
}

#pragma mark - 网络数据加载
//加载 数据 请求更新
- (void)requestNetworkingWithTableView:(UITableView *)tableView{
    if (_isRefrsh) {
        return;
    }
    [self.dataNet getNewsWithCateId:_currentIndex];
}

#pragma mark dataNetDelegate

//下拉刷新数据
- (void)refreshTable{
    [self endRefresh];
    if (self.dataNet.countNum) {
    [self.navigationController showNavigationViewWithTitle:@"已为您更新"];
    }
  
    [_leftTableView reloadData];
    [_middlTableView reloadData];
    [_rightTableView reloadData];
//    if (_currentIndex==0) {
//        [_leftTableView reloadData];
//    }else if(_currentIndex == self.titleArr.count - 1){
//        [_rightTableView reloadData];
//    }else{
//        [_middlTableView reloadData];
//    }
}

//加载失败
- (void)loadError{
    [self endRefresh];
    [self.navigationController showNavigationViewWithTitle:@"没有更多内容"];
}

//网络更改
- (void)netChangeWithMessage:(NSString *)message{
    
    CGFloat systermVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f",systermVersion);
    if (systermVersion < 8.0) {
        kTipAlert7(message);
    }else{
        kTipAlert(message);
    }
}

#pragma mark - 事件响应
//刷新 控件
-(void)refreshStart{
    //1开始下拉刷新
    _isRefrsh=YES;
    [self.dataNet getNewsWithCateId:_currentIndex];
}

- (void)endRefresh{
    _isRefrsh = NO;
    [_freshControl1 endRefreshing];
    [_freshControl2 endRefreshing];
    [_freshControl3 endRefreshing];
//    if (_currentIndex == 0) {
//        [_freshControl1 endRefreshing];
//    }else if (_currentIndex == self.titleArr.count){
//        [_freshControl3 endRefreshing];
//    }else{
//        [_freshControl2 endRefreshing];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
