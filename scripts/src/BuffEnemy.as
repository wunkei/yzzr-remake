package src
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class BuffEnemy extends MovieClip
   {
      
      public static var AllBuff:Array = [];
      
      private var who:Player;
      
      private var type:int;
      
      private var space:int;
      
      private var totalTime:int;
      
      private var numValue:int;
      
      private var speedValue:int;
      
      private var effectMC:MovieClip;
      
      private var timeTemp:int = 0;
      
      private var tempNum:Number = 0;
      
      private var shandian_C:Class = NewLoad.XiaoGuoData.getClass("Shandian") as Class;
      
      private var poisoning_C:Class = NewLoad.XiaoGuoData.getClass("Poisoning") as Class;
      
      private var zhongdu_C:Class = NewLoad.XiaoGuoData.getClass("ZhongDu") as Class;
      
      private var iceing_C:Class = NewLoad.XiaoGuoData.getClass("Iceing") as Class;
      
      private var sufu_C:Class = NewLoad.XiaoGuoData.getClass("Shufu") as Class;
      
      private var langtou_C:Class = NewLoad.XiaoGuoData.getClass("Langtou") as Class;
      
      private var bingshuang_C:Class = NewLoad.XiaoGuoData.getClass("Bingshuang") as Class;
      
      private var iceBroken_C:Class = NewLoad.XiaoGuoData.getClass("IceBroken") as Class;
      
      private var ghosting_C:Class = NewLoad.XiaoGuoData.getClass("Ghosting") as Class;
      
      private var ruanni_C:Class = NewLoad.XiaoGuoData.getClass("Ruanni") as Class;
      
      private var ruanniDead_C:Class = NewLoad.XiaoGuoData.getClass("RuanniDead") as Class;
      
      private var burn_C:Class = NewLoad.XiaoGuoData.getClass("Burn") as Class;
      
      private var jiansu_C:Class = NewLoad.XiaoGuoData.getClass("Jiansu") as Class;
      
      private var shandian:MovieClip = new shandian_C();
      
      private var poisoning:MovieClip = new poisoning_C();
      
      private var zhongdu:MovieClip = new zhongdu_C();
      
      private var iceing:MovieClip = new iceing_C();
      
      private var sufu:MovieClip = new sufu_C();
      
      private var langtou:MovieClip = new langtou_C();
      
      private var bingshuang:MovieClip = new bingshuang_C();
      
      private var iceBroken:MovieClip = new iceBroken_C();
      
      private var ghosting:MovieClip = new ghosting_C();
      
      private var ruanni:MovieClip = new ruanni_C();
      
      private var ruanniDead:MovieClip = new ruanniDead_C();
      
      private var burn:MovieClip = new burn_C();
      
      private var jiansu:MovieClip = new jiansu_C();
      
      public function BuffEnemy(param1:MovieClip, param2:MovieClip, param3:uint = 0)
      {
         super();
         type = (param1 as HitXX).type;
         space = (param1 as HitXX).space;
         totalTime = (param1 as HitXX).totalTime;
         numValue = (param1 as HitXX).numValue;
         speedValue = (param1 as HitXX).speedValue;
         timeTemp = (param1 as HitXX).space;
         if((param1 as HitXX).who is Player)
         {
            who = (param1 as HitXX).who;
         }
         effectMC = param2;
         effectMC.addChild(this);
         this.x = 0;
         this.y = 0;
         zhongdu.x = this.x;
         zhongdu.y = this.y;
         bingshuang.x = this.x;
         bingshuang.y = this.y;
         langtou.x = this.x;
         langtou.y = this.y;
         sufu.x = this.x;
         sufu.y = this.y;
         poisoning.x = this.x;
         poisoning.y = this.y;
         iceing.x = this.x;
         iceing.y = this.y;
         iceBroken.x = this.x;
         iceBroken.y = this.y;
         ghosting.x = this.x;
         ghosting.y = this.y;
         ruanni.x = this.x;
         ruanni.y = this.y;
         ruanniDead.x = this.x;
         ruanniDead.y = this.y;
         shandian.x = this.x;
         shandian.y = this.y;
         jiansu.x = this.x;
         jiansu.y = this.y;
         burn.x = this.x;
         burn.y = this.y;
         if(type >= 100 && type < 500)
         {
            addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
            (effectMC as Enemy).cengshu[(effectMC as Enemy).cengshu.length] = this;
         }
         if(type >= 500)
         {
            if((effectMC as Enemy).cengshu.length == 0)
            {
               addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
               (effectMC as Enemy).cengshu[(effectMC as Enemy).cengshu.length] = this;
            }
            else if((effectMC as Enemy).cengshu.length == 1)
            {
               if((effectMC as Enemy).cengshu[0].type == this.type)
               {
                  (effectMC as Enemy).cengshu[0].totalTime = this.totalTime;
               }
            }
         }
      }
      
      public function onENTER_FRAME(param1:Event) : *
      {
         if(effectMC is Enemy)
         {
            realEffect();
         }
      }
      
      internal function bianXiao(param1:Event) : *
      {
         effectMC.scaleX -= 0.05;
         effectMC.scaleY -= 0.05;
         if(effectMC.scaleX <= 0.5 && effectMC.scaleY <= 0.5)
         {
            removeEventListener(Event.ENTER_FRAME,bianXiao);
         }
      }
      
      internal function removeIceBroken(param1:Event) : *
      {
         if(param1.target.currentFrame == MovieClip(param1.target).totalFrames)
         {
            effectMC.removeChild(iceBroken);
            param1.target.removeEventListener(Event.ENTER_FRAME,removeIceBroken);
         }
      }
      
      private function realEffect() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         --totalTime;
         if(type == 100)
         {
            if((effectMC as Enemy).changeMode == false)
            {
               return;
            }
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  this.addEventListener(Event.ENTER_FRAME,bianXiao);
                  timeTemp = 0;
               }
            }
            else
            {
               effectMC.scaleX = 1;
               effectMC.scaleY = 1;
               dead();
            }
         }
         else if(type == 501)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  _loc2_ = (effectMC as Enemy).life.getValue() - _loc1_;
                  if(_loc2_ < 0)
                  {
                     dead();
                  }
                  (effectMC as Enemy).hpCount(_loc1_);
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
                  this.addChild(burn);
               }
            }
            else
            {
               this.removeChild(burn);
               dead();
            }
         }
         else if(type == 502)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  _loc2_ = (effectMC as Enemy).life.getValue() - _loc1_;
                  if(_loc2_ < 0)
                  {
                     dead();
                  }
                  (effectMC as Enemy).hpCount(_loc1_);
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
                  this.addChild(zhongdu);
               }
               if(speedValue > 0)
               {
                  (effectMC as Enemy).walk_power -= speedValue;
                  if((effectMC as Enemy).walk_power < 0)
                  {
                     (effectMC as Enemy).walk_power = 0;
                  }
                  speedValue = 0;
               }
            }
            else
            {
               (effectMC as Enemy).walk_power = (effectMC as Enemy).walk_temp;
               this.removeChild(zhongdu);
               dead();
            }
         }
         else if(type == 503)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  _loc2_ = (effectMC as Enemy).life.getValue() - _loc1_;
                  if(_loc2_ < 0)
                  {
                     dead();
                  }
                  (effectMC as Enemy).hpCount(_loc1_);
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
                  this.addChild(bingshuang);
               }
               if(speedValue > 0)
               {
                  (effectMC as Enemy).walk_power -= speedValue;
                  if((effectMC as Enemy).walk_power < 0)
                  {
                     (effectMC as Enemy).walk_power = 0;
                  }
                  speedValue = 0;
               }
            }
            else
            {
               (effectMC as Enemy).walk_power = (effectMC as Enemy).walk_temp;
               this.removeChild(bingshuang);
               dead();
            }
         }
         else if(type == 504)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  this.addChild(shandian);
                  _loc1_ = numValue;
                  _loc2_ = (effectMC as Enemy).life.getValue() - _loc1_;
                  if(_loc2_ < 0)
                  {
                     dead();
                  }
                  (effectMC as Enemy).hpCount(_loc1_);
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
               }
            }
            else
            {
               this.removeChild(shandian);
               dead();
            }
         }
         else if(type == 505)
         {
            if(totalTime >= 0)
            {
               (effectMC as Enemy).walk_power = 0;
               this.addChild(sufu);
            }
            else
            {
               (effectMC as Enemy).walk_power = (effectMC as Enemy).walk_temp;
               this.removeChild(sufu);
               dead();
            }
         }
         else if(type == 506)
         {
            if(totalTime >= 0)
            {
               (effectMC as Enemy).攻击力.setValue(0);
               this.addChild(langtou);
            }
            else
            {
               (effectMC as Enemy).攻击力.setValue((effectMC as Enemy).att_temp);
               this.addChild(langtou);
               dead();
            }
         }
         else if(type == 507)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (effectMC as Enemy).walk_power -= numValue;
                  if((effectMC as Enemy).walk_power < 0)
                  {
                     (effectMC as Enemy).walk_power = 0;
                  }
                  this.addChild(jiansu);
               }
            }
            else
            {
               (effectMC as Enemy).walk_power = (effectMC as Enemy).walk_temp;
               this.removeChild(jiansu);
               dead();
            }
         }
         else if(type == 508)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (effectMC as Enemy).walk_power -= numValue;
                  if((effectMC as Enemy).walk_power < 0)
                  {
                     (effectMC as Enemy).walk_power = 0;
                  }
               }
            }
            else
            {
               (effectMC as Enemy).walk_power = (effectMC as Enemy).walk_temp;
               dead();
            }
         }
         if(type == 101)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if((effectMC as Enemy).cengshu.length > 3)
                  {
                     (effectMC as Enemy).isIce = true;
                     if((this.parent as Enemy).life.getValue() > 0)
                     {
                        this.addChild(iceing);
                        (effectMC as Enemy).skin.continuousTime = 81;
                        (effectMC as Enemy).skin.GoTo("被打",81);
                     }
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
               if((effectMC as Enemy).cengshu.length <= 0 && (effectMC as Enemy).isIce == true)
               {
                  (effectMC as Enemy).isIce = false;
                  effectMC.addChild(iceBroken);
                  iceBroken.gotoAndPlay(0);
                  iceBroken.addEventListener(Event.ENTER_FRAME,removeIceBroken);
               }
            }
         }
         if(type == 102)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if(Boolean(effectMC as Enemy) && Boolean((effectMC as Enemy).cengshu.length > 0) && (effectMC as Enemy).className != "龙卷风")
                  {
                     (effectMC as Enemy).isIce = true;
                     if((this.parent as Enemy).life.getValue() > 0)
                     {
                        this.addChild(iceing);
                        (effectMC as Enemy).skin.continuousTime = 81;
                        (effectMC as Enemy).skin.GoTo("被打",81);
                     }
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
               if((effectMC as Enemy).cengshu.length <= 0 && (effectMC as Enemy).isIce == true)
               {
                  (effectMC as Enemy).isIce = false;
                  effectMC.addChild(iceBroken);
                  iceBroken.gotoAndPlay(0);
                  iceBroken.addEventListener(Event.ENTER_FRAME,removeIceBroken);
               }
            }
         }
         if(type == 103)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if(Boolean(effectMC as Enemy) && Boolean((effectMC as Enemy).cengshu.length > 0) && (effectMC as Enemy).className != "龙卷风")
                  {
                     (effectMC as Enemy).isIce = true;
                     if((this.parent as Enemy).life.getValue() > 0)
                     {
                        this.addChild(iceing);
                        (effectMC as Enemy).skin.continuousTime = 27 * 2;
                        (effectMC as Enemy).skin.GoTo("被打",27 * 2);
                     }
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
               if((effectMC as Enemy).cengshu.length <= 0 && (effectMC as Enemy).isIce == true)
               {
                  (effectMC as Enemy).isIce = false;
                  effectMC.addChild(iceBroken);
                  iceBroken.gotoAndPlay(0);
                  iceBroken.addEventListener(Event.ENTER_FRAME,removeIceBroken);
               }
            }
         }
         if(type == 104)
         {
            if(timeTemp == space)
            {
               if((this.parent as Enemy).life.getValue() > 0)
               {
                  (effectMC as Enemy).skin.continuousTime = 54;
                  (effectMC as Enemy).skin.GoTo("被打",54);
                  dead();
               }
               timeTemp = 0;
            }
         }
         ++timeTemp;
      }
      
      private function dead() : *
      {
         this.removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         this.parent.removeChild(this);
         var _loc1_:int = 0;
         while(_loc1_ < (effectMC as Enemy).cengshu.length)
         {
            if((effectMC as Enemy).cengshu[_loc1_] == this)
            {
               (effectMC as Enemy).cengshu.splice(_loc1_,1);
            }
            _loc1_++;
         }
      }
   }
}

