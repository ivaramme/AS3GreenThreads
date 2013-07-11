package example.analytics
{
import com.grayscale.util.threads.Processor;

import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	//Notice implementation of the Processor interface
	[Bindable]
	public interface IAnalyticsProcessor extends IEventDispatcher, Processor
	{
		function prepareData():void;
		function complete():void;
        function reset():void;
        function start():void;

		function get points():ArrayCollection;
		function set points(val:ArrayCollection):void;
	}
}