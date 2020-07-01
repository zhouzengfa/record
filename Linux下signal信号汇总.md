# Linux下signal信号汇总
```
SIGHUP       1          /* Hangup (POSIX).  */                          终止进程     终端线路挂断
SIGINT       2          /* Interrupt (ANSI).  */                        终止进程     中断进程 Ctrl+C
SIGQUIT      3          /* Quit (POSIX).  */                            建立CORE文件终止进程，并且生成core文件 Ctrl+\
SIGILL       4          /* Illegal instruction (ANSI).  */              建立CORE文件,非法指令
SIGTRAP      5          /* Trace trap (POSIX).  */                      建立CORE文件,跟踪自陷
SIGABRT      6          /* Abort (ANSI).  */
SIGIOT       6          /* IOT trap (4.2 BSD).  */                      建立CORE文件,执行I/O自陷
SIGBUS       7          /* BUS error (4.2 BSD).  */                     建立CORE文件,总线错误
SIGFPE       8          /* Floating-point exception (ANSI).  */         建立CORE文件,浮点异常
SIGKILL      9          /* Kill, unblockable (POSIX).  */               终止进程     杀死进程
SIGUSR1      10         /* User-defined signal 1 (POSIX).  */           终止进程     用户定义信号1
SIGSEGV      11         /* Segmentation violation (ANSI).  */           建立CORE文件,段非法错误
SIGUSR2      12         /* User-defined signal 2 (POSIX).  */           终止进程     用户定义信号2
SIGPIPE      13         /* Broken pipe (POSIX).  */                     终止进程     向一个没有读进程的管道写数据
SIGALARM     14         /* Alarm clock (POSIX).  */                     终止进程     计时器到时
SIGTERM      15         /* Termination (ANSI).  */                      终止进程     软件终止信号
SIGSTKFLT    16         /* Stack fault.  */
SIGCLD       SIGCHLD    /* Same as SIGCHLD (System V).  */
SIGCHLD      17         /* Child status has changed (POSIX).  */        忽略信号     当子进程停止或退出时通知父进程
SIGCONT      18         /* Continue (POSIX).  */                        忽略信号     继续执行一个停止的进程
SIGSTOP      19         /* Stop, unblockable (POSIX).  */               停止进程     非终端来的停止信号
SIGTSTP      20         /* Keyboard stop (POSIX).  */                   停止进程     终端来的停止信号 Ctrl+Z
SIGTTIN      21         /* Background read from tty (POSIX).  */        停止进程     后台进程读终端
SIGTTOU      22         /* Background write to tty (POSIX).  */         停止进程     后台进程写终端
SIGURG       23         /* Urgent condition on socket (4.2 BSD).  */    忽略信号     I/O紧急信号
SIGXCPU      24         /* CPU limit exceeded (4.2 BSD).  */            终止进程     CPU时限超时
SIGXFSZ      25         /* File size limit exceeded (4.2 BSD).  */      终止进程     文件长度过长
SIGVTALRM    26         /* Virtual alarm clock (4.2 BSD).  */           终止进程     虚拟计时器到时
SIGPROF      27         /* Profiling alarm clock (4.2 BSD).  */         终止进程     统计分布图用计时器到时
SIGWINCH     28         /* Window size change (4.3 BSD, Sun).  */       忽略信号     窗口大小发生变化
SIGPOLL      SIGIO      /* Pollable event occurred (System V).  */
SIGIO        29         /* I/O now possible (4.2 BSD).  */              忽略信号     描述符上可以进行I/O
SIGPWR       30         /* Power failure restart (System V).  */
SIGSYS       31         /* Bad system call.  */
SIGUNUSED    31
```

<span style="color:red">1) SIGHUP</span> **本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业, 这时它们与控制终端不再关联.**

<span style="color:red">2) SIGINT</span> **程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl+C)时发出**

<span style="color:red">3) SIGQUIT</span> **和 SIGINT类似, 但由QUIT字符(通常是Ctrl+\)来控制. 进程在因收到 SIGQUIT 退出时会产生core文件, 在这个意义上类似于一个程序错误信号.**

