# linux别名设置

* 文件设置
  1. 若要每次登入就自动生效别名，则把别名加在`~/.bashrc`中。然后` source ~/.bashrc`
  2. 若要让每一位用户都生效别名，则把别名加在`/etc/bashrc`最后面，然后` source /etc/bashrc`


* 设置别名：
```
alias cp='cp -i'
```
* 删除别名：
格式：unalias name
```
unalias cp
```