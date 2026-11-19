package com.hotpoint.braveManIII.views.taskPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   import src.*;
   
   public class AwardPanel extends MovieClip
   {
      
      private static var _instance:AwardPanel;
      
      private var timer:Timer;
      
      private var timerNum:Number;
      
      private var bo:Boolean;
      
      public function AwardPanel()
      {
         super();
      }
      
      public static function open(param1:Array, param2:Array, param3:Number = 100) : void
      {
         if(AwardPanel._instance == null)
         {
            _instance = new AwardPanel();
            _instance.InitIcon();
         }
         Main._stage.addChild(AwardPanel._instance);
         _instance.visible = true;
         _instance.alpha = 0;
         _instance.init(param1,param2);
         _instance.addEvent(param3);
      }
      
      private function addEvent(param1:Number) : void
      {
         bo = false;
         timerNum = param1;
         timer = new Timer(0);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.start();
      }
      
      private function init(param1:Array, param2:Array) : void
      {
         trace(param1,"arr1_______________________");
         var _loc3_:uint = 0;
         while(_loc3_ < 5)
         {
            this["jl_" + _loc3_].visible = false;
            this["d_" + _loc3_].visible = false;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            this["jl_" + _loc3_].visible = true;
            this["d_" + _loc3_].visible = true;
            this["jl_" + _loc3_].pic_xx.gotoAndStop(param1[_loc3_].getFrame());
            this["jl_" + _loc3_].howNum.text = String(param2[_loc3_].getValue());
            _loc3_++;
         }
      }
      
      public function InitIcon() : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = int(_instance["jl_" + _loc1_].getChildIndex(_instance["jl_" + _loc1_].pic_xx));
            _loc2_.x = _instance["jl_" + _loc1_].pic_xx.x;
            _loc2_.y = _instance["jl_" + _loc1_].pic_xx.y;
            _loc2_.name = "pic_xx";
            _instance["jl_" + _loc1_].removeChild(_instance["jl_" + _loc1_].pic_xx);
            _instance["jl_" + _loc1_].pic_xx = _loc2_;
            _instance["jl_" + _loc1_].addChild(_loc2_);
            _instance["jl_" + _loc1_].setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(!bo)
         {
            if(this.alpha < 1)
            {
               this.alpha += 0.1;
            }
            else
            {
               bo = true;
            }
         }
         else if(timerNum > 0)
         {
            --timerNum;
         }
         else if(this.alpha > 0)
         {
            this.alpha -= 0.1;
         }
         else
         {
            bo = false;
            this.visible = false;
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,onTimer);
         }
      }
   }
}

