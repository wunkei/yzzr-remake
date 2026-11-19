package src
{
   import com.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class PK_UI extends MovieClip
   {
      
      public static var _this:PK_UI;
      
      public static var duiHuan_mc:MovieClip;
      
      public static var lingQu_mc:MovieClip;
      
      public static var xPk_nextPlayer:*;
      
      public static var xPk_nextPlayer_ID:*;
      
      public static var getTimeYn:Boolean;
      
      public static var whoData:PlayerData;
      
      public static var whoII:uint;
      
      private static var DengDaiYn:Boolean;
      
      public static var playerNum:int = 5000;
      
      public static var whoNumX:VT = VT.createVT(5000);
      
      public static var whoNum:int = 0;
      
      public static var PK_ing:Boolean = false;
      
      public static var loadPlayerNum:int = 0;
      
      public static var PlayerNumMax_XX:int = 1;
      
      public static var PlayerNum_XX:int = 0;
      
      public static var DataArr:Array = new Array();
      
      public static var DataArr2:Array = new Array();
      
      public static var playerDataArr:Array = new Array();
      
      public static var playerDataArr_id:Array = new Array();
      
      public static var xPk_Player100Arr:Array = new Array();
      
      public static var xPk_Player_min:int = 100;
      
      public static var jiFenArr:Array = [];
      
      public static var getTimeArr:Array = [];
      
      public static var equipLoad_YN:Boolean = true;
      
      public static var playerTime:uint = 81;
      
      public static var Pk_timeNum:int = 12960;
      
      public static var killNum70up:VT = VT.createVT();
      
      public static var killNum70down:VT = VT.createVT();
      
      public var 初始化mc:MovieClip = new 游戏初始化();
      
      public var pageNum:int = 1;
      
      public var pageX:int = 10;
      
      public var selPageX:int = 50;
      
      public var timeNum:uint = 0;
      
      public var userPage:VT = VT.createVT(-99);
      
      public var paiHang_MAX:uint = 5000;
      
      public var duiHuanArr:Array = [[],[63303,"得到过10次及以上的排行榜第一",50,"天下第一(称号)"],[63300,"",50,"勇者武器幻化券"],[31217,"",6,"四级强化石"],[63156,"",2,"星级碎片"]];
      
      public function PK_UI()
      {
         super();
         go_btn.addEventListener(MouseEvent.CLICK,GameStart);
         close_btn.addEventListener(MouseEvent.CLICK,Close);
         pageDOWN_btn.addEventListener(MouseEvent.CLICK,PageDOWN);
         pageUP_btn.addEventListener(MouseEvent.CLICK,PageUP);
         duihuan_btn.addEventListener(MouseEvent.CLICK,DuiHuan_Fun);
         addEventListener(Event.ENTER_FRAME,onTime);
         if(playerDataArr.length == 0)
         {
            if(Main.P1P2)
            {
               Api_4399_All.GetRankListsData(1,100,1364);
            }
            else
            {
               Api_4399_All.GetRankListsData(1,100,1365);
            }
            go_btn.visible = false;
         }
         InitSave();
      }
      
      public static function xPk_Player100_Fun(param1:Array) : *
      {
         var _loc2_:* = undefined;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         TiaoShi.txtShow("列表长度 = " + param1.length);
         PK_UI._this.go_btn.visible = true;
         for(_loc2_ in param1)
         {
            xPk_Player100Arr[_loc2_] = param1[_loc2_];
         }
      }
      
      public static function InitSave() : *
      {
         var _loc1_:int = 0;
         if(!jiFenArr[0])
         {
            jiFenArr[0] = VT.createVT(20141124);
            jiFenArr[1] = VT.createVT();
            jiFenArr[2] = VT.createVT();
            _loc1_ = 3;
            while(_loc1_ < 6)
            {
               jiFenArr[_loc1_] = 0;
               _loc1_++;
            }
         }
         if(!jiFenArr[6])
         {
            jiFenArr[6] = 0;
         }
         if(!jiFenArr[7])
         {
            jiFenArr[7] = 0;
         }
      }
      
      public static function Open() : *
      {
         var _loc1_:Class = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:Class = null;
         if(!NewLoad.Other_YN)
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"加载中,请稍候...");
            return;
         }
         Main.allClosePanel();
         if(!_this)
         {
            _this = new PK_UI();
            _loc1_ = NewLoad.OtherData.getClass("_PK_JiFen") as Class;
            _loc2_ = new _loc1_();
            _this.skin_mc.addChild(_loc2_);
            _loc3_ = NewLoad.OtherData.getClass("JingJiCangDuiHuan") as Class;
            duiHuan_mc = new _loc3_();
            _this.addChild(duiHuan_mc);
            duiHuan_mc.x = duiHuan_mc.y = -5000;
            _loc4_ = NewLoad.OtherData.getClass("pk_jiFen_Up") as Class;
            lingQu_mc = new _loc4_();
            _this.addChild(lingQu_mc);
            lingQu_mc.x = lingQu_mc.y = -5000;
         }
         _this.visible = true;
         _this.x = _this.y = 0;
         _this.Show();
         Main._this.addChild(_this);
         if(jiFenArr[2].getValue() >= 3 && jiFenArr[2].getValue() < 999)
         {
            jiFenArr[2].setValue(999);
            jiFenArr[1].setValue(jiFenArr[1].getValue() + 2);
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"追加奖励:获得2积分");
         }
      }
      
      public static function Close(param1:* = null) : *
      {
         if(!_this)
         {
            return;
         }
         _this.visible = false;
         _this.x = _this.y = 5000;
      }
      
      public static function TiaoJiao_1() : *
      {
         GameData.TiJiaoFenShu(InitData.BuyNum_1.getValue());
      }
      
      private static function onXingQiJi(param1:String) : int
      {
         var _loc7_:String = null;
         var _loc2_:int = int(param1.substr(0,2));
         var _loc3_:int = int(param1.substr(2,2));
         var _loc4_:int = int(param1.substr(4,2));
         var _loc5_:int = int(param1.substr(6,2));
         if(_loc4_ <= 2)
         {
            _loc4_ += 12;
            trace("M = " + _loc4_);
            _loc7_ = String(int(param1.substr(0,4)) - 1);
            trace("xxx2 = " + _loc7_);
            _loc2_ = int(_loc7_.substr(0,2));
            _loc3_ = int(_loc7_.substr(2,2));
         }
         var _loc6_:int = _loc2_ / 4 - 2 * _loc2_ + _loc3_ + _loc3_ / 4 + 13 * (_loc4_ + 1) / 5 + _loc5_ - 1;
         trace(_loc6_ % 7);
         return _loc6_;
      }
      
      public static function xxxTime() : *
      {
         if(!getTimeYn)
         {
            return;
         }
         getTimeYn = false;
         var _loc1_:Number = Number(onXingQiJi(getTimeArr[0]));
         var _loc2_:Number = Number(getTimeArr[1]);
         var _loc3_:Number = Number(getTimeArr[2]);
         if(_loc1_ == 0 && _loc2_ > 16 && _loc2_ < 18)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"排行榜数据重置期间无法挑战,请稍候再试");
            return;
         }
         if(xPk_Player100Arr.length < xPk_Player_min)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"排行榜数据重置期间无法挑战");
            return;
         }
         if(Main.player1.getGold() < 5000 || Boolean(Main.P1P2) && (Main.player1.getGold() < 5000 || Main.player2.getGold() < 5000))
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
            return;
         }
         if(Main.player1.killPoint.getValue() < 10 || Boolean(Main.P1P2) && (Main.player1.killPoint.getValue() < 10 || Main.player2.killPoint.getValue() < 10))
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"击杀点不足");
            return;
         }
         Main.player1.payGold(5000);
         Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 10);
         if(Main.P1P2)
         {
            Main.player2.payGold(5000);
            Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - 10);
         }
         _this.P1_money_txt.text = Main.player1.getGold();
         _this.P1_killPoint_txt.text = Main.player1.killPoint.getValue();
         if(Main.P1P2)
         {
            _this.P2_money_txt.text = Main.player2.getGold();
            _this.P2_killPoint_txt.text = Main.player2.killPoint.getValue();
         }
         _this.addChild(_this.初始化mc);
         _this.goGame(0);
         if(Main.P1P2)
         {
            PlayerNumMax_XX = 2;
         }
         else
         {
            PlayerNumMax_XX = 1;
         }
         PlayerNum_XX = 0;
         equipLoad_YN = true;
         DengDaiYn = false;
      }
      
      public static function AddOtherPlayer() : *
      {
         if(PK_ing && PlayerNum_XX < PlayerNumMax_XX && equipLoad_YN)
         {
            equipLoad_YN = false;
            Load_OtherPlayer();
            ++PlayerNum_XX;
         }
         TimeNumFun();
      }
      
      public static function reAddOtherPlayer() : *
      {
         TiaoShi.txtShow("数据出错重新刷新~~");
         if(PK_ing)
         {
            Load_OtherPlayer();
         }
         TimeNumFun();
      }
      
      private static function Load_OtherPlayer() : *
      {
         loadPlayerNum = Math.random() * xPk_Player_min;
         TiaoShi.txtShow("<pk玩家> 随机:" + loadPlayerNum);
         Load_OtherPlayerData(loadPlayerNum);
         playerTime = 81;
      }
      
      public static function Load_OtherPlayerData(param1:int = 0) : *
      {
         var _loc2_:Object = null;
         if(xPk_nextPlayer == null)
         {
            _loc2_ = xPk_Player100Arr[param1];
            Api_4399_All.GetUserData(_loc2_.uId,_loc2_.index);
            TiaoShi.txtShow("<pk玩家> 数据 读取中...>>>" + param1);
         }
         else
         {
            whoData = DeepCopyUtil.clone(xPk_nextPlayer);
            TiaoShi.txtShow("<pk玩家> 数据读取完成, 装备加载中... >>>" + param1);
            NewLoad.Loading(4);
            xPk_nextPlayer = null;
         }
      }
      
      public static function LoadEnd_And_AddPlayer2() : *
      {
         TiaoShi.txtShow("<pk玩家> 装备加载完成....>>>" + loadPlayerNum);
         if(playerTime > 0)
         {
            TiaoShi.txtShow("<pk玩家> 3秒等待 playerTime...>>>" + playerTime);
            DengDaiYn = true;
            return;
         }
         var _loc1_:Player2 = new Player2();
         _loc1_.data = whoData;
         _loc1_.Load_All_Player_Data();
         Main.world.moveChild_Player.addChild(_loc1_);
         _loc1_.x = Math.random() * 1000 + 100;
         _loc1_.y = 400;
         _loc1_.newSkin();
         _loc1_.pkmc._txt.text = xPk_nextPlayer_ID;
         equipLoad_YN = true;
         TiaoShi.txtShow("<pk玩家> 生成玩家!!...>>>" + loadPlayerNum);
      }
      
      public static function TimeNumFun() : *
      {
         if(Pk_timeNum > 0)
         {
            --Pk_timeNum;
         }
         if(Pk_timeNum <= 0 && PK_ing)
         {
            GameData.PkJiFun(true);
         }
      }
      
      public function DuiHuan_Fun(param1:*) : *
      {
         duiHuan_mc.x = duiHuan_mc.y = 0;
         duiHuan_mc.jifen_txt.text = PK_UI.jiFenArr[1].getValue();
         duiHuan_mc.close_btn.addEventListener(MouseEvent.CLICK,DuiHuan_Close);
         DuiHuan_Show();
      }
      
      public function DuiHuan_Close(param1:*) : *
      {
         duiHuan_mc.x = duiHuan_mc.y = -5000;
      }
      
      public function lingQu_Close(param1:*) : *
      {
         lingQu_mc.x = lingQu_mc.y = -5000;
      }
      
      public function DuiHuan_Show() : *
      {
         var _loc2_:MovieClip = null;
         duiHuan_mc.jifen_txt.text = "" + jiFenArr[1].getValue();
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            _loc2_ = duiHuan_mc["duiHuan_" + _loc1_];
            _loc2_.name_txt.text = duiHuanArr[_loc1_][3];
            _loc2_.pic_mc.gotoAndStop(_loc1_);
            _loc2_.money_txt.text = duiHuanArr[_loc1_][2] + "积分";
            _loc2_.tiaoJian_txt.text = "";
            if(_loc1_ == 1)
            {
               _loc2_.tiaoJian_txt.text = "当前已获得" + jiFenArr[3] + "次第一名";
            }
            _loc2_.duihuanXXX.addEventListener(MouseEvent.CLICK,DuiHuan_num);
            _loc1_++;
         }
      }
      
      public function DuiHuan_num(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.parent.name as String).substr(8,1));
         TiaoShi.txtShow(param1.target.name + "兑换" + _loc2_);
         if(jiFenArr[1].getValue() < duiHuanArr[_loc2_][2])
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
            return;
         }
         if(_loc2_ == 1 || _loc2_ == 2 || _loc2_ == 4)
         {
            if(Main.player1.getBag().backOtherBagNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"其他类背包空间不足!");
               return;
            }
            if(_loc2_ == 1 && jiFenArr[3] < 10)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"兑换条件不满足!");
               return;
            }
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(duiHuanArr[_loc2_][0]));
            jiFenArr[1].setValue(jiFenArr[1].getValue() - duiHuanArr[_loc2_][2]);
         }
         else if(_loc2_ == 3)
         {
            if(Main.player1.getBag().backGemBagNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"其他类背包空间不足!");
               return;
            }
            Main.player1.getBag().addGemBag(GemFactory.creatGemById(duiHuanArr[_loc2_][0]));
            jiFenArr[1].setValue(jiFenArr[1].getValue() - duiHuanArr[_loc2_][2]);
         }
         NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"兑换成功!");
         if(_loc2_ == 1)
         {
            ++jiFenArr[6];
         }
         if(_loc2_ == 2)
         {
            ++jiFenArr[7];
         }
         DuiHuan_Show();
         Main.Save();
      }
      
      public function Show() : *
      {
         P1_money_txt.text = Main.player1.getGold();
         P1_killPoint_txt.text = Main.player1.killPoint.getValue();
         if(Main.P1P2)
         {
            P2_money_txt.text = Main.player2.getGold();
            P2_killPoint_txt.text = Main.player2.killPoint.getValue();
         }
         var _loc1_:int = 0;
         while(_loc1_ < 11)
         {
            this["num_" + _loc1_].x_txt.text = "";
            this["num_" + _loc1_].id_txt.text = "";
            this["num_" + _loc1_].save_txt.text = "";
            this["num_" + _loc1_].score_txt.text = "";
            this["num_" + _loc1_].X123_mc.gotoAndStop(4);
            _loc1_++;
         }
         pageNum = 1;
         page_txt.text = "1/5";
         Api_4399_All.GetRankListsData(1,selPageX,1365);
         Api_4399_All.GetOneRankInfo();
      }
      
      public function get_PaiHang_Data(param1:Array, param2:int) : *
      {
         var _loc4_:* = undefined;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         var _loc3_:int = (param2 - 1) * selPageX;
         for(_loc4_ in param1)
         {
            DataArr[_loc3_ + _loc4_] = param1[_loc4_];
         }
         if(pageNum == 1)
         {
            PaiHang_Show(pageNum);
         }
      }
      
      public function PaiHang_Show(param1:uint) : *
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(DataArr == null || DataArr.length == 0)
         {
            return;
         }
         var _loc2_:int = (param1 - 1) * pageX;
         var _loc3_:int = 0;
         var _loc4_:* = _loc2_;
         while(_loc4_ < _loc2_ + 10)
         {
            if(!DataArr[_loc4_])
            {
               this["num_" + _loc3_].x_txt.text = "";
               this["num_" + _loc3_].id_txt.text = "";
               this["num_" + _loc3_].save_txt.text = "";
               this["num_" + _loc3_].score_txt.text = "";
               this["num_" + _loc3_].X123_mc.gotoAndStop(4);
            }
            else
            {
               _loc5_ = _loc3_ + 1 + _loc2_;
               _loc6_ = DataArr[_loc4_];
               if(_loc6_.score < 10)
               {
                  break;
               }
               this["num_" + _loc3_].x_txt.text = _loc3_ + 10 * (param1 - 1) + 1;
               this["num_" + _loc3_].id_txt.text = _loc6_.userName;
               this["num_" + _loc3_].save_txt.text = uint(_loc6_.index) + 1;
               this["num_" + _loc3_].score_txt.text = _loc6_.score;
               if(_loc5_ < 4)
               {
                  this["num_" + _loc3_].X123_mc.gotoAndStop(_loc5_);
               }
               else
               {
                  this["num_" + _loc3_].X123_mc.gotoAndStop(4);
               }
            }
            _loc3_++;
            _loc4_++;
         }
      }
      
      public function PaiHang_Show_X(param1:Array) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 != null && param1.length != 0)
         {
            for(_loc2_ in param1)
            {
               _loc3_ = param1[_loc2_];
               if(int(_loc3_.index) == Main.saveNum)
               {
                  if(_loc3_.score < 10)
                  {
                     break;
                  }
                  this["num_10"].x_txt.text = _loc3_.rank;
                  playerNum = int(_loc3_.rank);
                  whoNumX.setValue(int(_loc3_.rank));
                  this["num_10"].id_txt.text = _loc3_.userName;
                  this["num_10"].save_txt.text = uint(_loc3_.index) + 1;
                  this["num_10"].score_txt.text = _loc3_.score;
                  JiFenUP(_loc3_.rank);
                  if(_loc3_.rank < 4)
                  {
                     this["num_10"].X123_mc.gotoAndStop(_loc3_.rank);
                  }
                  userPage.setValue(int(_loc3_.rank) / pageX);
                  return;
               }
            }
            this["num_10"].x_txt.text = "?";
            this["num_10"].id_txt.text = Main.logName;
            this["num_10"].save_txt.text = Main.saveNum + 1;
            this["num_10"].score_txt.text = "未上榜";
            this["num_10"].X123_mc.gotoAndStop(4);
         }
         else
         {
            this["num_10"].x_txt.text = "?";
            this["num_10"].id_txt.text = Main.logName;
            this["num_10"].save_txt.text = Main.saveNum + 1;
            this["num_10"].score_txt.text = "未上榜";
            this["num_10"].X123_mc.gotoAndStop(4);
         }
      }
      
      private function JiFenUP(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         lingQu_mc.close_btn.addEventListener(MouseEvent.CLICK,lingQu_Close);
         TiaoShi.txtShow("当前挑战时间:" + jiFenArr[0].getValue());
         TiaoShi.txtShow("当前serverTime:" + Main.serverTime.getValue());
         if(jiFenArr[0].getValue() != 0 && jiFenArr[0].getValue() != Main.serverTime.getValue())
         {
            TiaoShi.txtShow("挑战奖励已领取! 名次:" + param1);
            jiFenArr[0].setValue(Main.serverTime.getValue());
            jiFenArr[2] = VT.createVT();
            _loc2_ = int((jiFenArr[1] as VT).getValue());
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            if(param1 == InitData.tiaoZhanJF_1.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_8.getValue());
               _loc4_ = 350;
               _loc5_ = 200;
               _loc6_ = 14;
            }
            else if(param1 == InitData.tiaoZhanJF_2.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_4.getValue());
               _loc4_ = 250;
               _loc5_ = 150;
               _loc6_ = 11;
            }
            else if(param1 == InitData.tiaoZhanJF_3.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_4.getValue());
               _loc4_ = 200;
               _loc5_ = 100;
               _loc6_ = 9;
            }
            else if(param1 <= InitData.tiaoZhanJF_10.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_2.getValue());
               _loc4_ = 145;
               _loc5_ = 100;
               _loc6_ = 8;
            }
            else if(param1 <= InitData.tiaoZhanJF_100.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_2.getValue());
               _loc4_ = 105;
               _loc5_ = 80;
               _loc6_ = 6;
            }
            else if(param1 <= InitData.tiaoZhanJF_500.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_1.getValue());
               _loc4_ = 70;
               _loc5_ = 50;
               _loc6_ = 5;
            }
            else if(param1 <= InitData.tiaoZhanJF_5000.getValue())
            {
               _loc3_ = int(InitData.tiaoZhanJF_0.getValue());
               _loc4_ = 20;
               _loc5_ = 20;
               _loc6_ = 5;
            }
            jiFenArr[1] = VT.createVT(_loc2_ + _loc3_);
            AchData.cjPoint_1.setValue(AchData.cjPoint_1.getValue() + _loc4_);
            Main.player1.AddKillPoint(_loc5_);
            Main.player_1.ExpUP(_loc6_,3);
            if(Main.P1P2)
            {
               Main.player2.AddKillPoint(_loc5_);
               Main.player_2.ExpUP(_loc6_,3);
            }
            TiaoShi.txtShow("竞技场积分:" + jiFenArr[1].getValue());
            TiaoShi.txtShow(_loc3_ + "," + _loc4_ + "," + _loc5_);
            if(param1 == 1)
            {
               ++jiFenArr[3];
            }
            else if(param1 <= 10)
            {
               ++jiFenArr[4];
            }
            else if(param1 <= 5000)
            {
               ++jiFenArr[5];
            }
            lingQu_mc.x = lingQu_mc.y = 0;
            lingQu_mc.num_txt.text = "第" + param1 + "名";
            lingQu_mc._1_txt.text = _loc3_;
            lingQu_mc._2_txt.text = "+" + _loc6_ + "%";
            lingQu_mc._3_txt.text = _loc5_;
            lingQu_mc._4_txt.text = _loc4_;
         }
      }
      
      private function PageUP(param1:*) : *
      {
         if(pageNum < 5)
         {
            ++pageNum;
            PaiHang_Show(pageNum);
            page_txt.text = pageNum + "/5";
         }
      }
      
      private function PageDOWN(param1:*) : *
      {
         if(pageNum > 1)
         {
            --pageNum;
            PaiHang_Show(pageNum);
            page_txt.text = pageNum + "/5";
         }
      }
      
      private function GameStart(param1:*) : *
      {
         if(!getTimeYn)
         {
            Main.GetServerTime(true);
            getTimeYn = true;
         }
      }
      
      private function goGame(param1:int = 0) : *
      {
         if(初始化mc.parent)
         {
            初始化mc.parent.removeChild(初始化mc);
         }
         PK_UI.Close();
         Main.gameNum.setValue(999);
         Main.gameNum2.setValue(1);
         Main._this.Loading();
         whoNum = param1;
         Pk_timeNum = 12960;
         killNum70down.setValue(0);
         killNum70up.setValue(0);
      }
      
      public function onTime(param1:*) : *
      {
         if(playerTime > 0)
         {
            --playerTime;
         }
         else if(Boolean(DengDaiYn) && PK_ing)
         {
            LoadEnd_And_AddPlayer2();
            DengDaiYn = false;
         }
      }
   }
}

