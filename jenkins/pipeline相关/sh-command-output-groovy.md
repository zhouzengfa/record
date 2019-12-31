**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/4 |周增法    | 创建文档  |

# shell 输出赋值给groovy变量
```
pipeline {  
   stages {
        stage('Run Required Scripts') {
            steps {            
                script {
                    NOTIFIER_BULD_NAME = sh([script: "./getNotifier.sh", returnStdout: true]).trim()
                    EMAIL_TEXT = sh([script: "./printEmailText.sh ${CURRENT_BUILD}  ${PREVIOUS_BUILD}", returnStdout: true]).trim()
                    BODY= sh([ script: "curl \"http://${jenkinsUser}:${jenkinsUserToken}@${jenkinsServer}:8080/job/myJob/lastBuild/consoleText\"").trim()
                }
            }
        }           
     }
}
```


参考文档：
https://www.e-learn.cn/content/wangluowenzhang/254039