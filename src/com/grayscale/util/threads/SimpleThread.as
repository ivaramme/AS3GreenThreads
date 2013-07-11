/**
* SimpleThread
 * 
* Copyright (c) 2009 Ivan Ramirez
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/
package com.grayscale.util.threads
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	/** 
	 * Dispatched when the thread is done
	 */
	[Event (type="flash.events.Event", name="complete")]
	
	/**
	 * Implementation of a green thread in AS3. The concept behind this class is to wait for the
     * ENTER_FRAME event and execute a Processor object
	 * <p>Based on a previous implementation created by Grant Skinner but with some modifications.
	 *  http://www.gskinner.com/libraries/Chunker.zip</p>
     *
     *  @author Ivan Ramirez - ivan.ramirez@gmail.com
	 */
	public class SimpleThread extends EventDispatcher
	{
        /**
         * This object will let us listen to the ENTER_FRAME event as it has a stage value assigned to it
         */
		private var shape:Shape = new Shape();
        /**
         * State of the Thread
         */
        private var _paused:Boolean = false;
        /**
         * How often is the Thread going to run
         */
		private var _frequency:uint;
        /**
         * Object performing the job, of type processor to enforce it has the method
         * executed by the thread
         */
        private var _processor:Processor;
		private var _args:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param frequency How often we want to run the greenthread
		 * @param callback function to execute everytime the thread is active
		 * @param args optional parameters to pass to the callback function
		 */
		public function SimpleThread(frequency:int, processor:Processor, args:Array=null)
		{
			_frequency = frequency;
            _processor = processor;
			_args = args;
			
			pause = false;			
		}
		
		/**
		 * Pause or resume the thread
		 */
		public function set pause(value:Boolean):void
		{
			_paused = value;
			if(_paused)
                shape.removeEventListener(Event.ENTER_FRAME, run);
			else
                shape.addEventListener(Event.ENTER_FRAME, run);
		}


        private var initialTime:int
		/**
         * @private
		 * Green thread event which is invoked on every ENTER_FRAME event but only executes the callback
         * when frequency time is reached
		 */
        private function run(event:Event):void
		{
            //Register if current time
            initialTime = getTimer();
            //Wait until it's time to run the thread
			while(!_paused && (getTimer() < _frequency+initialTime ))
			{
				//invoke process method from our processor
				_processor.process(_args);

				if(_processor.isComplete())
				{
					dispatchEvent(new Event(Event.COMPLETE));
					pause = true;					
				}
			}
		}
	}
}