[English](./README.md) | 简体中文

![](./docs/banner.png)

[![Crowdin](https://badges.crowdin.net/moekey/localized.svg)](https://crowdin.com/project/moekey)

# MoeKey

MoeKey 是由 Flutter 制作的跨平台 misskey 客户端。

## 特性

MoeKey希望成为一个UI风格与原版Misskey保持一致。功能完善的Misskey客户端。

> 该项目目前正在开发中，存在许多功能缺陷

目前已经实现的功能：

- 多用户登录
- 时间线查看、搜索
- 帖子的发布相关功能
- 通知查看
- 便签
- 系统公告
- 发现
- HashTag 浏览

暂时未实现的功能

- 个人资料编辑
- Misskey设置
- 天线，频道，列表
- 用户小组件
- 用户成就

## 下载

- [GitHub Releases](https://github.com/MoeKeyDev/MoeKey/releases/latest)

## 截图

![](./docs/Screenshot.png)

## 开发人员

### 本地化

帮助我们将 MoeKey 翻译成您的语言，请登录 [Crowdin](https://crowdin.com/project/moekey)

### 代码生成

Riverpod 代码生成

```shell
dart run build_runner watch --use-polling-watcher
```