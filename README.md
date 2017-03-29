# XLRefresh

## 说明
iOS刷新工具:
<br>
功能有下拉刷新、上拉加载;
<br>
支持UITableView、UICollectionView、UIWebView、UIScrollView;
<br>
 支持Block方式和代理方式的回调方法；

## 显示效果

| UITableView | UICollectionView | UIWebView |
| ---- | ---- | ---- |
|![image](https://github.com/mengxianliang/XLChannelControl/blob/master/GIF/1.gif)| ![image](https://github.com/mengxianliang/XLChannelControl/blob/master/GIF/2.gif)| ![image](https://github.com/mengxianliang/XLChannelControl/blob/master/GIF/3.gif)|
<br>
## 使用方法

```objc
    _tableView.xl_header = [XLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    _tableView.xl_footer = [XLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMethod)];
```
或者：
```objc
    _tableView.xl_header = [XLRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    _tableView.xl_footer = [XLRefreshFooter footerWithRefreshingBlock:^{
        
    }];

```
