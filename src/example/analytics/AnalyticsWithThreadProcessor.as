package example.analytics
{
	import example.analytics.model.Point;
	import com.grayscale.util.iterator.ArrayIterator;
	import com.grayscale.util.iterator.Iterator;
	import com.grayscale.util.threads.SimpleThread;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;

	[Bindable]
	public class AnalyticsWithThreadProcessor extends EventDispatcher implements IAnalyticsProcessor
	{
		private var data:XML;
		private var rawData:Array = new Array();
        private var _complete:Boolean = false;
		
		public var points:ArrayCollection;		
		private var iterator:Iterator;
		private var df:DateFormatter = new DateFormatter();
		
		public function AnalyticsWithThreadProcessor(data:XML)
		{super(this);
			
			this.data = data;
			
			prepareData();
		}

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
		
		public function prepareData():void
		{
			for each(var obj:XML in data.Report.*.*.Point){
				rawData.push(obj);
			}
			
			iterator = new ArrayIterator(rawData);
			points = new ArrayCollection();
			
			df.formatString = "YYYY/MM/DD HH:NN:SS"		
		}
		
		/**
		 * Function invoked by client, create Thread here
		 */
		public function start():void
		{	
			var thread:SimpleThread = new SimpleThread(50, this);
            //dispatch complete event
			thread.addEventListener(Event.COMPLETE, function(event:Event):void{
                complete()
            });
		}

		public function complete():void
		{
            _complete = true;
			trace("Parsing Complete");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function reset():void
		{
			points = new ArrayCollection();
			rawData = [];
			iterator.reset();
			prepareData();
		}
		
	}
}