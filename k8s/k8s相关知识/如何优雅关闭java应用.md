**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/7/24 |周增法    | 创建文档  |
|  2018/10/23 |周增法    | 添加Pod关闭前发送的信号说明  |

为保证应用优雅关闭，k8s提供了容器生命周期管理API preStop，让我们可以在容器将要关闭之前，做一些相关操作通知应用做关闭之前的处理。
- 在删除Pod的时候，SIGTERM信号会发送给容器中PID为1的进程(main process)，然后等待容器中的应用程序终止执行。
- 如果等待时间达到设定的超时时间，或者默认的30秒，会继续发送SIGKILL的系统信号强行kill掉进程。
- 在容器中的应用程序，可以选择忽略和不处理SIGTERM信号，不过一旦达到超时时间，程序就会被系统强行kill掉，所以如果应用需要做退出前处理，应该确保我们的应该能收到SIGTERM信号并wd做了处理。


用法示例如下：
1.注册通知信号， 如下，有两种接收信号的方式，可根据情况进行选择

	package com;
	import sun.misc.Signal;
	import sun.misc.SignalHandler;

	public class ShutdownHook {

    public static void main(String[] args) throws InterruptedException {

        // 1. 方式一
        Runtime.getRuntime().addShutdownHook(new DbShutdownWork());
        System.out.println("JVM start");

        // 2. 方式二
        MySignalHandler mySignalHandler = new MySignalHandler();

        // 注册对指定信号的处理
        Signal.handle(new Signal("TERM") ,mySignalHandler);    // kill or kill -15
        Signal.handle(new Signal("INT"), mySignalHandler);     // kill -2

        System.out.println("[Thread:"+Thread.currentThread().getName() + "] is sleep" );
        while(true){
            Thread.sleep(1000L);
        }
    }
    // 在此处理关闭之前的操作
    static class DbShutdownWork extends Thread{
        public void run(){
            System.out.println("signal close");
        }
    }
	}

	@SuppressWarnings("restriction")
	class MySignalHandler implements SignalHandler
	{
    public void handle(Signal signal) {

        // 信号量名称
        String name = signal.getName();
        // 信号量数值
        int number = signal.getNumber();

        // 当前进程名
        String currentThreadName = Thread.currentThread().getName();

        System.out.println("[Thread:"+currentThreadName + "] receved signal: " + name + " == kill -" + number);
        if(name.equals("TERM")){
            System.exit(0);
        }
    }
	}
	
2.在如下脚本中，preStop节点的command中通知应用结束信号
如果在容器中，我们的应用Pid为1（即主进程），则不需要做如下处理，系统会自动给主进程发送SIGTERM信号。

	apiVersion: extensions/v1beta1
	kind: Deployment
	metadata: 
 	 name: loho-test
	spec: 
  	replicas: 1
 	 template: 
    metadata: 
      labels: 
        test: test
    spec: 
     terminationGracePeriodSeconds: 30
     containers:
     - name: loho-test
       imagePullPolicy: Always
       image: registry.loho.local:5000/test
       lifecycle: #生命周期管理   
         preStop: #容器关闭之前运行的任务   
          exec:   
           command: ["/bin/bash", "-c", "PID=`pidof java` && kill -SIGTERM $PID "]  
		   
参考文档：https://www.jianshu.com/p/e642e646719b