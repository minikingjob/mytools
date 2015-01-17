/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class Cover
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createCoverLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = newScreen.width;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		public static function createCoverRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = -newScreen.width;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		public static function createCoverUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = newScreen.height;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		public static function createCoverDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = -newScreen.height;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		private static function slideInNewScreen(newScreen:DisplayObject,
			duration:Number, ease:Object, tweenProperties:Object, onComplete:Function):void
		{
			var tween:Tween = new Tween(newScreen, duration, ease);
			if(newScreen.x != 0)
			{
				tween.animate("x", 0);
			}
			if(newScreen.y !== 0)
			{
				tween.animate("y", 0);
			}
			if(tweenProperties)
			{
				for(var propertyName:String in tweenProperties)
				{
					tween[propertyName] = tweenProperties[propertyName];
				}
			}
			tween.onComplete = onComplete;
			Starling.juggler.add(tween);
		}
	}
}

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;

class CoverTween extends Tween
{
	public function CoverTween(newScreen:DisplayObject, oldScreen:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		var clipRect:Rectangle = new Rectangle(0, 0, oldScreen.width, oldScreen.height);
		this._temporaryParent = new Sprite();
		this._temporaryParent.clipRect = clipRect;
		oldScreen.parent.addChild(this._temporaryParent);
		this._temporaryParent.addChild(oldScreen);

		super(this._temporaryParent.clipRect, duration, ease);

		if(xOffset < 0)
		{
			this.animate("width", 0);
		}
		else if(xOffset > 0)
		{
			this.animate("x", xOffset);
			this.animate("width", 0);
		}
		if(yOffset < 0)
		{
			this.animate("height", 0);
		}
		else if(yOffset > 0)
		{
			this.animate("y", yOffset);
			this.animate("height", 0);
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		if(newScreen)
		{
			this._savedNewScreen = newScreen;
			this._savedXOffset = xOffset;
			this._savedYOffset = yOffset;
			this.onUpdate = this.updateNewScreen;
		}
		this.onComplete = this.cleanupTween;
		Starling.juggler.add(this);
	}

	private var _savedXOffset:Number;
	private var _savedYOffset:Number;
	private var _savedNewScreen:DisplayObject;
	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Function;

	private function updateNewScreen():void
	{
		var clipRect:Rectangle = this._temporaryParent.clipRect;
		if(this._savedXOffset < 0)
		{
			this._savedNewScreen.x = clipRect.width;
		}
		else if(this._savedXOffset > 0)
		{
			this._savedNewScreen.x = -clipRect.width;
		}
		if(this._savedYOffset < 0)
		{
			this._savedNewScreen.y = clipRect.height;
		}
		else if(this._savedYOffset > 0)
		{
			this._savedNewScreen.y = -clipRect.height;
		}
	}

	private function cleanupTween():void
	{
		var target:DisplayObject = this._temporaryParent.removeChildAt(0);
		this._temporaryParent.parent.addChild(target);
		this._temporaryParent.removeFromParent(true);
		target.x = 0;
		target.y = 0;
		this._savedNewScreen = null;
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}

}

