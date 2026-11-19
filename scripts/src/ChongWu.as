package src
{
   import com.*;
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.pet.Pet;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class ChongWu extends MovieClip
   {
      
      public static var dataXml:XML;
      
      public static var loadData:ClassLoader;
      
      public static var loadData2:ClassLoader;
      
      public static var chongWu_Data:Array = new Array();
      
      public static var jiaZaiOK:Array = [];
      
      public static var gongJiYn1:Boolean = false;
      
      public static var gongJiYn2:Boolean = false;
      
      public var who:Player;
      
      public var data:Pet;
      
      public var food:VT = VT.createVT(100);
      
      public var RL:Boolean = true;
      
      private var distance_X:int = 0;
      
      private var distanceMax:int = 1200;
      
      private var walk_power:VT = VT.createVT(7);
      
      private var gravity:int = 20;
      
      public var skin:MovieClip;
      
      public var runType:String = "站立";
      
      public var runType2:String = "站立";
      
      public var continuous:Boolean;
      
      public var noMove:Boolean = false;
      
      public var MoveYn:Boolean = false;
      
      private var gongJiEnemy:Enemy;
      
      public var goEnemy:Boolean = false;
      
      public var goJiCD_max:Array = [];
      
      public var goJiCD_now:Array = [];
      
      public var nullTime:int = 0;
      
      public var cdOK_Arr:Array = [];
      
      public var typeClass:int;
      
      private var wudiTime:int = 0;
      
      public var riyanTime:int = 0;
      
      public var riyanAdd:int = 0;
      
      public var tempTT:int = 0;
      
      public var tempTTT:int = 0;
      
      public var nai_C:Class = NewLoad.XiaoGuoData.getClass("Nai") as Class;
      
      public var naizui_C:Class = NewLoad.XiaoGuoData.getClass("Naizui") as Class;
      
      public var fire_C:Class = NewLoad.XiaoGuoData.getClass("Fire") as Class;
      
      public var nai:MovieClip = new nai_C();
      
      public var naizui:MovieClip = new naizui_C();
      
      public var fire:MovieClip = new fire_C();
      
      public function ChongWu(param1:Pet, param2:Player)
      {
         super();
         who = param2;
         who.data.playerCW_Data = data = param1;
         who.playerCW = this;
         goJiCD_max = data.getPetCD();
         goJiCD_now = DeepCopyUtil.clone(goJiCD_max);
         addSkin();
      }
      
      public static function get_XML_data() : *
      {
         dataXml = XMLAsset.createXML(Data2.petHit_data);
      }
      
      public function Close() : *
      {
         if(skin)
         {
            this.skin.gotoAndStop(1);
            this.parent.removeChild(this);
         }
         removeEventListener(Event.ENTER_FRAME,riyan);
         removeEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         who.playerCW = null;
         who.data.playerCW_Data = null;
      }
      
      private function LoadCWGo(param1:int, param2:String) : *
      {
         chongWu_Data[param1] = new ClassLoader(param2);
         if(NewPetPanel.petPanel)
         {
            NewPetPanel.petPanel["touming"].visible = true;
         }
         chongWu_Data[param1].addEventListener(Event.COMPLETE,LoadCWEnd);
      }
      
      private function LoadCWEnd(param1:*) : *
      {
         var _loc2_:int = int(PetFactory.getClassName(data._id.getValue()));
         jiaZaiOK[_loc2_] = true;
         if(NewPetPanel.petPanel)
         {
            NewPetPanel.petPanel["touming"].visible = false;
         }
         addSkin();
      }
      
      private function addSkin() : *
      {
         var _loc2_:String = null;
         var _loc4_:Class = null;
         var _loc1_:int = int(PetFactory.getClassName(data._id.getValue()));
         _loc2_ = _loc1_;
         typeClass = int(_loc2_);
         if(_loc1_ == 18)
         {
            _loc2_ = "18_v2";
         }
         if(_loc1_ == 20)
         {
            _loc2_ = "20_v842";
         }
         if(_loc1_ == 14)
         {
            _loc2_ = "14_v900";
         }
         if(_loc1_ == 22)
         {
            _loc2_ = "22_v900";
         }
         var _loc3_:String = "CW" + _loc2_ + ".swf";
         _loc2_ = "CW" + _loc1_;
         if(!chongWu_Data[_loc1_])
         {
            LoadCWGo(_loc1_,_loc3_);
            return;
         }
         if(!jiaZaiOK[_loc1_])
         {
            return;
         }
         _loc4_ = ChongWu.chongWu_Data[_loc1_].getClass(_loc2_) as Class;
         skin = new _loc4_();
         addChild(skin);
         this.y = 500;
         who.data.playerCW_Data = data;
         who.playerCW = this;
         Main.world.moveChild_ChongWu.addChild(this);
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
         SearchPlayer();
         mouseChildren = mouseEnabled = false;
         return true;
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         GongJi();
         if(!noMove)
         {
            WhereAreYou();
         }
         GoToPlay();
         WhoDead();
      }
      
      private function WhoDead() : *
      {
         if(!this.who || this.who.hp.getValue() <= 0)
         {
            Close();
         }
      }
      
      private function WhereAreYou() : *
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(this.parent != Main.world.moveChild_ChongWu)
         {
            Main.world.moveChild_ChongWu.addChild(this);
            SearchPlayer();
         }
         if(goEnemy && Enemy.All.length > 0)
         {
            if(!gongJiEnemy)
            {
               gongJiEnemy = Enemy.All[0];
               distance_X = this.x - gongJiEnemy.x;
               _loc1_ = 1;
               while(_loc1_ < Enemy.All.length)
               {
                  _loc2_ = this.x - Enemy.All[_loc1_].x;
                  if(Math.abs(distance_X) > Math.abs(_loc2_))
                  {
                     distance_X = _loc2_;
                  }
                  _loc1_++;
               }
            }
            else
            {
               distance_X = this.x - gongJiEnemy.x;
               if(gongJiEnemy.life.getValue() <= 0)
               {
                  gongJiEnemy = null;
               }
            }
         }
         else
         {
            distance_X = this.x - who.x;
            distance_Y = this.y - who.y;
            if(Math.abs(distance_X) > distanceMax)
            {
               SearchPlayer();
            }
            gongJiEnemy = null;
         }
         MoveRun();
      }
      
      private function SearchPlayer() : *
      {
         this.x = who.x + Math.random() * 200 - 100;
         this.y = who.y - 100;
      }
      
      private function MoveRun() : *
      {
         var _loc3_:* = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc1_:* = int(this.x + Main.world.x);
         var _loc2_:int = this.y;
         _loc3_ = int(gravity);
         while(_loc3_ > 0)
         {
            _loc7_ = Boolean(Main.world.MapData.hitTestPoint(_loc1_,_loc2_ - 3,true));
            _loc8_ = Boolean(Main.world.MapData.hitTestPoint(_loc1_,_loc2_ - 1,true));
            _loc9_ = Boolean(Main.world.MapData.hitTestPoint(_loc1_,_loc2_ + 6,true));
            if(_loc7_)
            {
               _loc2_ -= 2;
            }
            else if(_loc8_)
            {
               runY = 0;
            }
            else if(_loc9_)
            {
               _loc2_ += 3;
            }
            else
            {
               _loc2_++;
            }
            _loc3_--;
         }
         this.y = _loc2_;
         var _loc4_:int = data._id.getValue();
         var _loc5_:int = 100;
         if(_loc4_ == 73117 || _loc4_ == 73118)
         {
            walk_power.setValue(12);
            _loc5_ = 300;
         }
         _loc3_ = int(Math.abs(walk_power.getValue()));
         while(_loc3_ > 0)
         {
            _loc8_ = Boolean(Main.world.MapData1.hitTestPoint(_loc1_,_loc2_ - 30,true));
            if(!_loc8_)
            {
               if(distance_X > 5)
               {
                  getRL(false);
               }
               else if(distance_X < -5)
               {
                  getRL(true);
               }
               if(Boolean(gongJiEnemy) && Boolean(distance_X > _loc5_) || distance_X > 200)
               {
                  _loc1_--;
                  GoTo("移动",true);
               }
               else if(Boolean(gongJiEnemy) && Boolean(distance_X < -_loc5_) || distance_X < -200)
               {
                  _loc1_++;
                  GoTo("移动",true);
               }
               else
               {
                  GoTo("站立");
               }
            }
            _loc3_--;
         }
         var _loc6_:int = _loc1_ - Main.world.x;
         if(_loc6_ > Main.world._width + 100)
         {
            this.x = Main.world._width + 100;
         }
         else if(_loc6_ < -100)
         {
            this.x = -100;
         }
         else
         {
            this.x = _loc6_;
         }
      }
      
      public function getRL(param1:Boolean) : *
      {
         if(this.skin.currentLabel != "移动")
         {
            return;
         }
         this.RL = param1;
         if(param1)
         {
            scaleX = -1;
         }
         else if(!param1)
         {
            scaleX = 1;
         }
      }
      
      private function GoToPlay() : *
      {
         if(isRunOver())
         {
            if(runType2 != "攻击")
            {
               skin.gotoAndPlay(runType);
            }
            else
            {
               GoTo("站立");
            }
         }
      }
      
      public function isRunOver() : Boolean
      {
         if(skin.currentLabel != runType)
         {
            noMove = false;
            return true;
         }
         return false;
      }
      
      public function riyan(param1:*) : *
      {
         ++tempTT;
         --riyanTime;
         if(tempTT > 27)
         {
            for(i in Enemy.All)
            {
               if(Enemy.All[i])
               {
                  if(Math.abs(Enemy.All[i].x - who.playerCW.x) < 200)
                  {
                     Enemy.All[i].hpCount(riyanAdd);
                     HPdown.Open(riyanAdd,Enemy.All[i].x,Enemy.All[i].y - Enemy.All[i].height);
                  }
               }
            }
            tempTT = 0;
         }
         if(riyanTime <= 0)
         {
            who.playerCW.removeChild(fire);
            removeEventListener(Event.ENTER_FRAME,riyan);
         }
      }
      
      private function goWuDiMC(param1:*) : *
      {
         ++tempTTT;
         if(tempTTT >= 24)
         {
            nai.parent.removeChild(nai);
            tempTTT = 0;
            who.removeEventListener(Event.ENTER_FRAME,goWuDiMC);
         }
      }
      
      private function goWuDi(param1:*) : *
      {
         --wudiTime;
         if(who.skin.currentLabel == "站")
         {
            who.rexuewudi = true;
            if(wudiTime % 10 > 4)
            {
               who.alpha = 1;
            }
            else
            {
               who.alpha = 0.7;
            }
         }
         else
         {
            who.rexuewudi = false;
            who.alpha = 1;
         }
         if(wudiTime < 0)
         {
            naizui.parent.removeChild(naizui);
            who.rexuewudi = false;
            who.alpha = 1;
            who.removeEventListener(Event.ENTER_FRAME,goWuDi);
         }
      }
      
      private function GongJi() : *
      {
         if(nullTime > 0)
         {
            --nullTime;
         }
         cdOK_Arr = new Array();
         var _loc1_:int = 1;
         while(_loc1_ < 6)
         {
            if(goJiCD_now[_loc1_] > 0)
            {
               --goJiCD_now[_loc1_];
            }
            else
            {
               cdOK_Arr[_loc1_] = true;
            }
            _loc1_++;
         }
         if(Boolean(gongJiEnemy) || Boolean(this.who == Main.player_1 && gongJiYn1) || Boolean(Main.player_2 && this.who == Main.player_2) && Boolean(gongJiYn2))
         {
            if(nullTime <= 0 && cdOK_Arr.length > 0)
            {
               GoTo("攻击",true);
            }
         }
         var _loc2_:int = int(PetFactory.getClassName(data._id.getValue()));
         if(_loc2_ == 20)
         {
            CW20_GongJi();
         }
         if(_loc2_ == 24)
         {
            CW24_GongJi();
         }
         if(_loc2_ == 26)
         {
            CW26_GongJi();
         }
      }
      
      public function CW26_GongJi() : *
      {
         if(this.skin.currentFrame >= 36 + 24 && this.skin.currentFrame <= 36 + 28 || this.skin.currentFrame >= 36 + 35 && this.skin.currentFrame <= 36 + 38 || this.skin.currentFrame >= 36 + 47 && this.skin.currentFrame <= 36 + 52)
         {
            if(this.RL)
            {
               this.x += 28;
            }
            else
            {
               this.x -= 28;
            }
            return;
         }
         if(this.skin.currentFrame >= 100 + 24 && this.skin.currentFrame <= 100 + 70)
         {
            if(this.RL)
            {
               this.x += 15;
            }
            else
            {
               this.x -= 15;
            }
            return;
         }
      }
      
      public function CW20_GongJi() : *
      {
         if(this.skin.currentFrame >= 522 && this.skin.currentFrame <= 522 + 14)
         {
            if(this.RL)
            {
               this.x += 48;
            }
            else
            {
               this.x -= 48;
            }
            return;
         }
      }
      
      public function CW24_GongJi() : *
      {
         if(this.skin.currentFrame >= 489 + 35 && this.skin.currentFrame <= 489 + 95)
         {
            if(this.RL)
            {
               this.x += 7;
            }
            else
            {
               this.x -= 7;
            }
         }
         if(this.skin.currentFrame >= 594 + 13 && this.skin.currentFrame <= 594 + 117)
         {
            if(this.RL)
            {
               this.x += 6;
            }
            else
            {
               this.x -= 6;
            }
         }
      }
      
      public function GoTo(param1:String, param2:Boolean = false) : *
      {
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:HitXX = null;
         if(noMove)
         {
            return;
         }
         var _loc3_:uint = 3;
         if(data._id.getValue() == 73105)
         {
            _loc3_ = 5;
         }
         if(data._id.getValue() == 73108)
         {
            _loc3_ = 4;
         }
         if(data._id.getValue() == 73118)
         {
            _loc3_ = 2;
         }
         var _loc5_:String = param1;
         if(param1 == "站立")
         {
            _loc5_ = "站立" + int(Math.random() * _loc3_ + 1);
         }
         else if(param1 == "攻击")
         {
            _loc6_ = data.getPetSkillType();
            _loc7_ = int(Math.random() * 4);
            _loc4_ = int(_loc6_[_loc7_]);
            if(!(_loc4_ > 0 && Boolean(cdOK_Arr[_loc4_])))
            {
               if(_loc4_ <= 0)
               {
                  nullTime = 270;
                  if(this.who == Main.player_1)
                  {
                     gongJiYn1 = false;
                  }
                  else
                  {
                     gongJiYn2 = false;
                  }
               }
               return;
            }
            _loc5_ = "攻击" + _loc4_;
            if(data.getPetEquip())
            {
               if(data.getPetEquip().getType() == 7)
               {
                  _loc6_ = data.getPetEquip().getAffect();
                  riyanAdd = who.use_gongji.getValue() * _loc6_[0];
                  riyanTime = _loc6_[2];
                  who.playerCW.addChild(fire);
                  addEventListener(Event.ENTER_FRAME,riyan);
               }
               if(data.getPetEquip().getType() == 6)
               {
                  _loc6_ = data.getPetEquip().getAffect();
                  if(Math.random() * 100 <= _loc6_[1])
                  {
                     wudiTime = _loc6_[0];
                     who.addChild(naizui);
                     who.addChild(nai);
                     who.addEventListener(Event.ENTER_FRAME,goWuDi);
                     who.addEventListener(Event.ENTER_FRAME,goWuDiMC);
                  }
               }
            }
         }
         if(runType != _loc5_ && (isRunOver() || param2))
         {
            runType = _loc5_;
            runType2 = param1;
            if(param1 == "攻击")
            {
               if(data._id.getValue() == 73107 && _loc5_ == "攻击4")
               {
                  _loc8_ = new HitXX();
                  _loc8_.type = 100;
                  _loc8_.totalTime = 12 * 27;
                  new BuffEffect(_loc8_,this.who);
               }
               noMove = true;
               nullTime = goJiCD_now[_loc4_] = goJiCD_max[_loc4_];
               XXCD(_loc4_);
               if(this.who == Main.player_1)
               {
                  gongJiYn1 = false;
               }
               else
               {
                  gongJiYn2 = false;
               }
            }
            skin.gotoAndPlay(runType);
         }
      }
      
      public function XXCD(param1:int) : *
      {
         var _loc2_:Array = null;
         if(data.getPetEquip())
         {
            if(data.getPetEquip().getType() == 14 && Enemy.wscd > 135)
            {
               Enemy.wscd = 0;
               _loc2_ = data.getPetEquip().getAffect();
               goJiCD_now[param1] = 0;
            }
         }
      }
   }
}

