package src
{
   import com.hotpoint.braveManIII.models.elves.Elves;
   import com.hotpoint.braveManIII.repository.elves.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.other.*;
   import src.tool.*;
   
   public class JingLing extends MovieClip
   {
      
      public var who:Player;
      
      public var data:Elves;
      
      public var RL:Boolean = true;
      
      public var skin:MovieClip;
      
      private var distanceX_Max:int = 900;
      
      private var distanceY_Max:int = 500;
      
      private var distanceX2:int = 100;
      
      private var distanceY2:int = 30;
      
      public var jiNengZD_ID:int = 1;
      
      public var jiNengBD_ID:int = 0;
      
      private var jiNengZD_Data:Array = [];
      
      private var jiNengBD_Data:Array = [];
      
      public var jiNengZD_num:int = 0;
      
      public var jiNengZD_Time:int = 0;
      
      public var runType:String = "移动";
      
      public var lianJiNumArr:Array = [0,0,0,"",0];
      
      private var timeX:int = 0;
      
      private var timeY:int = 0;
      
      private var MoveX:int = 2;
      
      private var MoveY:int = 2;
      
      private var BD1Time:int = 0;
      
      private var ZD1time:int;
      
      public var ZD1num:int = 0;
      
      private var ZD2Time:int = 0;
      
      private var ZD1012_Time:int = 0;
      
      public function JingLing(param1:Elves, param2:Player)
      {
         var _loc3_:* = undefined;
         super();
         who = param2;
         who.data.playerJL_Data = data = param1;
         who.playerJL = this;
         addSkin();
         mouseChildren = mouseEnabled = false;
         getID();
         TiaoShi.txtShow("创建精灵 jiNengZD_num = " + jiNengZD_num);
         TiaoShi.txtShow("jiNengZD_ID = " + jiNengZD_ID);
         TiaoShi.txtShow("jiNengBD_ID = " + jiNengBD_ID);
         for(_loc3_ in jiNengZD_Data)
         {
            TiaoShi.txtShow("jiNengZD_Data i = " + _loc3_ + "=" + jiNengZD_Data[_loc3_].getValue());
         }
         for(_loc3_ in jiNengBD_Data)
         {
            TiaoShi.txtShow("jiNengBD_Data i = " + _loc3_ + "=" + jiNengBD_Data[_loc3_].getValue());
         }
      }
      
      public static function lianJiNumXX1010(param1:Player) : *
      {
         var _loc2_:JingLing = null;
         if(param1.playerJL)
         {
            _loc2_ = param1.playerJL;
            if(_loc2_.jiNengBD_ID == 1010)
            {
               _loc2_.lianJiNumArr[1] = param1.lianJi.getValue();
            }
         }
      }
      
      public static function ACT_Stop(param1:Player, param2:String) : *
      {
         var _loc3_:JingLing = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.playerJL)
         {
            _loc3_ = param1.playerJL;
            if(_loc3_.jiNengBD_ID == 1010)
            {
               _loc4_ = int(_loc3_.jiNengBD_Data[0].getValue());
               _loc5_ = int(_loc3_.jiNengBD_Data[1].getValue());
               if(_loc3_.lianJiNumArr[0] == 0)
               {
                  if(_loc3_.lianJiNumArr[1] < _loc4_)
                  {
                     _loc3_.lianJiNumArr[2] = 0;
                  }
                  if(_loc3_.lianJiNumArr[1] - _loc3_.lianJiNumArr[2] >= _loc4_)
                  {
                     _loc3_.lianJiNumArr[0] = 1;
                     TiaoShi.txtShow("XXX ===> 连击达成" + _loc4_);
                  }
               }
               if(_loc3_.lianJiNumArr[0] == 1)
               {
                  if(param2.substr(0,2) == "攻击")
                  {
                     _loc3_.lianJiNumArr[3] = param2;
                     _loc3_.lianJiNumArr[2] = _loc3_.lianJiNumArr[1];
                     _loc3_.lianJiNumArr[0] = 2;
                     param1.hpXX2num = param1.use_gongji.getValue() * _loc5_;
                     TiaoShi.txtShow("XXX ===> 攻击" + param2 + ",");
                  }
               }
               if(_loc3_.lianJiNumArr[0] == 2)
               {
                  if(_loc3_.lianJiNumArr[3] != param2)
                  {
                     _loc3_.lianJiNumArr[3] = "";
                     _loc3_.lianJiNumArr[0] = 0;
                     param1.hpXX2num = 0;
                     TiaoShi.txtShow("onLianJiFun 复原");
                  }
               }
            }
            else
            {
               _loc3_.lianJiNumArr = [0,0,0,"",0];
               param1.hpXX2num = 0;
            }
         }
      }
      
      public static function QingChuLengQue() : *
      {
         if(Boolean(Main.player_1) && Boolean(Main.player_1.playerJL))
         {
            Main.player_1.playerJL.jiNengZD_num = 0;
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player_2) && Boolean(Main.player_2.playerJL))
         {
            Main.player_2.playerJL.jiNengZD_num = 0;
         }
      }
      
      public function getID() : *
      {
         if(data.getSID3() > 0)
         {
            jiNengZD_ID = SkillFactory.getSkillById(data.getSKILL3()).getSkillActOn();
            jiNengZD_Data = SkillFactory.getSkillById(data.getSKILL3()).getSkillValueArray();
         }
         else
         {
            jiNengZD_ID = 0;
         }
         if(data.getSID2() > 0)
         {
            jiNengBD_ID = SkillFactory.getSkillById(data.getSKILL2()).getSkillActOn();
            jiNengBD_Data = SkillFactory.getSkillById(data.getSKILL2()).getSkillValueArray();
         }
         else
         {
            jiNengBD_ID = 0;
         }
      }
      
      public function InterfaceShow() : *
      {
         if(this.who == Main.player_1)
         {
            Play_Interface.interfaceX.jlNum_mc1.gotoAndStop("a" + jiNengZD_ID);
            Play_Interface.interfaceX.jlNum_txt1.text = jiNengZD_num + "%";
            if(jiNengZD_num >= 100)
            {
               Play_Interface.interfaceX.jlNum_mc_X1.gotoAndStop(2);
            }
            else
            {
               Play_Interface.interfaceX.jlNum_mc_X1.gotoAndStop(1);
            }
         }
         else if(Boolean(Main.P1P2) && this.who == Main.player_2)
         {
            Play_Interface.interfaceX.jlNum_mc2.gotoAndStop("a" + jiNengZD_ID);
            Play_Interface.interfaceX.jlNum_txt2.text = jiNengZD_num + "%";
            if(jiNengZD_num >= 100)
            {
               Play_Interface.interfaceX.jlNum_mc_X2.gotoAndStop(2);
            }
            else
            {
               Play_Interface.interfaceX.jlNum_mc_X2.gotoAndStop(1);
            }
         }
      }
      
      public function JingLingOPEN() : *
      {
         if(Boolean(who) && who.visible)
         {
            Main.world.moveChild_ChongWu.addChild(this);
            this.x = who.x + 110;
            this.y = who.y - 60;
            addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         }
      }
      
      public function Close() : *
      {
         who.hpXX2num = 0;
         removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         this.parent.removeChild(this);
         who.playerJL = null;
         who.data.playerJL_Data = null;
      }
      
      public function addSkin() : *
      {
         var _loc1_:String = ElvesFactory.getClassName(data.getId());
         var _loc2_:Class = ChongWu.loadData.getClass(_loc1_) as Class;
         skin = new _loc2_();
         addChild(skin);
         if(who)
         {
            Main.world.moveChild_ChongWu.addChild(this);
            this.x = who.x + 110;
            this.y = who.y - 60;
            addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         }
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         ShowPlay();
         Move();
         BD();
         ZD();
         InterfaceShow();
      }
      
      public function JNnumUP(param1:int, param2:int, param3:MovieClip) : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:GDpic = null;
         if(jiNengZD_ID != 0 && jiNengZD_Time <= 0)
         {
            _loc4_ = Math.random() * 100;
            if(_loc4_ < 50)
            {
               _loc5_ = Math.random() * 4 + 3;
               jiNengZD_num += _loc5_;
               if(jiNengZD_num > 100)
               {
                  jiNengZD_num = 100;
               }
               _loc6_ = "获得能量:" + _loc5_ + " 当前:" + jiNengZD_num;
               _loc7_ = new GDpic(param1,param2,param3,who);
            }
            else
            {
               jiNengZD_Time = 27 * 2;
            }
         }
      }
      
      public function ShowPlay() : *
      {
         if(this.skin)
         {
            if(skin.currentLabel != runType)
            {
               if(runType == "攻击")
               {
                  runType = "移动";
               }
               skin.gotoAndPlay(runType);
            }
         }
      }
      
      private function Move() : *
      {
         var _loc1_:int = this.x - who.x;
         var _loc2_:int = this.y - who.y + 70;
         if(Math.abs(_loc1_) > distanceX_Max || Math.abs(_loc2_) > distanceY_Max)
         {
            SearchPlayer();
         }
         var _loc3_:int = Math.abs(_loc1_) / 35 + 1;
         if(_loc1_ > distanceX2)
         {
            MoveX = -_loc3_;
            this.skin.scaleX = 1;
         }
         else if(_loc1_ < -distanceX2)
         {
            MoveX = _loc3_;
            this.skin.scaleX = -1;
         }
         if(MoveX > 0)
         {
            this.skin.scaleX = -1;
         }
         else
         {
            this.skin.scaleX = 1;
         }
         this.x += MoveX;
         var _loc4_:int = Math.abs(_loc2_) / 80 + 1;
         if(_loc2_ > distanceY2)
         {
            MoveY = -_loc4_;
         }
         else if(_loc2_ < -distanceX2)
         {
            MoveY = _loc4_;
         }
         this.y += MoveY;
      }
      
      private function WhoDead() : *
      {
         if(!who || who.hp.getValue() <= 0)
         {
            Close();
         }
      }
      
      private function SearchPlayer() : *
      {
         this.x = who.x + Math.random() * 200 - 100;
         this.y = who.y - 60;
      }
      
      private function ZD() : *
      {
         --jiNengZD_Time;
         if(jiNengZD_num >= 100)
         {
            this["ZD" + jiNengZD_ID]();
            jiNengZD_num = 0;
            runType = "攻击";
            skin.gotoAndPlay(runType);
         }
      }
      
      private function BD() : *
      {
         if(jiNengBD_ID == 1007)
         {
            BD1007();
         }
      }
      
      private function BD1007() : *
      {
         var _loc1_:int = 0;
         if(who.hp.getValue() < who.use_hp_Max.getValue() * jiNengBD_Data[0].getValue())
         {
            ++BD1Time;
            if(BD1Time >= jiNengBD_Data[1].getValue())
            {
               BD1Time = 0;
               _loc1_ = who.hp.getValue() * jiNengBD_Data[2].getValue();
               who.HpUp(_loc1_);
            }
         }
      }
      
      public function BD1001(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(jiNengBD_ID == 1001)
         {
            _loc2_ = Math.random() * 100;
            if(_loc2_ < jiNengBD_Data[0].getValue())
            {
               _loc3_ = param1 * jiNengBD_Data[1].getValue();
               who.HpUp(_loc3_);
            }
         }
      }
      
      public function BD1009(param1:Enemy, param2:int) : *
      {
         var _loc3_:int = 0;
         if(jiNengBD_ID == 1009)
         {
            _loc3_ = param2 * jiNengBD_Data[0].getValue();
            if(_loc3_ > 50000)
            {
               _loc3_ = 50000;
            }
            param1.HpXX2(_loc3_);
         }
      }
      
      public function BD1010() : *
      {
      }
      
      public function ZD1002() : *
      {
         ZD1time = jiNengZD_Data[2].getValue();
         NewMC.Open("萨泽效果",who);
         ZD1num = 0;
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1002);
      }
      
      private function onENTER_FRAME_ZD1002(param1:*) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(ZD1time > 0 && ZD1num >= jiNengZD_Data[0].getValue())
         {
            _loc2_ = jiNengZD_Data[1].getValue() + 0.0001;
            _loc3_ = who.use_hp_Max.getValue() * _loc2_;
            who.HpUp(_loc3_);
            ZD1num -= 10;
         }
         if(ZD1time <= 0)
         {
            ZD1num = 0;
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1002);
         }
         --ZD1time;
      }
      
      public function ZD1005() : *
      {
         var _loc1_:HitXX = null;
         ZD2Time = jiNengZD_Data[2].getValue();
         for(i in Enemy.All)
         {
            if(Enemy.All[i])
            {
               _loc1_ = new HitXX();
               _loc1_.type = 507;
               _loc1_.totalTime = 3 * 27;
               _loc1_.space = 3 * 27;
               _loc1_.numValue = jiNengZD_Data[0].getValue();
               new BuffEnemy(_loc1_,Enemy.All[i]);
               NewMC.Open("露娜效果",Enemy.All[i],0,-50);
            }
         }
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1005);
      }
      
      private function onENTER_FRAME_ZD1005(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Enemy = null;
         if(ZD2Time % 27 == 0)
         {
            _loc2_ = who.use_gongji.getValue() * jiNengZD_Data[1].getValue();
            for(i in Enemy.All)
            {
               if(Enemy.All[i])
               {
                  _loc3_ = Enemy.All[i];
                  _loc3_.HpXX2(_loc2_);
               }
            }
         }
         --ZD2Time;
         if(ZD2Time <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1005);
            jiNengZD_num = 0;
         }
      }
      
      public function ZD1012() : *
      {
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1012);
      }
      
      private function onENTER_FRAME_ZD1012(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Enemy = null;
         var _loc4_:Class = null;
         var _loc5_:* = undefined;
         ++ZD1012_Time;
         if(ZD1012_Time >= 23)
         {
            _loc2_ = who.use_gongji.getValue() * jiNengZD_Data[0].getValue();
            for(i in Enemy.All)
            {
               if(Enemy.All[i])
               {
                  _loc3_ = Enemy.All[i];
                  _loc3_.HpXX2(_loc2_);
                  _loc4_ = ChongWu.loadData.getClass("act_mc") as Class;
                  _loc5_ = new _loc4_();
                  Main.world.moveChild_Other.addChild(_loc5_);
                  _loc5_.x = _loc3_.x;
                  _loc5_.y = _loc3_.y;
               }
            }
            ZD1012_Time = 0;
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME_ZD1012);
         }
      }
   }
}

