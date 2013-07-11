Background:

As old versions of Flash Player (as of today it supports workers) didn't support threads developers had to come with ways to handle extensive processes without freezing the UI to the user.

An attempt to fix this issue was accomplished through the usage of GreenThreads or pseudo threads (http://en.wikipedia.org/wiki/Green_threads) that were emulated inside the code.

Solution:

This project presents a small library with a simple green thread named "SimpleThread.as" and a "Processor.as" interface that your data processing objects should implement in order to be handled by the thread. Also an implementation of the Iterator pattern is included as it provides an excellent way to decouple your lists when you don't have control over your loop, as in this case.

Main library code is located under the folder 'src/com/grayscale/util/*' and the example is under the folder 'src/example'. For the example you will need to have Flex enabled in your project. If you just want to import the library, then it will run perfectly fine inside a pure AS3 project.

Usage:

Clone this repo then import only the code inside the folder '/src/com/grayscale/util/*' (the rest of the code is just the example)
Then create a processor, which is the class that is going to process the data or actions that you want to separate. Make sure it implements the interface named 'Processor'

Create a method that will initialize the thread, like this:

```actionscript
public function start():void
{
    var thread:SimpleThread = new SimpleThread(50, this);
    //detect when the thread is complete
    thread.addEventListener(Event.COMPLETE, function(event:Event):void{
        complete()
    });
}
```

This is the method that will be invoked by your application.

Then inside your processor implement the method "isComplete" and the method "process". If you are using the iterator class both method will look like this:

```actionscript
/**
 * Processing is complete once we are done going through the iterator
 * @return
 */
public function isComplete():Boolean
{
    return !iterator.hasNext();
}

/**
 * Main method to execute
 * @param args
 */
public function process(args:Array = null):void
{
    var obj:XML = iterator.next() as XML;
    if(obj){
        var point:Point = new Point(Number(obj.Value), df.format(String(obj.Label)));
        points.addItem(point);
    }
}
```

The project uses Flex as the examples are written using that, but the Thread library itself is pure AS3.

Notice that the array data is not handled by the thread but by the processor implementation.
To see a better usage, look at the class AnalyticsWithThreadProcessor.as inside the example folder

Example:

Also in the project you can find an example of two flex applications (binaries included) that will both load a huge XML file of more than 4MB and more than 19K entries that will be processed by each of them in order to show them in a list.
The difference is that one uses the Green Thread library and the other one doesn't.
It is very easy to notice the difference between both applications, a quick way to do it is that when using the version with Threads you'll see a spinner executing and you'll be able to scroll the list. With the other version, even though the spinner is suppose to be visible you won't be able to notice it.
The examples use Flex, but the main library doesn't.

Instructions:

Inside the 'bin' folder localized the 2 swf files, open each of them and then click on start and you can see how the button and the list waits until the file is fully processed.
When using AnalyticsWithThread.swf, click on start and see how the list, button and spinner are active and fully working.
If you have problems running the examples from the binaries, try them from the Flash Builder.

Binaries:
This is a sample project with two binary files: AnalyticsNoThread.swf and AnalyticsWithThread.swf 'bin' folder
