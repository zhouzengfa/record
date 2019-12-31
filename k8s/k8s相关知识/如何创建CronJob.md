**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/23 |周增法    | 创建文档  |

# 如何创建CronJob

Kubernetes集群使用Cron Job管理基于时间的作业，可以在指定的时间点执行一次或在指定时间点执行多次任务。 一个Cron Job就好像Linux crontab中的一行，可以按照Cron定时运行任务。

- ### CronJob的定义
格式如下：
```
apiVersion: batch/v2alpha1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```
其中 schedule: "*/1 * * * *" 格式如下：
```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * command to execute
```
  *：表示匹配任意值，如果在Minutes 中使用，表示每分钟
  /： 表示起始时间开始触发，然后每隔固定时间触发一次

    例如：在Minutes 设置的是5/20，则表示第一次触发是在第5min时，接下来每20min触发一次，即，第25min，45min等时刻触发。
	
参考文档：https://jimmysong.io/kubernetes-handbook/concepts/cronjob.html