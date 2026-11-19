package src
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   import src.Skin.*;
   import src.tool.*;
   
   public class BuffEffect extends MovieClip
   {
      
      public static var AllBuffArr:Array = [];
      
      public static var isIce:Boolean = false;
      
      private var type:int;
      
      private var space:int;
      
      private var totalTime:int;
      
      private var numValue:int;
      
      private var effectMC:MovieClip;
      
      private var castMC:MovieClip;
      
      private var timeTemp:int = 0;
      
      private var tempNum:Number = 0;
      
      private var poisoning_C:Class = NewLoad.XiaoGuoData.getClass("Poisoning") as Class;
      
      private var iceing_C:Class = NewLoad.XiaoGuoData.getClass("Iceing") as Class;
      
      private var iceBroken_C:Class = NewLoad.XiaoGuoData.getClass("IceBroken") as Class;
      
      private var ghosting_C:Class = NewLoad.XiaoGuoData.getClass("Ghosting") as Class;
      
      private var ruanni_C:Class = NewLoad.XiaoGuoData.getClass("Ruanni") as Class;
      
      private var ruanniDead_C:Class = NewLoad.XiaoGuoData.getClass("RuanniDead") as Class;
      
      private var burn_C:Class = NewLoad.XiaoGuoData.getClass("Burn") as Class;
      
      private var mabi_C:Class = NewLoad.XiaoGuoData.getClass("Mabi") as Class;
      
      private var shandian_C:Class = NewLoad.XiaoGuoData.getClass("Shandian") as Class;
      
      private var zhongdu_C:Class = NewLoad.XiaoGuoData.getClass("ZhongDu") as Class;
      
      private var nianye_C:Class = NewLoad.XiaoGuoData.getClass("Nianye") as Class;
      
      private var jiansu_C:Class = NewLoad.XiaoGuoData.getClass("Jiansu") as Class;
      
      private var poisoning:MovieClip = new poisoning_C();
      
      private var iceing:MovieClip = new iceing_C();
      
      private var iceBroken:MovieClip = new iceBroken_C();
      
      private var ghosting:MovieClip = new ghosting_C();
      
      private var ruanni:MovieClip = new ruanni_C();
      
      private var ruanniDead:MovieClip = new ruanniDead_C();
      
      private var burn:MovieClip = new burn_C();
      
      private var mabi:MovieClip = new mabi_C();
      
      private var shandian:MovieClip = new shandian_C();
      
      private var zhongdu:MovieClip = new zhongdu_C();
      
      private var nianye:MovieClip = new nianye_C();
      
      private var jiansu:MovieClip = new jiansu_C();
      
      private var tempV:int = 0;
      
      public function BuffEffect(param1:MovieClip, param2:MovieClip)
      {
         super();
         type = (param1 as HitXX).type;
         space = (param1 as HitXX).space;
         totalTime = (param1 as HitXX).totalTime;
         numValue = (param1 as HitXX).numValue;
         timeTemp = (param1 as HitXX).space;
         castMC = (param1 as HitXX).who;
         effectMC = param2;
         if(type == 15)
         {
            if((effectMC as Player).debuff < 3)
            {
               ++(effectMC as Player).debuff;
            }
            return;
         }
         effectMC.addChild(this);
         this.x = 0;
         this.y = 0;
         zhongdu.x = this.x;
         zhongdu.y = this.y;
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
         burn.x = this.x;
         burn.y = this.y;
         jiansu.x = this.x;
         jiansu.y = this.y;
         if(type != 0)
         {
            addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
            AllBuffArr[AllBuffArr.length] = this;
         }
      }
      
      public function onENTER_FRAME(param1:Event) : *
      {
         if(effectMC is Player)
         {
            realEffect();
         }
      }
      
      internal function removeRuanniDead(param1:Event) : *
      {
         if(param1.target.currentFrame == MovieClip(param1.target).totalFrames)
         {
            effectMC.removeChild(ruanniDead);
            param1.target.removeEventListener(Event.ENTER_FRAME,removeRuanniDead);
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
      
      internal function bianXiao(param1:Event) : *
      {
         effectMC.scaleX -= 0.05;
         effectMC.scaleY -= 0.05;
         if(effectMC.scaleX <= 0.5 && effectMC.scaleY <= 0.5)
         {
            removeEventListener(Event.ENTER_FRAME,bianXiao);
         }
      }
      
      internal function zhongXie(param1:Event) : *
      {
         if((castMC as Enemy).skin.runType == "被打")
         {
            (effectMC as Player).skin.GoTo("被打",20,true);
         }
      }
      
      private function realEffect() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         var _loc4_:ColorMatrix = null;
         var _loc5_:ColorMatrixFilter = null;
         --totalTime;
         if(Boolean(effectMC) && (effectMC as Player).hp.getValue() <= 0)
         {
            dead();
         }
         if(type == 7)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if(AllBuffArr.length > 3)
                  {
                     isIce = true;
                     this.addChild(iceing);
                     (effectMC as Player).skin.GoTo("被打",81,true);
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
               if(AllBuffArr.length <= 0 && isIce == true)
               {
                  isIce = false;
                  effectMC.addChild(iceBroken);
                  iceBroken.gotoAndPlay(0);
                  iceBroken.addEventListener(Event.ENTER_FRAME,removeIceBroken);
               }
            }
         }
         else if(type == 6)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if(AllBuffArr.length > 0)
                  {
                     isIce = true;
                     this.addChild(iceing);
                     (effectMC as Player).skin.GoTo("被打",81,true);
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
               if(AllBuffArr.length <= 0 && isIce == true)
               {
                  isIce = false;
                  effectMC.addChild(iceBroken);
                  iceBroken.gotoAndPlay(0);
                  iceBroken.addEventListener(Event.ENTER_FRAME,removeIceBroken);
               }
            }
         }
         else if(type == 1)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  if(_loc1_ > 0)
                  {
                     _loc2_ = (effectMC as Player).hp.getValue() - _loc1_;
                     if(_loc2_ < 0)
                     {
                        (effectMC as Player).hp.setValue(0);
                     }
                     else
                     {
                        (effectMC as Player).hp.setValue(_loc2_);
                     }
                  }
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
                  this.addChild(zhongdu);
               }
            }
            else
            {
               this.removeChild(zhongdu);
               dead();
            }
         }
         else if(type == 11)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  timeTemp = 0;
                  (effectMC as Player).skin.GoTo("被打",18,true);
                  this.addChild(mabi);
               }
            }
            else
            {
               this.removeChild(mabi);
               dead();
            }
         }
         else if(type == 5)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  if(_loc1_ > 0)
                  {
                     _loc2_ = (effectMC as Player).hp.getValue() - _loc1_;
                     if(_loc2_ < 0)
                     {
                        (effectMC as Player).hp.setValue(0);
                     }
                     else
                     {
                        (effectMC as Player).hp.setValue(_loc2_);
                     }
                  }
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
         else if(type == 504)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  _loc1_ = numValue;
                  if(_loc1_ > 0)
                  {
                     _loc2_ = (effectMC as Player).hp.getValue() - _loc1_;
                     if(_loc2_ < 0)
                     {
                        (effectMC as Player).hp.setValue(0);
                     }
                     else
                     {
                        (effectMC as Player).hp.setValue(_loc2_);
                     }
                  }
                  timeTemp = 0;
                  HPdown.Open(_loc1_,effectMC.x,effectMC.y - effectMC.height);
                  this.addChild(shandian);
               }
            }
            else
            {
               this.removeChild(shandian);
               dead();
            }
         }
         else if(type == 10)
         {
            if(totalTime >= 0)
            {
               _loc3_ = Enemy.EnemyArr[82].getClass("视野丢失") as Class;
               (effectMC as Player).skin_W.addChild(new _loc3_());
               type = 0;
            }
            else
            {
               dead();
            }
         }
         else if(type == 8)
         {
            if(totalTime >= 0)
            {
               (effectMC as Player).speedTemp.setValue(-5);
            }
            else
            {
               (effectMC as Player).speedTemp.setValue(0);
               dead();
            }
         }
         else if(type == 9)
         {
            if(totalTime >= 0)
            {
               if(tempV == 0)
               {
                  tempV = (effectMC as Player).mp.getValue();
               }
               (effectMC as Player).mp.setValue(1);
            }
            else
            {
               (effectMC as Player).mp.setValue(tempV);
               tempV = 0;
               dead();
            }
         }
         else if(type == 2)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (effectMC as Player).skin.GoTo("被打",72,true);
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
         else if(type == 3)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  this.addEventListener(Event.ENTER_FRAME,zhongXie);
                  timeTemp = 0;
                  this.addChild(ghosting);
               }
            }
            else
            {
               this.removeEventListener(Event.ENTER_FRAME,zhongXie);
               dead();
            }
         }
         else if(type == 4)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (castMC as Enemy).life.setValue(0);
                  (castMC as Enemy).Dead();
                  timeTemp = 0;
                  this.addChild(ruanni);
               }
            }
            else
            {
               effectMC.addChild(ruanniDead);
               ruanniDead.gotoAndPlay(0);
               ruanniDead.addEventListener(Event.ENTER_FRAME,removeRuanniDead);
               dead();
            }
         }
         else if(type == 100)
         {
            if(totalTime >= 0)
            {
               (effectMC as Player).speedTemp.setValue(4);
            }
            else
            {
               (effectMC as Player).speedTemp.setValue(0);
               dead();
            }
         }
         else if(type == 23)
         {
            if(totalTime == 0)
            {
               ++Boss83.hongNUM;
            }
         }
         else if(type == 24)
         {
            if(totalTime == 0)
            {
               ++Boss83.lanNUM;
            }
         }
         else if(type == 25)
         {
            if(totalTime >= 0)
            {
               if(tempV == 0)
               {
                  tempV = int((effectMC as Player).mp.getValue());
               }
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).mp.setValue(1);
               }
            }
            else
            {
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).mp.setValue(tempV);
               }
               tempV = 0;
               dead();
            }
         }
         else if(type == 26)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  if(tempV == 0)
                  {
                     tempV = int((effectMC as Player).hp.getValue());
                  }
                  if((effectMC as Player).hp.getValue() > 0)
                  {
                     (effectMC as Player).hp.setValue(100);
                  }
                  timeTemp = 0;
               }
               if((effectMC as Player).hp.getValue() <= 0)
               {
                  dead();
               }
            }
            else
            {
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).HpUp(tempV);
               }
               tempV = 0;
               dead();
            }
         }
         else if(type == 27)
         {
            if(totalTime >= 0)
            {
               if(tempV == 0)
               {
                  tempV = (effectMC as Player).fangyu.getValue();
               }
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).fangyu.setValue(1);
               }
            }
            else
            {
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).fangyu.setValue(tempV);
               }
               tempV = 0;
               dead();
            }
         }
         else if(type == 28)
         {
            if(totalTime >= 0)
            {
               if(tempV == 0)
               {
                  tempV = (effectMC as Player).gongji.getValue();
               }
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).gongji.setValue(1);
               }
            }
            else
            {
               if((effectMC as Player).hp.getValue() > 0)
               {
                  (effectMC as Player).gongji.setValue(tempV);
               }
               tempV = 0;
               dead();
            }
         }
         else if(type == 16)
         {
            if(totalTime >= 0)
            {
               (effectMC as Player).speedTemp.setValue(-6);
               if(timeTemp == space)
               {
                  this.addChild(jiansu);
                  timeTemp = 0;
               }
            }
            else
            {
               (effectMC as Player).speedTemp.setValue(0);
               dead();
            }
         }
         else if(type == 18)
         {
            if(totalTime >= 0)
            {
               if(AllBuffArr.length == 1)
               {
                  (effectMC as Player).speedTemp.setValue(-2);
               }
               if(AllBuffArr.length == 2)
               {
                  (effectMC as Player).speedTemp.setValue(-4);
               }
               if(AllBuffArr.length == 3)
               {
                  (effectMC as Player).speedTemp.setValue(-6);
               }
               if(AllBuffArr.length == 4)
               {
                  (effectMC as Player).speedTemp.setValue(-8);
               }
               if(AllBuffArr.length >= 5)
               {
                  (effectMC as Player).speedTemp.setValue(-10);
               }
               if(timeTemp == space)
               {
                  this.addChild(jiansu);
                  timeTemp = 0;
               }
            }
            else
            {
               (effectMC as Player).speedTemp.setValue(0);
               dead();
            }
         }
         else if(type == 17)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (effectMC as Player).skin.GoTo("被打",81,true);
                  this.addChild(nianye);
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
            }
         }
         else if(type == 59)
         {
            if(totalTime >= 0)
            {
               if(timeTemp == space)
               {
                  (effectMC as Player).skin.GoTo("被打",54,true);
                  _loc4_ = new ColorMatrix();
                  _loc5_ = new ColorMatrixFilter();
                  _loc4_.SetSaturationMatrix(0);
                  _loc5_.matrix = _loc4_.GetFlatArray();
                  if((effectMC as Player).skin)
                  {
                     (effectMC as Player).skin.filters = [_loc5_];
                  }
                  if((effectMC as Player).skin_Z)
                  {
                     (effectMC as Player).skin_Z.filters = [_loc5_];
                  }
                  if((effectMC as Player).skin_Z2)
                  {
                     (effectMC as Player).skin_Z2.filters = [_loc5_];
                  }
                  if((effectMC as Player).skin_Z3)
                  {
                     (effectMC as Player).skin_Z3.filters = [_loc5_];
                  }
                  if((effectMC as Player).skin_W)
                  {
                     (effectMC as Player).skin_W.filters = [_loc5_];
                  }
                  timeTemp = 0;
               }
            }
            else
            {
               dead();
            }
         }
         ++timeTemp;
      }
      
      private function dead() : *
      {
         if(type == 59)
         {
            if((effectMC as Player).skin)
            {
               (effectMC as Player).skin.filters = [];
            }
            if((effectMC as Player).skin_Z)
            {
               (effectMC as Player).skin_Z.filters = [];
            }
            if((effectMC as Player).skin_Z2)
            {
               (effectMC as Player).skin_Z2.filters = [];
            }
            if((effectMC as Player).skin_Z3)
            {
               (effectMC as Player).skin_Z3.filters = [];
            }
            if((effectMC as Player).skin_W)
            {
               (effectMC as Player).skin_W.filters = [];
            }
         }
         this.removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         this.parent.removeChild(this);
         var _loc1_:int = 0;
         while(_loc1_ < AllBuffArr.length)
         {
            if(AllBuffArr[_loc1_] == this)
            {
               AllBuffArr.splice(_loc1_,1);
            }
            _loc1_++;
         }
      }
   }
}

