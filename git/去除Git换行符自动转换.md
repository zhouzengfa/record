# 去除Git换行符自动转换

安装好 GitHub 的 Windows 客户端之后，自动转换功能处理开启状态。当你在签出文件时，Git 试图将 UNIX 换行符（LF）替换为 Windows 的换行符（CRLF）；当你在提交文件时，它又试图将 CRLF 替换为 LF。

关闭方式，打gitbash，并输出如下命令
		
	git config --global core.autocrlf false

参考文档：
https://github.com/cssmagic/blog/issues/22