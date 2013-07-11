package example.analytics.model
{
	public class Point
	{
		public var value:Number;
		public var label:String;
		
		public function Point(value:Number, label:String)
		{
			this.value = value;
			this.label = label;
		}

		public function toString():String
		{
			return "Point -> Value: " + value + ", Label: " + label;
		}
	}
}