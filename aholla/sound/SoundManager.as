package aholla.sound
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class SoundManager extends EventDispatcher
	{
		private static var 	_instance					:SoundManager;
		private static var 	_allowInstance				:Boolean;
		
		private var 		_isMute					:Boolean;		
		private var 		_soundsDict					:Dictionary;
		private var 		_sounds						:Array;
		private var 		_delayed_ids				:Array;
		
/*-------------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------------*/

		public function SoundManager()
		{
			this._soundsDict 	= new Dictionary(true);
			this._sounds 		= []
			this._isMute		= false;
			this._delayed_ids	= []
			
			if (!SoundManager._allowInstance)
			{
				throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");
			}
		}
		
		public static function get inst():SoundManager
		{
			var s:SoundObject = new SoundObject;
			
			if (SoundManager._instance == null)
			{
				SoundManager._allowInstance = true;
				SoundManager._instance = new SoundManager();
				SoundManager._allowInstance = false;
			}
			return SoundManager._instance;
		}		
		
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/

		
		public function addLibrarySound($linkageID:*, $name:String):Boolean
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				if (this._sounds[i].name == $name) return false;
			}
			
			var sndObj:SoundObject = new SoundObject;
			var snd:Sound = new $linkageID;			
			sndObj.name 	= $name;
			sndObj.sound 	= snd;
			sndObj.channel 	= new SoundChannel();
			sndObj.position = 0;
			sndObj.paused 	= true;
			sndObj.volume 	= 1;
			sndObj.startTime = 0;
			sndObj.loops 	= 0;
			sndObj.pausedByAll = false;
			this._soundsDict[$name] = sndObj;
			this._sounds.push(sndObj);
			return true;
		}
		
		
		public function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false):Boolean
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				if (this._sounds[i].name == $name) return false;
			}
			
			var sndObj:SoundObject = new SoundObject;
			var snd:Sound 	= new Sound(new URLRequest($path), new SoundLoaderContext($buffer, $checkPolicyFile));
			sndObj.name 	= $name;
			sndObj.sound 	= snd;
			sndObj.channel 	= new SoundChannel();
			sndObj.position = 0;
			sndObj.paused 	= true;
			sndObj.volume 	= 1;
			sndObj.startTime = 0;
			sndObj.loops 	= 0;
			sndObj.pausedByAll 	= false;
			sndObj.isPlaying 	= false;
			this._soundsDict[$name] = sndObj;
			this._sounds.push(sndObj);
			return true;
		}
		
		
		public function removeSound($name:String):void
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				if (this._sounds[i].name == $name)
				{
					this._sounds[i] = null;
					this._sounds.splice(i, 1);
				}
			}
			delete this._soundsDict[$name];
		}
		
		
		public function removeAllSounds():void
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				this._sounds[i] = null;
			}
			this._sounds = []
			this._soundsDict = new Dictionary(true);
		}
		
		
		public function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0):void
		{
			var snd:SoundObject = this._soundsDict[$name];
			snd.volume 		= $volume;
			snd.startTime 	= $startTime;
			snd.loops 		= $loops;
			
			if (!_isMute)
			{
				if (snd.paused)
					snd.channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(snd.volume));
				else
					snd.channel = snd.sound.play($startTime, snd.loops, new SoundTransform(snd.volume));
				snd.paused = false;
				snd.isPlaying = true;
			}	
			else
			{
				snd.channel = snd.sound.play($startTime, snd.loops, new SoundTransform(0));
			}
			
			if(snd.channel)
				snd.channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandle, false, 0, true);
		}
		
		public function playDelayedSound($name:String, $delay:Number = 0, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0):void
		{
			_delayed_ids.push(setTimeout(playSound, $delay * 1000, $name, $volume, $startTime, $loops))
		}
		
		public function playRandomSound($namesArr:Array, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0):void
		{
			var rand:int =  int(Math.random() * ($namesArr.length - 1));	// random -1 noob - Joe
			var name:String = $namesArr[rand];
			playSound(name, $volume, $startTime, $loops);
		}
		
		
		private function onSoundCompleteHandle(e:Event):void
		{
			dispatchEvent(new Event("SOUND_COMPLETED") );
		}	
		
		public function stopSound($name:String):void
		{
			var snd:SoundObject = this._soundsDict[$name];
			snd.paused = true;
			snd.isPlaying = false;
			if (snd.channel) snd.channel.stop();
		}		
		
		public function pauseSound($name:String):void
		{
			var snd:SoundObject = this._soundsDict[$name];
			snd.paused = true;
			snd.position = snd.channel.position;
			snd.channel.stop();
		}
		
		
		public function playAllSounds($useCurrentlyPlayingOnly:Boolean = false):void
		{
			if (!_isMute)
			{
				for (var i:int = 0; i <this._sounds.length; i++)
				{
					var id:String = this._sounds[i].name;
					if ($useCurrentlyPlayingOnly)
					{
						if (this._soundsDict[id].pausedByAll)
						{
							this._soundsDict[id].pausedByAll = false;
							this.playSound(id);
						}
					}
					else
					{
						this.playSound(id);
					}
				}
			}
		}
		
		
		public function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				if ($useCurrentlyPlayingOnly)
				{
					if (!this._soundsDict[id].paused)
					{
						this._soundsDict[id].pausedByAll = true;
						this.stopSound(id);
					}
				}
				else
				{
					this.stopSound(id);
					for each (var item:uint in _delayed_ids)
					{
						clearTimeout(item);
					}
				}
			}
		}
		
		
		public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i <this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				if ($useCurrentlyPlayingOnly)
				{
					if (!this._soundsDict[id].paused)
					{
						this._soundsDict[id].pausedByAll = true;
						this.pauseSound(id);
					}
				}
				else
				{
					this.pauseSound(id);
				}
			}
		}
		
		
		public function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void
		{
			var fadeChannel:SoundChannel = this._soundsDict[$name].channel;
			if (!_isMute)
			{
				TweenMax.to(fadeChannel, $fadeLength, {volume: $targVolume});
			}
		}
		
		public function fadeSoundAndKill($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void
		{
			var fadeChannel:SoundChannel = this._soundsDict[$name].channel;
			TweenMax.to(fadeChannel, $fadeLength, {volume: $targVolume, onComplete:stopSound, onCompleteParams:[$name]});
		}
		
		
		public function muteAllSounds():void
		{
			_isMute = true;
			
			if (this._sounds)
			{
				for (var i:int = 0; i <this._sounds.length; i++)
				{
					var id:String = this._sounds[i].name;
					this.setSoundVolume(id, 0);
				}
			}
		}
		
		
		public function unmuteAllSounds():void
		{
			_isMute = false;
			if (this._sounds)
			{
				for (var i:int = 0; i <this._sounds.length; i++)
				{
					var id:String = this._sounds[i].name;
					var snd:SoundObject = this._soundsDict[id];
					var curTransform:SoundTransform = snd.channel.soundTransform;
					curTransform.volume = snd.volume;
					snd.channel.soundTransform = curTransform;
				}
			}
		}
		
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	

		public function setSoundVolume($name:String, $volume:Number):void
		{
			var snd:SoundObject = this._soundsDict[$name];
			var curTransform:SoundTransform = snd.channel.soundTransform;
			curTransform.volume = $volume;
			snd.channel.soundTransform = curTransform;
		}
		
		
		public function getSoundVolume($name:String):Number
		{
			return this._soundsDict[$name].channel.soundTransform.volume;
		}
	
		
		public function getSoundPosition($name:String):Number
		{
			return this._soundsDict[$name].channel.position;
		}
		
		
		public function getSoundDuration($name:String):Number
		{
			return this._soundsDict[$name].sound.length;
		}
		
		
		public function getSoundObject($name:String):Object
		{
			return this._soundsDict[$name];
		}
		
		public function getSound($name:String):Sound
		{
			return this._soundsDict[$name].sound;
		}
		
		public function getChannel($name:String):SoundChannel
		{
			return this._soundsDict[$name].channel;
		}
		
		
		public function isSoundPaused($name:String):Boolean
		{
			return this._soundsDict[$name].paused;
		}
		
		
		public function isSoundPausedByAll($name:String):Boolean
		{
			return this._soundsDict[$name].pausedByAll;
		}
		
		public function get sounds():Array
		{
			return this._sounds;
		}
		
		public override function toString():String
		{
			return getQualifiedClassName(this);
		}
		
		public function get mute()	:Boolean
		{
			return _isMute;
		}
		
		public function set mute(boo:Boolean)	:void
		{
			_isMute = boo;
		}
		
	}
}


import flash.media.Sound;
import flash.media.SoundChannel;


internal class SoundObject extends Object
{
	public var name					:String;
	public var sound				:Sound;
	public var channel				:SoundChannel;
	public var position				:Number;
	public var paused				:Boolean;
	public var volume				:Number;
	public var startTime			:Number;
	public var loops				:int;
	public var pausedByAll			:Boolean;
	public var isPlaying			:Boolean;
	
	public function SoundObject()
	{
	}
}