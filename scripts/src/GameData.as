package src
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import src.tool.*;
   
   public class GameData
   {
      
      public static var GameDataXml:XML;
      
      public static var 大关:int;
      
      public static var 小关:int;
      
      public static var 过关条件:int;
      
      public static var 刷怪索引:int;
      
      public static var monsterTime:int;
      
      public static var BossIS:Enemy;
      
      public static var GameDataXmlArr:Array = new Array();
      
      public static var 同屏数量:VT = VT.createVT();
      
      public static var 刷怪频率:VT = VT.createVT();
      
      public static var 刷怪总数:VT = VT.createVT();
      
      public static var BOSSid:VT = VT.createVT();
      
      public static var 怪物id:Array = new Array();
      
      public static var 随机id:Array = new Array();
      
      public static var BOSS:VT = VT.createVT(4399);
      
      public static var winYN:Boolean = false;
      
      public static var gameLV:int = 1;
      
      public static var deadMcYN:Boolean = false;
      
      public static var deadTime:int = 5;
      
      public static var jifenArr:Array = new Array();
      
      public function GameData()
      {
         super();
      }
      
      public static function GetData() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         AchData.initGk(Main.gameNum.getValue(),Main.gameNum2.getValue(),GameData.gameLV);
         TaskData.initGk();
         GameDataXml = GameDataXmlArr[gameLV];
         Enemy.EnemyXml = Enemy.EnemyXmlArr[gameLV];
         monsterTime = 0;
         刷怪索引 = 0;
         怪物id = new Array();
         随机id = new Array();
         if(Main.gameNum.getValue() == 59)
         {
            Gamedata59();
         }
         for(_loc1_ in GameDataXml.关卡)
         {
            大关 = int(GameDataXml.关卡[_loc1_].大关);
            小关 = int(GameDataXml.关卡[_loc1_].小关);
            if(Main.gameNum.getValue() == 大关 && Main.gameNum2.getValue() == 小关)
            {
               BOSS.setValue(4399);
               过关条件 = int(GameDataXml.关卡[_loc1_].预留1);
               同屏数量.setValue(int(GameDataXml.关卡[_loc1_].同屏数量));
               刷怪频率.setValue(int(GameDataXml.关卡[_loc1_].刷怪频率) * Main.fps);
               刷怪总数.setValue(int(GameDataXml.关卡[_loc1_].刷怪总数));
               BOSSid.setValue(int(GameDataXml.关卡[_loc1_].BOSSid));
               _loc2_ = 1;
               while(_loc2_ <= 30)
               {
                  _loc4_ = int(GameDataXml.关卡[_loc1_]["怪物id" + _loc2_]);
                  if(_loc4_ >= 0)
                  {
                     怪物id[怪物id.length] = VT.createVT(_loc4_);
                  }
                  _loc2_++;
               }
               _loc3_ = 1;
               while(_loc3_ <= 5)
               {
                  _loc5_ = int(GameDataXml.关卡[_loc1_]["随机id" + _loc3_]);
                  if(_loc5_ > 0)
                  {
                     随机id[随机id.length] = VT.createVT(_loc5_);
                  }
                  _loc3_++;
               }
               return;
            }
         }
         if(Main.gameNum.getValue() != 0 && Main.gameNum.getValue() != 999)
         {
            SaveXX.Save(15,15,true,false,false);
         }
      }
      
      public static function Gamedata59() : *
      {
         var _loc1_:Enemy = null;
         var _loc2_:Enemy = null;
         if(Main.gameNum2.getValue() == 1)
         {
            _loc1_ = new Enemy(90);
            Main.world.moveChild_Enemy.addChild(_loc1_);
            _loc1_.x = 1340;
            _loc1_.y = 520;
         }
         if(Main.gameNum2.getValue() == 2)
         {
            _loc1_ = new Enemy(90);
            Main.world.moveChild_Enemy.addChild(_loc1_);
            _loc1_.x = 2430;
            _loc1_.y = 520;
         }
         if(Main.gameNum2.getValue() == 3)
         {
            _loc1_ = new Enemy(90);
            Main.world.moveChild_Enemy.addChild(_loc1_);
            _loc1_.x = 4000;
            _loc1_.y = 520;
         }
         if(Main.gameNum2.getValue() == 4)
         {
            _loc1_ = new Enemy(90);
            Main.world.moveChild_Enemy.addChild(_loc1_);
            _loc1_.x = 4400;
            _loc1_.y = 520;
            _loc2_ = new Enemy(90);
            Main.world.moveChild_Enemy.addChild(_loc2_);
            _loc2_.x = 5570;
            _loc2_.y = 520;
         }
      }
      
      public static function MonsterGo() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Enemy = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         ++monsterTime;
         if(Main.gameNum.getValue() > 50 && Main.gameNum.getValue() < 81 && Main.world.stopYn == false)
         {
            return;
         }
         if(BOSS.getValue() > 0 && BOSSid.getValue() > 0)
         {
            Play_Interface.BossLifeYN = true;
            BossIS = new Enemy(BOSSid.getValue());
            Play_Interface.bossIS = BossIS;
            Main.world.moveChild_Enemy.addChild(BossIS);
            BossIS.x = Main.world._width - 200;
            BossIS.y = 380;
            BOSS.setValue(-4399);
            _loc1_ = int(Main.wts.getBoss());
            if(_loc1_ != -1 && gameLV < 5)
            {
               _loc2_ = new Enemy(_loc1_);
               Main.world.moveChild_Enemy.addChild(_loc2_);
               _loc2_.x = 700;
               _loc2_.y = 380;
               过关条件 = 1;
               刷怪总数.setValue(0);
            }
         }
         if(怪物id.length > 0 && monsterTime >= 刷怪频率.getValue())
         {
            monsterTime = 0;
            if(刷怪总数.getValue() > 0 && Enemy.All.length < 同屏数量.getValue())
            {
               _loc3_ = 同屏数量.getValue() - Enemy.All.length;
               if(_loc3_ <= 刷怪总数.getValue())
               {
                  刷怪总数.setValue(刷怪总数.getValue() - _loc3_);
               }
               else
               {
                  _loc3_ = 刷怪总数.getValue();
                  刷怪总数.setValue(0);
               }
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  if(Enemy.All.length < 同屏数量.getValue())
                  {
                     WhoAreYou();
                  }
                  _loc4_++;
               }
            }
         }
         if(monsterTime % 27 == 0)
         {
            if(winYN == false)
            {
               Win(过关条件);
               Lose();
            }
         }
         if(BOSSid.getValue() == 5022)
         {
            BossIS.x = 689;
         }
      }
      
      private static function WhoAreYou() : *
      {
         var _loc1_:Enemy = null;
         var _loc2_:int = 0;
         var _loc3_:Enemy = null;
         if(刷怪索引 >= 怪物id.length)
         {
            刷怪索引 = 0;
         }
         if(怪物id[刷怪索引].getValue() != 0)
         {
            _loc1_ = new Enemy(怪物id[刷怪索引].getValue());
            Main.world.moveChild_Enemy.addChild(_loc1_);
            _loc2_ = int(Where());
            _loc1_.x = _loc2_;
            _loc1_.y = 380;
         }
         else
         {
            _loc2_ = Math.random() * 随机id.length;
            _loc3_ = new Enemy(随机id[_loc2_].getValue());
            Main.world.moveChild_Enemy.addChild(_loc3_);
            _loc2_ = int(Where());
            _loc3_.x = _loc2_;
            _loc3_.y = 380;
         }
         if(怪物id[刷怪索引].getValue() == 9004 && Main.player1.skinArr[Main.player1.skinNum] == 2)
         {
            NewMC.Open("文字提示",Main._stage,480,300,540,0,false,0,"拳手请按L键切换武器后, 使用H技能攻击");
         }
         ++刷怪索引;
      }
      
      private static function Where() : int
      {
         var _loc1_:int = Math.random() * 7;
         var _loc2_:int = 0;
         if(Main.gameNum.getValue() == 17)
         {
            _loc2_ = Math.random() * 1000 + 100;
         }
         else if(_loc1_ == 0)
         {
            _loc2_ = -200 - Main.world.x;
         }
         else if(_loc1_ == 1)
         {
            _loc2_ = 940 + 200 - Main.world.x;
         }
         else
         {
            _loc2_ = Math.random() * 940 - Main.world.x;
         }
         return _loc2_;
      }
      
      private static function addBuff() : *
      {
         if(Main.gameNum2.getValue() == 2)
         {
            Main.player1.buffNine[0] = 10800;
            if(Main.P1P2)
            {
               Main.player2.buffNine[0] = 10800;
            }
         }
         if(Main.gameNum2.getValue() == 3)
         {
            Main.player1.buffNine[1] = 10800;
            if(Main.P1P2)
            {
               Main.player2.buffNine[1] = 10800;
            }
         }
         if(Main.gameNum2.getValue() == 4)
         {
            Main.player1.buffNine[2] = 10800;
            if(Main.P1P2)
            {
               Main.player2.buffNine[2] = 10800;
            }
         }
         if(Main.gameNum2.getValue() == 5)
         {
            Main.player1.buffNine[3] = 10800;
            if(Main.P1P2)
            {
               Main.player2.buffNine[3] = 10800;
            }
         }
         if(Main.gameNum2.getValue() == 6)
         {
            Main.player1.buffNine[4] = 7200;
            if(Main.P1P2)
            {
               Main.player2.buffNine[4] = 7200;
            }
         }
         if(Main.gameNum2.getValue() == 7)
         {
            Main.player1.buffNine[5] = 7200;
            if(Main.P1P2)
            {
               Main.player2.buffNine[5] = 7200;
            }
         }
         if(Main.gameNum2.getValue() == 8)
         {
            Main.player1.buffNine[6] = 7200;
            if(Main.P1P2)
            {
               Main.player2.buffNine[6] = 7200;
            }
         }
         if(Main.gameNum2.getValue() == 9)
         {
            Main.player1.buffNine[7] = 7200;
            if(Main.P1P2)
            {
               Main.player2.buffNine[7] = 7200;
            }
         }
         if(Main.gameNum2.getValue() == 10)
         {
            Main.player1.buffNine[8] = 7200;
            if(Main.P1P2)
            {
               Main.player2.buffNine[8] = 7200;
            }
         }
      }
      
      private static function Win(param1:int) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:ZhuFuMC = null;
         if(param1 == 0)
         {
            for(_loc2_ in GameDataXml.关卡)
            {
               if(int(GameDataXml.关卡[_loc2_].大关) == Main.gameNum.getValue() && int(GameDataXml.关卡[_loc2_].小关) == Main.gameNum2.getValue() + 1)
               {
                  if(Boolean(Main.world["继续"]) && Boolean(Main.world["继续"] is Door) && !Main.world["继续"].openYN)
                  {
                     (Main.world["继续"] as Door).Open();
                  }
                  return;
               }
               if(Boolean(Main.world["回村"]) && Boolean(Main.world["回村"] is Door) && !Main.world["回村"].openYN)
               {
                  (Main.world["回村"] as Door).Open();
               }
            }
         }
         else if(param1 == 1)
         {
            if(Enemy.All.length <= 0 && 刷怪总数.getValue() <= 0 && Main.world.moveChild_Enemy.numChildren <= 0)
            {
               for(_loc2_ in GameDataXml.关卡)
               {
                  if(int(GameDataXml.关卡[_loc2_].大关) == Main.gameNum.getValue() && int(GameDataXml.关卡[_loc2_].小关) == Main.gameNum2.getValue() + 1)
                  {
                     if(Boolean(Main.world["继续"]) && !Main.world["继续"].openYN)
                     {
                        (Main.world["继续"] as Door).Open(60);
                     }
                     return;
                  }
                  if(Boolean(Main.world["回村"]) && !Main.world["回村"].openYN)
                  {
                     (Main.world["回村"] as Door).Open(60);
                     if(Main.gameNum.getValue() > 17 && Main.gameNum.getValue() < 50)
                     {
                        _loc3_ = new ZhuFuMC();
                        Main.world.addChild(_loc3_);
                        winYN = true;
                     }
                  }
               }
            }
         }
         else if(param1 == 2)
         {
            if(Boolean(BossIS) && BossIS.life.getValue() <= 0)
            {
               if(Boolean(Main.world["继续"]) && !Main.world["继续"].openYN)
               {
                  (Main.world["继续"] as Door).Open(60);
               }
               if(Boolean(Main.world["回村"]) && !Main.world["回村"].openYN)
               {
                  (Main.world["回村"] as Door).Open(60);
                  if(Main.gameNum.getValue() > 17 && Main.gameNum.getValue() < 50)
                  {
                     _loc3_ = new ZhuFuMC();
                     Main.world.addChild(_loc3_);
                     winYN = true;
                  }
               }
            }
         }
         else if(param1 == 3)
         {
            if(Enemy.All.length <= 0 && 刷怪总数.getValue() <= 0 && Main.world.moveChild_Enemy.numChildren <= 0)
            {
               for(_loc2_ in GameDataXml.关卡)
               {
                  if(int(GameDataXml.关卡[_loc2_].大关) == Main.gameNum.getValue() && int(GameDataXml.关卡[_loc2_].小关) == Main.gameNum2.getValue() + 1)
                  {
                     Main.gameNum2.setValue(Main.gameNum2.getValue() + 1);
                     GameData.GetData();
                     Play_HPMP_up();
                     NewMC.Open("挑战关波数",Main._this,0,0,35,Main.gameNum2.getValue(),true,2);
                     if(Main.gameNum.getValue() == 1000)
                     {
                        addBuff();
                     }
                     AchData.isTc(Main.gameNum2.getValue());
                     if(Main.gameNum2.getValue() >= 10)
                     {
                        JiHua_Interface.ppp4_13 = true;
                     }
                     if(Main.gameNum2.getValue() >= 25)
                     {
                        JiHua_Interface.ppp5_17 = true;
                     }
                     if(Main.gameNum2.getValue() >= 30)
                     {
                        JiHua_Interface.ppp6_6 = true;
                     }
                     return;
                  }
               }
               AchData.isTc(Main.gameNum2.getValue() + 1);
               if(Boolean(Main.world["回村"]) && !Main.world["回村"].openYN)
               {
                  if(Main.gameNum.getValue() == 1000)
                  {
                     Main.player1.buffNine[9] = 7200;
                     if(Main.P1P2)
                     {
                        Main.player2.buffNine[9] = 7200;
                     }
                  }
                  (Main.world["回村"] as Door).Open(60);
               }
            }
         }
         else if(param1 == 4)
         {
            if(Boolean(Main.world.stopYn) && Enemy.All.length <= 0 && 刷怪总数.getValue() <= 0 && Main.world.moveChild_Enemy.numChildren <= 0)
            {
               for(_loc2_ in GameDataXml.关卡)
               {
                  if(int(GameDataXml.关卡[_loc2_].大关) == Main.gameNum.getValue() && int(GameDataXml.关卡[_loc2_].小关) == Main.gameNum2.getValue() + 1)
                  {
                     Main.gameNum2.setValue(Main.gameNum2.getValue() + 1);
                     GameData.GetData();
                     Main.world.NoStop();
                     return;
                  }
               }
            }
         }
         else if(param1 == 5)
         {
            if(Boolean(BossIS) && BossIS.life.getValue() <= 0)
            {
               if(Boolean(Main.world["继续"]) && !Main.world["继续"].openYN)
               {
                  (Main.world["继续"] as Door).Open(60);
               }
               if(Boolean(Main.world["回村"]) && !Main.world["回村"].openYN)
               {
                  (Main.world["回村"] as Door).Open(60);
               }
            }
         }
         else if(param1 == 6)
         {
            if(Boolean(BossIS) && BossIS.life.getValue() <= 0)
            {
               if(Main.world["bk2"])
               {
                  (Main.world["bk2"] as NewDoor).Open();
                  NewDoor.bool_1 = false;
                  NewDoor.bool_0 = true;
               }
               if(Main.world["bk3"])
               {
                  (Main.world["bk3"] as NewDoor).Open();
                  NewDoor.bool_2 = false;
                  NewDoor.bool_0 = true;
               }
               if(Main.world["bk4"])
               {
                  (Main.world["bk4"] as NewDoor).Open();
                  NewDoor.bool_3 = false;
                  NewDoor.bool_0 = true;
               }
            }
            if(Boolean(BossIS) && Boolean(BossIS.id == "5015") && BossIS.life.getValue() <= 0)
            {
               if(Main.world["bk5"])
               {
                  (Main.world["bk5"] as NewDoor).Open(60);
                  BossIS = null;
                  Main.player_1.energySlot.setZero();
                  if(Main.P1P2)
                  {
                     Main.player_2.energySlot.setZero();
                  }
               }
            }
         }
         else if(param1 == 7)
         {
            if(Boolean(Main.world.stopYn) && Enemy.All.length <= 0 && 刷怪总数.getValue() <= 0 && Main.world.moveChild_Enemy.numChildren <= 0)
            {
               for(_loc2_ in GameDataXml.关卡)
               {
                  if(Boolean(Main.world["继续"]) && !Main.world["继续"].openYN)
                  {
                     (Main.world["继续"] as Door).Open(60);
                  }
                  if(Boolean(Main.world["回村"]) && !Main.world["回村"].openYN)
                  {
                     (Main.world["回村"] as Door).Open(60);
                  }
               }
            }
         }
      }
      
      private static function Play_HPMP_up() : *
      {
         Main.player_1.HpUp(VT.GetTempVT("10/1*2"),2);
         Main.player_1.MpUp(VT.GetTempVT("10/1*4"),2);
         if(Main.P1P2)
         {
            Main.player_2.HpUp(VT.GetTempVT("10/1*2"),2);
            Main.player_2.MpUp(VT.GetTempVT("10/1*4"),2);
         }
      }
      
      public static function GuanKaXX() : *
      {
         AddKillPoint_fun();
         if(!Main.guanKa[Main.gameNum.getValue() + 1] || Main.guanKa[Main.gameNum.getValue() + 1] == 0)
         {
            Main.guanKa[Main.gameNum.getValue() + 1] = 1;
         }
         if(GameData.gameLV == 1 && Main.guanKa[Main.gameNum.getValue()] == 1)
         {
            Main.guanKa[Main.gameNum.getValue()] = 2;
         }
         else if(GameData.gameLV == 2 && Main.guanKa[Main.gameNum.getValue()] == 2)
         {
            Main.guanKa[Main.gameNum.getValue()] = 3;
         }
         else if(Main.guanKa[Main.gameNum.getValue()] != 1 && Main.guanKa[Main.gameNum.getValue()] != 2 && Main.guanKa[Main.gameNum.getValue()] != 3)
         {
            Main.guanKa[Main.gameNum.getValue()] = 2;
         }
      }
      
      private static function AddKillPoint_fun() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Main.gameNum.getValue() > 100 || Main.gameNum.getValue() == 9)
         {
            return;
         }
         if(Main.gameNum.getValue() == 17)
         {
            AddKillPoint_P1P2(VT.GetTempVT("6*2*5*2"));
            Add_CW_exp_P1P2(VT.GetTempVT("6*2*5*2"));
         }
         else if(Main.gameNum.getValue() < 51)
         {
            _loc1_ = 1;
            _loc2_ = 2;
            while(_loc2_ < 17)
            {
               if(!(Boolean(Main.guanKa[_loc2_]) || Main.guanKa[_loc2_] > 0))
               {
                  break;
               }
               _loc1_ = _loc2_;
               _loc2_++;
            }
            _loc3_ = _loc1_ - Main.gameNum.getValue();
            if(_loc3_ < 0)
            {
               return;
            }
            if(_loc3_ >= 4)
            {
               AddKillPoint_P1P2(VT.GetTempVT("8/4"));
               Add_CW_exp_P1P2(VT.GetTempVT("8/4"));
            }
            else
            {
               AddKillPoint_P1P2(VT.GetTempVT("9+1") - VT.GetTempVT("6/3") * _loc3_);
               Add_CW_exp_P1P2(VT.GetTempVT("9+1") - VT.GetTempVT("6/3") * _loc3_);
            }
         }
         else
         {
            _loc1_ = 1;
            _loc2_ = 51;
            while(_loc2_ < 81)
            {
               if(!(Boolean(_loc2_ == 51) || Boolean(Main.guanKa[_loc2_]) || Main.guanKa[_loc2_] > 0))
               {
                  break;
               }
               _loc1_ = _loc2_;
               _loc2_++;
            }
            _loc3_ = _loc1_ - Main.gameNum.getValue();
            if(_loc3_ < 0)
            {
               return;
            }
            if(_loc3_ >= 4)
            {
               AddKillPoint_P1P2(VT.GetTempVT("9/3"));
               Add_CW_exp_P1P2(VT.GetTempVT("9/3"));
            }
            else
            {
               AddKillPoint_P1P2(VT.GetTempVT("9+3") - VT.GetTempVT("6/3") * _loc3_);
               Add_CW_exp_P1P2(VT.GetTempVT("9+3") - VT.GetTempVT("6/3") * _loc3_);
            }
         }
      }
      
      private static function AddKillPoint_P1P2(param1:int) : *
      {
         if(Main.gameNum.getValue() != 17)
         {
            if(GameData.gameLV > 3 || param1 > 10)
            {
               return;
            }
         }
         if(GameData.gameLV == 2 && Main.gameNum.getValue() != 17)
         {
            param1 *= VT.GetTempVT("8+5/5/2");
         }
         else if(GameData.gameLV == 3 && Main.gameNum.getValue() != 17)
         {
            param1 *= VT.GetTempVT("8+8/5/2");
         }
         var _loc2_:int = 0;
         while(_loc2_ < Main.player1.getTitleSlot().getListLength())
         {
            if(Main.player1.getTitleSlot().getTitleFromSlot(_loc2_).getId() == 25)
            {
               param1 *= 1.5;
            }
            _loc2_++;
         }
         WinShow.txt_5 = param1;
         Main.player1.AddKillPoint(param1);
         if(Main.P1P2)
         {
            Main.player2.AddKillPoint(param1);
         }
      }
      
      private static function Add_CW_exp_P1P2(param1:int) : *
      {
         if(GameData.gameLV == 2)
         {
            param1 *= VT.GetTempVT("8+5/5/2");
         }
         else if(GameData.gameLV == 3)
         {
            param1 *= VT.GetTempVT("8+8/5/2");
         }
         var _loc2_:int = 0;
         while(_loc2_ < Main.player1.getTitleSlot().getListLength())
         {
            if(Main.player1.getTitleSlot().getTitleFromSlot(_loc2_).getId() == 25)
            {
               param1 *= 1.5;
            }
            _loc2_++;
         }
         WinShow.txt_5 = param1;
         if(Main.player_1.playerCW)
         {
            if(Main.player_1.playerCW.data.addExp(param1))
            {
               NewMC.Open("宠物升级",Main.player_1.playerCW);
            }
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player_2.playerCW))
         {
            if(Main.player_2.playerCW.data.addExp(param1))
            {
               NewMC.Open("宠物升级",Main.player_2.playerCW);
            }
         }
         if(Main.player_1.playerJL)
         {
            if(Main.player_1.playerJL.data.addExp(param1))
            {
               NewMC.Open("宠物升级",Main.player_1.playerJL);
            }
         }
         if(Boolean(Main.P1P2) && Boolean(Main.player_2.playerJL))
         {
            if(Main.player_2.playerJL.data.addExp(param1))
            {
               NewMC.Open("宠物升级",Main.player_2.playerJL);
            }
         }
      }
      
      private static function Lose() : *
      {
         var _loc1_:Boolean = false;
         if(Boolean(Main.P1P2) && Main.player_1.hp.getValue() <= 0 && Main.player_2.hp.getValue() <= 0)
         {
            _loc1_ = true;
         }
         else if(!Main.P1P2 && Main.player_1.hp.getValue() <= 0)
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            if(deadTime > 0)
            {
               --deadTime;
            }
            else if(!deadMcYN)
            {
               deadTime = 5;
               if(Main.gameNum.getValue() == 999)
               {
                  PkJiFun(false);
               }
               else
               {
                  GameOverX();
               }
            }
         }
      }
      
      private static function GameOverX() : *
      {
         var _loc1_:GameOver = new GameOver();
         Main._stage.addChild(_loc1_);
         deadMcYN = true;
         deadTime = 5;
      }
      
      public static function SelMapName() : String
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         if(Main.gameNum.getValue() == 17)
         {
            return "Map_17_1";
         }
         for(_loc2_ in GameDataXml.关卡)
         {
            if(int(GameDataXml.关卡[_loc2_].大关) == Main.gameNum.getValue() && int(GameDataXml.关卡[_loc2_].小关) == Main.gameNum2.getValue())
            {
               return "Map_" + int(GameDataXml.关卡[_loc2_].预留2) + "_" + int(GameDataXml.关卡[_loc2_].预留3);
            }
         }
         return "Map_" + Main.gameNum.getValue() + "_" + Main.gameNum2.getValue();
      }
      
      public static function PkJiFun(param1:Boolean = true) : *
      {
         var _loc2_:VT = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(Main.gameNum.getValue() == 999 && Boolean(PK_UI.PK_ing))
         {
            _loc2_ = VT.createVT();
            _loc3_ = 1;
            if(Main.P1P2)
            {
               _loc3_ = (Main.player1.level.getValue() + Main.player2.level.getValue()) / 2;
            }
            else
            {
               _loc3_ = int(Main.player1.level.getValue());
            }
            _loc4_ = PK_UI.killNum70up.getValue() + PK_UI.killNum70down.getValue();
            _loc5_ = _loc3_ * 100;
            _loc6_ = PK_UI.killNum70up.getValue() * 8000 + PK_UI.killNum70down.getValue() * 3000;
            _loc7_ = _loc4_ * 19 * Math.pow(18000 - PK_UI.Pk_timeNum,0.5);
            _loc8_ = 0;
            _loc9_ = 0;
            if(param1)
            {
               _loc8_ = 10000;
               _loc9_ = 1;
            }
            _loc10_ = (_loc5_ + _loc6_ + _loc7_ + _loc8_) * ((1000 - WinShow.txt_3) / 1000 - 1);
            jifenArr = [0,_loc5_,_loc6_,_loc7_,_loc8_,_loc10_];
            _loc11_ = _loc5_ + _loc6_ + _loc7_ + _loc8_ + _loc10_;
            if(_loc11_ < 0)
            {
               _loc11_ = 0;
            }
            _loc2_.setValue(_loc11_);
            TiaoShi.txtShow("积分 = " + _loc2_.getValue() + "," + _loc5_ + "," + _loc6_ + "," + _loc7_ + "," + _loc8_ + "," + _loc10_);
            TiaoShi.txtShow("击杀数 = " + PK_UI.killNum70up.getValue() + " + " + PK_UI.killNum70down.getValue() + ",PK_UI.Pk_timeNum = " + PK_UI.Pk_timeNum);
            PK_JiFen_UI.Open(param1,_loc11_);
            PK_UI.PK_ing = false;
            TiJiaoFenShu(_loc11_);
            if(PK_UI.Pk_timeNum <= 0 && PK_UI.jiFenArr[2].getValue() != 999)
            {
               PK_UI.jiFenArr[2].setValue(PK_UI.jiFenArr[2].getValue() + 1);
               TiaoShi.txtShow(">>>>>>>>>>>>>>>>>>> 挑战次数:" + PK_UI.jiFenArr[2].getValue());
            }
            Main.Save();
         }
      }
      
      public static function TiJiaoFenShu(param1:int) : *
      {
         var _loc2_:Array = [];
         _loc2_[0] = new Object();
         if(Main.P1P2)
         {
            _loc2_[0].rId = 1364;
         }
         else
         {
            _loc2_[0].rId = 1365;
         }
         _loc2_[0].score = param1;
         if(Main.tiaoShiYN)
         {
            _loc2_[0].score = 99;
         }
         if(param1 > InitData.PaiNumMax.getValue())
         {
            _loc2_[0].score = InitData.PaiNumMax.getValue();
         }
         Api_4399_All.SubmitScore(Main.saveNum,_loc2_);
      }
   }
}

