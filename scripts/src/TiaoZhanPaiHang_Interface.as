package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.petEquip.*;
   import com.hotpoint.braveManIII.models.petGem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.storagePanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class TiaoZhanPaiHang_Interface extends MovieClip
   {
      
      public static var _this:TiaoZhanPaiHang_Interface;
      
      public static var skin:MovieClip;
      
      public static var DuiHuanOpenX:int;
      
      public static var playTime:int;
      
      public static var Show1:PlayerShow = new PlayerShow();
      
      public static var Show2:PlayerShow = new PlayerShow();
      
      public static var Show3:PlayerShow = new PlayerShow();
      
      public static var pageNum:int = 1;
      
      public static var pageX:int = 9;
      
      public static var selPageX:int = 50;
      
      public static var selType:int = 0;
      
      public static var selTypeX:int = 0;
      
      public static var paiHangID_Arr:Array = new Array();
      
      public static var selTypeMaxNum:Array = [0,9,7,12,8];
      
      public static var buyPointArr:Array = [[],[0,25,50,25,50],[0,25,250,15,15],[0],[0]];
      
      public static var buyPointArr2:Array = [[],[0,10,20,10,20],[0,10,100,6,6],[0],[0]];
      
      private static var request:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-38150645.html");
      
      private static var request2:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-42764228.html");
      
      private static var money:int = 0;
      
      private static var moneyObj:int = 0;
      
      private static var moneyID:int = 0;
      
      private static var moneyType:int = 1;
      
      public static var playnum:int = 0;
      
      public static var noClose:Boolean = false;
      
      public static var dengDai:Boolean = false;
      
      public static var ShowPlayer_selType:int = 0;
      
      public static var ShowPlayer_selTypeX:int = 0;
      
      public function TiaoZhanPaiHang_Interface()
      {
         super();
         pageNum = 1;
         selType = 0;
         selTypeX = 0;
         _this = this;
         visible = false;
      }
      
      public static function InitSkin() : *
      {
         _this.addChild(skin);
         Show1.x = 667;
         Show1.y = 265;
         skin.addChild(Show1);
         Show2.x = 546;
         Show2.y = 340;
         skin.addChild(Show2);
         Show3.x = 776;
         Show3.y = 374;
         skin.addChild(Show3);
         skin.addChild(skin.playName1);
         skin.addChild(skin.playName2);
         skin.addChild(skin.playName3);
         skin.addChild(skin.shuoMing_btn);
         skin.addChild(skin.duiHuan_mc);
         skin.addChild(skin.loading_mc);
         skin.addChild(skin["jfMC"]);
         skin.close_btn.addEventListener(MouseEvent.CLICK,Close);
         skin.next_btn.addEventListener(MouseEvent.CLICK,NextFun);
         skin.back_btn.addEventListener(MouseEvent.CLICK,BackFun);
         skin.baoXiang_1.addEventListener(MouseEvent.CLICK,DuiHuanOpen);
         skin.baoXiang_2.addEventListener(MouseEvent.CLICK,DuiHuanOpen);
         skin.duiHuan_mc.close_btn.addEventListener(MouseEvent.CLICK,DuiHuanClose);
         skin.duiHuan_mc.b1_btn.addEventListener(MouseEvent.CLICK,DuiHuanBtn1);
         skin.duiHuan_mc.b2_btn.addEventListener(MouseEvent.CLICK,DuiHuanBtn2);
         skin.duiHuan_mc.b3_btn.addEventListener(MouseEvent.CLICK,DuiHuanBtn3);
         skin.duiHuan_mc.b4_btn.addEventListener(MouseEvent.CLICK,DuiHuanBtn4);
         skin.duiHuan_mc.b1_btn2.addEventListener(MouseEvent.CLICK,DuiHuanBtn2_1);
         skin.duiHuan_mc.b2_btn2.addEventListener(MouseEvent.CLICK,DuiHuanBtn2_2);
         skin.duiHuan_mc.b3_btn2.addEventListener(MouseEvent.CLICK,DuiHuanBtn2_3);
         skin.duiHuan_mc.b4_btn2.addEventListener(MouseEvent.CLICK,DuiHuanBtn2_4);
         skin.duiHuan_mc.b1_btn2.addEventListener(MouseEvent.MOUSE_MOVE,DuiHuanBtn2_MOVE);
         skin.duiHuan_mc.b2_btn2.addEventListener(MouseEvent.MOUSE_MOVE,DuiHuanBtn2_MOVE);
         skin.duiHuan_mc.b3_btn2.addEventListener(MouseEvent.MOUSE_MOVE,DuiHuanBtn2_MOVE);
         skin.duiHuan_mc.b4_btn2.addEventListener(MouseEvent.MOUSE_MOVE,DuiHuanBtn2_MOVE);
         skin.duiHuan_mc.b1_btn2.addEventListener(MouseEvent.MOUSE_OUT,DuiHuanBtn2_OUT);
         skin.duiHuan_mc.b2_btn2.addEventListener(MouseEvent.MOUSE_OUT,DuiHuanBtn2_OUT);
         skin.duiHuan_mc.b3_btn2.addEventListener(MouseEvent.MOUSE_OUT,DuiHuanBtn2_OUT);
         skin.duiHuan_mc.b4_btn2.addEventListener(MouseEvent.MOUSE_OUT,DuiHuanBtn2_OUT);
         skin.duiHuan_mc.info_btn.addEventListener(MouseEvent.CLICK,Web);
         skin.duiHuan_mc.info_btn2.addEventListener(MouseEvent.CLICK,Web2);
         skin.duiHuan_mc.XX_mc.mouseChildren = false;
         skin["XX0"].addEventListener(MouseEvent.CLICK,SelNum);
         skin["XX1"].addEventListener(MouseEvent.CLICK,SelNum);
         skin["XX2"].addEventListener(MouseEvent.CLICK,SelNum);
         skin["XX3"].addEventListener(MouseEvent.CLICK,SelNum);
         skin["XX4"].addEventListener(MouseEvent.CLICK,SelNum);
         skin["XX0"].mouseChildren = skin["XX1"].mouseChildren = skin["XX2"].mouseChildren = skin["XX3"].mouseChildren = skin["XX4"].mouseChildren = false;
         Show();
      }
      
      private static function Web(param1:*) : *
      {
         navigateToURL(request,"_blank");
      }
      
      private static function Web2(param1:*) : *
      {
         navigateToURL(request2,"_blank");
      }
      
      private static function DuiHuanBtn2_MOVE(param1:*) : *
      {
         var _loc2_:int = int(param1.target.name.substr(1,1));
         skin.duiHuan_mc.dianQuan_mc.visible = true;
         skin.duiHuan_mc.dianQuan_mc.x = param1.target.x - 40;
         skin.duiHuan_mc.dianQuan_mc._txt.text = "消耗" + buyPointArr2[DuiHuanOpenX][_loc2_] + "点券可兑换该物品";
      }
      
      private static function DuiHuanBtn2_OUT(param1:*) : *
      {
         skin.duiHuan_mc.dianQuan_mc.visible = false;
      }
      
      public static function DuiHuanOpen(param1:MouseEvent = null) : *
      {
         if(!_this || !skin)
         {
            return;
         }
         if(param1)
         {
            DuiHuanOpenX = (param1.target.name as String).substr(9,1);
            TiaoShi.txtShow("? ============> DuiHuanOpenX = " + DuiHuanOpenX);
         }
         skin.duiHuan_mc.x = skin.duiHuan_mc.y = 0;
         skin.duiHuan_mc.gotoAndStop(DuiHuanOpenX);
         skin.duiHuan_mc.obj_mc.x = skin.duiHuan_mc.obj_mc.x = -5000;
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            skin.duiHuan_mc["X" + _loc2_].gotoAndStop(DuiHuanOpenX);
            _loc2_++;
         }
         Duihuan_BtnInit();
      }
      
      private static function Duihuan_BtnInit() : *
      {
         var _loc1_:int = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
         TiaoShi.txtShow("积分" + DuiHuanOpenX + " = " + _loc1_);
         skin.duiHuan_mc.dianQuan_mc.visible = false;
         var _loc2_:int = 1;
         while(_loc2_ <= 4)
         {
            if(buyPointArr[DuiHuanOpenX][_loc2_])
            {
               skin.duiHuan_mc["X" + _loc2_].visible = true;
               if(Boolean(buyPointArr[DuiHuanOpenX][_loc2_]) && _loc1_ >= buyPointArr[DuiHuanOpenX][_loc2_])
               {
                  skin.duiHuan_mc["b" + _loc2_ + "_btn"].visible = true;
                  skin.duiHuan_mc["b" + _loc2_ + "_btn2"].visible = false;
               }
               else
               {
                  skin.duiHuan_mc["b" + _loc2_ + "_btn"].visible = false;
                  skin.duiHuan_mc["b" + _loc2_ + "_btn2"].visible = true;
               }
            }
            else
            {
               skin.duiHuan_mc["b" + _loc2_ + "_btn"].visible = false;
               skin.duiHuan_mc["b" + _loc2_ + "_btn2"].visible = false;
               skin.duiHuan_mc["X" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public static function DuiHuanClose(param1:MouseEvent) : *
      {
         skin.duiHuan_mc.x = skin.duiHuan_mc.y = -5000;
         skin.duiHuan_mc.obj_mc.x = skin.duiHuan_mc.obj_mc.x = -5000;
      }
      
      private static function DianQuanDuiHuanOpen(param1:int = 1, param2:int = 1, param3:int = 1, param4:int = 1) : *
      {
         money = param2;
         moneyID = param3;
         moneyType = param4;
         TiaoZhanPaiHang_Interface.moneyObj = moneyType;
         if(Shop4399.moneyAll.getValue() >= money)
         {
            if((moneyType == 1 || moneyType == 3 || moneyType == 4) && NewPetPanel.bag.backPetBagNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物背包已满!");
               return;
            }
            if((moneyType == 5 || moneyType == 6) && StoragePanel.storage.backSuppliesEmptyNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库\'消耗栏\' 空间不足!");
               return;
            }
            if((moneyType == 7 || moneyType == 8) && StoragePanel.storage.backOtherEmptyNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库\'其他栏\' 空间不足");
               return;
            }
            Api_4399_All.BuyObj(moneyID);
            skin.loading_mc.visible = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"点券不足");
            TiaoZhanPaiHang_Interface.moneyObj = 0;
         }
      }
      
      public static function DianQuanDuiGetObj() : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = false;
         if(moneyObj == 1)
         {
            _loc2_ = GetObjID();
            _loc3_ = int(_loc2_[0].getValue());
            playnum = _loc2_[1];
            NewPetPanel.bag.addPetBag(PetEquip.creatPetEquip(_loc3_));
            _loc1_ = true;
         }
         else if(moneyObj == 2)
         {
            NewPetPanel.XGkey.setValue(NewPetPanel.XGkey.getValue() + 1);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功!");
         }
         else if(moneyObj == 3)
         {
            playnum = 82;
            _loc4_ = int(Math.random() * 12) + 1;
            NewPetPanel.bag.addPetBag(PetGem.creatPetGem(_loc4_));
            _loc1_ = true;
         }
         else if(moneyObj == 4)
         {
            playnum = 95;
            NewPetPanel.LVkey.setValue(NewPetPanel.LVkey.getValue() + 1);
            _loc1_ = true;
         }
         else if(moneyObj == 5)
         {
            StoragePanel.storage.addSuppliesStorage(SuppliesFactory.getSuppliesById(21226));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
         }
         else if(moneyObj == 6)
         {
            StoragePanel.storage.addSuppliesStorage(SuppliesFactory.getSuppliesById(21227));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
         }
         else if(moneyObj == 7)
         {
            StoragePanel.storage.addOtherobjStorage(OtherFactory.creatOther(63290));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
         }
         else
         {
            if(moneyObj != 8)
            {
               return;
            }
            StoragePanel.storage.addOtherobjStorage(OtherFactory.creatOther(63289));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
         }
         if(_loc1_)
         {
            playTime = 60;
            skin.addEventListener(Event.ENTER_FRAME,PlayGO);
            skin.duiHuan_mc.obj_mc.x = skin.duiHuan_mc.obj_mc.y = 0;
            skin.duiHuan_mc.obj_mc.pic_mc.gotoAndStop(playnum);
         }
         skin.loading_mc.visible = false;
         moneyObj = 0;
         Duihuan_BtnInit();
         Show();
      }
      
      public static function GeiObjMC_Play() : *
      {
         if(noClose)
         {
            noClose = false;
            skin.loading_mc.visible = false;
            playTime = 60;
            skin.addEventListener(Event.ENTER_FRAME,PlayGO);
            skin.duiHuan_mc.obj_mc.x = skin.duiHuan_mc.obj_mc.y = 0;
            skin.duiHuan_mc.obj_mc.pic_mc.gotoAndStop(playnum);
            Show();
         }
      }
      
      public static function PlayGO(param1:*) : *
      {
         --playTime;
         if(playTime <= 0)
         {
            skin.duiHuan_mc.obj_mc.x = skin.duiHuan_mc.obj_mc.y = -5000;
            skin.removeEventListener(Event.ENTER_FRAME,PlayGO);
         }
      }
      
      public static function DuiHuanBtn1(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(DuiHuanOpenX == 1)
         {
            if(NewPetPanel.bag.backPetBagNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物背包已满!");
               return;
            }
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 25);
            _loc3_ = GetObjID();
            _loc4_ = int(_loc3_[0].getValue());
            playnum = _loc3_[1];
            skin.loading_mc.visible = true;
            noClose = true;
            NewPetPanel.bag.addPetBag(PetEquip.creatPetEquip(_loc4_));
            Duihuan_BtnInit();
            Main.Save();
         }
         else if(DuiHuanOpenX == 2)
         {
            _loc5_ = int(StoragePanel.storage.backSuppliesEmptyNum());
            if(_loc5_ >= 1)
            {
               StoragePanel.storage.addSuppliesStorage(SuppliesFactory.getSuppliesById(21226));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
               _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
               PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 25);
               Duihuan_BtnInit();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
            }
         }
         Show();
      }
      
      public static function DuiHuanBtn2(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(DuiHuanOpenX == 1)
         {
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 50);
            NewPetPanel.XGkey.setValue(NewPetPanel.XGkey.getValue() + 1);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功!");
            Main.Save();
            Show();
         }
         else if(DuiHuanOpenX == 2)
         {
            _loc3_ = int(StoragePanel.storage.backSuppliesEmptyNum());
            if(_loc3_ >= 1)
            {
               StoragePanel.storage.addSuppliesStorage(SuppliesFactory.getSuppliesById(21227));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
               _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
               PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 250);
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
            }
         }
         Duihuan_BtnInit();
         Show();
      }
      
      public static function DuiHuanBtn3(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         if(DuiHuanOpenX == 1)
         {
            if(NewPetPanel.bag.backPetBagNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物背包已满!");
               return;
            }
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 25);
            playnum = 82;
            skin.loading_mc.visible = true;
            noClose = true;
            _loc2_ = int(Math.random() * 12) + 1;
            NewPetPanel.bag.addPetBag(PetGem.creatPetGem(_loc2_));
            Main.Save();
            Show();
         }
         else if(DuiHuanOpenX == 2)
         {
            if(StoragePanel.storage.backOtherEmptyNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
               return;
            }
            StoragePanel.storage.addOtherobjStorage(OtherFactory.creatOther(63290));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 15);
         }
         Duihuan_BtnInit();
         Show();
      }
      
      public static function DuiHuanBtn4(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         if(DuiHuanOpenX == 1)
         {
            if(NewPetPanel.bag.backPetBagNum() <= 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物背包已满!");
               return;
            }
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 50);
            skin.loading_mc.visible = true;
            playnum = 95;
            noClose = true;
            NewPetPanel.LVkey.setValue(NewPetPanel.LVkey.getValue() + 1);
            Main.Save();
            Show();
         }
         else if(DuiHuanOpenX == 2)
         {
            if(StoragePanel.storage.backOtherEmptyNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
               return;
            }
            StoragePanel.storage.addOtherobjStorage(OtherFactory.creatOther(63289));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功 物品已放入仓库");
            _loc2_ = int(PaiHang_Data.jiFenArr[DuiHuanOpenX].getValue());
            PaiHang_Data.jiFenArr[DuiHuanOpenX].setValue(_loc2_ - 15);
         }
         Duihuan_BtnInit();
         Show();
      }
      
      public static function DuiHuanBtn2_1(param1:MouseEvent) : *
      {
         if(DuiHuanOpenX == 1)
         {
            DianQuanDuiHuanOpen(1,10,131,1);
         }
         else if(DuiHuanOpenX == 2)
         {
            DianQuanDuiHuanOpen(1,10,226,5);
         }
      }
      
      public static function DuiHuanBtn2_2(param1:MouseEvent) : *
      {
         if(DuiHuanOpenX == 1)
         {
            DianQuanDuiHuanOpen(1,20,132,2);
         }
         else if(DuiHuanOpenX == 2)
         {
            DianQuanDuiHuanOpen(1,100,227,6);
         }
      }
      
      public static function DuiHuanBtn2_3(param1:MouseEvent) : *
      {
         if(DuiHuanOpenX == 1)
         {
            DianQuanDuiHuanOpen(1,10,133,3);
         }
         else if(DuiHuanOpenX == 2)
         {
            DianQuanDuiHuanOpen(1,6,229,7);
         }
      }
      
      public static function DuiHuanBtn2_4(param1:MouseEvent) : *
      {
         if(DuiHuanOpenX == 1)
         {
            DianQuanDuiHuanOpen(1,20,134,4);
         }
         else if(DuiHuanOpenX == 2)
         {
            DianQuanDuiHuanOpen(1,6,228,8);
         }
      }
      
      public static function GetObjID() : Array
      {
         var _loc1_:int = Math.random() * 10000 + 1;
         var _loc2_:int = 0;
         var _loc3_:int = 1;
         while(_loc3_ < PaiHang_Data.AllData.length)
         {
            _loc2_ += PaiHang_Data.AllData[_loc3_][2].getValue();
            if(_loc1_ <= _loc2_)
            {
               return PaiHang_Data.AllData[_loc3_];
            }
            _loc3_++;
         }
         return new Array();
      }
      
      public static function SelNum(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(2,1));
         selType = _loc2_;
         selTypeX = 0;
         TiaoShi.txtShow("大陆选择 = " + selType + "," + selTypeX);
         Show(true,true);
      }
      
      public static function Open() : *
      {
         LoadInGame.Open(TiaoZhan_Interface.loadData);
         Main._stage.addChild(_this);
         _this.visible = true;
         _this.x = _this.y = 0;
         Show(false,true);
      }
      
      public static function Close(param1:* = null) : *
      {
         if(noClose)
         {
            return;
         }
         _this.visible = false;
         _this.x = _this.y = 5000;
      }
      
      public static function NextFun(param1:* = null) : *
      {
         if(pageNum < 6)
         {
            ++pageNum;
            Show(false);
         }
      }
      
      public static function BackFun(param1:* = null) : *
      {
         if(pageNum > 1)
         {
            --pageNum;
            Show(false);
         }
      }
      
      public static function Show(param1:Boolean = false, param2:Boolean = false) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         if(!skin)
         {
            return;
         }
         skin["x0"].text = "查询中";
         skin["s0"].text = "查询中";
         _loc3_ = 1;
         while(_loc3_ < 10)
         {
            _loc7_ = (pageNum - 1) * 9 + _loc3_;
            skin["x" + _loc3_].text = "";
            skin["name" + _loc3_].text = "";
            skin["save" + _loc3_].text = "";
            skin["s" + _loc3_].text = "";
            _loc3_++;
         }
         if(!_this || _this.visible == false)
         {
            return;
         }
         PaiHang_Data.InitSave();
         JifenUP();
         Btn_Init(param1);
         if(Main.P1P2)
         {
            _loc5_ = 2;
         }
         else
         {
            _loc5_ = 1;
         }
         _loc4_ = int(PaiHang_Data["gameNum_x" + _loc5_ + "_" + selType][selTypeX]);
         var _loc6_:int = int(PaiHang_Data["gameNum_x" + _loc5_ + "_" + selType][0]);
         if(!PaiHang_Data.paiHangArr[_loc4_])
         {
            Api_4399_All.GetOneRankInfo(Main.logName,_loc4_,1);
            return;
         }
         if(!PaiHang_Data.paiHangArr[_loc4_][1])
         {
            Api_4399_All.GetRankListsData(1,50,_loc4_);
            return;
         }
         if(PaiHang_Data.paiHangArr[_loc4_][0])
         {
            _loc8_ = PaiHang_Data.paiHangArr[_loc4_][0];
            skin["x0"].text = _loc8_.rank;
            skin["s0"].text = _loc8_.score;
         }
         else
         {
            skin["x0"].text = "未上榜";
            skin["s0"].text = "未上榜";
         }
         _loc3_ = 1;
         while(_loc3_ < 10)
         {
            _loc7_ = (pageNum - 1) * 9 + _loc3_;
            if(PaiHang_Data.paiHangArr[_loc4_][_loc7_])
            {
               _loc9_ = PaiHang_Data.paiHangArr[_loc4_][_loc7_];
               skin["x" + _loc3_].text = _loc7_;
               skin["name" + _loc3_].text = _loc9_.userName;
               skin["save" + _loc3_].text = uint(_loc9_.index) + 1;
               skin["s" + _loc3_].text = _loc9_.score;
               if(_loc7_ <= 3)
               {
                  TiaoZhanPaiHang_Interface["ShowArr" + _loc7_] = _loc9_.extra;
               }
            }
            _loc3_++;
         }
         if(pageNum != 1)
         {
            skin["xxx_mc"].visible = false;
         }
         else
         {
            skin["xxx_mc"].visible = true;
         }
         skin["jf0"].text = PaiHang_Data.jiFenArr[1].getValue() + "/500";
         skin["jf1"].text = PaiHang_Data.jiFenArr[2].getValue() + "/500";
         skin["jf2"].text = PaiHang_Data.jiFenArr[3].getValue() + "/500";
         skin["jf3"].text = PaiHang_Data.jiFenArr[4].getValue() + "/500";
         if(param2)
         {
            skin.loading_mc.visible = true;
            ShowPlayerLoad(_loc6_);
         }
      }
      
      public static function JifenUP() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(dengDai)
         {
            return false;
         }
         if(PaiHang_Data.jiFenArr[0].getValue() != Main.serverTime.getValue())
         {
            if(Main.P1P2)
            {
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x2_1[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x2_1[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x2_2[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x2_2[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x2_3[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x2_3[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x2_0[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x2_0[0],1);
                  dengDai = true;
                  return false;
               }
            }
            else
            {
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x1_1[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x1_1[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x1_2[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x1_2[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x1_3[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x1_3[0],1);
                  dengDai = true;
                  return false;
               }
               if(!PaiHang_Data.paiHangArr[PaiHang_Data.gameNum_x1_0[0]])
               {
                  Api_4399_All.GetOneRankInfo(Main.logName,PaiHang_Data.gameNum_x1_0[0],1);
                  dengDai = true;
                  return false;
               }
            }
            _loc1_ = ["总战绩排名:","勇者大陆排名:","暗黑大陆排名:","失落大陆排名:"];
            _loc2_ = _loc1_.length - 1;
            _loc3_ = 0;
            while(_loc3_ <= _loc2_)
            {
               if(Main.P1P2)
               {
                  _loc5_ = 2;
               }
               else
               {
                  _loc5_ = 1;
               }
               _loc4_ = int(PaiHang_Data["gameNum_x" + _loc5_ + "_" + _loc3_][0]);
               skin["jfMC"]["jfx" + _loc3_].text = "0";
               skin["jfMC"]["x_" + _loc3_].text = _loc1_[_loc3_] + " 未进榜";
               if(Boolean(PaiHang_Data.paiHangArr[_loc4_]) && Boolean(PaiHang_Data.paiHangArr[_loc4_][0]))
               {
                  _loc6_ = PaiHang_Data.paiHangArr[_loc4_][0];
                  _loc7_ = int(_loc6_.rank);
                  _loc8_ = _loc3_;
                  if(_loc8_ == 0)
                  {
                     _loc8_ = 4;
                  }
                  _loc9_ = int((PaiHang_Data.jiFenArr[_loc8_] as VT).getValue());
                  if(_loc7_ == InitData.tiaoZhanJF_1.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_100.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "100";
                  }
                  else if(_loc7_ == InitData.tiaoZhanJF_2.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_80.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "80";
                  }
                  else if(_loc7_ == InitData.tiaoZhanJF_3.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_60.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "60";
                  }
                  else if(_loc7_ < InitData.tiaoZhanJF_10.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_40.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "40";
                  }
                  else if(_loc7_ < InitData.tiaoZhanJF_100.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_20.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "20";
                  }
                  else if(_loc7_ <= InitData.tiaoZhanJF_500.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(_loc9_ + InitData.tiaoZhanJF_10.getValue());
                     skin["jfMC"]["jfx" + _loc3_].text = "10";
                  }
                  if(PaiHang_Data.jiFenArr[_loc8_].getValue() > InitData.tiaoZhanJF_500.getValue())
                  {
                     PaiHang_Data.jiFenArr[_loc8_] = VT.createVT(InitData.tiaoZhanJF_500.getValue());
                  }
                  if(_loc7_ > 0 && _loc7_ <= 5000)
                  {
                     skin["jfMC"]["x_" + _loc3_].text = _loc1_[_loc3_] + " 第" + _loc7_ + "名";
                  }
                  skin["jfMC"].x = skin["jfMC"].y = 0;
                  skin["jfMC"].ok_btn.addEventListener(MouseEvent.CLICK,jfMC_Close);
               }
               if(_loc3_ == _loc2_)
               {
                  PaiHang_Data.jiFenArr[0].setValue(Main.serverTime.getValue());
                  Main.Save();
                  Show(false,true);
                  return true;
               }
               _loc3_++;
            }
         }
         return true;
      }
      
      private static function jfMC_Close(param1:*) : *
      {
         skin["jfMC"].x = skin["jfMC"].y = -5000;
         Show();
      }
      
      private static function Btn_Init(param1:Boolean) : *
      {
         var _loc3_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc2_:int = selTypeX;
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            if(selType == _loc3_)
            {
               skin["XX" + _loc3_].gotoAndStop(3);
            }
            else
            {
               skin["XX" + _loc3_].gotoAndStop(2);
            }
            _loc3_++;
         }
         var _loc4_:int = int(selTypeMaxNum[selType]);
         _loc3_ = 0;
         while(_loc3_ <= 999)
         {
            if(!skin["btn" + _loc3_])
            {
               break;
            }
            _loc6_ = skin["btn" + _loc3_];
            _loc6_.mouseChildren = false;
            _loc6_.addEventListener(MouseEvent.CLICK,btnCLICK);
            _loc6_.addEventListener(MouseEvent.MOUSE_MOVE,btnMOVE);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,btnMOUSE_OUT);
            if(_loc3_ > 0 && param1)
            {
               _loc6_.x = (_loc3_ - 1) * 28 + 61;
            }
            _loc6_.gotoAndStop(1);
            if(selTypeX == _loc3_)
            {
               _loc6_.gotoAndStop(3);
            }
            if(_loc3_ <= _loc4_ && _loc6_.x > 60 && _loc6_.x < 365)
            {
               _loc6_.visible = true;
            }
            else
            {
               _loc6_.visible = false;
            }
            if(_loc3_ == 0)
            {
               _loc6_.visible = true;
            }
            _loc3_++;
         }
         var _loc5_:int = 1;
         if(selType == 2)
         {
            _loc2_ += 9;
         }
         else if(selType == 3)
         {
            _loc2_ += 50;
         }
         else if(selType == 4)
         {
            _loc2_ += 17;
         }
         if(selTypeX == 0)
         {
            skin["guanka_mc"].gotoAndStop("x" + selType);
         }
         else
         {
            skin["guanka_mc"].gotoAndStop("d" + _loc2_);
         }
      }
      
      private static function btnCLICK(param1:MouseEvent) : *
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = int((param1.target.name as String).substr(3));
         param1.target.gotoAndStop(3);
         pageNum = 1;
         selTypeX = _loc2_;
         TiaoShi.txtShow("选择" + _loc2_);
         var _loc3_:MovieClip = MovieClip(param1.target);
         var _loc4_:int = int(selTypeMaxNum[selType]);
         var _loc5_:int = 1;
         if(_loc4_ > 10)
         {
            if(_loc3_.x < 90)
            {
               _loc5_ -= 9;
               if(_loc5_ < 1)
               {
                  _loc5_ = 1;
               }
            }
            else if(_loc3_.x > 300)
            {
               _loc5_ += 9;
               if(_loc5_ > _loc4_ - 9)
               {
                  _loc5_ = _loc4_ - 9;
               }
            }
            _loc6_ = (_loc5_ - 1) * 28;
            TiaoShi.txtShow("one = " + _loc5_ + ", move = " + _loc6_);
            _loc7_ = 1;
            while(_loc7_ <= _loc4_)
            {
               _loc3_ = skin["btn" + _loc7_];
               _loc3_.x = (_loc7_ - 1) * 28 + 61 - _loc6_;
               _loc7_++;
            }
         }
         Show();
      }
      
      private static function btnMOVE(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(3));
         if(selTypeX != _loc2_)
         {
            param1.target.gotoAndStop(2);
         }
      }
      
      private static function btnMOUSE_OUT(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(3));
         if(selTypeX != _loc2_)
         {
            param1.target.gotoAndStop(1);
         }
      }
      
      public static function ShowPlayerLoad(param1:int) : *
      {
         var _loc4_:MovieClip = null;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc2_:int = 1;
         while(_loc2_ <= 3)
         {
            _loc4_ = TiaoZhanPaiHang_Interface["Show" + _loc2_];
            _loc4_.visible = false;
            _loc2_++;
         }
         var _loc3_:int = 0;
         if(PaiHang_Data.paiHangArr[param1])
         {
            _loc2_ = 1;
            while(_loc2_ <= 3)
            {
               if(PaiHang_Data.paiHangArr[param1][_loc2_])
               {
                  _loc5_ = PaiHang_Data.paiHangArr[param1][_loc2_];
                  if(_loc5_.extra)
                  {
                     _loc6_ = Boolean((TiaoZhanPaiHang_Interface["Show" + _loc2_] as PlayerShow).Loading(_loc5_.extra));
                     if(_loc6_)
                     {
                        _loc3_++;
                     }
                  }
                  else
                  {
                     (TiaoZhanPaiHang_Interface["Show" + _loc2_] as PlayerShow).Loading();
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         }
         ShowPlayer_selType = selType;
         ShowPlayer_selTypeX = selTypeX;
         if(_loc3_ >= 3 && Boolean(NewLoad.loadingYN))
         {
            ShowPlayer();
         }
      }
      
      public static function ShowPlayer() : *
      {
         var _loc1_:int = 0;
         var _loc3_:MovieClip = null;
         if(Main.P1P2)
         {
            _loc1_ = 2;
         }
         else
         {
            _loc1_ = 1;
         }
         var _loc2_:int = int(PaiHang_Data["gameNum_x" + _loc1_ + "_" + selType][0]);
         i = 1;
         while(i <= 3)
         {
            _loc3_ = TiaoZhanPaiHang_Interface["Show" + i];
            _loc3_.visible = false;
            (TiaoZhanPaiHang_Interface["Show" + i] as PlayerShow).AddSkin();
            if(Boolean(PaiHang_Data.paiHangArr[_loc2_]) && Boolean(PaiHang_Data.paiHangArr[_loc2_][i]) && Boolean(PaiHang_Data.paiHangArr[_loc2_][i].userName))
            {
               skin["playName" + i].text = PaiHang_Data.paiHangArr[_loc2_][i].userName;
            }
            else
            {
               skin["playName" + i].text = "";
            }
            ++i;
         }
         skin.loading_mc.visible = false;
      }
   }
}

