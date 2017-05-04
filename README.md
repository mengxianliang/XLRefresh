# XLRefresh

### 功能说明
* 功能有下拉刷新、上拉加载
* 支持UITableView、UICollectionView、UIWebView、UIScrollView
* 支持Block方式和代理方式的回调方法

### 显示效果

| UITableView | UICollectionView | UIWebView |
| ---- | ---- | ---- |
|![image](https://github.com/mengxianliang/XLRefresh/blob/master/GIF/1.gif)| ![image](https://github.com/mengxianliang/XLRefresh/blob/master/GIF/2.gif)| ![image](https://github.com/mengxianliang/XLRefresh/blob/master/GIF/3.gif)|

### 使用方法

**代理方式创建：**

```objc
_tableView.xl_header = [XLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
_tableView.xl_footer = [XLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMethod)];
```
**block方式创建：**

```objc
_tableView.xl_header = [XLRefreshHeader headerWithRefreshingBlock:^{
        
}];
_tableView.xl_footer = [XLRefreshFooter footerWithRefreshingBlock:^{
        
}];
```

**结束刷新**

```objc
[_tableView.xl_header endRefreshing];
[_tableView.xl_footer endRefreshing];
```
