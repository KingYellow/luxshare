//
//  TYSearchTableCustomProtocol.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TYSearchController;

@protocol TYSearchTableCustomProtocol <NSObject>

@required
+ (instancetype)new;
- (__kindof UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@optional
@property (nonatomic, weak) TYSearchController *searchController;

- (void)searchControllerStatusDidChanged:(TYSearchController *)searchController;
- (void)searchController:(TYSearchController *)searchController textDidChange:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
