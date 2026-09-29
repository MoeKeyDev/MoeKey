# MoeKey 静态首页

纯 HTML / CSS / JavaScript，无依赖、无需构建。包含应用介绍、真实应用截图、功能展示、下载与 GitHub 链接，适配手机和桌面。

## 本地使用

直接打开 `index.html`，或在此目录启动 HTTP 服务：

```sh
python3 -m http.server 8080 --bind 127.0.0.1
```

浏览器访问 `http://127.0.0.1:8080`。部署时将 `website` 目录的内容放入任意静态 HTTP 服务的站点目录即可。

## 修改内容

- `index.html`：文案、功能列表、GitHub 与下载地址。
- `styles.css`：颜色、布局与响应式样式。
- `motion.js`：滚动入场、图标交互、导航与回顶状态；支持减少动态效果设置。
- `assets/`：来自当前 MoeKey 项目的图标与截图。

页面内容依据本地项目 README。首屏入口指向 GitHub 最新发布页；下载区的五个平台按钮指向已核对的 `0.9.0+59` 正式版安装包。发布新版时需同步更新按钮链接与版本标签，所有版本入口可查看其他架构。没有在线字体、第三方脚本或运行时 API 请求。


## 自动部署

推送到 `main` 且变更 `website/**` 或 `.github/workflows/website-pages.yml` 时，GitHub Actions 将此目录发布到 GitHub Pages，也可手动运行工作流。

站点域名：<https://moekey.moegirl.love>。GitHub Pages 使用 GitHub Actions 作为发布源，并绑定该自定义域名；Cloudflare 将 `moekey` 的 CNAME 指向 `moekeydev.github.io`，开启代理。原站 HTTPS 证书就绪后，Cloudflare 应以 Full (strict) 连接原站。