<span style="color:red">4) SIGILL</span> **执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号.**

<span style="color:red">5) SIGTRAP</span> **由断点指令或其它trap指令产生. 由debugger使用.**

<span style="color:red">6) SIGABRT</span> **程序自己发现错误并调用abort时产生**.

<span style="color:red">6) SIGIOT</span> **在PDP-11上由iot指令产生, 在其它机器上和SIGABRT一样.**

<span style="color:red">7) SIGBUS</span> **非法地址, 包括内存地址对齐(alignment)出错. eg: 访问一个四个字长的整数, 但其地址不是4的倍数.**

<span style="color:red">8) SIGFPE</span> **在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误.**

<span style="color:red">9) SIGKILL</span> **用来立即结束程序的运行. 本信号不能被阻塞, 处理和忽略.**

<span style="color:red">10) SIGUSR1</span> **留给用户使用**

<span style="color:red">11) SIGSEGV</span> **试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.**

<span style="color:red">12) SIGUSR2</span> **留给用户使用**

<span style="color:red">13) SIGPIPE</span> **Broken pipe**

<span style="color:red">14) SIGALRM</span> **时钟定时信号, 计算的是实际的时间或时钟时间. alarm函数使用该信号.**

<span style="color:red">15) SIGTERM</span> **程序结束(terminate)信号, 与SIGKILL不同的是该信号可以被阻塞和处理. 通常用来要求程序自己正常退出. shell命令kill缺省产生这个信号.**

<span style="color:red">17) SIGCHLD</span> **子进程结束时, 父进程会收到这个信号.**

<span style="color:red">18) SIGCONT</span> **让一个停止(stopped)的进程继续执行. 本信号不能被阻塞. 可以用一个handler来让程序在由stopped状态变为继续执行时完成特定的工作. 例如, 重新显示提示符**

<span style="color:red">19) SIGSTOP</span> **停止(stopped)进程的执行. 注意它和terminate以及interrupt的区别:该进程还未结束, 只是暂停执行. 本信号不能被阻塞, 处理或忽略.**

<span style="color:red">20) SIGTSTP</span> **停止进程的运行, 但该信号可以被处理和忽略. 用户键入SUSP字符时(通常是Ctrl+Z)发出这个信号**

<span style="color:red">21) SIGTTIN</span> **当后台作业要从用户终端读数据时, 该作业中的所有进程会收到SIGTTIN信号. 缺省时这些进程会停止执行.**

<span style="color:red">22) SIGTTOU</span> **类似于SIGTTIN, 但在写终端(或修改终端模式)时收到**.

<span style="color:red">23) SIGURG</span> **有"紧急"数据或out-of-band数据到达socket时产生.**

<span style="color:red">24) SIGXCPU</span> **超过CPU时间资源限制. 这个限制可以由getrlimit/setrlimit来读取/改变**

<span style="color:red">25) SIGXFSZ</span> **超过文件大小资源限制.**

<span style="color:red">26) SIGVTALRM</span> **虚拟时钟信号. 类似于SIGALRM, 但是计算的是该进程占用的CPU时间.**

<span style="color:red">27) SIGPROF</span> **类似于SIGALRM/SIGVTALRM, 但包括该进程用的CPU时间以及系统调用的时间.**

<span style="color:red">28) SIGWINCH</span> **窗口大小改变时发出.**

<span style="color:red">29) SIGIO</span> **文件描述符准备就绪, 可以开始进行输入/输出操作.**

<span style="color:red">30) SIGPWR</span> **Power failure**

有两个信号可以停止进程:SIGTERM和SIGKILL。 SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。


在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。


对于 SIGKILL 信号，进程是不能忽略的。这是一个 “我不管您在做什么,立刻停止”的信号。假如您发送SIGKILL信号给进程，Linux就将进程停止在那里。

 

sigaddset 将信号signo 加入到信号集合之中；
sigdelset 将信号从信号集合中删除；
sigemptyset 函数初始化信号集合set,将set 设置为空；
sigfillset 也初始化信号集合,只是将信号集合设置为所有信号的集合；