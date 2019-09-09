# crontab 定时任务

#### 1.命令
```
crontab的使用就是编辑配置文件。
配置文件位于/var/spool/cron/<username>，其中<username >是用户名。
日志位于/var/log/cron
```
#### 2. 格式
```
*     *     *     *     *     cmd
分　  时　   日　   月　   周　  命令

第1列表示分钟1～59 每分钟用*或者 */1表示
第2列表示小时1～23（0表示0点）
第3列表示日期1～31
第4列表示月份1～12
第5列标识号星期0～6（0表示星期天）
第6列要运行的命令
```
#### 3.列出crontab文件
	crontab -l

#### 4.编辑crontab文件
	crontab -e

#### 5.删除crontab文件
	crontab -r

#### 6.样例
```
#每晚的21:30 重启apache
30 21 * * * /usr/local/etc/rc.d/lighttpd restart

#每月1、10、22日的4 : 45重启apache
45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart

#每周六、周日的1 : 10重启apache
10 1 * * 6,0 /usr/local/etc/rc.d/lighttpd restart

#每天18 : 00至23 : 00之间每隔30分钟重启apache
0,30 18-23 * * * /usr/local/etc/rc.d/lighttpd restart

#晚上11点到早上7点之间，每隔一小时重启apache
* 23-7/1 * * * /usr/local/etc/rc.d/lighttpd restart

#每一小时重启apache
*/60 * * * * /usr/local/etc/rc.d/lighttpd restart

#每月的4号与每周一到周三的11点重启apache
0 11 4 * mon-wed /usr/local/etc/rc.d/lighttpd restart

#一月一号的4点重启apache
0 4 1 jan * /usr/local/etc/rc.d/lighttpd restart

#每半小时同步一下时间
*/30 * * * * /usr/sbin/ntpdate 210.72.145.44
```

参考：
https://www.jianshu.com/p/b3c8493753ca