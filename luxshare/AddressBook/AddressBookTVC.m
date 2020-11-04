//
//  AddressBookTVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AddressBookTVC.h"
#import "ContactDataHelper.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "SCIndexView.h"
#import "SCIndexViewConfiguration.h"


@interface AddressBookTVC ()<UISearchControllerDelegate,SCIndexViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
@property (strong, nonatomic)UISearchController *searchController;
@property (nonatomic, assign)SCIndexViewStyle indexViewStyle;
@property (copy, nonatomic)SCIndexView *indexView;
@property (strong, nonatomic)NSMutableArray *rowArr;
@property (copy, nonatomic)NSArray *sectionArr;
@property (copy, nonatomic)NSArray *serverDataArr;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *searchResultArr;
@property (assign, nonatomic)BOOL isSearch;
@end

@implementation AddressBookTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    self.tableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.tableView.bounces = NO;
    [self initConfig];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:QZHLoaclString(@"cancel")];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.indexView removeFromSuperview];
}
- (void)initConfig{
    
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];

    self.isSearch = false;
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
    for (NSDictionary *subDic in self.serverDataArr) {
        ContactModel *model=[ContactModel yy_modelWithDictionary:subDic];
        [self.dataArr addObject:model];
    }
    
    _rowArr = [ContactDataHelper getFriendListDataBy:self.dataArr];
    _sectionArr = [ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
    
    [self searchBarConfig];
}
- (void)searchBarConfig{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    // 设置为NO的时候 列表的单元格可以点击 默认为YES无法点击无效

    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
        // Fallback on earlier versions
    }
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    // 保证搜索导航栏中可见
    [self.searchController.searchBar sizeToFit];

    self.searchController.searchBar.showsCancelButton = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    [self.navigationController.view addSubview:self.indexView];
    [self.navigationController.view bringSubviewToFront:self.indexView];
    
    // 配置数据
    if ([_sectionArr count]>0) {
        NSMutableArray *indexViewDataSource = [NSMutableArray array];
        for (NSString *str in _sectionArr) {
            [indexViewDataSource addObject:str];
        }
        self.indexView.dataSource = indexViewDataSource.copy;
    }

}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (_isSearch) {

        [cell.nameLabel setText:[_searchResultArr[indexPath.row] valueForKey:QZHLoaclString(@"language")]];
        return cell;
        
    }else{

        ContactModel *model=_rowArr[indexPath.section][indexPath.row];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans-CN"]){
            [cell.nameLabel setText: model.chinese];
        }else{
            [cell.nameLabel setText: model.english];
        }
            

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _isSearch?1:self.rowArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearch?self.searchResultArr.count:[self.rowArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",_sectionArr[section]]];
    return label;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return _isSearch?0:22;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSearch) {
        ContactModel *model = _searchResultArr[indexPath.row];
        self.countryBlock(model);

    }else{
        ContactModel *model = _rowArr[indexPath.section][indexPath.row];
        self.countryBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -- UISearchResultsUpdating searchBar
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text.length == 0) {
        self.isSearch = false;
        [self.tableView reloadData];
    }else{
        self.isSearch = true;
        [self filterContentForSearchText:searchController.searchBar.text scope:@""];
    }
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    self.isSearch = false;
    self.indexView.hidden = self.isSearch;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.isSearch = false;
    self.indexView.hidden = self.isSearch;
    self.searchController.searchBar.showsCancelButton = NO;

}

// --searchbar的代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchController.searchBar.showsCancelButton = YES;
    self.indexView.hidden = YES;
    NSArray*searchBarSubViews = self.searchController.searchBar.subviews;//UIView

    UIView *view = [searchBarSubViews objectAtIndex:0];

    NSArray *searchBarContainerView = [[[view subviews] objectAtIndex:1] subviews];//UISearchBarContainerView

    for(UIView*view in searchBarContainerView) {
        if ([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton *cancelButton = (UIButton*)view;
            [cancelButton setTitle:QZHLoaclString(@"cancel") forState:UIControlStateNormal];
            [cancelButton setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];
      }
    }
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString ;
        NSString *storeStringeng ;
        if ([QZHCommons languageOfTheDeviceSystem] == LanguageChinese){
            storeString = [(ContactModel *)self.dataArr[i] chinese];
            storeStringeng = [(ContactModel *)self.dataArr[i] spell];
        }else{
            storeString = [(ContactModel *)self.dataArr[i] english];
            storeStringeng = [(ContactModel *)self.dataArr[i] english];
            
        }

        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange storeRangeeng = NSMakeRange(0, storeStringeng.length);

        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        NSRange foundRangeeng = [storeStringeng rangeOfString:searchText options:searchOptions range:storeRangeeng];
        if (foundRange.length || foundRangeeng.length) {
            [tempResults addObject:self.dataArr[i]];
        }
    }
    [self.searchResultArr removeAllObjects];
    [self.searchResultArr addObjectsFromArray:tempResults];
    [self.tableView reloadData];
}

#pragma mark - SCIndexViewDelegate
- (void)indexView:(SCIndexView *)indexView didSelectAtSection:(NSUInteger)section
{
  
}

- (SCIndexView *)indexView
{
    if (!_indexView) {
        _indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:[SCIndexViewConfiguration configurationWithIndexViewStyle:self.indexViewStyle]];
        _indexView.translucentForTableViewInNavigationBar = NO;
        _indexView.delegate = self;
    }
    return _indexView;
}

#pragma mark - serverDataArr(模拟从服务器获取到的数据)
- (NSArray *)serverDataArr{
    if (!_serverDataArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _serverDataArr = [NSArray arrayWithArray:arr];
    }
    return _serverDataArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)searchResultArr{
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}

@end
