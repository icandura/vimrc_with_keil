## 可调用 Keil MDK 的 VIM 配置

### 简介

![image](https://github.com/icandura/vimrc_with_keil/raw/master/screenshot.png)

　　本配置文件为本人自用 VIM 配置文件，包含个人偏好及编程所需的几个最基本的插件，所用插件均采用`Vundle`进行管理；此外增加了调用`Keil MDK`来对项目进行编译、下载的功能，基本实现对**已有工程**的支持。Keil 的项目文件本质上是 XML 格式的文件，如果后续有大神整合相关操作，能直接通过 VIM 建立新工程、新文件就更加好了~

### 使用环境及安装方法

　　本配置文件在 Win7 系统、gVim8.1 版本下测试通过，不过除了针对 Keil MDK 的配置内容之外，其他的插件处理部分和常规修改部分是能够同时在 Linux 下正常使用的。

　　安装步骤如下：

1. 在官网下载 gVim 及 全语言帮助文件 安装包并安装。
2. 将本仓库内容覆盖到 gVim 的安装目录，如`C:\Program Files\Vim`。 _（若非gVim8.1版本请修改`vim81`文件夹名称为对应版本文件夹名称）_
3. 启动 gVim，输入命令`:PluginInstall`安装插件
4. 将 Keil MDK 编辑器（即`UV4.exe`）所在路径增加到环境变量`PATH`中。 _（注：仓库内的 bat 文件能自动在C盘寻找可能的目录并增加到用户环境变量中，但是由于会冗余系统的环境变量到用户的环境变量中，建议还是手动添加环境变量）_
5. 重启 gVim 开始使用。

### 包含插件

1. Vundle插件管理器本身，本仓库已包含其管理器本身，后续可通过`:PluginUpdate`对其自身进行升级。
2. NERD_tree 文件浏览器，本配置中浏览器位于左侧，采用快捷键`F3`开启或关闭。
3. ~~MiniBufExplorer 多文件编辑插件。~~ _（由于Airline插件已具备该功能故不再使用）_
4. Vim-airline 超级状态栏插件及相关主题，本配置中未启用 Powerline 字体，有需求的可自行配置，采用快捷键`F11`和`F12`切换文件。
5. Tagbar 标签列表插件，用于替代 TagList。本配置中标签列表位于右侧，采用快捷键`F3`开启或关闭。另外，本仓库中已包含Windows版本的`ctags`、`cscope`和`sort`程序，可采用快捷键`F9`生成引索文件。
6. a.vim 切换C代码文件与H头文件插件，采用快捷键`F4`切换。
7. AutoComplPop 变量函数自动弹出插件。
8. OmniCppComplete 代码自动补全插件。
9. ~~ale 语法检查插件~~ _（嫌麻烦不用了）_
10. NERD_Commenter 快速注释插件，采用快捷键`Ctrl + /`快速添加注释。
11. DoxygenToolKit 增加Doxygen风格注释插件，采用快捷键`F5`快速增加函数注释，快捷键`F6`在文件顶部快速增加作者信息。

### 快捷键及命令

#### 快捷键列表

　　本配置文件中所有**自定义**的快捷键列表如下：

1. <F2\>：打开、关闭文件浏览器
2. <F3\>：打开、关闭标签列表
3. <F4\>：切换 C 源码与 H 头文件
4. <F5\>：增加函数Doxygen风格注释
5. <F6\>：在文件顶部增加作者信息
6. <F9\>：生成 tags 引索文件
7. <F11\>、<F12\>：切换已开启文件
8. <Ctrl+/\>：快速注释代码块

　　以上快捷键均以本人自用方便为主，如有需求请自行更改 map 映射。

#### 调用 Keil MDK 命令

　　本配置文件中调用 Keil MDK 的相关命令如下：

1. <leader\>kb：编译（Build）项目
2. <leader\>kr：清除并重新编译（Rebuild）项目
3. <leader\>kd：烧写程序到芯片（Download）

　　本配置文件中仅在当前编辑代码本身目录、上上级目录、上级的`Project`目录中寻找 Keil MDK 项目文件，如代码与项目文件结构不同请自行修改`MakeKeilTarget`函数中的查找部分。

　　亦可参照 Keil 官方的[命令行使用说明](http://www.keil.com/support/man/docs/uv4/uv4_commandline.htm)来自行增加其他功能和改进，比如编译时不让 Keil 弹出UI界面、建立新项目等等。

![image](https://github.com/icandura/vimrc_with_keil/raw/master/rebuild.png)

### 参考文档

1. [本博使用的vim(gvim)相关插件整理](http://www.vimer.cn/archives/1372.html) 
2. [为Vim配置Keil uVision开发环境](https://blog.csdn.net/fearroar/article/details/80198962) 