package src
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.gem.Gem;
   import com.hotpoint.braveManIII.models.other.Otherobj;
   import com.hotpoint.braveManIII.models.petEquip.*;
   import com.hotpoint.braveManIII.models.quest.Quest;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.quest.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.cardPanel.*;
   import com.hotpoint.braveManIII.views.chunjiePanel.*;
   import com.hotpoint.braveManIII.views.fanpaiPanel.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.setTransfer.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import src.Skin.*;
   import src.other.*;
   import src.tool.*;
   
   public class Enemy extends MovieClip
   {
      
      public static var EnemyXml:XML;
      
      public static var hit_x:int;
      
      public static var hit_y:int;
      
      public static var xuanshang5:Boolean = true;
      
      public static var wscd:int = 0;
      
      public static var EnemyArr:Array = new Array();
      
      public static var EnemyXmlArrMd5:Array = new Array();
      
      public static var EnemyXmlArr:Array = new Array();
      
      public static var All:Array = [];
      
      public static var only:Boolean = true;
      
      public static var gongJiPOWER:VT = VT.createVT();
      
      public static var hpNumX:Number = -1;
      
      private static var addTimes:int = 0;
      
      public static var bool_5:Boolean = true;
      
      public static var bool_6:Boolean = true;
      
      public static var boss54:int = 0;
      
      public var cengshu:Array = [];
      
      public var rebornTimes:int = 0;
      
      public var iii:int = 0;
      
      private var zhuoshaoTimes:int = 0;
      
      public var id:int;
      
      public var className:String;
      
      public var isFunction:Boolean = true;
      
      public var lifeMAX:VT = VT.createVT();
      
      public var life:VT = VT.createVT();
      
      public var isIce:Boolean = false;
      
      public var RL:Boolean = true;
      
      public var over:Boolean;
      
      public var skinArr:Array = [0,1];
      
      public var skinNum:int = 0;
      
      public var skin:EnemySkin;
      
      public var hitXX:HitXX;
      
      public var hit:MovieClip = null;
      
      private var jumptemp:int;
      
      public var att_temp:* = 0;
      
      public var walk_temp:* = 0;
      
      public var walk_power:* = 3;
      
      private var jump_power:* = 120;
      
      private var jump_time:* = 8;
      
      private var parabola:Number = 0.2;
      
      private var jumping:Boolean;
      
      private var jumpType:int = 2;
      
      public var gravity:int = 2;
      
      private var gravityNum:* = 0;
      
      public var gravityXX:int = 2;
      
      private var lastTime:int;
      
      public var 硬直:VT = VT.createVT();
      
      public var 攻击力:VT = VT.createVT();
      
      public var 防御力:VT = VT.createVT();
      
      public var 魔攻力:VT = VT.createVT();
      
      public var 魔防力:VT = VT.createVT();
      
      private var 震退值:VT = VT.createVT();
      
      private var 经验:VT = VT.createVT();
      
      private var 等级:VT = VT.createVT();
      
      private var 掉落物品:Array = [];
      
      private var 掉落概率:Array = [];
      
      public var 金钱:VT = VT.createVT();
      
      private var 掉落数量:VT = VT.createVT();
      
      private var 浮动硬直:Number = 0;
      
      public var 关卡:int = 0;
      
      public var changeMode:Boolean = true;
      
      public var distance_X:int;
      
      public var distance_Y:int;
      
      private var guard_XY:Array = [10,10];
      
      private var attack_XY:Array = [];
      
      public var attack_Time:Array = [];
      
      public var attack_TimeNum:Array = [];
      
      public var runType:String = "自由";
      
      public var noMove:Boolean = false;
      
      public var lifeMC:EnemyLife = new EnemyLife();
      
      private var temp2:VT = VT.createVT(2);
      
      private var temp3:VT = VT.createVT(3);
      
      private var temp10:VT = VT.createVT(10);
      
      private var tempXXX2:VT = VT.createVT(VT.GetTempVT("8/4"));
      
      private var rdom:int = 0;
      
      private var cj_arr:Array = [[3,3000],[6,3500],[9,4000],[13,4200],[16,4400],[19,4600],[23,4700],[28,4800],[32,4900],[35,5000],[41,5100],[46,6000],[50,5100],[55,5200],[58,5400],[62,5500],[65,5600],[203,6500],[201,6500],[202,6500],[204,6500],[205,6500],[206,6500],[207,6500],[208,6500],[209,6500],[210,6500],[211,6500],[212,6500],[213,6500],[214,6500],[215,6500],[68,7200],[71,7300],[216,6500],[217,6500],[218,6500],[74,7700],[78,7800]];
      
      internal var iceTime:int = 0;
      
      internal var temp:String;
      
      internal var tempXX:String;
      
      internal var tempTimeXX:int = 0;
      
      private var runX:int = 0;
      
      private var runY:int = 0;
      
      private var runArr:Array = new Array();
      
      public var EnemySkinXml:XML = new XML();
      
      private var 特殊掉落物品:Array = [];
      
      private var 特殊掉落概率:Array = [];
      
      public function Enemy(param1:int = 0)
      {
         var _loc2_:String = null;
         super();
         addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         if(param1 != 0)
         {
            this.id = param1;
            _loc2_ = SkinData(param1);
            if(_loc2_ == null)
            {
               trace("怪物信息错误!! 找不到ID" + param1);
            }
            else
            {
               addSkin(_loc2_);
               All[All.length] = this;
               this.skin.EnemySkinXml = EnemySkin.EnemySkinXmlArr[GameData.gameLV][关卡];
            }
         }
         else
         {
            trace("无法创建 怪物0");
         }
      }
      
      public static function hpNUMXXX(param1:int) : *
      {
         if(hpNumX >= 0)
         {
            hpNumX += param1 * 0.04;
         }
      }
      
      public static function hpNUMXXX2(param1:Object, param2:Object, param3:int) : *
      {
         var _loc4_:int = 0;
         if(param1 is Fly && param1 is Cw17_Fly3x && param2 is ChongWu && param2.who is Player)
         {
            _loc4_ = param3 * 0.008;
            (param2.who as Player).HpUp(_loc4_);
         }
      }
      
      public static function getEnemyNum(param1:String) : int
      {
         var _loc2_:int = 0;
         for(i in All)
         {
            if(All[i].className == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      private function addSkin(param1:String) : *
      {
         var _loc2_:Class = EnemyArr[关卡].getClass(param1) as Class;
         this.skin = new _loc2_();
         addChild(skin);
         skin.id = id;
         set_attack_Time();
         addChild(lifeMC);
         lifeMC.stop();
         lifeMC.y = -this.skin.height;
         setMode();
      }
      
      private function setMode() : *
      {
         if(id == 2014)
         {
            changeMode = false;
         }
         if(className == "罗生门" || id == "2013" || id == "2014" || id == "5015" || id == "5016" || id == "5017" || id == "5018" || id == "5019" || id == "5020" || id == "5021" || id == "5022" || id == "2012" || id == "79" || id == "90" || id == "88")
         {
            isFunction = false;
         }
      }
      
      private function SkinData(param1:int) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for(_loc2_ in EnemyXml.怪物)
         {
            _loc3_ = int(EnemyXml.怪物[_loc2_].ID);
            if(_loc3_ == param1)
            {
               this.className = String(EnemyXml.怪物[_loc2_].名称);
               this.lifeMAX.setValue(int(EnemyXml.怪物[_loc2_].HP));
               this.life.setValue(int(EnemyXml.怪物[_loc2_].HP));
               this.walk_power = int(EnemyXml.怪物[_loc2_].移动速度);
               this.jumptemp = int(EnemyXml.怪物[_loc2_].跳跃力);
               this.jump_power = int(EnemyXml.怪物[_loc2_].跳跃力);
               this.jump_time = int(EnemyXml.怪物[_loc2_].跳跃时间);
               this.gravity = int(EnemyXml.怪物[_loc2_].重力);
               this.gravityXX = int(EnemyXml.怪物[_loc2_].重力);
               攻击力.setValue(Number(EnemyXml.怪物[_loc2_].攻击力));
               walk_temp = int(EnemyXml.怪物[_loc2_].移动速度);
               att_temp = Number(EnemyXml.怪物[_loc2_].攻击力);
               防御力.setValue(int(EnemyXml.怪物[_loc2_].防御力));
               魔攻力.setValue(int(EnemyXml.怪物[_loc2_].魔攻力));
               魔防力.setValue(int(EnemyXml.怪物[_loc2_].魔防力));
               震退值.setValue(Number(EnemyXml.怪物[_loc2_].震退值));
               经验.setValue(int(EnemyXml.怪物[_loc2_].经验));
               等级.setValue(int(EnemyXml.怪物[_loc2_].等级));
               lastTime = int(EnemyXml.怪物[_loc2_].存在时间);
               金钱.setValue(int(EnemyXml.怪物[_loc2_].金钱));
               掉落数量.setValue(int(EnemyXml.怪物[_loc2_].掉落数量));
               硬直.setValue(Number(EnemyXml.怪物[_loc2_].硬直));
               关卡 = int(EnemyXml.怪物[_loc2_].关卡);
               _loc4_ = int(EnemyXml.怪物[_loc2_].警戒距离x);
               _loc5_ = _loc4_ - Math.random() * 51;
               if(_loc5_ < 0)
               {
                  _loc5_ = 0;
               }
               guard_XY = [_loc5_,int(EnemyXml.怪物[_loc2_].警戒距离y)];
               _loc6_ = 0;
               while(_loc6_ < 6)
               {
                  if(int(EnemyXml.怪物[_loc2_]["攻击距离" + (_loc6_ + 1) + "x"]) != -1)
                  {
                     attack_XY[_loc6_] = [int(EnemyXml.怪物[_loc2_]["攻击距离" + (_loc6_ + 1) + "x"]),int(EnemyXml.怪物[_loc2_]["攻击距离" + (_loc6_ + 1) + "y"])];
                  }
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < 20)
               {
                  掉落物品[_loc6_] = int(EnemyXml.怪物[_loc2_]["掉落物品" + (_loc6_ + 1)]);
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < 20)
               {
                  掉落概率[_loc6_] = int(EnemyXml.怪物[_loc2_]["掉落概率" + (_loc6_ + 1)]);
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < 3)
               {
                  特殊掉落物品[_loc6_] = int(EnemyXml.怪物[_loc2_]["特殊掉落ID" + (_loc6_ + 1)]);
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < 3)
               {
                  特殊掉落概率[_loc6_] = int(EnemyXml.怪物[_loc2_]["特殊概率ID" + (_loc6_ + 1)]);
                  _loc6_++;
               }
               return String(EnemyXml.怪物[_loc2_].名称);
            }
         }
         return null;
      }
      
      public function getRandom(param1:Number) : Boolean
      {
         var _loc2_:Number = Math.random() * 100;
         if(_loc2_ < param1)
         {
            return true;
         }
         return false;
      }
      
      public function HpXX(param1:HitXX, param2:Boolean = false, param3:Boolean = false) : *
      {
         var _loc6_:Player = null;
         var _loc7_:int = 0;
         var _loc14_:Player = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:HitXX = null;
         var _loc21_:Number = NaN;
         var _loc22_:Array = null;
         var _loc23_:String = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Player = null;
         var _loc30_:HitXX = null;
         var _loc31_:Class = null;
         var _loc32_:* = undefined;
         var _loc33_:int = 0;
         var _loc34_:Class = null;
         var _loc35_:int = 0;
         var _loc36_:Class = null;
         var _loc37_:Class = null;
         var _loc38_:Class = null;
         var _loc39_:Class = null;
         var _loc40_:SkillDarkBoom = null;
         var _loc41_:int = 0;
         var _loc42_:Player = null;
         var _loc43_:int = 0;
         hitXX = param1;
         var _loc4_:int = param1.times;
         var _loc5_:Number = 1;
         var _loc8_:int = this.x + Math.random() * 100 - 50;
         var _loc9_:int = this.x + Math.random() * 100 - 50;
         var _loc10_:int = this.y + Math.random() * 100 - 50;
         var _loc11_:int = this.y + Math.random() * 100;
         if(param1.who is Player)
         {
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 4)
            {
               (param1.who as Player).fbChengFa = true;
            }
            _loc14_ = Player(param1.who);
            if(_loc14_.playerJL)
            {
               ++_loc14_.playerJL.ZD1num;
               _loc14_.playerJL.JNnumUP(this.x + Main.world.x,this.y,Play_Interface.interfaceX);
            }
            if(param1.who == Main.player_1)
            {
               ChongWu.gongJiYn1 = true;
            }
            else
            {
               ChongWu.gongJiYn2 = true;
            }
            _loc6_ = param1.who as Player;
            if(_loc6_.data.skinArr[_loc6_.data.skinNum] == 0)
            {
               _loc5_ = Number(_loc6_.职业附加[0]);
            }
            else if(_loc6_.data.skinArr[_loc6_.data.skinNum] == 1)
            {
               _loc5_ = Number(_loc6_.职业附加[1]);
            }
            else if(_loc6_.data.skinArr[_loc6_.data.skinNum] == 2)
            {
               _loc5_ = Number(_loc6_.职业附加[2]);
            }
            _loc15_ = _loc6_.use_gongji.getValue();
            _loc16_ = _loc15_ * param1.gongJi_hp * _loc5_;
            _loc16_ += _loc16_ * Math.random() * InitData.X002.getValue();
            if(_loc4_ == 0)
            {
               _loc4_ = 1;
            }
            _loc7_ = _loc16_ - 防御力.getValue() / _loc4_;
            if(_loc7_ <= 0)
            {
               _loc7_ = 0;
            }
            if(param2)
            {
               _loc7_ *= tempXXX2.getValue();
               if(Math.random() * 100 < _loc6_.data.getElvesSlot().backElvesSkill3())
               {
                  _loc7_ *= 1 + _loc6_.data.getElvesSlot().backElvesSkill3_2();
               }
            }
            if(Math.random() * 100 < 20 && _loc6_.data.getElvesSlot().backElvesSkill6() > 0)
            {
               _loc20_ = new HitXX();
               _loc20_.type = 501;
               _loc20_.space = 27;
               _loc20_.totalTime = 27;
               _loc20_.numValue = int(_loc6_.use_gongji.getValue() * _loc6_.data.getElvesSlot().backElvesSkill6());
               new BuffEnemy(_loc20_,this);
            }
            _loc6_.energySlot.addEnergy(param1.who,_loc7_);
            _loc17_ = _loc6_.data.getEquipSlot().getAllSuitSkill();
            _loc18_ = 0;
            for(_loc19_ in _loc17_)
            {
               if(_loc17_[_loc19_] == 57359)
               {
                  if(getRandom(30) && _loc6_.flagTempSY)
                  {
                     _loc6_.setInTimeCDSY();
                     _loc6_.flagTempSY = false;
                     _loc6_.HpUp(_loc6_.use_hp_Max.getValue() * 0.035);
                     _loc21_ = _loc6_.use_hp_Max.getValue();
                     if(param1.who is Player && Main.water.getValue() != 1)
                     {
                        _loc21_ = _loc21_ * (1 + (param1.who as Player).use_gongji2.getValue() / 100) / (1 + 魔防力.getValue() / 100);
                     }
                     for(_loc19_ in All)
                     {
                        HpSXX(All[_loc19_],_loc21_);
                     }
                  }
               }
               else if(_loc17_[_loc19_] == 57360)
               {
                  if(getRandom(5) && _loc6_.flagTempSJ)
                  {
                     _loc6_.setInTimeCDSJ();
                     _loc6_.flagTempSJ = false;
                     _loc22_ = [];
                     _loc23_ = "";
                     if(_loc6_.data.skinArr[_loc6_.data.skinNum] == 0)
                     {
                        _loc23_ = "a";
                     }
                     else if(_loc6_.data.skinArr[_loc6_.data.skinNum] == 1)
                     {
                        _loc23_ = "b";
                     }
                     else
                     {
                        _loc23_ = "c";
                     }
                     for(_loc24_ in _loc6_.AllSkillCDXX)
                     {
                        if((_loc6_.AllSkillCDXX[_loc24_][0] as String).substr(0,1) == _loc23_ && int((_loc6_.AllSkillCDXX[_loc24_][0] as String).substr(1,2)) > 7 && int((_loc6_.AllSkillCDXX[_loc24_][0] as String).substr(1,2)) <= 15)
                        {
                           if(_loc6_.data.getSkillLevel(_loc6_.AllSkillCDXX[_loc24_][0]) > 0 && _loc6_.AllSkillCDXX[_loc24_][1] != _loc6_.AllSkillCD[_loc24_][1])
                           {
                              _loc22_.push(_loc24_);
                           }
                        }
                     }
                     if(_loc22_.length > 0)
                     {
                        _loc25_ = Math.random() * _loc22_.length;
                        _loc6_.AllSkillCDXX[_loc22_[_loc25_]][1] = _loc6_.AllSkillCD[_loc22_[_loc25_]][1];
                        _loc6_.AllSkillCDXX[_loc22_[_loc25_]][2] = 50;
                     }
                  }
               }
               else if(_loc17_[_loc19_] == 57361)
               {
                  _loc26_ = Math.pow(Number(_loc6_.use_baoji.getValue() / 70),0.8) / 100;
                  _loc27_ = Math.pow(1 + _loc26_,4.7);
                  if(getRandom(1.8) && _loc6_.flagTempBJ && param2)
                  {
                     _loc6_.setInTimeCDBJ();
                     _loc6_.flagTempBJ = false;
                     if(_loc6_.data.skinNum == 0)
                     {
                        _loc18_ = int(_loc6_.data.getEquipSlot().getEquipFromSlot(2).getAttack() * _loc27_);
                     }
                     else
                     {
                        _loc18_ = int(_loc6_.data.getEquipSlot().getEquipFromSlot(5).getAttack() * _loc27_);
                     }
                     if(param1.who is Player && Main.water.getValue() != 1)
                     {
                        _loc18_ = _loc18_ * (1 + (param1.who as Player).use_gongji2.getValue() / 100) / (1 + 魔防力.getValue() / 100);
                     }
                     if(_loc18_ > 650000)
                     {
                        _loc18_ = 650000;
                     }
                     if(_loc18_ > 200000 && GameData.gameLV == 5)
                     {
                        _loc18_ = 200000;
                     }
                     NewMC.Open("_特殊数字",Main.world.moveChild_Other,_loc8_,_loc10_ - 50,20,_loc18_,true);
                  }
                  else if(param2)
                  {
                     _loc28_ = Number(Math.pow(Number((param1.who as Player).use_baoji.getValue() / 70),InitData.Temp8.getValue()).toFixed(1));
                     _loc7_ *= 1 + _loc28_ / InitData.BuyNum_2000.getValue();
                  }
               }
               else if(_loc17_[_loc19_] != 57362)
               {
                  if(_loc17_[_loc19_] == 57363)
                  {
                     if(getRandom(15) && _loc6_.flagTempXL)
                     {
                        _loc6_.setInTimeCDXL();
                        _loc6_.flagTempXL = false;
                        _loc18_ = (_loc6_.use_mp_Max.getValue() + _loc6_.mp.getValue()) * ((_loc6_.use_mp_Max.getValue() + _loc6_.mp.getValue()) / 10000);
                        if(param1.who is Player && Main.water.getValue() != 1)
                        {
                           _loc18_ = _loc18_ * (1 + (param1.who as Player).use_gongji2.getValue() / 100) / (1 + 魔防力.getValue() / 100);
                        }
                        if(_loc18_ > 650000)
                        {
                           _loc18_ = 650000;
                        }
                        if(_loc18_ > 200000 && GameData.gameLV == 5)
                        {
                           _loc18_ = 200000;
                        }
                        NewMC.Open("_特殊数字",Main.world.moveChild_Other,_loc8_,_loc10_ - 50,20,_loc18_,true);
                     }
                  }
               }
            }
         }
         else
         {
            _loc7_ = param1.gongJi_hp;
            if(_loc7_ <= 0)
            {
               _loc7_ = 0;
            }
         }
         if(param1.who is ChongWu)
         {
            _loc29_ = (param1.who as ChongWu).who;
            if((param1.who as ChongWu).data.getPetEquip())
            {
               if((param1.who as ChongWu).data.getPetEquip().getType() == 4)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  _loc20_ = new HitXX();
                  _loc20_.type = 502;
                  _loc20_.space = _loc22_[1];
                  _loc20_.totalTime = _loc22_[2];
                  _loc20_.numValue = _loc29_.use_gongji.getValue() * _loc22_[0];
                  _loc20_.speedValue = _loc22_[4];
                  new BuffEnemy(_loc20_,this);
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 5)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[3])
                  {
                     _loc20_ = new HitXX();
                     _loc20_.type = 503;
                     _loc20_.totalTime = 135;
                     _loc20_.space = _loc20_.totalTime;
                     _loc20_.numValue = _loc29_.use_gongji.getValue() * _loc22_[0];
                     _loc20_.speedValue = _loc22_[4];
                     new BuffEnemy(_loc20_,this);
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 8 && wscd > 135)
               {
                  wscd = 0;
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[1])
                  {
                     _loc20_ = new HitXX();
                     _loc20_.type = 504;
                     _loc20_.space = 16;
                     _loc20_.totalTime = 16;
                     _loc20_.numValue = _loc29_.use_gongji.getValue() * _loc22_[0];
                     new BuffEnemy(_loc20_,this);
                     _loc30_ = new HitXX();
                     _loc30_.type = 504;
                     _loc30_.space = 16;
                     _loc30_.totalTime = 16;
                     _loc30_.numValue = _loc22_[2];
                     new BuffEffect(_loc30_,(param1.who as ChongWu).who);
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 9 && wscd > 80)
               {
                  wscd = 0;
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[1])
                  {
                     _loc20_ = new HitXX();
                     _loc20_.type = 505;
                     _loc20_.totalTime = _loc22_[0];
                     new BuffEnemy(_loc20_,this);
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 10 && wscd > 405)
               {
                  wscd = 0;
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[0])
                  {
                     ++addTimes;
                     if(addTimes >= 5)
                     {
                        addTimes = 0;
                        (param1.who as ChongWu).who.HpUp(_loc22_[1],2);
                     }
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 11 && wscd > 135)
               {
                  wscd = 0;
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[1])
                  {
                     _loc20_ = new HitXX();
                     _loc20_.type = 506;
                     wscd = 0;
                     _loc20_.totalTime = _loc22_[0];
                     new BuffEnemy(_loc20_,this);
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 12 && GameData.gameLV == 5)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  _loc20_ = new HitXX();
                  _loc20_.type = 501;
                  _loc20_.space = _loc22_[0];
                  _loc20_.totalTime = _loc22_[1];
                  _loc20_.numValue = int(this.lifeMAX.getValue() * 0.01);
                  new BuffEnemy(_loc20_,this);
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 13 && GameData.gameLV == 5)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  param1.gongJi_hp = param1.gongJi_Ctr * _loc22_[0];
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 2 && GameData.gameLV == 5 && wscd > 135)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[0])
                  {
                     wscd = 0;
                     if(this.life.getValue() <= this.lifeMAX.getValue() * _loc22_[1])
                     {
                        this.life.setValue(0);
                     }
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 3)
               {
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc22_[1])
                  {
                     _loc20_ = new HitXX();
                     _loc20_.type = 507;
                     _loc20_.totalTime = 135;
                     _loc20_.space = _loc20_.totalTime;
                     _loc20_.numValue = _loc22_[2];
                     new BuffEnemy(_loc20_,this);
                  }
               }
               if((param1.who as ChongWu).data.getPetEquip().getType() == 1 && wscd > 80)
               {
                  wscd = 0;
                  _loc22_ = (param1.who as ChongWu).data.getPetEquip().getAffect();
                  rdom = Math.round(Math.random() * 100);
                  if(rdom <= _loc22_[1])
                  {
                     _loc19_ = 0;
                     while(_loc19_ < _loc22_[0])
                     {
                        if(Enemy.All[_loc19_])
                        {
                           _loc31_ = NewLoad.XiaoGuoData.getClass("蛇冠") as Class;
                           _loc32_ = int(param1.gongJi_hp * 2);
                           _loc33_ = Enemy.All[_loc19_].life.getValue() - _loc32_;
                           Enemy.All[_loc19_].hpCount(_loc32_);
                           Enemy.All[_loc19_].skin.addChild(new _loc31_());
                           HPdown.Open(_loc32_,Enemy.All[_loc19_].x,Enemy.All[_loc19_].y - Enemy.All[_loc19_].height);
                        }
                        _loc19_++;
                     }
                  }
               }
            }
            _loc7_ = param1.gongJi_hp;
         }
         if(param1.who is Player && Main.water.getValue() != 1)
         {
            _loc7_ = _loc7_ * (1 + (param1.who as Player).use_gongji2.getValue() / 100) / (1 + 魔防力.getValue() / 100);
         }
         if(GameData.gameLV == 5 && _loc7_ > param1.gongJi_hp_MAX)
         {
            _loc7_ = param1.gongJi_hp_MAX;
         }
         if(Main.tiaoShiYN)
         {
            _loc7_ += gongJiPOWER.getValue();
         }
         if(Boolean(NewPetPanel.XueMai) && (Boolean(Main.player_1.playerCW) || Boolean(Main.P1P2 && Main.player_2.playerCW)))
         {
            if(NewPetPanel.XueMai.isHaveSX(3))
            {
               _loc7_ *= 1.05;
            }
         }
         if(param1.who is Player)
         {
            _loc7_ *= (param1.who as Player).gongji_UP;
         }
         hit_x = this.x;
         hit_y = this.y;
         if(param1.who is Player)
         {
            if(Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6)) && Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getFrame() == 372) && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
            {
               if(Math.random() * 100 < 5 && Player.szCD > 54)
               {
                  Player.szCD = 0;
                  _loc34_ = NewLoad.XiaoGuoData.getClass("时装陨石") as Class;
                  (param1.who as Player).skin_W.addChild(new _loc34_());
               }
            }
            if(Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6)) && Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getFrame() == 377) && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
            {
               _loc35_ = 0;
               _loc19_ = 0;
               while(_loc19_ < Fly.All.length)
               {
                  if(Fly.All[_loc19_]._name == "时装龙卷风")
                  {
                     _loc35_++;
                  }
                  _loc19_++;
               }
               if(Math.random() * 100 < 5 && _loc35_ < 3 && Player.szCD > 54)
               {
                  Player.szCD = 0;
                  _loc36_ = NewLoad.XiaoGuoData.getClass("时装龙卷风") as Class;
                  (param1.who as Player).skin_W.addChild(new _loc36_());
               }
            }
            if((param1.who as Player).data.skinNum == 0 && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(2).getHuanHua() == 1 || (param1.who as Player).data.skinNum == 1 && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(5).getHuanHua() == 1)
            {
               if(Math.random() * 100 < 10)
               {
                  _loc37_ = NewLoad.OtherData.getClass("zhuoshang") as Class;
                  this.skin.addChild(new _loc37_());
                  HpXX2((param1.who as Player).use_gongji.getValue() * 0.5);
                  ++zhuoshaoTimes;
               }
               if(zhuoshaoTimes >= 10)
               {
                  _loc38_ = NewLoad.OtherData.getClass("huolong") as Class;
                  (param1.who as Player).skin_W.addChild(new _loc38_());
                  zhuoshaoTimes = 0;
               }
            }
            if((param1.who as Player).data.skinNum == 0 && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(2).getHuanHua() == 3 || (param1.who as Player).data.skinNum == 1 && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(5).getHuanHua() == 3)
            {
               if(Math.random() * 100 < 20 && Player.szCD > 54)
               {
                  Player.szCD = 0;
                  _loc39_ = NewLoad.XiaoGuoData.getClass("幻化黑暗爆炸") as Class;
                  _loc40_ = new _loc39_();
                  (param1.who as Player).skin_W.addChild(_loc40_);
               }
            }
            if(Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6)) && Boolean((param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getFrame() == 404) && (param1.who as Player).data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
            {
               if(Player.szCD > 71 && (param1.who as Player).isDarkState == false)
               {
                  Player.szCD = 0;
                  if(Math.random() * 100 < 20)
                  {
                     (param1.who as Player).darkTime = 0;
                     (param1.who as Player).isDarkState = true;
                  }
               }
            }
         }
         if(Main.gameNum.getValue() == 57)
         {
            for(_loc19_ in Enemy.All)
            {
               if((Enemy.All[_loc19_] as Enemy).id == 79 && this.id != 79)
               {
                  if(Math.abs(Enemy.All[_loc19_].x - this.x) < 350)
                  {
                     _loc7_ *= 0.1;
                  }
               }
            }
         }
         if(this.className == "阿卡利" || this.className == "阿卡利召唤")
         {
            _loc41_ = Math.random() * 100;
            if(_loc41_ < 3)
            {
               skin.otherGoTo("攻击5");
               return;
            }
         }
         if(this.className == "悬赏8")
         {
            _loc41_ = Math.random() * 100;
            if(_loc41_ < 3)
            {
               skin.otherGoTo("攻击1");
               return;
            }
         }
         if(this.id == 9001)
         {
            if(param1.who is Player)
            {
               if((param1.who as Player).skin.currentLabel != "攻击1" && (param1.who as Player).skin.currentLabel != "攻击2" && (param1.who as Player).skin.currentLabel != "攻击3" && (param1.who as Player).skin.currentLabel != "攻击4" && param1.parent._name != "法师魔法弹")
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"请按J普通攻击");
                  return;
               }
            }
         }
         if(this.id == 9002)
         {
            if(param1.who is Player)
            {
               if((param1.who as Player).skin.currentLabel != "上挑")
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"请按W+J特殊攻击");
                  return;
               }
            }
         }
         if(this.id == 9003)
         {
            if(param1.who is Player)
            {
               if((param1.who as Player).skin.currentLabel != "下斩")
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"请按S+J特殊攻击");
                  return;
               }
            }
         }
         if(this.id == 9004)
         {
            if(param1.who is Player)
            {
               if((param1.who as Player).skin.currentLabel != "技能1")
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"请按H施放技能");
                  return;
               }
            }
         }
         if(this.id == 2015)
         {
            _loc7_ = Math.ceil(Math.random() * 2);
            _loc18_ = Math.ceil(Math.random() * 2);
         }
         if(param1.who is Player && param1.who.hpXX2num != 0)
         {
            if(this.id == 2015)
            {
               _loc7_ = Math.ceil(Math.random() * 2);
               _loc18_ = Math.ceil(Math.random() * 2);
               NewMC.Open("_暴击数字",Main.world.moveChild_Other,_loc8_,_loc10_,20,_loc7_,true);
            }
            else
            {
               _loc7_ = int(param1.who.hpXX2num);
               NewMC.Open("_暴击数字",Main.world.moveChild_Other,_loc8_,_loc10_,20,_loc7_,true);
            }
         }
         else if(param2)
         {
            if(this.id == 31)
            {
               NewMC.Open("_暴击数字",Main.world.moveChild_Other,_loc8_,_loc10_ - 200,20,_loc7_,true);
            }
            else if(this.id != 5003)
            {
               NewMC.Open("_暴击数字",Main.world.moveChild_Other,_loc8_,_loc10_,20,_loc7_,true);
            }
         }
         else if(this.id == 31)
         {
            NewMC.Open("_攻击数字",Main.world.moveChild_Other,_loc8_,_loc10_ - 200,15,_loc7_,true);
         }
         else if(this.id != 5003)
         {
            NewMC.Open("_攻击数字",Main.world.moveChild_Other,_loc8_,_loc10_,15,_loc7_,true);
         }
         if(param1.who is Player)
         {
            _loc42_ = Player(param1.who);
            if(_loc42_.playerJL)
            {
               _loc42_.playerJL.BD1001(_loc7_);
            }
         }
         if(_loc7_ > 0 && life.getValue() > 0)
         {
            this.life.setValue(life.getValue() - _loc7_);
            hpNUMXXX(_loc7_);
            hpNUMXXX2(param1.parent,param1.who,_loc7_);
            this.life.setValue(life.getValue() - _loc18_);
            hpNUMXXX(_loc18_);
            hpNUMXXX2(param1.parent,param1.who,_loc18_);
            WinShow.txt_4 += _loc7_;
            _loc43_ = 100 - life.getValue() / lifeMAX.getValue() * 100;
            lifeMC.gotoAndStop(_loc43_);
            if(this.life.getValue() < lifeMAX.getValue() / 2)
            {
               if(Boolean(JingLingCatch.only) && GameData.BOSSid.getValue() == this.id)
               {
                  JingLingCatch.addSkin();
                  JingLingCatch.only = false;
               }
            }
            if(this.life.getValue() <= 0)
            {
               if(rebornTimes > 0)
               {
                  reborn();
                  return;
               }
               life.setValue(0);
               if(this.金钱.getValue() > 0)
               {
                  NewMC.Open("掉钱",Main.world.moveChild_Other,_loc9_,_loc11_,15,this.金钱.getValue(),true);
               }
               if(Boolean(_loc6_) && _loc6_.data.getElvesSlot().backElvesSkill2() > 0)
               {
                  _loc6_.HpUp(_loc6_.data.getElvesSlot().backElvesSkill2(),2);
               }
               Main.player_1.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
               Main.player_1.MoneyUP(this.金钱.getValue());
               if(Main.P1P2)
               {
                  Main.player_2.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
                  Main.player_2.MoneyUP(this.金钱.getValue());
               }
               任务品掉落();
               装备掉落();
               PaiHang_Data.EnemyOver();
               AchData.addEnemyNum(id);
               TaskData.setEnemyNum(id);
               TaskData.isEnemyTaskOk();
               newYearDiaoLuo();
               CardPanel.monsterSlot.addMonsterCard(id);
               return;
            }
         }
         var _loc12_:Number = Math.random() * temp3.getValue() / temp10.getValue();
         浮动硬直 += _loc12_;
         var _loc13_:Number = param1.硬直 - skin.被攻击硬直 - 浮动硬直;
         if(_loc13_ >= skin.continuousTime)
         {
            _loc13_ = param1.硬直 - this.硬直.getValue() - 浮动硬直;
         }
         if(_loc13_ >= 0)
         {
            skin.GoTo("被打",int(_loc13_));
            jump_power = 0;
         }
         if(震退值.getValue() != 0)
         {
            runArr = new Array();
            if(param1.RL)
            {
               runPower(-param1.runArr[0] * 震退值.getValue(),param1.runArr[1] * 震退值.getValue(),param1.runArr[2]);
            }
            else
            {
               runPower(param1.runArr[0] * 震退值.getValue(),param1.runArr[1] * 震退值.getValue(),param1.runArr[2]);
            }
         }
      }
      
      public function HpXX2(param1:int) : *
      {
         var _loc2_:int = 0;
         if(this.id == 2015)
         {
            param1 = Math.ceil(Math.random() * 2);
         }
         if(param1 > 0 && life.getValue() > 0)
         {
            this.life.setValue(life.getValue() - param1);
            NewMC.Open("_攻击数字",Main.world.moveChild_Other,this.x,this.y,15,param1,true);
            WinShow.txt_4 += param1;
            _loc2_ = 100 - life.getValue() / lifeMAX.getValue() * 100;
            lifeMC.gotoAndStop(_loc2_);
            if(this.life.getValue() <= 0)
            {
               if(rebornTimes > 0)
               {
                  reborn();
                  return;
               }
               life.setValue(0);
               Main.player_1.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
               Main.player_1.MoneyUP(this.金钱.getValue());
               if(Main.P1P2)
               {
                  Main.player_2.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
                  Main.player_2.MoneyUP(this.金钱.getValue());
               }
               任务品掉落();
               装备掉落();
               PaiHang_Data.EnemyOver();
               AchData.addEnemyNum(id);
               TaskData.setEnemyNum(id);
               TaskData.isEnemyTaskOk();
               CardPanel.monsterSlot.addMonsterCard(id);
            }
         }
      }
      
      public function reborn() : *
      {
         --rebornTimes;
         hpUpEnemy(lifeMAX.getValue());
         var _loc1_:int = 100 - life.getValue() / lifeMAX.getValue() * 100;
         lifeMC.gotoAndStop(_loc1_);
         if(this.id == 3022)
         {
            skin.runOver = true;
            skin.GoTo("攻击3");
         }
      }
      
      public function hpUpEnemy(param1:int) : *
      {
         life.setValue(life.getValue() + param1);
         NewMC.Open("回血效果",this,0,0,0,param1);
      }
      
      public function hpCount(param1:int) : *
      {
         var _loc2_:int = 0;
         if(this.id == 2015)
         {
            param1 = Math.ceil(Math.random() * 2);
         }
         if(param1 > 0 && life.getValue() > 0)
         {
            this.life.setValue(life.getValue() - param1);
            hpNUMXXX(param1);
            _loc2_ = 100 - life.getValue() / lifeMAX.getValue() * 100;
            lifeMC.gotoAndStop(_loc2_);
            if(this.life.getValue() <= 0)
            {
               if(rebornTimes > 0)
               {
                  reborn();
                  return;
               }
               life.setValue(0);
               Main.player_1.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
               Main.player_1.MoneyUP(this.金钱.getValue());
               if(Main.P1P2)
               {
                  Main.player_2.ExpUP(this.经验.getValue() * InitData.GetEXPxN().getValue());
                  Main.player_2.MoneyUP(this.金钱.getValue());
               }
               任务品掉落();
               装备掉落();
               PaiHang_Data.EnemyOver();
               AchData.addEnemyNum(id);
               TaskData.setEnemyNum(id);
               TaskData.isEnemyTaskOk();
               newYearDiaoLuo();
               CardPanel.monsterSlot.addMonsterCard(id);
            }
         }
      }
      
      private function HpSXX(param1:Enemy, param2:Number) : *
      {
         var _loc5_:int = 0;
         if(this.id == 2015)
         {
            param2 = Math.ceil(Math.random() * 2);
         }
         if(param2 > 650000)
         {
            param2 = 650000;
         }
         if(param2 > 80000 && GameData.gameLV == 5)
         {
            param2 = 80000;
         }
         var _loc3_:int = param1.x + Math.random() * 100 - 50;
         var _loc4_:int = param1.y + Math.random() * 100 - 50;
         NewMC.Open("_特殊数字",Main.world.moveChild_Other,_loc3_,_loc4_ - 50,20,param2,true);
         if(param2 > 0 && param1.life.getValue() > 0)
         {
            param1.life.setValue(param1.life.getValue() - param2);
            hpNUMXXX(param2);
            _loc5_ = 100 - param1.life.getValue() / param1.lifeMAX.getValue() * 100;
            param1.lifeMC.gotoAndStop(_loc5_);
            if(param1.life.getValue() <= 0)
            {
               param1.life.setValue(0);
               NewMC.Open("掉钱",Main.world.moveChild_Other,_loc3_,_loc4_,15,this.金钱.getValue(),true);
               Main.player_1.ExpUP(param1.经验.getValue() * InitData.GetEXPxN().getValue());
               Main.player_1.MoneyUP(param1.金钱.getValue());
               if(Main.P1P2)
               {
                  Main.player_2.ExpUP(param1.经验.getValue() * InitData.GetEXPxN().getValue());
                  Main.player_2.MoneyUP(param1.金钱.getValue());
               }
               param1.任务品掉落();
               param1.装备掉落();
               AchData.addEnemyNum(param1.id);
               TaskData.setEnemyNum(param1.id);
               TaskData.isEnemyTaskOk();
            }
         }
      }
      
      private function shengdandiaoluo(param1:int) : *
      {
         var _loc2_:int = Math.random() * 100;
         var _loc3_:int = 0;
         while(_loc3_ < InitData.shengdanArr.length)
         {
            if(InitData.shengdanArr[_loc3_][0] == param1)
            {
               if(InitData.shengdanArr[_loc3_][1] > _loc2_)
               {
                  Main.addShengDan();
               }
            }
            _loc3_++;
         }
      }
      
      private function newYearDiaoLuo() : *
      {
         if(Boolean(GameData.BossIS) && this == GameData.BossIS)
         {
            if(this.id == 2015)
            {
               if(Math.random() * 100 < 10)
               {
                  NewYear_Interface.addKey();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得宝箱钥匙！");
                  return;
               }
            }
            if(this.id == 29 || this.id == 38 || this.id == 102 || this.id == 104 || this.id == 105 || this.id == 107 || this.id == 2015 || this.id == 108)
            {
               return;
            }
            if(Main.gameNum.getValue() >= 17 && Main.gameNum.getValue() <= 27)
            {
               return;
            }
            if(Main.gameNum.getValue() >= 81 && Main.gameNum.getValue() <= 84)
            {
               return;
            }
            if(Main.gameNum.getValue() == 1000)
            {
               return;
            }
            if(Math.random() * 100 < 15)
            {
               NewYear_Interface.addJuan();
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得年兽大作战邀请函！");
            }
         }
      }
      
      private function 装备掉落() : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:Array = null;
         var _loc9_:Equip = null;
         var _loc10_:obj = null;
         var _loc11_:Gem = null;
         var _loc12_:PetEquip = null;
         var _loc13_:String = null;
         var _loc14_:Otherobj = null;
         if(ChunJiePanel.saveArr2[2] < 35)
         {
            if(Main.serverTime.getValue() < 20140206 && Main.serverTime.getValue() > 20140129)
            {
               for(_loc3_ in cj_arr)
               {
                  if(cj_arr[_loc3_][0] == this.id)
                  {
                     if(Math.random() * 10000 < cj_arr[_loc3_][1])
                     {
                        ChunJiePanel.addShaGuaiJiFen();
                        NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜获得 魔法马刷");
                     }
                  }
               }
            }
         }
         var _loc1_:uint = 掉落数量.getValue() * InitData.GetDOWNxN().getValue();
         var _loc2_:int = 0;
         while(_loc2_ < Main.player1.getTitleSlot().getListLength())
         {
            if(Main.player1.getTitleSlot().getTitleFromSlot(_loc2_).getId() == 25)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         if(this.className == "悬赏7" && Main.wts.getBoss() >= 222)
         {
            if(getEnemyNum("阿卡利") > 0 || getEnemyNum("阿卡利召唤") > 0)
            {
               return;
            }
         }
         if((this.className == "阿卡利" || this.className == "阿卡利召唤") && Main.wts.getBoss() >= 222)
         {
            if(getEnemyNum("悬赏7") > 0)
            {
               return;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = int(掉落物品计算());
            _loc5_ = int(String(_loc4_).substr(1,1));
            _loc6_ = int(String(_loc4_).substr(0,1));
            _loc7_ = this.x + Math.random() * 200 - 100;
            if(this.id == "5015")
            {
               _loc7_ -= 300;
            }
            _loc7_ = ObjWhere(_loc7_);
            if(_loc4_ != 0)
            {
               if(_loc5_ == 1)
               {
                  _loc8_ = [_loc4_];
                  _loc9_ = EquipFactory.createEquipByColorAndLevel(_loc8_);
                  _loc10_ = new obj(_loc9_,_loc7_,this.y - 100);
               }
               else if(_loc5_ == 2)
               {
                  _loc8_ = [_loc4_];
                  _loc11_ = GemFactory.createGemByColorAndLevel(_loc8_);
                  _loc10_ = new obj(_loc11_,_loc7_,this.y - 100);
               }
               else if(_loc5_ == 7)
               {
                  _loc12_ = PetEquip.creatPetEquip(_loc4_);
                  NewPetPanel.bag.addPetBag(_loc12_);
                  _loc13_ = "获得:" + PetEquip.creatPetEquip(_loc4_).getName();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,_loc13_);
               }
               if(_loc6_ == 6)
               {
                  _loc14_ = OtherFactory.creatOther(_loc4_);
                  _loc10_ = new obj(_loc14_,_loc7_,this.y - 100);
               }
            }
            _loc3_++;
         }
      }
      
      private function ObjWhere(param1:int) : int
      {
         var _loc2_:int = Math.random() * 100;
         if(param1 < 0)
         {
            return int(param1 + _loc2_);
         }
         if(param1 > Main.world._width)
         {
            return int(Main.world._width - _loc2_);
         }
         return param1;
      }
      
      private function 掉落物品计算() : int
      {
         var _loc1_:int = Math.random() * 10000 + 1;
         var _loc2_:int = 0;
         j = 0;
         while(j < 20)
         {
            _loc2_ += 掉落概率[j];
            if(_loc2_ >= _loc1_)
            {
               return 掉落物品[j];
            }
            ++j;
         }
         return 0;
      }
      
      private function onADDED_TO_STAGE(param1:*) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         Main.world.moveChild_Enemy.addChild(this);
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         addEventListener(Event.REMOVED_FROM_STAGE,onREMOVED_FROM_STAGE);
      }
      
      private function onREMOVED_FROM_STAGE(param1:*) : *
      {
         if(this.skin)
         {
            this.skin.Over();
         }
         removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      public function Dead() : *
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
            this.life.setValue(0);
         }
         if(FanPaiPanel.saveArr2[2] < 500)
         {
            if(id == 100 || id == 10 || id == 103 || id == 37 || id == 51 || id == 52 || id == 36 || id == 219 || id == 220 || id == 221 || id == 5005 || id == 5006)
            {
               return;
            }
            ++FanPaiPanel.saveArr2[2];
            ++FanPaiPanel.saveArr2[3];
         }
         removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         ++wscd;
         if(lastTime > -1)
         {
            --lastTime;
            if(lastTime == 0)
            {
               this.life.setValue(0);
               removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
            }
         }
         if(life.getValue() > 0)
         {
            if(isIce == true && life.getValue() > 0)
            {
               iceHPXX();
            }
            MoveData();
            if(!noMove)
            {
               MoveRun();
            }
         }
         else
         {
            if(skin)
            {
               skin.GoTo("死亡");
            }
            removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         }
      }
      
      private function iceHPXX() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(Boolean(Main.player1.getEquipSlot().getEquipFromSlot(7) && Main.player1.getEquipSlot().getEquipFromSlot(7).getFrame() == 385) && Boolean(Main.player1.getEquipSlot().getEquipFromSlot(7).getRemainingTime() > 0) || Boolean(Main.P1P2) && (Boolean(Main.player2.getEquipSlot().getEquipFromSlot(7) && Main.player2.getEquipSlot().getEquipFromSlot(7).getFrame() == 385 && Main.player2.getEquipSlot().getEquipFromSlot(7).getRemainingTime() > 0)))
         {
            ++iceTime;
            if(iceTime == 27)
            {
               _loc1_ = int(Main.player_1.use_gongji.getValue() * Math.pow(Main.player1.getLevel(),0.2));
               _loc2_ = life.getValue() - _loc1_;
               if(GameData.gameLV == 5)
               {
                  if(_loc1_ > 16200)
                  {
                     _loc1_ = 16200;
                  }
               }
               hpCount(_loc1_);
               HPdown.Open(_loc1_,this.x,this.y - this.height);
               iceTime = 0;
            }
         }
      }
      
      internal function test() : *
      {
         if(Main.player_1.skin.runType == "技能1" || Main.player_1.skin.runType == "技能2" || Main.player_1.skin.runType == "技能3" || Main.player_1.skin.runType == "技能4" || Main.player_1.skin.runType == "转职技能1" || Main.player_1.skin.runType == "转职技能2" || Main.player_1.skin.runType == "转职技能3" || Main.player_1.skin.runType == "转职技能4")
         {
            temp = Main.player_1.skin.runType;
            if(temp != tempXX && tempTimeXX > 5)
            {
               tempXX = temp;
               tempTimeXX = 0;
               skin.GoTo("攻击5");
            }
            return;
         }
      }
      
      private function MoveData() : *
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         WhereAreYou();
         Attack_TimeXX();
         var _loc1_:* = Math.abs(distance_X);
         var _loc2_:* = Math.abs(distance_Y);
         if(skin.runType == "站立" || skin.runType == "移动" || skin.runType == "跳")
         {
            _loc4_ = Math.random() * attack_XY.length;
            _loc5_ = "攻击" + (_loc4_ + 1);
            if(skin.continuousTime <= 0)
            {
               jump_power = jumptemp;
               if(attack_Time[_loc4_] == attack_TimeNum[_loc4_] && _loc1_ < attack_XY[_loc4_][0] && _loc2_ < attack_XY[_loc4_][1])
               {
                  if(distance_X > 0)
                  {
                     getRL(false);
                  }
                  else
                  {
                     getRL(true);
                  }
                  attack_TimeNum[_loc4_] = 0;
                  if(this.className == "金牛座")
                  {
                     if(_loc4_ == 4 && bool_5)
                     {
                        skin.GoTo(_loc5_);
                        bool_6 = false;
                        bool_5 = false;
                     }
                     else if(_loc4_ == 5 && bool_6)
                     {
                        skin.GoTo(_loc5_);
                        bool_5 = false;
                        bool_6 = false;
                     }
                     else if(_loc4_ < 4)
                     {
                        skin.GoTo(_loc5_);
                     }
                  }
                  else if(this.className == "BOSS_54")
                  {
                     if(_loc4_ == 3)
                     {
                        return;
                     }
                     if(boss54 < 5 && _loc4_ == 5)
                     {
                        return;
                     }
                     if(boss54 == 5)
                     {
                        skin.GoTo("攻击6");
                        ++boss54;
                     }
                     else if(boss54 > 5)
                     {
                        if(Math.random() * 10 > 5)
                        {
                           skin.GoTo("攻击3");
                        }
                        else
                        {
                           skin.GoTo("攻击5");
                        }
                     }
                     else
                     {
                        skin.GoTo(_loc5_);
                     }
                  }
                  else if(this.className == "天秤座")
                  {
                     if(_loc4_ == 0 || _loc4_ == 1)
                     {
                        _loc3_ = 0;
                        while(_loc3_ < Fly.All.length)
                        {
                           if((Fly.All[_loc3_] as Fly)._name == "火焰之路" || (Fly.All[_loc3_] as Fly)._name == "寒冰之路")
                           {
                              return;
                           }
                           _loc3_++;
                        }
                     }
                     skin.GoTo(_loc5_);
                  }
                  else if(this.id == 3022)
                  {
                     if(_loc4_ == 2)
                     {
                        return;
                     }
                     skin.GoTo(_loc5_);
                  }
                  else if(this.className == "悬赏7")
                  {
                     if(_loc4_ == 0)
                     {
                        for(_loc3_ in Enemy.All)
                        {
                           if((Enemy.All[_loc3_] as Enemy).className == "阿卡利" || (Enemy.All[_loc3_] as Enemy).className == "阿卡利召唤")
                           {
                              return;
                           }
                        }
                     }
                     if(_loc4_ == 2)
                     {
                        for(_loc3_ in Enemy.All)
                        {
                           if((Enemy.All[_loc3_] as Enemy).className == "罗生门")
                           {
                              return;
                           }
                        }
                     }
                     skin.GoTo(_loc5_);
                  }
                  else
                  {
                     if(this.className == "BOSS_53")
                     {
                        ++tempTimeXX;
                        test();
                        if(_loc4_ == 4)
                        {
                           return;
                        }
                     }
                     if(this.className == "悬赏5")
                     {
                        if(_loc4_ == 3 && xuanshang5 == false || _loc4_ == 4 && xuanshang5 == false)
                        {
                           return;
                        }
                        if(_loc4_ == 3 && xuanshang5 == true)
                        {
                           xuanshang5 = false;
                        }
                        if(_loc4_ == 4 && xuanshang5 == true)
                        {
                           xuanshang5 = false;
                        }
                     }
                     skin.GoTo(_loc5_);
                  }
                  this.浮动硬直 = 0;
               }
               else
               {
                  if(this.className == "火鸟王" || this.id == 5005 || this.id == 5006 || this.id == 5014 || this.id == 95)
                  {
                     this.skin.GoTo("移动");
                     return;
                  }
                  if(_loc1_ < 50 && _loc2_ < 500)
                  {
                     this.skin.GoTo("站立");
                  }
                  else if(distance_X > guard_XY[0])
                  {
                     runPower(this.walk_power,0,1);
                     getRL(false);
                     skin.GoTo("移动");
                  }
                  else if(distance_X < -guard_XY[0])
                  {
                     runPower(-this.walk_power,0,1);
                     getRL(true);
                     skin.GoTo("移动");
                  }
                  else
                  {
                     this.skin.GoTo("站立");
                  }
               }
            }
            _loc6_ = Math.random() * 60;
            if(_loc6_ == 0 && !jumping)
            {
               if(RL)
               {
                  runPower(-walk_power * 0.8,jump_power,jump_time);
               }
               else
               {
                  runPower(walk_power * 0.8,jump_power,jump_time);
               }
            }
         }
         runX = runY = 0;
         _loc3_ = int(runArr.length - 1);
         while(_loc3_ >= 0)
         {
            if(runArr[_loc3_][2] > 0)
            {
               runX += runArr[_loc3_][0] + runArr[_loc3_][3] * runArr[_loc3_][2];
               runY -= runArr[_loc3_][1] + runArr[_loc3_][4] * runArr[_loc3_][2];
               --runArr[_loc3_][2];
            }
            else
            {
               runArr.splice(_loc3_,1);
            }
            _loc3_--;
         }
         if(runY < 0)
         {
            jumpType = 1;
            gravityNum = 0;
            jumping = true;
         }
         else
         {
            jumpType = 2;
            if(gravity != 0)
            {
               gravityNum += 1;
            }
            runY += gravity * gravityNum;
         }
      }
      
      private function WhereAreYou() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         if(Player.All.length > 0)
         {
            distance_X = this.x - Player.All[0].x;
            distance_Y = this.y - Player.All[0].y;
            _loc1_ = 1;
            while(_loc1_ < Player.All.length)
            {
               _loc2_ = this.x - Player.All[_loc1_].x;
               if(Math.abs(_loc2_) < Math.abs(distance_X))
               {
                  distance_X = _loc2_;
                  distance_Y = this.y - Player.All[_loc1_].y;
               }
               _loc1_++;
            }
         }
         else
         {
            distance_X = 0;
         }
      }
      
      private function MoveRun() : *
      {
         var _loc1_:Boolean = false;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:* = undefined;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         if(runX > 0)
         {
            _loc1_ = true;
         }
         var _loc2_:int = int(this.runX);
         var _loc3_:int = int(this.runY);
         var _loc4_:* = int(this.x + Main.world.x);
         var _loc5_:* = int(this.y);
         _loc6_ = int(Math.abs(_loc3_));
         while(_loc6_ > 0)
         {
            if(this.jumpType == 1)
            {
               _loc9_ = Boolean(Main.world.MapData1.hitTestPoint(_loc4_,_loc5_ - this.height,true));
               if(!_loc9_)
               {
                  _loc10_ = 0;
                  while(_loc10_ < Main.world.numChildren)
                  {
                     _loc11_ = Main.world.getChildAt(_loc10_);
                     if(_loc11_ is Map && Boolean(_loc11_.MapData1.hitTestPoint(_loc4_,_loc5_ - this.height,true)))
                     {
                        _loc9_ = true;
                        break;
                     }
                     _loc10_++;
                  }
               }
               if(!_loc9_)
               {
                  _loc5_--;
               }
            }
            else if(this.jumpType == 2)
            {
               _loc12_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ - 3,true));
               _loc9_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ - 1,true));
               _loc13_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ + 6,true));
               _loc10_ = 0;
               while(_loc10_ < Main.world.numChildren)
               {
                  _loc11_ = Main.world.getChildAt(_loc10_);
                  if(_loc11_ is Map && Boolean(_loc11_.MapData.hitTestPoint(_loc4_,_loc5_ - 3,true)))
                  {
                     _loc12_ = true;
                  }
                  else if(_loc11_ is Map && Boolean(_loc11_.MapData.hitTestPoint(_loc4_,_loc5_ - 1,true)))
                  {
                     _loc9_ = true;
                  }
                  else if(_loc11_ is Map && Boolean(_loc11_.MapData.hitTestPoint(_loc4_,_loc5_ + 6,true)))
                  {
                     _loc13_ = true;
                  }
                  _loc10_++;
               }
               jumping = false;
               if(_loc12_)
               {
                  _loc5_ -= 2;
               }
               else if(_loc9_)
               {
                  runY = 0;
                  gravityNum = 0;
               }
               else if(_loc13_)
               {
                  _loc5_ += 3;
               }
               else
               {
                  _loc5_++;
                  this.jumping = true;
               }
            }
            else if(this.jumpType == 3)
            {
               _loc9_ = Boolean(Main.world.MapData1.hitTestPoint(_loc4_,_loc5_ - 1,true));
               _loc10_ = 0;
               while(_loc10_ < Main.world.numChildren)
               {
                  _loc11_ = Main.world.getChildAt(_loc10_);
                  if(_loc11_ is Map && Boolean(_loc11_.MapData1.hitTestPoint(_loc4_,_loc5_ - this.height,true)))
                  {
                     _loc9_ = true;
                  }
                  _loc10_++;
               }
               if(!_loc9_)
               {
                  jumpType = 2;
                  break;
               }
               _loc5_++;
            }
            _loc6_--;
         }
         this.y = _loc5_;
         if(_loc2_ > 0)
         {
            _loc7_ = _loc4_ - 20;
         }
         else
         {
            _loc7_ = _loc4_ + 20;
         }
         _loc6_ = int(Math.abs(_loc2_));
         while(_loc6_ > 0)
         {
            _loc9_ = Boolean(Main.world.MapData1.hitTestPoint(_loc7_,_loc5_ - 50,true));
            if(!_loc9_)
            {
               _loc10_ = 0;
               while(_loc10_ < Main.world.numChildren)
               {
                  _loc11_ = Main.world.getChildAt(_loc10_);
                  if(_loc11_ is Map && Boolean(_loc11_.MapData.hitTestPoint(_loc7_,_loc5_ - 50,true)))
                  {
                     _loc9_ = true;
                     break;
                  }
                  _loc10_++;
               }
            }
            if(!_loc9_)
            {
               if(_loc2_ > 0)
               {
                  _loc4_--;
               }
               else
               {
                  _loc4_++;
               }
            }
            _loc6_--;
         }
         var _loc8_:int = _loc4_ - Main.world.x;
         if(_loc8_ > Main.world._width + 200)
         {
            this.x = Main.world._width + 200;
         }
         else if(_loc8_ < -200)
         {
            this.x = -200;
         }
         else
         {
            this.x = _loc8_;
         }
      }
      
      public function runPower(param1:Number = 0, param2:Number = 0, param3:int = 0) : *
      {
         if(param3 <= 3)
         {
            runArr[runArr.length] = [param1,param2,1,0,0,0];
            return;
         }
         var _loc4_:* = param1 / param3 * parabola;
         var _loc5_:* = param2 / param3 * parabola;
         var _loc6_:Number = param1 * (1 - parabola) / (param3 * param3 - param3 * (param3 - 1) / 2);
         var _loc7_:Number = param2 * (1 - parabola) / (param3 * param3 - param3 * (param3 - 1) / 2);
         runArr[runArr.length] = [_loc4_,_loc5_,param3,_loc6_,_loc7_];
      }
      
      public function getRL(param1:Boolean) : *
      {
         this.RL = param1;
         if(this.className == "金牛座石像" || this.className == "金牛座石像2" || this.id == 303 || this.id == 2014 || this.id == 88 || this.id == 5001 || this.id == 5002 || this.id == 5003 || this.id == 5015 || this.id == 88 || this.id == 5016 || this.id == 5017 || this.id == 5018 || this.id == 5019 || this.id == 5020 || this.id == 5021 || this.id == 5022)
         {
            return;
         }
         if(param1)
         {
            skin.scaleX = -1;
         }
         else if(!param1)
         {
            skin.scaleX = 1;
         }
         if(this.id == 9001 || this.id == 9002 || this.id == 9003 || this.id == 9004)
         {
            if(skin.xx_mc)
            {
               skin.xx_mc.scaleX = skin.scaleX;
            }
         }
      }
      
      private function set_attack_Time() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         EnemySkinXml = EnemySkin.EnemySkinXmlArr[GameData.gameLV][关卡];
         var _loc1_:int = 0;
         while(_loc1_ < attack_XY.length)
         {
            for(_loc2_ in EnemySkinXml.怪物攻击)
            {
               _loc3_ = int(EnemySkinXml.怪物攻击[_loc2_].ID);
               _loc4_ = String(EnemySkinXml.怪物攻击[_loc2_].帧标签);
               if(id == _loc3_ && _loc4_ == "攻击" + (_loc1_ + 1))
               {
                  _loc5_ = int(EnemySkinXml.怪物攻击[_loc2_].间隔);
                  attack_Time[_loc1_] = _loc5_;
                  attack_TimeNum[_loc1_] = int(_loc5_ * Math.random());
                  break;
               }
            }
            _loc1_++;
         }
      }
      
      private function Attack_TimeXX() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < attack_TimeNum.length)
         {
            if(attack_TimeNum[_loc1_] < attack_Time[_loc1_])
            {
               ++attack_TimeNum[_loc1_];
            }
            _loc1_++;
         }
      }
      
      private function 任务品掉落() : *
      {
         var _loc2_:Quest = null;
         var _loc3_:obj = null;
         var _loc4_:uint = 0;
         var _loc1_:int = int(任务概率掉落计算());
         if(_loc1_ != 0)
         {
            if(_loc1_ >= 84117 && _loc1_ <= 84120)
            {
               _loc4_ = _loc1_ - 84117;
               if(Boolean(Main.player1) && (Main.player1.getBag().fallQusetBag(_loc1_) > 0 || Main.LuoPanArr[_loc4_] == 1))
               {
                  return;
               }
               if(Boolean(Main.P1P2) && Boolean(Main.player2) && (Main.player2.getBag().fallQusetBag(_loc1_) > 0 || Main.LuoPanArr[_loc4_] == 1))
               {
                  return;
               }
            }
            _loc2_ = QuestFactory.creatQust(_loc1_);
            _loc3_ = new obj(_loc2_,this.x,this.y);
         }
      }
      
      private function 任务概率掉落计算() : int
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         if(!mainQuest())
         {
            if(!getbagQuestNum())
            {
               _loc1_ = Math.random() * 10000 + 1;
            }
            else
            {
               _loc1_ = 99999;
            }
         }
         else
         {
            _loc1_ = 99999;
         }
         j = 0;
         while(j < 3)
         {
            _loc2_ = Number(特殊掉落物品[j]);
            if(_loc2_ != 0)
            {
               _loc3_ = Number(QuestFactory.getType(_loc2_));
               if(_loc3_ == 0)
               {
                  _loc4_ = Number(QuestFactory.getTaskId(_loc2_));
                  if(TaskData.isTaskById(_loc4_) != null)
                  {
                     if(!TaskData.getAddBag(_loc4_))
                     {
                        if(_loc1_ <= 特殊掉落概率[j])
                        {
                           return _loc2_;
                        }
                     }
                  }
               }
               else
               {
                  _loc4_ = Number(QuestFactory.getTaskId(_loc2_));
                  if(_loc1_ <= 特殊掉落概率[j])
                  {
                     return _loc2_;
                  }
               }
            }
            ++j;
         }
         return 0;
      }
      
      private function getbagQuestNum() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         while(_loc4_ < 3)
         {
            if(特殊掉落物品[_loc4_] != 0)
            {
               _loc1_ = Number(特殊掉落物品[_loc4_]);
               _loc3_ = Number(QuestFactory.getType(_loc1_));
               if(_loc3_ == 1)
               {
                  if(Main.player2 == null)
                  {
                     return p1bagFall(_loc1_);
                  }
                  if(p1bagFall(_loc1_) || p2bagFall(_loc1_))
                  {
                     return true;
                  }
               }
               else if(_loc3_ == 2)
               {
                  if(Main.player2 == null)
                  {
                     if(p1bagFall(_loc1_))
                     {
                        return p1bagFall(_loc1_);
                     }
                  }
                  else
                  {
                     if(p1bagFall(_loc1_) && p2bagFall(_loc1_))
                     {
                        return true;
                     }
                     if(Boolean(SetTransferPanel.tbo1()) && p2bagFall(_loc1_))
                     {
                        return true;
                     }
                     if(Boolean(SetTransferPanel.tbo2()) && p1bagFall(_loc1_))
                     {
                        return true;
                     }
                  }
               }
               else if(_loc3_ == 0)
               {
                  return false;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function p1bagFall(param1:Number) : Boolean
      {
         var _loc2_:Number = Number(Main.player1.getBag().fallQusetBag(param1));
         var _loc3_:Number = Number(QuestFactory.getFallMax(param1));
         if(_loc2_ < _loc3_)
         {
            return false;
         }
         return true;
      }
      
      public function p2bagFall(param1:Number) : Boolean
      {
         var _loc2_:Number = Number(Main.player2.getBag().fallQusetBag(param1));
         var _loc3_:Number = Number(QuestFactory.getFallMax(param1));
         if(_loc2_ < _loc3_)
         {
            return false;
         }
         return true;
      }
      
      private function mainQuest() : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < 3)
         {
            if(特殊掉落物品[_loc3_] != 0)
            {
               _loc4_ = Number(特殊掉落物品[_loc3_]);
               _loc5_ = Number(QuestFactory.getType(_loc4_));
               if(_loc5_ == 1)
               {
                  return Main.getQuest(_loc4_);
               }
               if(_loc5_ == 2)
               {
                  if(Main.player2 == null)
                  {
                     return SetTransferPanel.tbo1();
                  }
                  if(Boolean(SetTransferPanel.tbo1()) && Boolean(SetTransferPanel.tbo2()))
                  {
                     return true;
                  }
               }
               else if(_loc5_ == 0)
               {
                  return false;
               }
            }
            _loc3_++;
         }
         return false;
      }
   }
}

