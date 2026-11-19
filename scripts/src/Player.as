package src
{
   import com.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.elves.Elves;
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.pet.Pet;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.models.skill.Skill;
   import com.hotpoint.braveManIII.models.supplies.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.cardPanel.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.suppliesShopPanel.*;
   import flash.display.*;
   import flash.events.*;
   import src._data.*;
   import src.other.*;
   import src.tool.*;
   
   public class Player extends MovieClip
   {
      
      public static var LV_data:XML;
      
      public static var enemySkillMC:*;
      
      public static var szCD:int = 0;
      
      public static var skillYAO:int = 0;
      
      public static var upLevelInfo:Boolean = false;
      
      public static var maxLevel:int = 90;
      
      public static var All:Array = [];
      
      public static var PlayerMcLoaded:Boolean = false;
      
      public static var PlayerMcArr:Array = new Array();
      
      public static var num_hp:VT = VT.createVT();
      
      public static var num_mp:VT = VT.createVT();
      
      public static var num_gj:VT = VT.createVT();
      
      public static var num_fy:VT = VT.createVT();
      
      public static var num_sb:VT = VT.createVT();
      
      public static var num_bj:VT = VT.createVT();
      
      public static var num_sd:VT = VT.createVT();
      
      public static var num_pm:VT = VT.createVT();
      
      public static var num_mk:VT = VT.createVT();
      
      public static var num_1:VT = VT.createVT();
      
      public static var num_15:VT = VT.createVT();
      
      public static var num_20:VT = VT.createVT();
      
      public static var num_25:VT = VT.createVT();
      
      public static var num_30:VT = VT.createVT();
      
      public static var num_32:VT = VT.createVT(0.32);
      
      public static var num_35:VT = VT.createVT();
      
      public static var num_7:VT = VT.createVT();
      
      public static var num_5:VT = VT.createVT();
      
      public static var num_27:VT = VT.createVT();
      
      public static var num_13:VT = VT.createVT();
      
      public static var num_65:VT = VT.createVT();
      
      public static var Vip_Point_YN:Boolean = true;
      
      private static var Temp11:VT = VT.createVT(VT.GetTempVT("10+1/10"));
      
      public static var boolYS:Boolean = true;
      
      public var fbChengFa:Boolean = false;
      
      public var darkTime:int = 0;
      
      public var isDarkState:Boolean = false;
      
      public var debuff:int = 0;
      
      public var gongji_UP:Number = 1;
      
      public var jianSang_UP:Number = 1;
      
      public var zhongqiuState:Number = 0;
      
      public var jianrenState:Number = 0;
      
      public var reXueType:Boolean = false;
      
      public var lianjiBool:Boolean = false;
      
      public var isDead:Boolean = false;
      
      public var noMove:Boolean = false;
      
      private var tempXXX2:VT = VT.createVT(VT.GetTempVT("8/4"));
      
      public var hpXX2num:int = 0;
      
      public var hitXX:HitXX;
      
      public var shuangShouBeiShu:Number = 1;
      
      public var energySlot:EnergySlot = new EnergySlot();
      
      public var skin:Skin;
      
      public var cengHao_mc:CengHao = new CengHao();
      
      public var backMC:MovieClip;
      
      public var skin_Z:Skin_ZhuangBei;
      
      public var skin_Z2:Skin_ZhuangBei;
      
      public var skin_Z3:Skin_ZhuangBei;
      
      public var skin_Z2_V:Boolean = true;
      
      public var skin_Z3_V:Boolean = true;
      
      public var headFrame:int = 1;
      
      public var skin_W:Skin_WuQi;
      
      public var playerCW:ChongWu;
      
      public var playerJL:JingLing;
      
      public var hit:MovieClip = null;
      
      private var nodead_C:Class = NewLoad.XiaoGuoData.getClass("undeath") as Class;
      
      private var nodead:MovieClip = new nodead_C();
      
      public var deadX:Dead;
      
      public var 职业附加:Array = [1,1,1];
      
      public var 套装强化:Array = [0,0,0,0,0,false,false,false];
      
      public var 装备附加:Array = [];
      
      public var time:int = 1000;
      
      public var lianJi:VT = VT.createVT(0);
      
      public var lianJiTime:VT = VT.createVT(60);
      
      public var data:PlayerData;
      
      public var nextExp:VT = VT.createVT();
      
      public var speedTemp:VT = VT.createVT(0);
      
      public var hp:VT = VT.createVT();
      
      public var mp:VT = VT.createVT();
      
      public var hp_Max:VT = VT.createVT();
      
      public var mp_Max:VT = VT.createVT();
      
      public var gongji:VT = VT.createVT();
      
      public var fangyu:VT = VT.createVT();
      
      public var baoji:VT = VT.createVT();
      
      public var sanbi:VT = VT.createVT();
      
      public var walk_power:VT = VT.createVT();
      
      public var yingzhi:VT = VT.createVT();
      
      public var gongji2:VT = VT.createVT();
      
      public var fangyu2:VT = VT.createVT();
      
      public var use_hp_Max:VT = VT.createVT();
      
      public var use_mp_Max:VT = VT.createVT();
      
      public var use_gongji:VT = VT.createVT();
      
      public var use_gongji2:VT = VT.createVT();
      
      public var use_fangyu:VT = VT.createVT();
      
      public var use_fangyu2:VT = VT.createVT();
      
      public var use_baoji:VT = VT.createVT();
      
      public var use_sanbi:VT = VT.createVT();
      
      public var temp_hp_Max:VT = VT.createVT();
      
      public var temp_mp_Max:VT = VT.createVT();
      
      public var temp_gongji:VT = VT.createVT();
      
      public var temp_fangyu:VT = VT.createVT();
      
      public var temp_baoji:VT = VT.createVT();
      
      public var temp_sanbi:VT = VT.createVT();
      
      public var AllSkillCD:Array = new Array();
      
      public var AllSkillCDXX:Array = new Array();
      
      public var All_ObjCD:Array = new Array();
      
      public var All_ObjCDXX:Array = new Array();
      
      public var RL:Boolean = true;
      
      private var jump_power:* = 145;
      
      private var jump_time:* = 8;
      
      private var parabola:Number = 0.3;
      
      public var jumping:int = 0;
      
      private var jumpX2:Boolean = false;
      
      private var jumpType:int = 2;
      
      public var gravity:int = 2;
      
      private var gravityNum:* = 0;
      
      private var SwitchingTime:int;
      
      public var paiHangShow:Array = [1,1,1,[0],[0]];
      
      public var noHit:Boolean = false;
      
      public var noHit82:Boolean = false;
      
      public var noYingZhi:Boolean = false;
      
      private var XXSupplies:Supplies;
      
      public var fangYuPOWER:VT = VT.createVT();
      
      private var KeyArrStr:Array = ["上","下","左","右","攻击","跳","切换","技能1","技能2","技能3","技能4","消耗1","消耗2","消耗3","转职","怪物"];
      
      private var getAllMoveSpeed:VT = VT.createVT(-99);
      
      private var getAllSuitSkill:Array;
      
      private var getAllEquipSkill:Array;
      
      internal var xuemaiTime:int = 0;
      
      internal var xuemaiTime2:int = 0;
      
      private var dkState:MovieClip = new DarkPower();
      
      public var noHead:Boolean = false;
      
      public var flagTempMP:Boolean = true;
      
      public var flagTempXL:Boolean = true;
      
      public var flagTempSY:Boolean = true;
      
      public var flagTempSJ:Boolean = true;
      
      public var flagTempRX:Boolean = true;
      
      public var flagTempBJ:Boolean = true;
      
      public var timeTemp:int = 0;
      
      public var timeTempmp:int = 0;
      
      public var rexuewudi:Boolean = false;
      
      internal var kouxue:Boolean = false;
      
      internal var tankaiTime:int = 0;
      
      internal var iceTIME:int = 0;
      
      internal var jKey:Boolean = false;
      
      public var flyTime:int = 0;
      
      public var fly:Boolean = false;
      
      public var newLifeTime:VT = VT.createVT();
      
      internal var tempCXHF:int = 0;
      
      internal var tempVaPer:int = 0;
      
      internal var tempChiXuTime:int = 0;
      
      private var runX:int = 0;
      
      private var runY:int = 0;
      
      private var runArr:Array = new Array();
      
      public var playerYS:YongShi61;
      
      private var feixingTime:int = 0;
      
      private var feixingBool:Boolean = false;
      
      private var class_ps:Class = NewLoad.XiaoGuoData.getClass("高能喷射") as Class;
      
      private var fffps:Skill2015_3 = null;
      
      private var feixingBool2:Boolean = false;
      
      private var feixingBool3:Boolean = false;
      
      private var penSheTime:int = 0;
      
      private var nbTime:int = 0;
      
      public function Player()
      {
         super();
         mouseEnabled = mouseChildren = false;
         deadX = new Dead();
         addChild(deadX);
         deadX.visible = false;
         addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         addEventListener(Event.ENTER_FRAME,onENTER_FRAME);
      }
      
      public static function Init() : *
      {
         num_hp = VT.createVT(1);
         num_mp = VT.createVT(1);
         num_gj = VT.createVT(1);
         num_fy = VT.createVT(1);
         num_sb = VT.createVT(1);
         num_bj = VT.createVT(1);
         num_pm = VT.createVT(1);
         num_mk = VT.createVT(1);
         num_sd = VT.createVT(0);
         num_5 = VT.createVT(0.05);
         num_1 = VT.createVT(0.1);
         num_15 = VT.createVT(0.15);
         num_20 = VT.createVT(0.2);
         num_25 = VT.createVT(0.25);
         num_30 = VT.createVT(0.3);
         num_35 = VT.createVT(0.35);
         num_7 = VT.createVT(0.07);
         num_13 = VT.createVT(0.13);
         num_27 = VT.createVT(0.27);
         num_65 = VT.createVT(1);
      }
      
      public static function getPlayerLvData(param1:PlayerData) : XML
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         for(_loc2_ in LV_data.角色)
         {
            _loc3_ = int(LV_data.角色[_loc2_].等级);
            if(_loc3_ == param1.getLevel())
            {
               return LV_data.角色[_loc2_];
            }
         }
         return null;
      }
      
      public static function 一起信春哥() : *
      {
         Main.player_1.deadX.visible = false;
         Main.player_1.信春哥();
         Main.player_1.energySlot.setZero();
         Main.player_1.runArr = new Array();
         if(Main.P1P2)
         {
            Main.player_2.deadX.visible = false;
            Main.player_2.信春哥();
            Main.player_2.runArr = new Array();
            Main.player_2.energySlot.setZero();
         }
      }
      
      public static function getEquipDataXX() : *
      {
         Main.player_1.getEquipData(true);
         if(Main.P1P2)
         {
            Main.player_2.getEquipData(true);
         }
      }
      
      public static function Vip_Point() : *
      {
         if(Shop4399.totalPaiedMoney.getValue() < 0)
         {
            if(Vip_Point_YN)
            {
               Api_4399_All.TotalPaied();
               Vip_Point_YN = false;
            }
         }
         else if(Shop4399.totalPaiedMoney.getValue() < InitData.vip2990.getValue())
         {
            SaveXX.Save(13,2990,true,false,false);
         }
      }
      
      private function onADDED_TO_STAGE(param1:*) : *
      {
         Main.world.moveChild_Player.addChild(this);
         All[All.length] = this;
         Main._stage.addEventListener(KeyboardEvent.KEY_DOWN,onKEY_DOWN);
         addEventListener(Event.REMOVED_FROM_STAGE,onREMOVED_FROM_STAGE);
      }
      
      public function 不信春哥() : *
      {
         isDead = false;
         debuff = 0;
         if(Main.gameNum.getValue() == 0 && this.visible)
         {
            复活药使用();
            return;
         }
         if(data.buffNine[9] > 0)
         {
            if(data.reBorn == 0)
            {
               复活药使用();
               data.reBorn = 3600;
               return;
            }
         }
         if(!deadX.visible)
         {
            NewMC.Open("死亡倒计时",this);
         }
         deadX.frame = this.headFrame;
         if(noHead)
         {
            deadX.head_mc.gotoAndStop(24);
            deadX.head_mc.visible = true;
         }
         else
         {
            deadX.head_mc.gotoAndStop(deadX.frame);
         }
         deadX.visible = true;
         skin_Z.visible = false;
         skin_W.visible = false;
         if(skin_Z2)
         {
            skin_Z2.visible = false;
         }
         if(skin_Z3)
         {
            skin_Z3.visible = false;
         }
         energySlot.setZero();
      }
      
      public function 信春哥() : *
      {
         isDead = false;
         if(this.visible == false)
         {
            return;
         }
         this.scaleX = this.scaleY = 1;
         if(Boolean(deadX && skin) && Boolean(skin_Z) && Boolean(skin_W))
         {
            deadX.visible = false;
            skin.visible = true;
            skin_Z.visible = true;
            skin_W.visible = true;
            skin.GoTo("站立",1,true);
         }
         PK_hpMax();
         this.hp.setValue(9999999);
         this.mp.setValue(9999999);
         continuousTime = 0;
         if(Boolean(data.getPetSlot().getJilu() >= 0) && Boolean(data.getPetSlot().getPetFromSlot(data.getPetSlot().getJilu())) && data.getPetSlot().getPetFromSlot(data.getPetSlot().getJilu()).getType() > 1)
         {
            NewCW(data.getPetSlot().getPetFromSlot(data.getPetSlot().getJilu()));
         }
         if(playerCW)
         {
            playerCW.goEnemy = data.getPetSlot().getMode();
         }
      }
      
      private function onREMOVED_FROM_STAGE(param1:*) : *
      {
         this.skin.Over();
      }
      
      public function ExpUP(param1:int, param2:int = 1) : String
      {
         if(param2 != 2 && hp.getValue() <= 0)
         {
            return undefined;
         }
         if(param2 == 3)
         {
            param1 = nextExp.getValue() * param1 / 100;
         }
         if(data.buffNine[0] > 0)
         {
            param1 *= 1.15;
         }
         else if(data.buffNine[8] > 0)
         {
            param1 *= 1.3;
         }
         data.setEXP(data.getEXP() + param1);
         if(data.level.getValue() < maxLevel)
         {
            if(data.getEXP() >= nextExp.getValue())
            {
               return LevelUP(param2);
            }
         }
         return "ok";
      }
      
      public function LevelUP(param1:int = 1) : *
      {
         if(hp.getValue() <= 0)
         {
            return;
         }
         var _loc2_:int = data.getLevel();
         if(_loc2_ < Player.maxLevel)
         {
            if(param1 == 1 || param1 == 3)
            {
               data.setEXP(0);
               LevelUP_X();
            }
            else if(param1 == 2)
            {
               while(data.getEXP() >= nextExp.getValue() && _loc2_ < Player.maxLevel)
               {
                  data.setEXP(data.getEXP() - nextExp.getValue());
                  LevelUP_X();
               }
            }
            NewMC.Open("升级效果",this);
            if(data.getLevel() == 2)
            {
               NewMC.Open("文字提示",Main._this,470,500,150,0,true,1,"恭喜你升到2级! 你可以在主城找【奥古斯汀】学习技能啦!");
               upLevelInfo = true;
            }
            if(data.getLevel() >= 50)
            {
               data.setRebirth();
            }
         }
      }
      
      public function LevelUP_X() : *
      {
         data.setLevel(data.getLevel() + VT.GetTempVT("8/8"));
         TiaoShi.tempVar = "data.getLevel() = " + data.getLevel() + " , data.getEXP() = " + data.getEXP();
         if(data.isRebirth())
         {
            data.addPoint(VT.GetTempVT("10/2"));
         }
         else
         {
            data.addPoint(VT.GetTempVT("8/2"));
         }
         LoadPlayerLvData();
         this.hp.setValue(9999999);
         this.mp.setValue(9999999);
      }
      
      public function MoneyUP(param1:int) : *
      {
         if(hp.getValue() <= 0)
         {
            return;
         }
         data.addGold(param1);
      }
      
      public function Load_All_Player_Data() : *
      {
         LoadPlayerLvData();
         GetAllSkillCD();
         GetAllObjCD();
         newSkin();
         信春哥();
         left_Reight();
         ChongSeng_no50lv();
      }
      
      private function ChongSeng_no50lv() : *
      {
         if(data.getLevel() >= 50)
         {
            data.setRebirth();
         }
      }
      
      public function left_Reight() : *
      {
         if(this.data.getEquipSkillSlot().getGemFromSkillSlot(0) != null)
         {
            if(Main.gameNum.getValue() == 0)
            {
               energySlot.energyLeftNum.setValue(0);
               energySlot.energyLeftMax.setValue(SkillFactory.getSkillById(this.data.getEquipSkillSlot().getGemFromSkillSlot(0).getGemSkill()).getEp());
            }
         }
         if(this.data.getEquipSkillSlot().getGemFromSkillSlot(1) != null)
         {
            if(Main.gameNum.getValue() == 0)
            {
               energySlot.energyRightNum.setValue(0);
               energySlot.energyRightMax.setValue(SkillFactory.getSkillById(this.data.getEquipSkillSlot().getGemFromSkillSlot(1).getGemSkill()).getEp());
            }
         }
      }
      
      public function LoadPlayerLvData() : *
      {
         双手加成();
         var _loc1_:XML = Player.getPlayerLvData(this.data);
         nextExp.setValue(int(_loc1_.经验));
         var _loc2_:int = int(_loc1_.HP) + data.getEquipSlot().getAllHP();
         hp_Max.setValue(_loc2_);
         var _loc3_:int = int(_loc1_.MP) + data.getEquipSlot().getAllMP();
         mp_Max.setValue(_loc3_);
         var _loc4_:int = (int(_loc1_.攻击) + data.getEquipSlot().getAllAttack()) * shuangShouBeiShu;
         gongji.setValue(_loc4_);
         var _loc5_:int = int(_loc1_.防御) + data.getEquipSlot().getAllDefense();
         fangyu.setValue(_loc5_);
         var _loc6_:int = int(_loc1_.暴击) + data.getEquipSlot().getAllCrit();
         baoji.setValue(_loc6_);
         var _loc7_:int = int(_loc1_.闪避) + data.getEquipSlot().getAllDuck();
         sanbi.setValue(_loc7_);
         var _loc8_:int = int(_loc1_.硬值) + data.getEquipSlot().getAllHardValue();
         yingzhi.setValue(_loc8_);
         var _loc9_:int = data.getEquipSlot().getAllPOMO();
         gongji2.setValue(_loc9_);
         var _loc10_:int = data.getEquipSlot().getAllMOKANG();
         fangyu2.setValue(_loc10_);
         walk_power.setValue(6 + data.getEquipSlot().getAllMoveSpeed());
         LoadAll_D_Skill();
      }
      
      private function TestEquipSlot() : *
      {
         if(data.getEquipSlot().testAllEquip() == true)
         {
            Main.NoGame("5星装备");
         }
      }
      
      private function LoadAll_D_Skill() : *
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         for(_loc1_ in data.getSkillArr())
         {
            _loc2_ = (data.getSkillArr()[_loc1_][0] as String).substr(0,1);
            if(_loc2_ == "d")
            {
               if(data.getSkillArr()[_loc1_][0] == "d1" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  this.jumpX2 = true;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d2" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc4_ = Number((_loc3_[0] as VT).getValue());
                  hp_Max.setValue(hp_Max.getValue() + _loc4_);
               }
               else if(data.getSkillArr()[_loc1_][0] == "d3" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc4_ = Number((_loc3_[0] as VT).getValue());
                  mp_Max.setValue(mp_Max.getValue() + _loc4_);
               }
               else if(data.getSkillArr()[_loc1_][0] == "d4" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc4_ = Number((_loc3_[0] as VT).getValue());
                  baoji.setValue(baoji.getValue() + _loc4_);
               }
               else if(data.getSkillArr()[_loc1_][0] == "d5" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc4_ = Number((_loc3_[0] as VT).getValue());
                  sanbi.setValue(sanbi.getValue() + _loc4_);
               }
               else if(data.getSkillArr()[_loc1_][0] == "d6" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  职业附加[0] = 1 + _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d7" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  职业附加[1] = 1 + _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d8" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  职业附加[2] = 1 + _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d9" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  套装强化[0] = _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d10" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  套装强化[1] = _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d11" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  _loc5_ = Number((_loc3_[0] as VT).getValue());
                  套装强化[2] = _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d12" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  套装强化[3] = _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d13" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  _loc3_ = SkillFactory.getSkillByTypeIAndLevel(data.getSkillArr()[_loc1_][0],data.getSkillArr()[_loc1_][1]).getSkillValueArray();
                  套装强化[4] = _loc5_;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d14" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  套装强化[5] = true;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d15" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  套装强化[6] = true;
               }
               else if(data.getSkillArr()[_loc1_][0] == "d16" && data.getSkillArr()[_loc1_][1] > 0)
               {
                  套装强化[7] = true;
               }
            }
         }
      }
      
      private function getEquipData(param1:Boolean = false) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(getAllMoveSpeed.getValue() == -99 || param1)
         {
            getAllMoveSpeed.setValue(data.getEquipSlot().getAllMoveSpeed());
         }
         if(!getAllSuitSkill || param1)
         {
            getAllSuitSkill = data.equipSlot.getAllSuitSkill();
         }
         if(!getAllEquipSkill || param1)
         {
            _loc2_ = data.getEquipSlot().getAllEquipSkill();
            getAllEquipSkill = new Array();
            for(_loc3_ in _loc2_)
            {
               getAllEquipSkill[_loc3_] = SkillFactory.getSkillById(_loc2_[_loc3_]);
            }
         }
      }
      
      private function LoadAll_ZB_Skill() : *
      {
         getEquipData();
         use_hp_Max.setValue(hp_Max.getValue());
         use_mp_Max.setValue(mp_Max.getValue());
         use_gongji.setValue(gongji.getValue());
         use_fangyu.setValue(fangyu.getValue());
         use_baoji.setValue(baoji.getValue());
         use_sanbi.setValue(sanbi.getValue());
         use_fangyu2.setValue(fangyu2.getValue());
         use_gongji2.setValue(gongji2.getValue());
         walk_power.setValue(6 + getAllMoveSpeed.getValue() + speedTemp.getValue());
         if(walk_power.getValue() <= 0)
         {
            walk_power.setValue(0);
         }
         reSet();
         zengFu();
         huiZhangJiaCheng();
         chongwujiacheng();
         QiangHuaJiaCheng();
         chenghaoJiaCheng();
         VIPJiaCheng();
         jinglingjiacheng();
         cardjiacheng();
         stampjiacheng();
         装备技能();
         ALLTempcompute();
         TaoZhuangXiaoGuo();
         rexueSkill();
         ALLcompute();
         nineBuffJiaCheng();
         stampjiacheng2();
         XingLingJiaCeng();
         xuemaiJiaCheng();
         huanhuaJiaCheng();
         zhongQiuJiaCheng();
         jianRenJiaCheng();
         PK_hpMax();
         ZB_HpMpUP();
         数值溢出修正();
      }
      
      private function PK_hpMax() : *
      {
         if(Main.gameNum.getValue() == 999)
         {
            use_hp_Max.setValue(use_hp_Max.getValue() * InitData.pkHpMaxNum_Player.getValue());
         }
         else
         {
            use_hp_Max.setValue(use_hp_Max.getValue());
         }
      }
      
      private function 装备技能() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         for(_loc1_ in getAllEquipSkill)
         {
            _loc2_ = int(getAllEquipSkill[_loc1_].getSkillActOn());
            _loc3_ = getAllEquipSkill[_loc1_].getSkillValueArray();
            if(_loc2_ == 32)
            {
               if(lianJi.getValue() > _loc3_[1].getValue())
               {
                  _loc4_ = Number(_loc3_[0].getValue());
                  num_gj.setValue(num_gj.getValue() + _loc4_);
               }
            }
            else if(_loc2_ == 35)
            {
               _loc4_ = use_baoji.getValue() + _loc3_[0].getValue();
               use_baoji.setValue(_loc4_);
            }
            else if(_loc2_ == 200)
            {
               if(Boolean(data.getEquipSlot().getEquipFromSlot(6)) && data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
               {
                  num_fy.setValue(num_fy.getValue() + _loc3_[0].getValue());
                  num_gj.setValue(num_gj.getValue() + _loc3_[1].getValue());
               }
            }
            else if(_loc2_ == 201)
            {
               if(Boolean(data.getEquipSlot().getEquipFromSlot(7)) && data.getEquipSlot().getEquipFromSlot(7).getRemainingTime() > 0)
               {
                  num_hp.setValue(num_hp.getValue() + _loc3_[0].getValue());
                  num_bj.setValue(num_bj.getValue() + _loc3_[1].getValue());
               }
            }
         }
      }
      
      private function rexueSkill() : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc1_:Array = XingLingFactory.GetTolal_Data_VT();
         var _loc2_:uint = uint(_loc1_[1].getValue());
         var _loc3_:uint = data.getStampSlot().getValueSlot5();
         for(_loc4_ in getAllEquipSkill)
         {
            _loc5_ = int(getAllEquipSkill[_loc4_].getSkillActOn());
            _loc6_ = getAllEquipSkill[_loc4_].getSkillValueArray();
            if(_loc5_ == 31)
            {
               _loc8_ = (temp_hp_Max.getValue() + _loc2_ + _loc3_) * _loc6_[1].getValue();
               if(hp.getValue() < _loc8_)
               {
                  _loc7_ = Number(_loc6_[0].getValue());
                  num_gj.setValue(num_gj.getValue() + _loc7_);
               }
            }
         }
      }
      
      private function ZB_HpMpUP() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         for(i in getAllEquipSkill)
         {
            _loc1_ = int(getAllEquipSkill[i].getSkillActOn());
            _loc2_ = getAllEquipSkill[i].getSkillValueArray();
            if(_loc1_ == 33)
            {
               if(time % (_loc2_[0].getValue() - 套装强化[0]) == 0)
               {
                  num = _loc2_[1].getValue() * use_mp_Max.getValue();
                  MP_UP(num);
               }
            }
            else if(_loc1_ == 34)
            {
               if(time % (_loc2_[0].getValue() - 套装强化[1]) == 0)
               {
                  if(PK_UI.PK_ing)
                  {
                     num = _loc2_[1].getValue() * use_hp_Max.getValue() / 20;
                  }
                  else
                  {
                     num = _loc2_[1].getValue() * use_hp_Max.getValue();
                  }
                  HP_UP(num);
               }
            }
         }
      }
      
      private function huiZhangJiaCheng() : *
      {
         num_hp.setValue(this.data.getBadgeSlot().getHP() + num_hp.getValue());
         num_bj.setValue(this.data.getBadgeSlot().getCRIT() + num_bj.getValue());
         num_gj.setValue(this.data.getBadgeSlot().getATT() + num_gj.getValue());
         num_fy.setValue(this.data.getBadgeSlot().getDEF() + num_fy.getValue());
         num_mp.setValue(this.data.getBadgeSlot().getMP() + num_mp.getValue());
         num_sd.setValue(this.data.getBadgeSlot().getSPEED() + num_sd.getValue());
      }
      
      private function VIPJiaCheng() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < Main.player1.getTitleSlot().getListLength())
         {
            if(Main.player1.getTitleSlot().getTitleFromSlot(_loc1_).getId() == 25)
            {
               num_hp.setValue(num_5.getValue() + num_hp.getValue());
               num_bj.setValue(num_5.getValue() + num_bj.getValue());
               num_gj.setValue(num_5.getValue() + num_gj.getValue());
               num_fy.setValue(num_5.getValue() + num_fy.getValue());
               num_mp.setValue(num_5.getValue() + num_mp.getValue());
               num_sb.setValue(num_5.getValue() + num_sb.getValue());
               num_pm.setValue(num_5.getValue() + num_pm.getValue());
               num_mk.setValue(num_5.getValue() + num_mk.getValue());
               if(this == Main.player_1)
               {
                  Vip_Point();
               }
            }
            _loc1_++;
         }
      }
      
      private function zengFu() : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc1_:Array = data.equipSlot.getAllEquipNewSkill();
         for(_loc2_ in _loc1_)
         {
            _loc3_ = int(SkillFactory.getSkillById(_loc1_[_loc2_]).getSkillActOn());
            _loc4_ = SkillFactory.getSkillById(_loc1_[_loc2_]).getSkillValueArray();
            if(_loc3_ == 39)
            {
               num_gj.setValue(num_gj.getValue() + _loc4_[0].getValue());
            }
            else if(_loc3_ == 40)
            {
               num_bj.setValue(num_bj.getValue() + _loc4_[0].getValue());
            }
            else if(_loc3_ == 41)
            {
               Main.NoGame("闪避");
            }
            else if(_loc3_ == 42)
            {
               num_hp.setValue(num_hp.getValue() + _loc4_[0].getValue());
            }
            else if(_loc3_ == 43)
            {
               num_fy.setValue(num_fy.getValue() + _loc4_[0].getValue());
            }
         }
      }
      
      private function reSet() : *
      {
         num_gj.setValue(InitData.BuyNum_1.getValue());
         num_fy.setValue(InitData.BuyNum_1.getValue());
         num_hp.setValue(InitData.BuyNum_1.getValue());
         num_mp.setValue(InitData.BuyNum_1.getValue());
         num_sb.setValue(InitData.BuyNum_1.getValue());
         num_bj.setValue(InitData.BuyNum_1.getValue());
         num_pm.setValue(InitData.BuyNum_1.getValue());
         num_mk.setValue(InitData.BuyNum_1.getValue());
         num_sd.setValue(InitData.BuyNum_0.getValue());
      }
      
      private function ALLcompute() : *
      {
         use_hp_Max.setValue(int(use_hp_Max.getValue() * num_hp.getValue()));
         use_mp_Max.setValue(int(use_mp_Max.getValue() * num_mp.getValue()));
         use_gongji.setValue(use_gongji.getValue() * num_gj.getValue());
         use_fangyu.setValue(use_fangyu.getValue() * num_fy.getValue());
         use_sanbi.setValue(use_sanbi.getValue() * num_sb.getValue());
         use_baoji.setValue(use_baoji.getValue() * num_bj.getValue());
         use_gongji2.setValue(use_gongji2.getValue() * num_pm.getValue());
         use_fangyu2.setValue(use_fangyu2.getValue() * num_mk.getValue());
         walk_power.setValue(walk_power.getValue() + num_sd.getValue());
      }
      
      private function ALLTempcompute() : *
      {
         temp_hp_Max.setValue(int(use_hp_Max.getValue() * num_hp.getValue()));
         temp_mp_Max.setValue(int(use_mp_Max.getValue() * num_mp.getValue()));
         temp_gongji.setValue(use_gongji.getValue() * num_gj.getValue());
         temp_fangyu.setValue(use_fangyu.getValue() * num_fy.getValue());
         temp_sanbi.setValue(use_sanbi.getValue() * num_sb.getValue());
         temp_baoji.setValue(use_baoji.getValue() * num_bj.getValue());
      }
      
      private function xuemaiJiaCheng() : *
      {
         if(Boolean(NewPetPanel.XueMai) && Boolean(playerCW))
         {
            if(NewPetPanel.XueMai.isHaveSX(1))
            {
               use_gongji.setValue(200 + use_gongji.getValue());
            }
            if(NewPetPanel.XueMai.isHaveSX(2))
            {
               use_fangyu.setValue(100 + use_fangyu.getValue());
            }
            if(NewPetPanel.XueMai.isHaveSX(5))
            {
               use_mp_Max.setValue(400 + use_mp_Max.getValue());
            }
            if(NewPetPanel.XueMai.isHaveSX(6))
            {
               walk_power.setValue(1 + walk_power.getValue());
            }
            if(NewPetPanel.XueMai.isHaveSX(7))
            {
               use_fangyu2.setValue(use_fangyu2.getValue() + 20);
            }
            if(NewPetPanel.XueMai.isHaveSX(8))
            {
               use_gongji2.setValue(use_gongji2.getValue() + 20);
            }
            if(NewPetPanel.XueMai.isHaveSX(9))
            {
               use_baoji.setValue(300 + use_baoji.getValue());
            }
            if(NewPetPanel.XueMai.isHaveSX(10))
            {
               use_hp_Max.setValue(700 + use_hp_Max.getValue());
            }
         }
      }
      
      private function huanhuaJiaCheng() : *
      {
         if(data.getEquipSlot().getEquipFromSlot(5).getHuanHua() == 2)
         {
            walk_power.setValue(walk_power.getValue() + 1);
         }
      }
      
      private function jianRenJiaCheng() : *
      {
         if(jianrenState == 2)
         {
            use_gongji.setValue(use_gongji.getValue() + use_gongji.getValue() * 0.5);
         }
      }
      
      private function nineBuffJiaCheng() : *
      {
         if(data.buffNine[1] > 0)
         {
            if(data.buffNine[8] > 0)
            {
               use_fangyu.setValue(use_fangyu.getValue() + use_fangyu.getValue() * 0.2);
               use_mp_Max.setValue(use_mp_Max.getValue() + use_mp_Max.getValue() * 0.2);
               use_hp_Max.setValue(use_hp_Max.getValue() + use_hp_Max.getValue() * 0.2);
               use_gongji.setValue(use_gongji.getValue() + use_gongji.getValue() * 0.2);
               use_gongji2.setValue(use_gongji2.getValue() + use_gongji2.getValue() * 0.1);
               use_baoji.setValue(use_baoji.getValue() + use_baoji.getValue() * 0.4);
               walk_power.setValue(walk_power.getValue() + 4);
               use_fangyu2.setValue(use_fangyu2.getValue() + use_fangyu2.getValue() * 0.1);
            }
            else
            {
               if(data.buffNine[1] > 0)
               {
                  use_fangyu.setValue(use_fangyu.getValue() + use_fangyu.getValue() * 0.1);
               }
               if(data.buffNine[2] > 0)
               {
                  use_mp_Max.setValue(use_mp_Max.getValue() + use_mp_Max.getValue() * 0.1);
               }
               if(data.buffNine[3] > 0)
               {
                  use_hp_Max.setValue(use_hp_Max.getValue() + use_hp_Max.getValue() * 0.1);
               }
               if(data.buffNine[4] > 0)
               {
                  use_gongji.setValue(use_gongji.getValue() + use_gongji.getValue() * 0.1);
               }
               if(data.buffNine[5] > 0)
               {
                  walk_power.setValue(walk_power.getValue() + 2);
               }
               if(data.buffNine[6] > 0)
               {
                  use_baoji.setValue(use_baoji.getValue() + use_baoji.getValue() * 0.2);
               }
               if(data.buffNine[7] > 0)
               {
                  use_fangyu2.setValue(use_fangyu2.getValue() + use_fangyu2.getValue() * 0.05);
               }
               if(data.buffNine[8] > 0)
               {
                  use_gongji2.setValue(use_gongji2.getValue() + use_gongji2.getValue() * 0.05);
               }
            }
         }
      }
      
      private function zhongQiuJiaCheng() : *
      {
         if(zhongqiuState == 2)
         {
            use_gongji.setValue(use_gongji.getValue() + use_gongji.getValue());
         }
      }
      
      private function chenghaoJiaCheng() : *
      {
         if(this.data.getTitleSlot().getTitleAttrib())
         {
            use_hp_Max.setValue(this.data.getTitleSlot().getTitleAttrib().getHP() + use_hp_Max.getValue());
            use_baoji.setValue(this.data.getTitleSlot().getTitleAttrib().getCrit() + use_baoji.getValue());
            use_gongji.setValue(this.data.getTitleSlot().getTitleAttrib().getAttack() + use_gongji.getValue());
            use_fangyu.setValue(this.data.getTitleSlot().getTitleAttrib().getDefense() + use_fangyu.getValue());
            use_mp_Max.setValue(this.data.getTitleSlot().getTitleAttrib().getMP() + use_mp_Max.getValue());
            walk_power.setValue(this.data.getTitleSlot().getTitleAttrib().getMoveSpeed() + walk_power.getValue());
         }
      }
      
      private function jinglingjiacheng() : *
      {
         if(this.data.playerJL_Data)
         {
            use_hp_Max.setValue(int(this.data.playerJL_Data.getHP() * 13.3) + use_hp_Max.getValue());
            use_baoji.setValue(int(this.data.playerJL_Data.getCRIT() * 7.3) + use_baoji.getValue());
            use_gongji.setValue(int(this.data.playerJL_Data.getATT()) + use_gongji.getValue());
            use_fangyu.setValue(int(this.data.playerJL_Data.getDEF() * 1.9) + use_fangyu.getValue());
            use_mp_Max.setValue(int(this.data.playerJL_Data.getMP() * 8.8) + use_mp_Max.getValue());
         }
         use_hp_Max.setValue(this.data.getElvesSlot().backElvesSkill1() * use_hp_Max.getValue() + use_hp_Max.getValue());
         use_fangyu.setValue(this.data.getElvesSlot().backElvesSkill4() * use_fangyu.getValue() + use_fangyu.getValue());
      }
      
      private function stampjiacheng() : *
      {
         num_gj.setValue(data.getStampSlot().getValueSlot3() + num_gj.getValue());
         num_fy.setValue(data.getStampSlot().getValueSlot4() + num_fy.getValue());
         walk_power.setValue(data.getStampSlot().getValueSlot7() + walk_power.getValue());
      }
      
      private function stampjiacheng2() : *
      {
         use_hp_Max.setValue(use_hp_Max.getValue() + data.getStampSlot().getValueSlot5());
         use_gongji.setValue(use_gongji.getValue() + data.getStampSlot().getValueSlot6());
      }
      
      private function XingLingJiaCeng() : *
      {
         var _loc1_:Array = XingLingFactory.GetTolal_Data_VT();
         use_hp_Max.setValue(use_hp_Max.getValue() + _loc1_[1].getValue());
         use_mp_Max.setValue(use_mp_Max.getValue() + _loc1_[2].getValue());
         use_gongji.setValue(use_gongji.getValue() + _loc1_[3].getValue());
         use_fangyu.setValue(use_fangyu.getValue() + _loc1_[4].getValue());
         use_baoji.setValue(use_baoji.getValue() + _loc1_[5].getValue());
         use_sanbi.setValue(use_sanbi.getValue() + _loc1_[6].getValue());
         use_gongji2.setValue(use_gongji2.getValue() + _loc1_[7].getValue());
         use_fangyu2.setValue(use_fangyu2.getValue() + _loc1_[8].getValue());
      }
      
      private function cardjiacheng() : *
      {
         if(CardPanel.monsterSlot)
         {
            use_hp_Max.setValue(int(CardPanel.monsterSlot.getAllHpup()) + use_hp_Max.getValue());
            use_baoji.setValue(int(CardPanel.monsterSlot.getAllCritup()) + use_baoji.getValue());
            use_gongji.setValue(int(CardPanel.monsterSlot.getAllAttup()) + use_gongji.getValue());
            use_fangyu.setValue(int(CardPanel.monsterSlot.getAllDefup()) + use_fangyu.getValue());
            use_mp_Max.setValue(int(CardPanel.monsterSlot.getAllMpup()) + use_mp_Max.getValue());
         }
      }
      
      private function chongwujiacheng() : *
      {
         if(playerCW)
         {
            num_hp.setValue(playerCW.data.getLife() + num_hp.getValue());
            num_bj.setValue(playerCW.data.getCrit() + num_bj.getValue());
            num_gj.setValue(playerCW.data.getAtt() + num_gj.getValue());
            num_fy.setValue(playerCW.data.getDef() + num_fy.getValue());
         }
      }
      
      private function QiangHuaJiaCheng() : *
      {
         var _loc1_:int = data.getEquipSlot().getSuitStrength();
         if(_loc1_ < 4)
         {
            return;
         }
         switch(_loc1_)
         {
            case 4:
               num_hp.setValue(num_hp.getValue() + num_1.getValue());
               break;
            case 5:
               num_hp.setValue(num_hp.getValue() + num_15.getValue());
               num_bj.setValue(num_bj.getValue() + num_1.getValue());
               break;
            case 6:
               num_hp.setValue(num_hp.getValue() + num_15.getValue());
               num_bj.setValue(num_bj.getValue() + num_15.getValue());
               num_sd.setValue(num_sd.getValue() + 1);
               break;
            case 7:
               num_hp.setValue(num_hp.getValue() + num_15.getValue());
               num_bj.setValue(num_bj.getValue() + num_20.getValue());
               num_fy.setValue(num_fy.getValue() + num_7.getValue());
               num_sd.setValue(num_sd.getValue() + 1);
               break;
            case 8:
               num_hp.setValue(num_hp.getValue() + num_20.getValue());
               num_bj.setValue(num_bj.getValue() + num_25.getValue());
               num_fy.setValue(num_fy.getValue() + num_7.getValue());
               num_sd.setValue(num_sd.getValue() + 1);
               break;
            case 9:
               num_hp.setValue(num_hp.getValue() + num_20.getValue());
               num_bj.setValue(num_bj.getValue() + num_25.getValue());
               num_fy.setValue(num_fy.getValue() + num_1.getValue());
               num_sd.setValue(num_sd.getValue() + 1);
               num_gj.setValue(num_gj.getValue() + num_5.getValue());
               break;
            case 10:
               num_hp.setValue(num_hp.getValue() + num_27.getValue());
               num_bj.setValue(num_bj.getValue() + num_25.getValue());
               num_fy.setValue(num_fy.getValue() + num_15.getValue());
               num_sd.setValue(num_sd.getValue() + 2);
               num_gj.setValue(num_gj.getValue() + num_32.getValue());
         }
      }
      
      private function TaoZhuangXiaoGuo() : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc1_:Array = XingLingFactory.GetTolal_Data_VT();
         var _loc2_:uint = uint(_loc1_[1].getValue());
         var _loc3_:uint = data.getStampSlot().getValueSlot5();
         for(_loc4_ in getAllSuitSkill)
         {
            if(getAllSuitSkill[_loc4_] == 57200)
            {
               _loc5_ = (temp_hp_Max.getValue() + _loc2_ + _loc3_) * 0.3;
               if(hp.getValue() < _loc5_)
               {
                  num_gj.setValue(num_gj.getValue() + num_13.getValue());
               }
            }
            if(getAllSuitSkill[_loc4_] == 57362)
            {
               _loc5_ = (temp_hp_Max.getValue() + _loc2_ + _loc3_) * 0.3;
               if(hp.getValue() < _loc5_)
               {
                  num_gj.setValue(num_gj.getValue() + num_65.getValue());
               }
            }
            else if(getAllSuitSkill[_loc4_] == 57201)
            {
               _loc5_ = (temp_hp_Max.getValue() + _loc2_ + _loc3_) * 0.4;
               if(hp.getValue() < _loc5_)
               {
                  num_fy.setValue(num_fy.getValue() + num_20.getValue());
               }
            }
            else if(getAllSuitSkill[_loc4_] == 57210)
            {
               _loc6_ = lianJi.getValue();
               if(_loc6_ > 2000)
               {
                  _loc6_ = 2000;
               }
               _loc7_ = _loc6_ / 10 * 0.01;
               if(_loc7_ > 5)
               {
                  _loc7_ = 5;
               }
               num_gj.setValue(num_gj.getValue() + _loc7_);
            }
            else if(getAllSuitSkill[_loc4_] == 57360)
            {
               lianjiBool = true;
               _loc6_ = lianJi.getValue();
               if(_loc6_ > 500)
               {
                  _loc6_ = 500;
               }
               _loc8_ = int(_loc6_ / 50);
               _loc7_ = _loc8_ * 0.23;
               if(_loc7_ > 5)
               {
                  _loc7_ = 5;
               }
               num_gj.setValue(num_gj.getValue() + _loc7_);
            }
         }
      }
      
      private function 数值溢出修正() : *
      {
         if(hp.getValue() > use_hp_Max.getValue())
         {
            hp.setValue(use_hp_Max.getValue());
         }
         if(mp.getValue() > use_mp_Max.getValue())
         {
            mp.setValue(use_mp_Max.getValue());
         }
      }
      
      private function HP_UP(param1:int) : *
      {
         if(param1 <= 0)
         {
            return;
         }
         var _loc2_:int = param1 + hp.getValue();
         if(_loc2_ > use_hp_Max.getValue())
         {
            hp.setValue(use_hp_Max.getValue());
         }
         else
         {
            hp.setValue(_loc2_);
         }
      }
      
      private function MP_UP(param1:int) : *
      {
         if(param1 <= 0)
         {
            return;
         }
         var _loc2_:int = param1 + mp.getValue();
         if(_loc2_ > use_mp_Max.getValue())
         {
            mp.setValue(use_mp_Max.getValue());
         }
         else
         {
            mp.setValue(_loc2_);
         }
      }
      
      public function 连击计数() : *
      {
         lianJiTime = VT.createVT();
         lianJi.setValue(lianJi.getValue() + 1);
         WinShow.LianJi(lianJi.getValue());
         JingLing.lianJiNumXX1010(this);
      }
      
      private function 连击计时() : *
      {
         if(lianJiTime.getValue() < 60)
         {
            lianJiTime.setValue(lianJiTime.getValue() + 1);
         }
         else if(lianjiBool)
         {
            if(lianJiTime.getValue() < 87)
            {
               lianJiTime.setValue(lianJiTime.getValue() + 1);
            }
            else
            {
               lianJi = VT.createVT();
            }
            lianjiBool = false;
         }
         else
         {
            lianJi = VT.createVT();
         }
      }
      
      public function GetAllSkillCD() : *
      {
         var _loc1_:int = 0;
         AllSkillCD = data.skillCdArr();
         AllSkillCDXX = DeepCopyUtil.clone(AllSkillCD);
         for(_loc1_ in AllSkillCD)
         {
            AllSkillCDXX[_loc1_][2] = 1;
            AllSkillCDXX[_loc1_][1] = 0;
            if(data.getSkillLevel(AllSkillCDXX[_loc1_][0]) > 0)
            {
               AllSkillCDXX[_loc1_][2] = 50;
               AllSkillCDXX[_loc1_][1] = AllSkillCD[_loc1_][1];
            }
         }
      }
      
      public function GetAllObjCD() : *
      {
         var _loc1_:int = 0;
         All_ObjCD = data.ObjCdArr();
         All_ObjCDXX = DeepCopyUtil.clone(All_ObjCD);
         for(_loc1_ in All_ObjCD)
         {
            All_ObjCDXX[_loc1_][2] = 50;
         }
      }
      
      public function GetKeyArr(param1:Array) : *
      {
         var _loc2_:int = 0;
         if(param1.length == data._keyArr.length)
         {
            _loc2_ = 0;
            while(_loc2_ < data._keyArr.length)
            {
               if(param1[_loc2_] is int)
               {
               }
               _loc2_++;
            }
            this.KeyArr = data._keyArr;
         }
      }
      
      private function xuemaiHuiFu() : *
      {
         if(Boolean(NewPetPanel.XueMai) && Boolean(playerCW))
         {
            if(NewPetPanel.XueMai.isHaveSX(11))
            {
               ++xuemaiTime;
               if(xuemaiTime >= 20 * 27)
               {
                  HpUp(500);
                  xuemaiTime = 0;
               }
            }
            if(NewPetPanel.XueMai.isHaveSX(12))
            {
               ++xuemaiTime2;
               if(xuemaiTime2 >= 20 * 27)
               {
                  MpUp(200);
                  xuemaiTime2 = 0;
               }
            }
         }
      }
      
      private function DKTime() : *
      {
         var _loc1_:int = 0;
         if(isDarkState)
         {
            ++darkTime;
            _loc1_ = 5 * 27;
            if(Boolean(data.getEquipSlot().getEquipFromSlot(7)) && Boolean(data.getEquipSlot().getEquipFromSlot(7).getFrame() == 405) && data.getEquipSlot().getEquipFromSlot(7).getRemainingTime() > 0)
            {
               _loc1_ = 10 * 27;
            }
            if(darkTime < _loc1_)
            {
               this.addChild(dkState);
            }
            else
            {
               this.removeChild(dkState);
               isDarkState = false;
               darkTime = 0;
            }
         }
      }
      
      private function onENTER_FRAME(param1:*) : *
      {
         ++szCD;
         ++time;
         DKTime();
         连击计时();
         nineBuffTime();
         药品使用();
         xuemaiHuiFu();
         chibangFeiXing();
         shizhuangPenShe();
         if(isDead || this.hp.getValue() <= 0)
         {
            hp.setValue(0);
            isDead = true;
            this.skin.visible = false;
            不信春哥();
            return;
         }
         if(!isDead)
         {
            this.skin.visible = true;
         }
         LoadAll_ZB_Skill();
         if(Main.world)
         {
            CDtime();
            SkinValue();
            KeyControl();
            MoveData();
            MoveRun();
         }
         if(Boolean(data.getEquipSlot().getEquipFromSlot(6) && skin_Z2) && Boolean(skin_Z2_V) && data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
         {
            skin_Z2.visible = true;
            skin_Z.visible = false;
         }
      }
      
      public function 双手加成() : *
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         shuangShouBeiShu = 1;
         if(data.isTransferOk())
         {
            _loc1_ = data.getTransferOk();
            _loc2_ = data.getEquipSlot().getEquipFromSlot(2).getPosition();
            _loc3_ = data.getEquipSlot().getEquipFromSlot(5).getPosition();
            for(_loc4_ in _loc1_)
            {
               if(_loc1_[_loc4_] == 0)
               {
                  if(_loc2_ == _loc3_ && _loc3_ == 5)
                  {
                     shuangShouBeiShu = Temp11.getValue();
                     return;
                  }
               }
               else if(_loc1_[_loc4_] == 1)
               {
                  if(_loc2_ == _loc3_ && _loc3_ == 6)
                  {
                     shuangShouBeiShu = Temp11.getValue();
                     return;
                  }
               }
               else if(_loc1_[_loc4_] == 2)
               {
                  if(_loc2_ == _loc3_ && _loc3_ == 7)
                  {
                     shuangShouBeiShu = Temp11.getValue();
                     return;
                  }
               }
            }
         }
      }
      
      private function HeadXX() : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Equip = data.getEquipSlot().getEquipFromSlot(0);
         var _loc2_:Equip = data.getEquipSlot().getEquipFromSlot(1);
         if(Main.water.getValue() != 1)
         {
            _loc1_ = data.getEquipSlot().getEquipFromSlot(8);
         }
         if(Boolean(skin_Z2) && Boolean(skin_Z2_V) && data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
         {
            _loc3_ = int(data.getEquipSlot().getEquipFromSlot(6).getClassName2());
            headFrame = _loc3_;
            noHead = false;
            this.paiHangShow[1] = headFrame;
         }
         else if(Boolean(data) && Boolean(_loc1_))
         {
            _loc4_ = int(_loc1_.getClassName());
            headFrame = _loc4_;
            noHead = false;
            if(_loc4_ == 24)
            {
               if(Boolean(_loc2_) && Boolean(_loc2_.getClassName() == "甲红10") && Main.water.getValue() == 1)
               {
                  this.paiHangShow[1] = 0;
                  noHead = true;
               }
               else
               {
                  this.paiHangShow[1] = headFrame;
                  noHead = false;
               }
               TiaoShi.txtShow("发型0 = ???");
            }
            if(Boolean(_loc2_) && _loc2_.getClassName() == "甲红6")
            {
               if(Main.water.getValue() != 1)
               {
                  eadFrame = 1;
                  noHead = false;
               }
               else
               {
                  eadFrame = 53;
                  noHead = true;
               }
               TiaoShi.txtShow("发型1 = " + _loc2_.getClassName());
            }
         }
         else
         {
            headFrame = 1;
            if(Boolean(_loc2_) && Boolean(_loc2_.getClassName() == "甲红10") && Main.water.getValue() == 1)
            {
               this.paiHangShow[1] = 0;
               noHead = true;
            }
            else
            {
               this.paiHangShow[1] = 1;
               noHead = false;
            }
            if(Boolean(_loc2_) && _loc2_.getClassName() == "甲红6")
            {
               if(Main.water.getValue() != 1)
               {
                  eadFrame = 1;
                  noHead = false;
               }
               else
               {
                  eadFrame = 53;
                  noHead = true;
               }
               TiaoShi.txtShow("发型2 = " + _loc2_.getClassName());
            }
         }
      }
      
      private function CDtime() : *
      {
         var _loc1_:int = 0;
         for(_loc1_ in AllSkillCDXX)
         {
            if(AllSkillCDXX[_loc1_][1] < AllSkillCD[_loc1_][1] && data.getSkillLevel(AllSkillCDXX[_loc1_][0]) > 0)
            {
               ++AllSkillCDXX[_loc1_][1];
               AllSkillCDXX[_loc1_][2] = int(AllSkillCDXX[_loc1_][1] / AllSkillCD[_loc1_][1] * 50);
            }
         }
         for(_loc1_ in All_ObjCDXX)
         {
            if(All_ObjCDXX[_loc1_][1] < All_ObjCD[_loc1_][1])
            {
               ++All_ObjCDXX[_loc1_][1];
               All_ObjCDXX[_loc1_][2] = int(All_ObjCDXX[_loc1_][1] / All_ObjCD[_loc1_][1] * 50);
            }
         }
      }
      
      private function selCD(param1:String) : int
      {
         var _loc2_:int = 0;
         for(_loc2_ in AllSkillCDXX)
         {
            if(AllSkillCDXX[_loc2_][0] == param1)
            {
               if(AllSkillCDXX[_loc2_][1] == AllSkillCD[_loc2_][1])
               {
                  return _loc2_;
               }
               return -1;
            }
         }
         return -1;
      }
      
      private function sel_objCD(param1:String) : int
      {
         var _loc2_:int = 0;
         for(_loc2_ in All_ObjCD)
         {
            if(All_ObjCDXX[_loc2_][0] == param1)
            {
               if(All_ObjCDXX[_loc2_][1] == All_ObjCD[_loc2_][1])
               {
                  return _loc2_;
               }
               return -1;
            }
         }
         return -1;
      }
      
      public function selCD50(param1:String) : int
      {
         var _loc2_:int = 0;
         for(_loc2_ in AllSkillCDXX)
         {
            if(AllSkillCDXX[_loc2_][0] == param1)
            {
               return AllSkillCDXX[_loc2_][2];
            }
         }
         return 50;
      }
      
      public function sel_objCD50(param1:String) : int
      {
         var _loc2_:int = 0;
         for(_loc2_ in All_ObjCDXX)
         {
            if(All_ObjCDXX[_loc2_][0] == param1)
            {
               return All_ObjCDXX[_loc2_][2];
            }
         }
         return 50;
      }
      
      public function wudi(param1:*) : *
      {
         ++timeTemp;
         if(timeTemp > 81)
         {
            removeChild(nodead);
            rexuewudi = false;
            timeTemp = 0;
            flagTempRX = true;
            removeEventListener(Event.ENTER_FRAME,wudi);
         }
      }
      
      public function timeLimitBJ(param1:*) : *
      {
         ++timeTemp;
         if(timeTemp > 54)
         {
            timeTemp = 0;
            flagTempBJ = true;
            removeEventListener(Event.ENTER_FRAME,timeLimitBJ);
         }
      }
      
      public function timeLimitSJ(param1:*) : *
      {
         ++timeTemp;
         if(timeTemp > 351)
         {
            timeTemp = 0;
            flagTempSJ = true;
            removeEventListener(Event.ENTER_FRAME,timeLimitSJ);
         }
      }
      
      public function timeLimitSY(param1:*) : *
      {
         ++timeTemp;
         if(timeTemp > 284)
         {
            timeTemp = 0;
            flagTempSY = true;
            removeEventListener(Event.ENTER_FRAME,timeLimitSY);
         }
      }
      
      public function timeLimitXL(param1:*) : *
      {
         ++timeTemp;
         if(timeTemp > 284)
         {
            timeTemp = 0;
            flagTempXL = true;
            removeEventListener(Event.ENTER_FRAME,timeLimitXL);
         }
      }
      
      public function timeLimitMP(param1:*) : *
      {
         ++timeTempmp;
         if(timeTempmp > 216)
         {
            timeTempmp = 0;
            flagTempMP = true;
            removeEventListener(Event.ENTER_FRAME,timeLimitMP);
         }
      }
      
      public function setInTimeCDMP() : *
      {
         addEventListener(Event.ENTER_FRAME,timeLimitMP);
      }
      
      public function setInTimeCDXL() : *
      {
         addEventListener(Event.ENTER_FRAME,timeLimitXL);
      }
      
      public function setInTimeCDBJ() : *
      {
         addEventListener(Event.ENTER_FRAME,timeLimitBJ);
      }
      
      public function setInTimeCDSJ() : *
      {
         addEventListener(Event.ENTER_FRAME,timeLimitSJ);
      }
      
      public function setInTimeCDSY() : *
      {
         addEventListener(Event.ENTER_FRAME,timeLimitSY);
      }
      
      public function HpXX(param1:*, param2:Boolean = false) : *
      {
         var _loc10_:Player2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Player = null;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Array = null;
         var _loc18_:Number = NaN;
         var _loc19_:HitXX = null;
         var _loc20_:Class = null;
         if(newLifeTime.getValue() > InitData.BuyNum_0.getValue() + InitData.BuyNum_1.getValue())
         {
            return;
         }
         if(noHit)
         {
            noHit = false;
            return;
         }
         if(noHit82)
         {
            return;
         }
         if(rexuewudi)
         {
            return;
         }
         if(param1 is HitXX)
         {
            hitXX = param1;
         }
         ++WinShow.txt_3;
         var _loc3_:Number = Number(param1.gongJi_hp);
         var _loc4_:int = int(param1.times);
         var _loc5_:int = 0;
         NewMC.Open("被攻击",this);
         if(_loc3_ == -1001)
         {
            _loc3_ = int(use_hp_Max.getValue() * 0.02);
         }
         if(param1.parent is Fly && (param1.parent as Fly)._name == "暗黑牢笼")
         {
            param1.parent.hitWho = this;
         }
         if(param1 is HitXX && param1.who is Player2)
         {
            _loc10_ = param1.who as Player2;
            _loc11_ = _loc10_.use_gongji.getValue();
            _loc12_ = 1;
            if(_loc10_.data.skinArr[_loc10_.data.skinNum] == 0)
            {
               _loc12_ = Number(_loc10_.职业附加[0]);
            }
            else if(_loc10_.data.skinArr[_loc10_.data.skinNum] == 1)
            {
               _loc12_ = Number(_loc10_.职业附加[1]);
            }
            else if(_loc10_.data.skinArr[_loc10_.data.skinNum] == 2)
            {
               _loc12_ = Number(_loc10_.职业附加[2]);
            }
            if(data.skinArr[data.skinNum] == 0 && skin.runType == "转职技能1" && skin.frame < 20)
            {
               if(data.getSkillLevel("a12") > 0)
               {
                  _loc3_ *= 0.3;
               }
            }
            _loc13_ = this.use_fangyu.getValue() + fangYuPOWER.getValue();
            _loc11_ = _loc10_.use_gongji.getValue();
            _loc5_ = _loc3_ * _loc12_ * _loc11_ - _loc13_ / _loc4_;
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            else
            {
               {};
            }
            _loc5_ += _loc3_ * (Math.random() * 3 + 2) / 100;
            if(param2)
            {
               _loc5_ *= tempXXX2.getValue();
            }
         }
         else if(Main.gameNum.getValue() == 0 && param1.who != this && param1 is HitXX && param1.who is Player)
         {
            _loc14_ = param1.who as Player;
            _loc11_ = _loc14_.use_gongji.getValue();
            _loc12_ = 1;
            if(_loc14_.data.skinArr[_loc14_.data.skinNum] == 0)
            {
               _loc12_ = Number(_loc14_.职业附加[0]);
            }
            else if(_loc14_.data.skinArr[_loc14_.data.skinNum] == 1)
            {
               _loc12_ = Number(_loc14_.职业附加[1]);
            }
            else if(_loc14_.data.skinArr[_loc14_.data.skinNum] == 2)
            {
               _loc12_ = Number(_loc14_.职业附加[2]);
            }
            if(data.skinArr[data.skinNum] == 0 && skin.runType == "转职技能1" && skin.frame < 20)
            {
               if(data.getSkillLevel("a12") > 0)
               {
                  _loc3_ *= 0.3;
               }
            }
            _loc13_ = this.use_fangyu.getValue() + fangYuPOWER.getValue();
            _loc11_ = _loc14_.use_gongji.getValue();
            _loc5_ = _loc3_ * _loc12_ * _loc11_ - _loc13_ / _loc4_;
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            else
            {
               {};
            }
            _loc5_ += _loc3_ * (Math.random() * 3 + 2) / 100;
            if(param2)
            {
               _loc5_ *= tempXXX2.getValue();
            }
         }
         else
         {
            if(data.skinArr[data.skinNum] == 0 && skin.runType == "转职技能1" && skin.frame < 20)
            {
               if(data.getSkillLevel("a12") > 0)
               {
                  _loc3_ *= 0.3;
               }
            }
            _loc13_ = this.use_fangyu.getValue() + fangYuPOWER.getValue();
            _loc5_ = _loc3_ - _loc13_ / _loc4_;
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            else
            {
               {};
            }
            _loc5_ += _loc3_ * (Math.random() * 3 + 2) / 100;
            if(param2)
            {
               _loc5_ *= tempXXX2.getValue();
            }
         }
         if(param1.who is Enemy && Main.water.getValue() != 1)
         {
            _loc5_ = _loc5_ * (1 + (param1.who as Enemy).魔攻力.getValue() / 100) / (1 + this.use_fangyu2.getValue() / 100);
         }
         if(lianJi.getValue() > 50 && this.data.getElvesSlot().backElvesSkill5() > 0)
         {
            _loc5_ *= 1 - this.data.getElvesSlot().backElvesSkill5();
         }
         if(Boolean(NewPetPanel.XueMai) && Boolean(playerCW))
         {
            if(NewPetPanel.XueMai.isHaveSX(4))
            {
               _loc5_ *= 0.95;
            }
         }
         if(data.getEquipSlot().getEquipFromSlot(6))
         {
            if(data.getEquipSlot().getEquipFromSlot(6).getFrame() == 415)
            {
               _loc5_ *= 0.9;
            }
         }
         if(data.getEquipSlot().getEquipFromSlot(7))
         {
            if(data.getEquipSlot().getEquipFromSlot(7).getFrame() == 416)
            {
               _loc5_ *= 0.9;
            }
         }
         if(speedTemp.getValue() <= -6)
         {
            _loc5_ += use_hp_Max.getValue() * 0.02;
         }
         _loc5_ *= this.jianSang_UP;
         if(data.getStampSlot().getValueSlot8() > 0)
         {
            _loc5_ -= _loc5_ * data.getStampSlot().getValueSlot8();
         }
         if(jianrenState == 2)
         {
            _loc5_ *= 0.7;
         }
         var _loc6_:int = this.x + Math.random() * 50 - 25;
         var _loc7_:int = this.y + Math.random() * 50 - 25;
         if(Skin.xishouWuDi)
         {
            if(Skin.xishouHP > 0)
            {
               Skin.xishouHP -= _loc5_;
               NewMC.Open("闪避2",Main.world.moveChild_Other,_loc6_,_loc7_,15,0,true,2);
            }
            else
            {
               Skin.xishouWuDi = false;
            }
            return;
         }
         if(Main.gameNum.getValue() == 999 && _loc5_ > param1.gongJi_hp_MAX)
         {
            _loc5_ = int(param1.gongJi_hp_MAX);
            if(param1.gongJi_hp_MAX > 300000 && hitXX.who is Player2)
            {
               (hitXX.who as Player2).hp.setValue(0);
               TiaoShi.txtShow("清除秒杀玩家,重新加载~~~~");
               return;
            }
         }
         if(param1.parent is Fly && (param1.parent as Fly)._name == "灵魂抽取")
         {
            for(_loc15_ in Enemy.All)
            {
               if(Boolean(Enemy.All[_loc15_]) && (Enemy.All[_loc15_] as Enemy).id == 3022)
               {
                  (Enemy.All[_loc15_] as Enemy).hpUpEnemy(_loc5_);
                  NewMC.Open("回血效果",Enemy.All[_loc15_],0,0,0,_loc5_);
                  TiaoShi.txtShow("回复" + _loc5_);
               }
            }
         }
         if(param1.who is Enemy && (param1.who as Enemy).id == 2015)
         {
            _loc5_ = use_hp_Max.getValue() * 0.02;
         }
         var _loc8_:int = hp.getValue() - _loc5_;
         if(_loc8_ <= 0)
         {
            _loc16_ = 0;
            _loc17_ = data.getEquipSlot().getAllSuitSkill();
            for(_loc15_ in _loc17_)
            {
               if(_loc17_[_loc15_] == 57362)
               {
                  if(Boolean(getRandom(50)) && flagTempRX && Main.gameNum.getValue() != 999)
                  {
                     addChild(nodead);
                     rexuewudi = true;
                     addEventListener(Event.ENTER_FRAME,wudi);
                     flagTempRX = false;
                     _loc16_ = 1;
                  }
               }
            }
            hp.setValue(_loc16_);
         }
         else
         {
            hp.setValue(_loc8_);
         }
         if(hp.getValue() <= 0)
         {
            isDead = true;
         }
         if(_loc5_ == 0)
         {
            NewMC.Open("闪避2",Main.world.moveChild_Other,_loc6_,_loc7_,15,0,true,2);
         }
         else if(!param2)
         {
            NewMC.Open("_被打数字",Main.world.moveChild_Other,_loc6_,_loc7_,15,_loc5_,true,2);
         }
         else
         {
            NewMC.Open("_暴击数字",Main.world.moveChild_Other,_loc6_,_loc7_,20,_loc5_,true);
         }
         if(Boolean(this.playerJL) && param1.who is Enemy)
         {
            this.playerJL.BD1009(param1.who,_loc5_);
         }
         if(data.getEquipSlot().getEquipFromSlot(6))
         {
            if(data.getEquipSlot().getEquipFromSlot(6).getId() == 14455 || data.getEquipSlot().getEquipFromSlot(6).getId() == 14461 || data.getEquipSlot().getEquipFromSlot(6).getId() == 14462 || data.getEquipSlot().getEquipFromSlot(6).getId() == 14463 || data.getEquipSlot().getEquipFromSlot(6).getId() == 14464 || data.getEquipSlot().getEquipFromSlot(6).getId() == 14465)
            {
               _loc18_ = Math.random() * 20;
               if(_loc18_ < 1)
               {
                  if(Main.gameNum.getValue() == 999)
                  {
                     if(hp.getValue() > 0)
                     {
                        hp.setValue(hp.getValue() + Math.round(use_hp_Max.getValue() / 5 / InitData.pkHpMaxNum_Player.getValue()));
                        NewMC.Open("回血效果",this,0,0,0,Math.round(use_hp_Max.getValue() / 5 / InitData.pkHpMaxNum_Player.getValue()));
                     }
                  }
                  else if(hp.getValue() > 0)
                  {
                     hp.setValue(hp.getValue() + Math.round(use_hp_Max.getValue() / 5));
                     NewMC.Open("回血效果",this,0,0,0,Math.round(use_hp_Max.getValue() / 5));
                  }
               }
            }
            else if(data.getEquipSlot().getEquipFromSlot(6).getId() >= 14622 && data.getEquipSlot().getEquipFromSlot(6).getId() <= 14627 || data.getEquipSlot().getEquipFromSlot(6).getId() >= 14613 && data.getEquipSlot().getEquipFromSlot(6).getId() <= 14618)
            {
               if(hitXX.who is Enemy)
               {
                  _loc19_ = new HitXX();
                  _loc19_.who = this;
                  _loc19_.type = 102;
                  _loc19_.space = 81;
                  _loc19_.totalTime = 81;
                  _loc19_.numValue = 0;
                  if(iceTIME == 0)
                  {
                     addEventListener(Event.ENTER_FRAME,iceCD);
                     _loc18_ = Math.round(Math.random() * 100);
                     if(_loc18_ <= 25)
                     {
                        new BuffEnemy(_loc19_,hitXX.who);
                     }
                  }
               }
            }
            else if(data.getEquipSlot().getEquipFromSlot(6).getFrame() == 415)
            {
               if(szCD > 54)
               {
                  szCD = 0;
                  if(Math.random() * 100 < 30)
                  {
                     _loc20_ = NewLoad.XiaoGuoData.getClass("时装冲击波") as Class;
                     skin_W.addChild(new _loc20_());
                     kouxue = true;
                     tankaiTime = 0;
                     addEventListener(Event.ENTER_FRAME,tankai);
                  }
               }
            }
         }
         var _loc9_:int = param1.硬直 - this.skin.被攻击硬直;
         if(Boolean(param1.who) && param1.who is Player2)
         {
            _loc9_ = _loc9_ / 5 * 4;
         }
         if(noYingZhi)
         {
            _loc9_ = -1;
         }
         if(_loc9_ > skin.continuousTime && _loc9_ >= 0)
         {
            skin.GoTo("被打",_loc9_);
         }
         runArr = new Array();
         if(!noYingZhi)
         {
            if(param1.RL)
            {
               runPower(param1.runArr[0],param1.runArr[1],param1.runArr[2]);
            }
            else
            {
               runPower(-param1.runArr[0],param1.runArr[1],param1.runArr[2]);
            }
         }
      }
      
      private function tankai(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:HitXX = null;
         ++tankaiTime;
         if(tankaiTime < 9)
         {
            for(_loc2_ in Enemy.All)
            {
               if((Enemy.All[_loc2_] as Enemy).isFunction)
               {
                  _loc3_ = Enemy.All[_loc2_].x - this.x;
                  if(_loc3_ < 300 && _loc3_ >= 0)
                  {
                     Enemy.All[_loc2_].x += 33;
                     if(kouxue)
                     {
                        _loc4_ = new HitXX();
                        _loc4_.who = this;
                        _loc4_.gongJi_hp = 1;
                        _loc4_.times = 1;
                        (Enemy.All[_loc2_] as Enemy).HpXX(_loc4_);
                     }
                     if(Math.random() * 100 < 15)
                     {
                        if(Boolean(data.getEquipSlot().getEquipFromSlot(7)) && data.getEquipSlot().getEquipFromSlot(7).getFrame() == 416)
                        {
                           Enemy.All[_loc2_].skin.GoTo("被打",27);
                        }
                     }
                  }
                  if(_loc3_ > -300 && _loc3_ < 0)
                  {
                     Enemy.All[_loc2_].x -= 33;
                     if(kouxue)
                     {
                        _loc4_ = new HitXX();
                        _loc4_.who = this;
                        _loc4_.gongJi_hp = 1;
                        _loc4_.times = 1;
                        (Enemy.All[_loc2_] as Enemy).HpXX(_loc4_);
                     }
                     if(Math.random() * 100 < 15)
                     {
                        if(Boolean(data.getEquipSlot().getEquipFromSlot(7)) && data.getEquipSlot().getEquipFromSlot(7).getFrame() == 416)
                        {
                           Enemy.All[_loc2_].skin.GoTo("被打",27);
                        }
                     }
                  }
               }
            }
            kouxue = false;
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,tankai);
         }
      }
      
      private function iceCD(param1:*) : *
      {
         ++iceTIME;
         if(iceTIME == 135)
         {
            iceTIME = 0;
            removeEventListener(Event.ENTER_FRAME,iceCD);
         }
      }
      
      private function getRandom(param1:Number) : Boolean
      {
         var _loc2_:Number = Math.random() * 100;
         if(_loc2_ < param1)
         {
            return true;
         }
         return false;
      }
      
      private function SkinValue() : *
      {
         if(skin != null)
         {
            this.gravity = this.skin.gravity;
            if(skin.moveArr != null)
            {
               if(RL)
               {
                  runPower(skin.moveArr[0],skin.moveArr[1],skin.moveArr[2]);
               }
               else
               {
                  runPower(-skin.moveArr[0],skin.moveArr[1],skin.moveArr[2]);
               }
            }
         }
      }
      
      private function onKEY_DOWN(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == data._keyArr[5])
         {
            jKey = true;
         }
      }
      
      private function KeyControl() : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:Class = null;
         if(DuoKai_Info._noSave)
         {
            return;
         }
         if(!skin)
         {
            return;
         }
         if(skin.continuousTime > 0)
         {
            return;
         }
         if(!this.skin.Get_StopRun())
         {
            if(jumping > 0 && skin.runType.substr(0,2) == "攻击")
            {
               MoveFun();
            }
            return;
         }
         if(jumping > 0 && getKeyStatus("跳",1) && !PK_UI.PK_ing)
         {
            if(mp.getValue() < 1)
            {
               mp.setValue(1);
               fly = false;
               flyTime = 0;
            }
            else
            {
               fly = true;
            }
         }
         if(getKeyStatus("跳",2) == false)
         {
            flyTime = 0;
         }
         if(PK_UI.PK_ing)
         {
            fly = false;
            flyTime = 0;
         }
         if(Boolean(fly && mp.getValue() > 1 && getKeyStatus("跳",2) && skin_Z3_V) && Boolean(data.getEquipSlot().getEquipFromSlot(7)) && data.getEquipSlot().getEquipFromSlot(7).getColor() >= 4)
         {
            _loc2_ = 2;
            ++flyTime;
            if(data.getEquipSlot().getEquipFromSlot(6))
            {
               if(data.getEquipSlot().getEquipFromSlot(6).getFrame() == 423)
               {
                  _loc2_ = 4;
               }
            }
            if(flyTime > 4)
            {
               feixingBool3 = true;
               if(flyTime % 24 == 10)
               {
                  _loc5_ = mp.getValue() - use_mp_Max.getValue() / 100 * _loc2_;
                  if(_loc5_ < 1)
                  {
                     this.mp.setValue(1);
                  }
                  else
                  {
                     this.mp.setValue(_loc5_);
                  }
               }
               gravity = gravityNum = 0;
               _loc3_ = walk_power.getValue() * 1.5;
               _loc4_ = data.getEquipSlot().getEquipFromSlot(7).getId();
               if(_loc4_ >= 14604 && _loc4_ <= 14609)
               {
                  _loc3_ += 2;
               }
               if(getKeyStatus("左",2))
               {
                  runPower(-_loc3_,0,1);
                  getRL(false);
               }
               if(getKeyStatus("右",2))
               {
                  runPower(_loc3_,0,1);
                  getRL(true);
               }
               if(getKeyStatus("上",2))
               {
                  runPower(0,8,1);
               }
               if(getKeyStatus("下",2))
               {
                  runPower(0,-8,1);
               }
               SkinPlay("跳");
               return;
            }
         }
         else
         {
            feixingBool3 = false;
         }
         if(jKey && (jumping == 0 || Boolean(jumpX2) && jumping < 2))
         {
            jKey = false;
            runPower(0,jump_power,jump_time,"跳");
            SkinPlay("跳");
            jumping += 1;
            if(Boolean(jumpX2) && jumping == 2)
            {
               NewMC.Open("二段跳效果",Main.world.moveChild_Other,this.x,this.y);
            }
         }
         else if(jKey)
         {
            jKey = false;
         }
         var _loc1_:String = "站";
         if(getKeyStatus("左",3))
         {
            _loc1_ = "跑";
            if(!noMove)
            {
               runPower(-walk_power.getValue() * 1.5,0,1);
            }
            getRL(false);
         }
         else if(getKeyStatus("右",3))
         {
            _loc1_ = "跑";
            if(!noMove)
            {
               runPower(walk_power.getValue() * 1.5,0,1);
            }
            getRL(true);
         }
         else if(getKeyStatus("左",2))
         {
            _loc1_ = "走";
            if(!noMove)
            {
               runPower(-walk_power.getValue(),0,1);
            }
            getRL(false);
         }
         else if(getKeyStatus("右",2))
         {
            _loc1_ = "走";
            if(!noMove)
            {
               runPower(walk_power.getValue(),0,1);
            }
            getRL(true);
         }
         if(getKeyStatus("攻击",1))
         {
            if(_loc1_ == "跑" && jumping == 0)
            {
               SkinPlay("跑攻");
            }
            else if(getKeyStatus("上",2))
            {
               SkinPlay("上挑");
            }
            else if(getKeyStatus("下",2))
            {
               SkinPlay("下斩");
            }
            else if(jumping > 0)
            {
               SkinPlay("攻击1");
               if(isDarkState)
               {
                  _loc6_ = NewLoad.XiaoGuoData.getClass("时装死灵球") as Class;
                  this.skin_W.addChild(new _loc6_());
               }
            }
            else
            {
               skin.timeNum = 15;
               SkinPlay("攻击");
               if(isDarkState)
               {
                  _loc6_ = NewLoad.XiaoGuoData.getClass("时装死灵球") as Class;
                  this.skin_W.addChild(new _loc6_());
               }
            }
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 2)
            {
               fbChengFa = true;
            }
         }
         else if(getKeyStatus("怪物",1))
         {
            SkinPlay("怪物技能");
         }
         else if(getKeyStatus("技能1",1))
         {
            SkinPlay("技能1");
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
            {
               fbChengFa = true;
            }
         }
         else if(getKeyStatus("技能2",1))
         {
            SkinPlay("技能2");
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
            {
               fbChengFa = true;
            }
         }
         else if(getKeyStatus("技能3",1))
         {
            SkinPlay("技能3");
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
            {
               fbChengFa = true;
            }
         }
         else if(getKeyStatus("技能4",1))
         {
            SkinPlay("技能4");
            if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
            {
               fbChengFa = true;
            }
         }
         else if(getKeyStatus("转职",1))
         {
            if(getKeyStatus("上",3))
            {
               SkinPlay("转职技能4");
               if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
               {
                  fbChengFa = true;
               }
            }
            else if(getKeyStatus("下",2))
            {
               SkinPlay("转职技能3");
               if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
               {
                  fbChengFa = true;
               }
            }
            else if(getKeyStatus("上",2))
            {
               SkinPlay("转职技能2");
               if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
               {
                  fbChengFa = true;
               }
            }
            else
            {
               SkinPlay("转职技能1");
               if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 3)
               {
                  fbChengFa = true;
               }
            }
         }
         else if(jumping == 0)
         {
            SkinPlay(_loc1_);
         }
         else
         {
            SkinPlay("跳");
         }
         --SwitchingTime;
         if(getKeyStatus("切换",1) && SwitchingTime <= 0)
         {
            SwitchingTime = 6;
            QieHuanSkin();
         }
      }
      
      public function QieHuanSkin() : *
      {
         if(NewLoad.loadArr.length > 0)
         {
            TiaoShi.txtShow("pk玩家加载中, 禁止切换");
            return;
         }
         if(data.skinNum == 0)
         {
            data.skinNum = 1;
            newSkin();
         }
         else
         {
            data.skinNum = 0;
            newSkin();
         }
      }
      
      private function 药品使用() : *
      {
         if(Boolean(GameOver.noFuHuo) || this.visible == false)
         {
            return;
         }
         if(getKeyStatus("消耗1",1))
         {
            UserObj(0);
         }
         else if(getKeyStatus("消耗2",1))
         {
            UserObj(1);
         }
         else if(getKeyStatus("消耗3",1))
         {
            UserObj(2);
         }
      }
      
      private function 复活药使用() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in Enemy.All)
         {
            if(Enemy.All[_loc1_].id == 3022)
            {
               Enemy.All[_loc1_].rebornTimes = 1;
               Enemy.All[_loc1_].skin.runOver = true;
               Enemy.All[_loc1_].skin.GoTo("攻击3");
            }
         }
         JiHua_Interface.ppp2_13 = true;
         信春哥();
         this.alpha = 0.7;
         newLifeTime.setValue(InitData.BuyNum_1.getValue());
         addEventListener(Event.ENTER_FRAME,NewLife);
         All[All.length] = this;
         GameData.deadTime = 5;
         newSkin();
      }
      
      private function 刷新背包显示() : *
      {
         BagItemsShow.suppliesShow();
      }
      
      private function NewLife(param1:*) : *
      {
         newLifeTime.setValue(newLifeTime.getValue() + InitData.BuyNum_1.getValue());
         if(newLifeTime.getValue() % 10 > 4)
         {
            this.alpha = 1;
         }
         else
         {
            this.alpha = 0.7;
         }
         if(newLifeTime.getValue() > InitData.BuyNum_80.getValue())
         {
            newLifeTime = VT.createVT();
            this.alpha = 1;
            removeEventListener(Event.ENTER_FRAME,NewLife);
         }
      }
      
      private function UserObj(param1:int) : *
      {
         var _loc4_:int = 0;
         var _loc5_:Supplies = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         if(Main.gameNum.getValue() == 84 && Boss84FP.paiState == 1)
         {
            fbChengFa = true;
         }
         if(this.data.getSuppliesSlot().getNumFromSuppliesSlot(this.data.getBag(),param1) < 1)
         {
            return;
         }
         if(this.hp.getValue() <= 0)
         {
            _loc5_ = this.data.getSuppliesSlot().getFromSuppliesSlot(param1);
            _loc6_ = _loc5_.getAffectMode();
            if(_loc6_ == 2)
            {
               if(Boolean(PK_JiFen_UI._this) && Boolean(PK_JiFen_UI._this.visible))
               {
                  return;
               }
               复活药使用();
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
               Main.Save(false);
            }
            return;
         }
         var _loc2_:String = this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getName();
         if(!CanUserObj(_loc2_))
         {
            return;
         }
         if(this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getAffectMode() == 3)
         {
            if(skillYAO >= 3)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"一关内最多使用3次，已达到上限");
               return;
            }
            if(data.skinNum == 0 && Boolean(this.data.getEquipSkillSlot().getGemFromSkillSlot(0)))
            {
               if(this.energySlot.getEnergyPer(this) < 100)
               {
                  this.energySlot.energyLeftNum.setValue(98745305);
               }
               ++skillYAO;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"技能石充能完毕！");
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
            }
            if(data.skinNum == 1 && Boolean(this.data.getEquipSkillSlot().getGemFromSkillSlot(1)))
            {
               if(this.energySlot.getEnergyPer(this) < 100)
               {
                  this.energySlot.energyRightNum.setValue(92145035);
               }
               ++skillYAO;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"技能石充能完毕！");
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
            }
         }
         if(this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getAffectMode() == 5)
         {
            if(JingLingCatch.count == 1)
            {
               if(JingLingCatch.isMove)
               {
                  JingLingCatch.myplayer = this.data;
                  JingLingCatch.catchJL();
                  _loc7_ = int(sel_objCD(_loc2_));
                  All_ObjCDXX[_loc7_][1] = 0;
                  this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵正在被捕捉中");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"没有发现精灵踪迹");
            }
         }
         if(this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getAffectMode() == 6)
         {
            if(zhongqiuState == 0)
            {
               if(Main.gameNum.getValue() > 0 && Main.gameNum.getValue() < 999 && GameData.gameLV < 5)
               {
                  zhongqiuState = 2;
               }
               else
               {
                  zhongqiuState = 1;
               }
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"已经处于疯狂状态");
            }
         }
         if(this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getAffectMode() == 7)
         {
            if(jianrenState == 0)
            {
               if(Main.gameNum.getValue() > 0 && Main.gameNum.getValue() < 999 && GameData.gameLV < 5)
               {
                  jianrenState = 2;
               }
               else
               {
                  jianrenState = 1;
               }
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"已经处于坚韧状态");
            }
         }
         if(this.data.getSuppliesSlot().getFromSuppliesSlot(param1).getAffectMode() == 4)
         {
            _loc8_ = use_mp_Max.getValue() * InitData.zongzi.getValue();
            _loc9_ = mp.getValue() + _loc8_;
            _loc10_ = use_mp_Max.getValue();
            if(_loc9_ < _loc10_)
            {
               mp.setValue(_loc9_);
            }
            else
            {
               mp.setValue(_loc10_);
            }
            NewMC.Open("回蓝效果",this,0,0,0,_loc8_);
            _loc11_ = use_hp_Max.getValue() * InitData.zongzi.getValue();
            _loc9_ = hp.getValue() + _loc11_;
            _loc12_ = use_hp_Max.getValue();
            if(_loc9_ < _loc12_)
            {
               hp.setValue(_loc9_);
            }
            else
            {
               hp.setValue(_loc12_);
            }
            NewMC.Open("回血效果",this,0,60,0,_loc11_);
            _loc7_ = int(sel_objCD(_loc2_));
            All_ObjCDXX[_loc7_][1] = 0;
            this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
         }
         XXSupplies = this.data.getSuppliesSlot().getFromSuppliesSlot(param1);
         var _loc3_:Array = XXSupplies.getAffectAttrib();
         for(_loc4_ in _loc3_)
         {
            _loc13_ = int((_loc3_[_loc4_] as SuppliesAffect).getAttribType());
            _loc14_ = int((_loc3_[_loc4_] as SuppliesAffect).getValue());
            _loc15_ = int(XXSupplies.getUseLevel());
            _loc19_ = int(XXSupplies.getPercent());
            if(_loc13_ == 1 && this.data.getLevel() >= _loc15_)
            {
               _loc21_ = data.getStampSlot().getValueSlot2();
               _loc14_ *= 1 + _loc21_;
               _loc16_ = hp.getValue() + _loc14_;
               _loc17_ = use_hp_Max.getValue();
               if(_loc16_ < _loc17_)
               {
                  hp.setValue(_loc16_);
               }
               else
               {
                  hp.setValue(_loc17_);
               }
               NewMC.Open("回血效果",this,0,0,0,_loc14_);
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
               tempChiXuTime = XXSupplies.getDuration();
               tempVaPer = XXSupplies.getPercent();
               addEventListener(Event.ENTER_FRAME,chixuhuifu);
            }
            else if(_loc13_ == 2 && this.data.getLevel() >= _loc15_)
            {
               _loc21_ = data.getStampSlot().getValueSlot1();
               _loc20_ = Math.round(use_mp_Max.getValue() * (_loc19_ / 100));
               _loc14_ = (_loc14_ + _loc20_) * (1 + _loc21_);
               _loc16_ = mp.getValue() + _loc14_;
               _loc17_ = use_mp_Max.getValue();
               if(_loc16_ < _loc17_)
               {
                  mp.setValue(_loc16_);
               }
               else
               {
                  mp.setValue(_loc17_);
               }
               NewMC.Open("回蓝效果",this,0,0,0,_loc14_);
               _loc7_ = int(sel_objCD(_loc2_));
               All_ObjCDXX[_loc7_][1] = 0;
               this.data.getSuppliesSlot().useSupplies(this.data.getBag(),param1);
            }
         }
         刷新背包显示();
      }
      
      private function chixuhuifu(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(hp.getValue() <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,chixuhuifu);
         }
         else
         {
            ++tempCXHF;
            _loc2_ = use_hp_Max.getValue();
            _loc3_ = Math.round(_loc2_ * (tempVaPer / 100));
            _loc4_ = hp.getValue() + _loc3_;
            if(tempCXHF <= tempChiXuTime)
            {
               if(tempCXHF % 27 == 0)
               {
                  if(_loc4_ < _loc2_)
                  {
                     hp.setValue(_loc4_);
                  }
                  else
                  {
                     hp.setValue(_loc2_);
                  }
                  NewMC.Open("回血效果",this,0,0,0,_loc3_);
               }
            }
            else
            {
               tempCXHF = 0;
               removeEventListener(Event.ENTER_FRAME,chixuhuifu);
            }
         }
      }
      
      public function CanSkill(param1:String, param2:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc3_:Skill = SkillFactory.getSkillByTypeIAndLevel(param1,param2);
         if(_loc3_ != null)
         {
            _loc4_ = this.mp.getValue() - _loc3_.getMp();
            _loc5_ = int(selCD(param1));
            if(_loc4_ <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"魔法不足,无法发动技能");
               return false;
            }
            if(_loc5_ == -1)
            {
               return false;
            }
            _loc6_ = data.getEquipSlot().getAllSuitSkill();
            for(_loc7_ in _loc6_)
            {
               if(_loc6_[_loc7_] == 57363)
               {
                  if(flagTempMP)
                  {
                     flagTempMP = false;
                     setInTimeCDMP();
                     AllSkillCDXX[_loc5_][1] = 0;
                     return true;
                  }
               }
            }
            this.mp.setValue(_loc4_);
            AllSkillCDXX[_loc5_][1] = 0;
            return true;
         }
         return true;
      }
      
      public function CanUserObj(param1:String) : Boolean
      {
         var _loc2_:int = int(sel_objCD(param1));
         if(_loc2_ == -1)
         {
            return false;
         }
         return true;
      }
      
      public function runPower(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:String = "") : *
      {
         var _loc9_:* = 0;
         if(param4 == "跳")
         {
            _loc9_ = int(runArr.length - 1);
            while(_loc9_ >= 0)
            {
               if(runArr[_loc9_][5] == "跳")
               {
                  runArr.splice(_loc9_,1);
               }
               _loc9_--;
            }
         }
         if(param3 <= 3)
         {
            runArr[runArr.length] = [param1,param2,1,0,0,param4];
            return;
         }
         var _loc5_:* = param1 * parabola / param3;
         var _loc6_:* = param2 * parabola / param3;
         var _loc7_:Number = param1 * (1 - parabola) / (param3 * param3 - param3 * (param3 - 1) / 2);
         var _loc8_:Number = param2 * (1 - parabola) / (param3 * param3 - param3 * (param3 - 1) / 2);
         runArr[runArr.length] = [_loc5_,_loc6_,param3,_loc7_,_loc8_,param4];
      }
      
      private function MoveData() : *
      {
         runX = runY = 0;
         var _loc1_:* = int(runArr.length - 1);
         while(_loc1_ >= 0)
         {
            if(runArr[_loc1_][2] > 0)
            {
               runX += runArr[_loc1_][0] + runArr[_loc1_][3] * runArr[_loc1_][2];
               runY -= runArr[_loc1_][1] + runArr[_loc1_][4] * runArr[_loc1_][2];
               --runArr[_loc1_][2];
            }
            else
            {
               runArr.splice(_loc1_,1);
            }
            _loc1_--;
         }
         if(runY < 0)
         {
            jumpType = 1;
            gravityNum = 0;
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
      
      private function MoveRun() : *
      {
         var _loc1_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Player = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         if(runX > 0)
         {
            _loc1_ = true;
         }
         var _loc2_:int = Math.abs(this.runX);
         var _loc3_:int = Math.abs(this.runY);
         var _loc4_:* = int(this.x + Main.world.x);
         var _loc5_:* = int(this.y);
         var _loc6_:* = int(Main.world.x);
         var _loc7_:* = _loc3_;
         while(_loc7_ > 0)
         {
            if(this.jumpType == 1)
            {
               _loc11_ = Boolean(Main.world.MapData1.hitTestPoint(_loc4_,_loc5_ - 100,true));
               if(!_loc11_)
               {
                  _loc5_--;
               }
            }
            else if(this.jumpType == 2)
            {
               _loc12_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ - 3,true));
               _loc13_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ - 1,true));
               _loc14_ = Boolean(Main.world.MapData.hitTestPoint(_loc4_,_loc5_ + 6,true));
               if(_loc12_)
               {
                  _loc5_ -= 2;
                  jumping = 0;
               }
               else if(_loc13_)
               {
                  runY = 0;
                  gravityNum = 0;
                  jumping = 0;
               }
               else if(_loc14_)
               {
                  _loc5_ += 3;
                  jumping = 0;
               }
               else
               {
                  _loc5_++;
               }
            }
            else if(this.jumpType == 3)
            {
               _loc15_ = Boolean(Main.world.MapData1.hitTestPoint(_loc4_,_loc5_ - 5,true));
               if(!_loc15_)
               {
                  jumpType = 2;
                  break;
               }
               _loc5_ += 2;
            }
            _loc7_--;
         }
         this.y = _loc5_;
         if(Main.player_2)
         {
            if(Main.player_1.hp.getValue() > 0 && Main.player_2.hp.getValue() > 0)
            {
               _loc8_ = true;
            }
            else
            {
               _loc8_ = false;
            }
            if(this == Main.player_1)
            {
               _loc9_ = Main.player_2;
            }
            else
            {
               _loc9_ = Main.player_1;
            }
         }
         var _loc10_:* = _loc2_;
         while(_loc10_ > 0)
         {
            if(_loc1_ && !Main.world.MapData1.hitTestPoint(_loc4_ + 20,_loc5_ - 50,true))
            {
               if(!_loc8_)
               {
                  if(_loc4_ > 700 && _loc6_ > 940 - Main.world.stopX_2)
                  {
                     _loc6_--;
                  }
                  if(_loc4_ - Main.world.x < Main.world.stopX_2)
                  {
                     _loc4_++;
                  }
               }
               else
               {
                  if(_loc4_ > 700 && _loc6_ > 940 - Main.world.stopX_2 && _loc9_.x + _loc6_ > 0)
                  {
                     _loc6_--;
                  }
                  if(_loc4_ - Main.world.x < Main.world.stopX_2 && Math.abs(_loc4_ - _loc9_.x - _loc6_ + 2) < 940)
                  {
                     _loc4_++;
                  }
               }
            }
            else if(!_loc1_ && !Main.world.MapData1.hitTestPoint(_loc4_ - 20,_loc5_ - 50,true))
            {
               if(!_loc8_)
               {
                  if(_loc4_ < 240 && _loc6_ < -Main.world.stopX_1)
                  {
                     _loc6_++;
                  }
                  if(_loc4_ - Main.world.x > Main.world.stopX_1)
                  {
                     _loc4_--;
                  }
               }
               else
               {
                  if(_loc4_ < 240 && _loc6_ < -Main.world.stopX_1 && _loc9_.x + _loc6_ < 940)
                  {
                     _loc6_++;
                  }
                  if(_loc4_ - Main.world.x > Main.world.stopX_1 && Math.abs(_loc4_ - _loc9_.x - _loc6_ - 2) < 940)
                  {
                     _loc4_--;
                  }
               }
            }
            _loc10_--;
         }
         this.x = _loc4_ - Main.world.x;
         Main.world.x = _loc6_;
      }
      
      public function getKeyStatus(param1:*, param2:int = 1, param3:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(param1 is String)
         {
            _loc4_ = 0;
            while(_loc4_ < data._keyArr.length)
            {
               if(KeyArrStr[_loc4_] == param1)
               {
                  return Boolean(BasicKey.getKeyState(data._keyArr[_loc4_],param2));
               }
               _loc4_++;
            }
            return false;
         }
         if(param1 is Array)
         {
            _loc6_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < (param1 as Array).length)
            {
               _loc7_ = 0;
               while(_loc7_ < data._keyArr.length)
               {
                  if(KeyArrStr[_loc7_] == param1[_loc4_])
                  {
                     _loc6_[_loc6_.length] = data._keyArr[_loc7_];
                  }
                  _loc7_++;
               }
               _loc4_++;
            }
            return BasicKey.getTargetState(_loc6_);
         }
         return false;
      }
      
      public function newSkin() : *
      {
         var _loc1_:uint = 1;
         var _loc2_:uint = 2;
         if(this == Main.player_2)
         {
            _loc1_ = 2;
            _loc2_ = 3;
         }
         NewLoad.Loading(_loc2_,_loc1_);
      }
      
      public function newSkin_LoadEnd() : *
      {
         if(!backMC)
         {
            backMC = new MovieClip();
            this.addChild(backMC);
         }
         newZhuangBei3();
         if(skin)
         {
            skin.gotoAndStop("站");
            skin.parent.removeChild(skin);
            skin = null;
         }
         OpenJL();
         AddSkin();
         newZhuangBei();
         HeadXX();
         newWuQi();
         OpenCW();
         if(SixOne_Interface.state.getValue() == 1 || SixOne_Interface.state.getValue() == 2)
         {
            OpenYS();
         }
         LoadPlayerLvData();
         getRL(RL);
         addChild(cengHao_mc);
      }
      
      private function newZhuangBei3() : *
      {
         if(skin_Z3)
         {
            skin_Z3.parent.removeChild(skin_Z3);
            skin_Z3 = null;
         }
         AddSkin_Z3();
      }
      
      public function newZhuangBei() : *
      {
         if(skin_Z2)
         {
            skin_Z2.parent.removeChild(skin_Z2);
            skin_Z2 = null;
         }
         if(skin_Z)
         {
            skin_Z.parent.removeChild(skin_Z);
            skin_Z = null;
         }
         AddSkin_Z();
      }
      
      public function newWuQi() : *
      {
         if(skin_W)
         {
            skin_W.parent.removeChild(skin_W);
            skin_W = null;
         }
         AddSkin_W();
      }
      
      private function AddSkin() : *
      {
         var _loc1_:int = int(data.skinArr[data.skinNum]);
         var _loc2_:Class = PlayerMcArr[_loc1_].getClass("src.Skin.Skin_player" + _loc1_) as Class;
         this.skin = new _loc2_();
         skin.skinNum = _loc1_;
         skin.Xml = Skin.PlayerXml[_loc1_];
         skin.playX = this;
         addChild(skin);
         skin.mouseChildren = skin.mouseEnabled = false;
      }
      
      private function AddSkin_Z3() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Class = null;
         if(data.getEquipSlot().getEquipFromSlot(7) != null)
         {
            _loc1_ = int(data.skinArr[data.skinNum]);
            _loc2_ = data.getEquipSlot().getEquipFromSlot(7).getClassName();
            _loc3_ = data.getEquipSlot().getEquipFromSlot(7).getClassName3();
            _loc4_ = data.getEquipSlot().getEquipFromSlot(7).getClassName4();
            _loc5_ = NewLoad.zhuangBeiSkin[_loc1_][_loc3_].getClass(_loc2_) as Class;
            this.skin_Z3 = new _loc5_();
            addChild(skin_Z3);
            if(skin_Z3)
            {
               if(skin_Z3_V && data.getEquipSlot().getEquipFromSlot(7).getRemainingTime() > 0)
               {
                  skin_Z3.visible = true;
                  this.paiHangShow[4] = [_loc3_,_loc4_,_loc2_];
               }
               else
               {
                  skin_Z3.visible = false;
               }
            }
         }
      }
      
      private function AddSkin_Z() : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc1_:int = int(data.skinArr[data.skinNum]);
         this.paiHangShow[0] = _loc1_;
         var _loc4_:uint = 1;
         if(Main.water.getValue() != 1)
         {
            _loc4_ = 9;
         }
         if(data.getEquipSlot().getEquipFromSlot(_loc4_) == null)
         {
            _loc2_ = "甲白1";
            _loc3_ = 1;
            _loc5_ = "1_v2";
         }
         else
         {
            _loc2_ = data.getEquipSlot().getEquipFromSlot(_loc4_).getClassName();
            _loc3_ = data.getEquipSlot().getEquipFromSlot(_loc4_).getClassName3();
            _loc5_ = data.getEquipSlot().getEquipFromSlot(_loc4_).getClassName4();
         }
         var _loc6_:Class = NewLoad.zhuangBeiSkin[_loc1_][_loc3_].getClass(_loc2_) as Class;
         this.skin_Z = new _loc6_();
         addChild(skin_Z);
         skin_Z.mouseChildren = skin_Z.mouseEnabled = false;
         this.paiHangShow[3] = [_loc3_,_loc5_,_loc2_];
         var _loc7_:Array = new Array();
         if(data.getEquipSlot().getEquipFromSlot(6) != null)
         {
            _loc2_ = data.getEquipSlot().getEquipFromSlot(6).getClassName();
            _loc3_ = data.getEquipSlot().getEquipFromSlot(6).getClassName3();
            _loc5_ = data.getEquipSlot().getEquipFromSlot(6).getClassName4();
            _loc6_ = NewLoad.zhuangBeiSkin[_loc1_][_loc3_].getClass(_loc2_) as Class;
            this.skin_Z2 = new _loc6_();
            addChild(skin_Z2);
            skin_Z.visible = false;
            _loc7_ = [_loc3_,_loc5_,_loc2_];
         }
         if(Boolean(skin_Z2) && Boolean(skin_Z2_V) && data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() > 0)
         {
            skin_Z2.visible = true;
            skin_Z.visible = false;
            skin_Z2.mouseChildren = skin_Z2.mouseEnabled = false;
            this.paiHangShow[3] = _loc7_;
         }
         else if(!skin_Z2_V || Boolean(skin_Z2) && Boolean(data.getEquipSlot().getEquipFromSlot(6).getRemainingTime() <= 0))
         {
            if(skin_Z2)
            {
               skin_Z2.visible = false;
            }
            skin_Z.visible = true;
         }
      }
      
      private function AddSkin_W() : *
      {
         var _loc2_:String = null;
         var _loc1_:int = data.skinNum;
         if(_loc1_ == 0)
         {
            _loc2_ = data.getEquipSlot().getEquipFromSlot(2).getClassName();
         }
         else if(_loc1_ == 1)
         {
            _loc2_ = data.getEquipSlot().getEquipFromSlot(5).getClassName();
         }
         var _loc3_:Class = Skin_WuQi.PlayerMcArr[data.skinArr[data.skinNum]].getClass(_loc2_) as Class;
         this.paiHangShow[2] = _loc2_;
         this.skin_W = new _loc3_();
         addChild(skin_W);
         skin_W.mouseChildren = skin_W.mouseEnabled = false;
      }
      
      private function SkinPlay(param1:String) : *
      {
         if(skin)
         {
            this.skin.GoTo(param1);
         }
      }
      
      private function getRL(param1:Boolean) : *
      {
         this.RL = param1;
         if(param1)
         {
            skin.scaleX = skin_Z.scaleX = skin_W.scaleX = -1;
            if(skin_Z2)
            {
               skin_Z2.scaleX = -1;
            }
            if(skin_Z3)
            {
               skin_Z3.scaleX = -1;
            }
            if(this.cengHao_mc.frame == 363)
            {
               cengHao_mc.scaleX = 1;
            }
         }
         else if(!param1)
         {
            skin.scaleX = skin_Z.scaleX = skin_W.scaleX = 1;
            if(skin_Z2)
            {
               skin_Z2.scaleX = 1;
            }
            if(skin_Z3)
            {
               skin_Z3.scaleX = 1;
            }
            if(this.cengHao_mc.frame == 363)
            {
               cengHao_mc.scaleX = -1;
            }
         }
      }
      
      private function MoveFun() : *
      {
         if(getKeyStatus("左",3))
         {
            runPower(-walk_power.getValue() * 1.5,0,1);
         }
         else if(getKeyStatus("右",3))
         {
            runPower(walk_power.getValue() * 1.5,0,1);
         }
         else if(getKeyStatus("左",2))
         {
            runPower(-walk_power.getValue(),0,1);
         }
         else if(getKeyStatus("右",2))
         {
            runPower(walk_power.getValue(),0,1);
         }
      }
      
      public function OpenCW() : *
      {
         if(Boolean(data.playerCW_Data) && data.playerCW_Data.getType() == 1)
         {
            data.playerCW_Data = null;
            return;
         }
         if(Boolean(data.playerCW_Data) && Boolean(!playerCW) && data.playerCW_Data.getFood() > 0)
         {
            NewCW(data.playerCW_Data);
         }
      }
      
      public function NewCW(param1:Pet) : *
      {
         if(playerCW)
         {
            playerCW.Close();
         }
         this.data.playerCW_Data = param1;
         playerCW = new ChongWu(param1,this);
      }
      
      public function OpenJL() : *
      {
         if(playerJL)
         {
            playerJL.JingLingOPEN();
            if(Main.gameNum.getValue() == 0)
            {
               playerJL.jiNengZD_num = 0;
            }
         }
         else if(Boolean(data.playerJL_Data) && this.visible)
         {
            NewJL(data.playerJL_Data);
         }
      }
      
      public function NewJL(param1:Elves) : *
      {
         if(playerJL)
         {
            playerJL.Close();
         }
         this.data.playerJL_Data = param1;
         playerJL = new JingLing(param1,this);
      }
      
      public function HpUp(param1:Number, param2:int = 1) : *
      {
         var _loc4_:int = 0;
         if(hp.getValue() <= 0)
         {
            return;
         }
         var _loc3_:int = use_hp_Max.getValue();
         if(param2 == 1)
         {
            _loc4_ = hp.getValue() + param1;
         }
         else if(param2 == 2)
         {
            param1 = _loc3_ * param1 / 100;
            _loc4_ = hp.getValue() + param1;
         }
         else if(param2 == 3)
         {
            hp.setValue(param1);
         }
         else
         {
            _loc4_ = param1 = 0;
         }
         if(_loc4_ < _loc3_)
         {
            hp.setValue(_loc4_);
         }
         else
         {
            hp.setValue(_loc3_);
         }
         NewMC.Open("回血效果",this,0,0,0,param1);
      }
      
      public function MpUp(param1:Number, param2:int = 1) : *
      {
         var _loc4_:int = 0;
         if(hp.getValue() <= 0 || param1 <= 0)
         {
            return;
         }
         var _loc3_:int = use_mp_Max.getValue();
         if(param2 == 1)
         {
            mpUpNum = mp.getValue() + param1;
         }
         else if(param2 == 2)
         {
            param1 = _loc3_ * param1 / 100;
            mpUpNum = mp.getValue() + param1;
         }
         else
         {
            mpUpNum = param1 = 0;
         }
         if(mpUpNum < _loc3_)
         {
            mp.setValue(mpUpNum);
         }
         else
         {
            mp.setValue(_loc3_);
         }
         NewMC.Open("回蓝效果",this,0,0,0,param1);
      }
      
      public function OpenYS() : *
      {
         if(SixOne_Interface.booltemp)
         {
            if(boolYS)
            {
               if(playerYS)
               {
                  playerYS.close();
               }
               playerYS = new YongShi61(this);
            }
         }
      }
      
      public function CloseYS() : *
      {
         if(playerYS)
         {
            playerYS.close();
         }
      }
      
      private function chibangFeiXing() : *
      {
         if(data.getEquipSlot().getEquipFromSlot(7))
         {
            if(data.getEquipSlot().getEquipFromSlot(7).getFrame() == 424)
            {
               ++feixingTime;
               if(gravity == 0 && feixingBool == false && jumping > 0)
               {
                  speedTemp.setValue(speedTemp.getValue() + 20);
                  feixingBool = true;
               }
               if(gravity > 0)
               {
                  this.rotation = 0;
                  speedTemp.setValue(0);
                  feixingBool = false;
               }
               if(feixingTime >= 3)
               {
                  if(gravity == 0 && speedTemp.getValue() > 0)
                  {
                     feixingTime = 0;
                     speedTemp.setValue(speedTemp.getValue() - 1);
                  }
               }
            }
         }
      }
      
      private function shizhuangPenShe() : *
      {
         if(data.getEquipSlot().getEquipFromSlot(6))
         {
            if(data.getEquipSlot().getEquipFromSlot(6).getFrame() == 423)
            {
               if(feixingBool3 == true && feixingBool2 == false)
               {
                  if(Main.gameNum.getValue() == 0)
                  {
                     return;
                  }
                  this.skin_W.addChild(new class_ps());
                  feixingBool2 = true;
               }
               if(feixingBool3 == false)
               {
                  feixingBool2 = false;
               }
            }
         }
      }
      
      public function nineBuffTime() : *
      {
         ++nbTime;
         if(data.buffNine[0] > 0)
         {
            if(nbTime % 27 == 0)
            {
               if(data.buffNine[9] > 0)
               {
                  --data.buffNine[9];
                  if(data.buffNine[9] == 0)
                  {
                     data.buffNine[8] = 7200;
                  }
                  if(data.reBorn > 0)
                  {
                     --data.reBorn;
                  }
               }
               if(data.buffNine[8] > 0)
               {
                  --data.buffNine[8];
                  if(data.buffNine[8] == 0)
                  {
                     data.buffNine[7] = 7200;
                  }
               }
               else if(data.buffNine[7] > 0)
               {
                  --data.buffNine[7];
                  if(data.buffNine[7] == 0)
                  {
                     data.buffNine[6] = 7200;
                  }
               }
               else if(data.buffNine[6] > 0)
               {
                  --data.buffNine[6];
                  if(data.buffNine[6] == 0)
                  {
                     data.buffNine[5] = 7200;
                  }
               }
               else if(data.buffNine[5] > 0)
               {
                  --data.buffNine[5];
                  if(data.buffNine[5] == 0)
                  {
                     data.buffNine[4] = 7200;
                  }
               }
               else if(data.buffNine[4] > 0)
               {
                  --data.buffNine[4];
                  if(data.buffNine[4] == 0)
                  {
                     data.buffNine[3] = 10800;
                  }
               }
               else if(data.buffNine[3] > 0)
               {
                  --data.buffNine[3];
                  if(data.buffNine[3] == 0)
                  {
                     data.buffNine[2] = 10800;
                  }
               }
               else if(data.buffNine[2] > 0)
               {
                  --data.buffNine[2];
                  if(data.buffNine[2] == 0)
                  {
                     data.buffNine[1] = 10800;
                  }
               }
               else if(data.buffNine[1] > 0)
               {
                  --data.buffNine[1];
                  if(data.buffNine[1] == 0)
                  {
                     data.buffNine[0] = 10800;
                  }
               }
               else if(data.buffNine[0] > 0)
               {
                  --data.buffNine[0];
               }
            }
         }
      }
   }
}

