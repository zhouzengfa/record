**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/4 |周增法    | 创建文档  |

# 控制台显示不用同颜色
```
ansiColor("xterm") {
    echo "\033[31m Red \033[0m"
    echo "\033[32m Green \033[0m"
    echo "\033[33m Yellow \033[0m"
    echo "\033[34m Blue \033[0m"
    
    echo "\033[41m Red \033[0m"
    echo "\033[42m Green \033[0m"
    echo "\033[43m Yellow \033[0m"
    echo "\033[44m Blue \033[0m"
}
```

参考文档：
https://blog.johnwu.cc/article/jenkins-ansi-color-console-output.html
https://misc.flogisoft.com/bash/tip_colors_and_formatting