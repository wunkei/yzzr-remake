package com.hotpoint.braveManIII.views.fanpaiPanel
{
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class FanPaiPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var fpp:FanPaiPanel;
      
      public static var ccc:ClassLoader;
      
      public static var fanPanel:MovieClip;
      
      private static var loadData:ClassLoader;
      
      private static var fanNum:int;
      
      public static var arr:Array = [0,1,2,3,4,5,6,7,8];
      
      public static var times:int = 0;
      
      public static var countRMB:int = 0;
      
      public static var saveArr:Array = [0,0,0,0,0,0,0,0,0];
      
      public static var JFOK:Boolean = false;
      
      public static var saveArr2:Array = [1,0,0,0];
      
      private static var loadName:String = "FanPai_v3.swf";
      
      private static var OpenYN:Boolean = false;
      
      private static var DayChange:Boolean = true;
      
      private static var clickBool:Boolean = true;
      
      private static var timeTemp:int = 0;
      
      public static var jifenTime:int = 0;
      
      public static var start:int = 0;
      
      public static var end:int = 0;
      
      public function FanPaiPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!fanPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("FanpaiShow") as Class;
         fanPanel = new _loc2_();
         fpp.addChild(fanPanel);
         if(OpenYN)
         {
            open();
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         fpp = new FanPaiPanel();
         LoadSkin();
         Main._stage.addChild(fpp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         fpp = new FanPaiPanel();
         if(jifenTime <= 0)
         {
         }
         Main._stage.addChild(fpp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(fanPanel)
         {
            Main.stopXX = true;
            fpp.x = 0;
            fpp.y = 0;
            addListenerP1();
            fpp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(fanPanel)
         {
            fpp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      public static function closeCP(param1:*) : *
      {
         close();
      }
      
      public static function countTimes() : *
      {
         var _loc1_:* = undefined;
         times = 0;
         for(_loc1_ in saveArr)
         {
            if(saveArr[_loc1_] >= 1)
            {
               ++times;
            }
         }
      }
      
      public static function initFanPai() : *
      {
         saveArr = [0,0,0,0,0,0,0,0,0];
         saveArr2[1] = saveArr2[2] = saveArr2[3] = 0;
         setRandom();
         var _loc1_:uint = 0;
         while(_loc1_ < 9)
         {
            fanPanel["fan" + _loc1_].gotoAndStop(1);
            fanPanel["fan" + _loc1_].visible = true;
            fanPanel["pai" + _loc1_].visible = false;
            fanPanel["pai" + _loc1_]["duihuan"].visible = true;
            fanPanel["fan" + _loc1_]["tt"].visible = true;
            _loc1_++;
         }
      }
      
      public static function showFanPai() : *
      {
         var _loc1_:uint = 0;
         countTimes();
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            fanPanel["fan" + _loc1_]["tt"].text = "消耗" + 10 * (times + 1) + "积分翻牌";
            _loc1_++;
         }
         fanPanel["tongji"].text = saveArr2[3];
         fanPanel["jifenRBM"]["dianjuan"].text = Shop4399.moneyAll.getValue();
         fanPanel["txt_jf"]["t1"].text = "在线积分:" + saveArr2[1] + "/300";
         fanPanel["txt_jf"]["t2"].text = "杀怪积分:" + saveArr2[2] + "/500";
         for(_loc1_ in saveArr)
         {
            if(saveArr[_loc1_] == 0)
            {
               fanPanel["fan" + _loc1_].gotoAndStop(1);
               fanPanel["fan" + _loc1_].visible = true;
            }
            if(saveArr[_loc1_] >= 1)
            {
               fanPanel["fan" + _loc1_].visible = false;
               fanPanel["pai" + _loc1_].visible = true;
               fanPanel["pai" + _loc1_]["duihuan"].visible = true;
               if(saveArr[_loc1_] == 2)
               {
                  fanPanel["pai" + _loc1_]["duihuan"].visible = false;
               }
            }
         }
         fanPanel["pai" + arr[0]].x = 360.3;
         fanPanel["pai" + arr[0]].y = 102;
         fanPanel["pai" + arr[1]].x = 500.85;
         fanPanel["pai" + arr[1]].y = 102;
         fanPanel["pai" + arr[2]].x = 645.25;
         fanPanel["pai" + arr[2]].y = 102;
         fanPanel["pai" + arr[3]].x = 784.75;
         fanPanel["pai" + arr[3]].y = 102;
         fanPanel["pai" + arr[4]].x = 360.3;
         fanPanel["pai" + arr[4]].y = 280;
         fanPanel["pai" + arr[5]].x = 500.85;
         fanPanel["pai" + arr[5]].y = 280;
         fanPanel["pai" + arr[6]].x = 645.25;
         fanPanel["pai" + arr[6]].y = 280;
         fanPanel["pai" + arr[7]].x = 784.75;
         fanPanel["pai" + arr[7]].y = 280;
         fanPanel["pai" + arr[8]].x = 967.25;
         fanPanel["pai" + arr[8]].y = 102;
         fanPanel["fan" + arr[0]].x = 360.3;
         fanPanel["fan" + arr[0]].y = 102;
         fanPanel["fan" + arr[1]].x = 500.85;
         fanPanel["fan" + arr[1]].y = 102;
         fanPanel["fan" + arr[2]].x = 645.25;
         fanPanel["fan" + arr[2]].y = 102;
         fanPanel["fan" + arr[3]].x = 784.75;
         fanPanel["fan" + arr[3]].y = 102;
         fanPanel["fan" + arr[4]].x = 360.3;
         fanPanel["fan" + arr[4]].y = 280;
         fanPanel["fan" + arr[5]].x = 500.85;
         fanPanel["fan" + arr[5]].y = 280;
         fanPanel["fan" + arr[6]].x = 645.25;
         fanPanel["fan" + arr[6]].y = 280;
         fanPanel["fan" + arr[7]].x = 784.75;
         fanPanel["fan" + arr[7]].y = 280;
         fanPanel["fan" + arr[8]].x = 967.25;
         fanPanel["fan" + arr[8]].y = 102;
      }
      
      public static function addListenerP1() : *
      {
         if(saveArr2[0] != Main.serverTime.getValue())
         {
            initFanPai();
            saveArr2[0] = Main.serverTime.getValue();
         }
         showFanPai();
         var _loc1_:uint = 0;
         while(_loc1_ < 9)
         {
            fanPanel["fan" + _loc1_].addEventListener(MouseEvent.CLICK,gofan);
            fanPanel["pai" + _loc1_]["duihuan"].addEventListener(MouseEvent.CLICK,duiHuan);
            fanPanel["fan" + _loc1_]["tt"].mouseEnabled = false;
            fanPanel["m" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            fanPanel["m" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            _loc1_++;
         }
         fanPanel["txt_jf"].visible = false;
         fanPanel["jfmx"].addEventListener(MouseEvent.MOUSE_OVER,txtOpen);
         fanPanel["jfmx"].addEventListener(MouseEvent.MOUSE_OUT,txtClose);
         fanPanel["close"].addEventListener(MouseEvent.CLICK,closeCP);
         fanPanel["jifenRBM"].visible = false;
         fanPanel["ifRMB"].visible = false;
         fanPanel["ifRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,buyRMB);
         fanPanel["ifRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,closeIF);
         fanPanel["jifenRBM"]["close"].addEventListener(MouseEvent.CLICK,closeRMB);
         fanPanel["jifenRBM"]["buy_10"].addEventListener(MouseEvent.CLICK,buyRMB10);
         fanPanel["jifenRBM"]["buy_30"].addEventListener(MouseEvent.CLICK,buyRMB30);
         fanPanel["jifenRBM"]["buy_50"].addEventListener(MouseEvent.CLICK,buyRMB50);
         fanPanel["goumai"].addEventListener(MouseEvent.CLICK,openRMB);
      }
      
      public static function txtOpen(param1:*) : *
      {
         fanPanel["txt_jf"].visible = true;
      }
      
      public static function txtClose(param1:*) : *
      {
         fanPanel["txt_jf"].visible = false;
      }
      
      public static function openRMB(param1:*) : *
      {
         fanPanel["jifenRBM"].visible = true;
      }
      
      public static function closeRMB(param1:*) : *
      {
         fanPanel["jifenRBM"].visible = false;
      }
      
      public static function closeIF(param1:*) : *
      {
         fanPanel["ifRMB"].visible = false;
      }
      
      public static function buyRMB10(param1:*) : *
      {
         countRMB = 10;
         fanPanel["ifRMB"].visible = true;
      }
      
      public static function buyRMB30(param1:*) : *
      {
         countRMB = 30;
         fanPanel["ifRMB"].visible = true;
      }
      
      public static function buyRMB50(param1:*) : *
      {
         countRMB = 50;
         fanPanel["ifRMB"].visible = true;
      }
      
      public static function buyRMB(param1:*) : *
      {
         if(countRMB == 10)
         {
            if(Shop4399.moneyAll.getValue() >= 10)
            {
               Api_4399_All.BuyObj(InitData.jifen10.getValue());
               JFOK = true;
               fanPanel["ifRMB"].visible = false;
               fanPanel["jifenRBM"].visible = false;
            }
            else
            {
               fanPanel["ifRMB"].visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
            }
         }
         if(countRMB == 30)
         {
            if(Shop4399.moneyAll.getValue() >= 30)
            {
               Api_4399_All.BuyObj(InitData.jifen30.getValue());
               JFOK = true;
               fanPanel["ifRMB"].visible = false;
               fanPanel["jifenRBM"].visible = false;
            }
            else
            {
               fanPanel["ifRMB"].visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
            }
         }
         if(countRMB == 50)
         {
            if(Shop4399.moneyAll.getValue() >= 50)
            {
               Api_4399_All.BuyObj(InitData.jifen50.getValue());
               JFOK = true;
               fanPanel["ifRMB"].visible = false;
               fanPanel["jifenRBM"].visible = false;
            }
            else
            {
               fanPanel["ifRMB"].visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
            }
         }
      }
      
      public static function jifenOK() : *
      {
         if(JFOK)
         {
            if(countRMB == 10)
            {
               saveArr2[3] += 50;
            }
            if(countRMB == 30)
            {
               saveArr2[3] += 160;
            }
            if(countRMB == 50)
            {
               saveArr2[3] += 280;
            }
            fanPanel["tongji"].text = saveArr2[3];
            fanPanel["jifenRBM"]["dianjuan"].text = Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            JFOK = false;
         }
      }
      
      private static function setRandom() : *
      {
         var _loc1_:Array = [];
         while(arr.length > 0)
         {
            _loc1_.push(arr.splice(Math.floor(Math.random() * arr.length),1)[0]);
         }
         arr = _loc1_;
      }
      
      public static function removeListenerP1() : *
      {
      }
      
      public static function gofan(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         if(saveArr2[3] >= 10 * (times + 1))
         {
            if(clickBool)
            {
               saveArr2[3] -= 10 * (times + 1);
               fanPanel["tongji"].text = saveArr2[3];
               clickBool = false;
               _loc2_ = param1.target as MovieClip;
               fanNum = int(_loc2_.name.substr(3,1));
               saveArr[fanNum] = 1;
               fanPanel["fan" + fanNum]["tt"].visible = false;
               _loc2_.play();
               Main.Save();
               fanPanel.addEventListener(Event.ENTER_FRAME,showPai);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
         }
      }
      
      public static function showPai(param1:*) : *
      {
         var _loc2_:uint = 0;
         ++timeTemp;
         if(timeTemp > 20)
         {
            fanPanel["pai" + fanNum].visible = true;
         }
         if(timeTemp > 21)
         {
            countTimes();
            _loc2_ = 0;
            while(_loc2_ < 9)
            {
               fanPanel["fan" + _loc2_]["tt"].text = "消耗" + 10 * (times + 1) + "积分翻牌";
               _loc2_++;
            }
            clickBool = true;
            timeTemp = 0;
            fanPanel.removeEventListener(Event.ENTER_FRAME,showPai);
         }
      }
      
      public static function duiHuan(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = (param1.target as SimpleButton).parent;
         if(_loc2_.name == "pai0")
         {
            if(Main.player1.getBag().backSuppliesBagNum() > 0)
            {
               if(saveArr2[3] >= 20)
               {
                  saveArr2[3] -= 20;
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21223));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[0] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         if(_loc2_.name == "pai1")
         {
            if(Main.player1.getBag().backOtherBagNum() > 0)
            {
               if(saveArr2[3] >= 700)
               {
                  saveArr2[3] -= 700;
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[1] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         if(_loc2_.name == "pai2")
         {
            if(Main.player1.getBag().backSuppliesBagNum() > 0)
            {
               if(saveArr2[3] >= 100)
               {
                  saveArr2[3] -= 100;
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[2] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"药品栏空间不足");
            }
         }
         if(_loc2_.name == "pai3")
         {
            if(saveArr2[3] >= 130)
            {
               saveArr2[3] -= 130;
               NewPetPanel.XGkey.setValue(NewPetPanel.XGkey.getValue() + 1);
               (param1.target as SimpleButton).visible = false;
               saveArr[3] = 2;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
            }
         }
         if(_loc2_.name == "pai4")
         {
            if(Main.player1.getBag().backOtherBagNum() > 0)
            {
               if(saveArr2[3] >= 750)
               {
                  saveArr2[3] -= 750;
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[4] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         if(_loc2_.name == "pai5")
         {
            if(Main.player1.getBag().backOtherBagNum() > 0)
            {
               if(saveArr2[3] >= 50)
               {
                  saveArr2[3] -= 50;
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[5] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         if(_loc2_.name == "pai6")
         {
            if(Main.player1.getBag().backGemBagNum() > 0)
            {
               if(saveArr2[3] >= 700)
               {
                  saveArr2[3] -= 700;
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[6] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足");
            }
         }
         if(_loc2_.name == "pai7")
         {
            if(Main.player1.getBag().backOtherBagNum() > 0)
            {
               if(saveArr2[3] >= 250)
               {
                  saveArr2[3] -= 250;
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[7] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         if(_loc2_.name == "pai8")
         {
            if(Main.player1.getBag().backOtherBagNum() > 0)
            {
               if(saveArr2[3] >= 60)
               {
                  saveArr2[3] -= 60;
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                  (param1.target as SimpleButton).visible = false;
                  saveArr[8] = 2;
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"积分不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"其他栏空间不足");
            }
         }
         fanPanel["tongji"].text = saveArr2[3];
      }
      
      public static function addZaiXianJiFen(param1:*) : *
      {
         var _loc2_:Date = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         ++jifenTime;
         if(jifenTime == 2)
         {
            _loc2_ = new Date();
            _loc3_ = _loc2_.getHours();
            _loc4_ = _loc2_.getMinutes();
            _loc5_ = _loc2_.getSeconds();
            start = (_loc3_ * 3600 + _loc4_ * 60 + _loc5_) * 27;
         }
         if(jifenTime / 12960 > 1)
         {
            _loc2_ = new Date();
            _loc3_ = _loc2_.getHours();
            _loc4_ = _loc2_.getMinutes();
            _loc5_ = _loc2_.getSeconds();
            end = (_loc3_ * 3600 + _loc4_ * 60 + _loc5_) * 27;
            if(jifenTime - (end - start) < 600 * 27)
            {
               if(saveArr2[1] < 300)
               {
                  saveArr2[1] += 10;
                  saveArr2[3] += 10;
               }
            }
            else
            {
               Main.NoGame("翻牌");
            }
            jifenTime = 1;
         }
      }
      
      public static function addShaGuaiJiFen() : *
      {
         if(saveArr2[2] < 500)
         {
            saveArr2[2] += 1;
            saveArr2[3] += 1;
         }
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         fanPanel.addChild(itemsTooltip);
         var _loc3_:String = _loc2_.name;
         if(_loc3_ == "m0")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63256));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m1")
         {
            itemsTooltip.suppliesTooltip(SuppliesFactory.getSuppliesById(21223));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m2")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63255));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m3")
         {
            itemsTooltip.gemTooltip(GemFactory.creatGemById(33213));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m4")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63204));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m5")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63140));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m6")
         {
            itemsTooltip.suppliesTooltip(SuppliesFactory.getSuppliesById(21221));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m7")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63235));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         else if(_loc3_ == "m8")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63100));
            itemsTooltip.y = fanPanel.mouseY - 150;
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = fanPanel.mouseX - 100;
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
   }
}

