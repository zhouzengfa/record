# jenkins 实现构建通知

##### 1.安装插件 Parameterized Trigger
在Plugin Manager中搜索`Parameterized Trigger`并安装。

##### 2.新建一个freestyle工程
	1.取名为notifier
	2.增加变量参数PROJECT_BUILD_URL,BUILD_URL,TIPS
##### 3.在构建部分增加构建步骤，选择Executeshell
添加如下脚本：
```shell
#!/bin/bash

set -e

#获取Jenkins Job API, --user 添加jenkins管理员用户和token， 用户→用户id→设置页面中查看
curl -s -o .temp.xml "$PROJECT_BUILD_URL" --user admin:123456 >/dev/null 
#curl -s -o .temp.xml "$JENKINS_URL/job/$JOB_NAME/$BUILD_NUMBER/api/xml" --user admin:123456 >/dev/null

#需要先安装xml2工具，yum -y install xml2
action=`cat .temp.xml | xml2 | grep /freeStyleBuild/action/cause/shortDescription= | awk -F= '{print $2}'`

#获取job的build状态
build_status=`cat .temp.xml | xml2 | grep /freeStyleBuild/result= | awk -F= '{print $2}'`
developer=`cat .temp.xml | xml2 | grep /freeStyleBuild/culprit/fullName= | awk -F= '{print $2}'`

#发送群消息
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=f02c0cbf-7319-425b-b6d5-a4407994c31f'    -H 'Content-Type: application/json'    -d "
   {
        \"msgtype\": \"markdown\",
           \"markdown\": {
        \"content\":\"<font color=\\\"#bb00ff\\\">$TIPS</font>\n>Status: $build_status \n>Action: $action \n>Developer: $developer  \n>url: $PROJECT_URL/console \n\",
    }
   }"
   
##清理现场
rm -rf .temp.xml
```

##### 4.在其它工程（Test_B）中触发此工程
	1.在构建后操作中选择Trigger parameterized build on other projects
	2.在	Projects to build中填notifier
	3.在Trigger when build is中选择合适的选项
	4.在Add Parameters中选择Predefined parameters，并填充变量
		PROJECT_BUILD_URL=$JENKINS_URL/job/$JOB_NAME/$BUILD_NUMBER/api/xml
		TIPS=xxx
		PROJECT_URL=$BUILD_URL


参考：
https://www.jianshu.com/p/4534649a1ca9