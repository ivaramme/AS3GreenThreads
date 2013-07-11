package example.analytics
{
	import example.analytics.model.Point;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;

	[Bindable]
	public class AnalyticsNoThreadProcessor extends EventDispatcher implements IAnalyticsProcessor
	{
		private var data:XML;
		private var rawData:Array = new Array();
		
		public var points:ArrayCollection;
        private var _complete:Boolean = false;
		
		public function AnalyticsNoThreadProcessor(data:XML)
		{
			super(this);
			
			this.data = data;
			
			prepareData();
		}

        //Green Thread processor implementation
        public function isComplete():Boolean
        {
            return _complete;
        }

        /**
         * Main method to execute
         * @param args
         */
        public function process(args:Array = null):void
        {
            //Empty, no need to implement thread
        }

        public function start():void
        {
            points = new ArrayCollection();
            var df:DateFormatter = new DateFormatter();
            df.formatString = "YYYY/MM/DD HH:NN:SS"

            //Process all items at once
            for (var i:uint = 0; i < rawData.length; i++)
            {
                var obj:XML = rawData[i] as XML;
                if(obj){
                    var point:Point = new Point(Number(obj.Value), df.format(String(obj.Label)));
                    points.addItem(point);
                }
            }

            complete();
        }
		
		public function prepareData():void
		{
			for each(var obj:XML in data.Report.*.*.Point){
				rawData.push(obj);
			}
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
			prepareData();
		}

	}
}