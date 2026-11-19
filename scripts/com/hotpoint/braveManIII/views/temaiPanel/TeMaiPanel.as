package com.hotpoint.braveManIII.views.temaiPanel
{
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class TeMaiPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var fpp:TeMaiPanel;
      
      public static var tmPanel:MovieClip;
      
      private static var loadData:ClassLoader;
      
      public static var save_OK:Boolean = false;
      
      public static var OK990:Boolean = false;
      
      public static var OK19:Boolean = false;
      
      public static var OK499:Boolean = false;
      
      public static var OK79:Boolean = false;
      
      public static var OK29:Boolean = false;
      
      public static var OK499_1:Boolean = false;
      
      public static var OK499_2:Boolean = false;
      
      public static var OK260_1:Boolean = false;
      
      public static var OK260_2:Boolean = false;
      
      private static var loadName:String = "TeMai_v930.swf";
      
      private static var OpenYN:Boolean = false;
      
      private static var caonima:int = 0;
      
      public function TeMaiPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!tmPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("TeMaiShow") as Class;
         tmPanel = new _loc2_();
         fpp.addChild(tmPanel);
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
         fpp = new TeMaiPanel();
         LoadSkin();
         Main._stage.addChild(fpp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         fpp = new TeMaiPanel();
         Main._stage.addChild(fpp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(tmPanel)
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
         if(tmPanel)
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
      
      public static function removeListenerP1() : *
      {
      }
      
      public static function addListenerP1() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            tmPanel["m" + _loc1_].mouseChildren = false;
            tmPanel["m" + _loc1_].stop();
            tmPanel["m" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            tmPanel["m" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            _loc1_++;
         }
         tmPanel["btn0"].addEventListener(MouseEvent.CLICK,gouMai0);
         tmPanel["btn1"].addEventListener(MouseEvent.CLICK,gouMai1);
         tmPanel["btn2"].addEventListener(MouseEvent.CLICK,gouMai2);
         tmPanel["btn3"].addEventListener(MouseEvent.CLICK,gouMai3);
         tmPanel["rmb19"].visible = false;
         tmPanel["rmb499"].visible = false;
         tmPanel["rmb499_1"].visible = false;
         tmPanel["rmb499_2"].visible = false;
         tmPanel["rmb79"].visible = false;
         tmPanel["rmb990"].visible = false;
         tmPanel["rmb29"].visible = false;
         tmPanel["rmb260_1"].visible = false;
         tmPanel["rmb260_2"].visible = false;
         tmPanel["rmb19"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB499_2);
         tmPanel["rmb499"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB499);
         tmPanel["rmb499_1"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB499_1);
         tmPanel["rmb499_2"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB499_2);
         tmPanel["rmb79"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB79);
         tmPanel["rmb990"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB990);
         tmPanel["rmb29"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB29);
         tmPanel["rmb260_1"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB260_1);
         tmPanel["rmb260_2"]["yes_btn"].addEventListener(MouseEvent.CLICK,RMB260_2);
         tmPanel["rmb19"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb499"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb499_1"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb499_2"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb79"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb990"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb29"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb260_1"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["rmb260_2"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         tmPanel["go_btn"].addEventListener(MouseEvent.CLICK,go_btn);
         tmPanel["close"].addEventListener(MouseEvent.CLICK,closeCP);
         show();
      }
      
      public static function show() : *
      {
         if(!Main.isVip())
         {
            caonima = 0;
            tmPanel["m0"].gotoAndStop(1);
         }
         else
         {
            caonima = 3;
            tmPanel["m0"].gotoAndStop(4);
         }
         tmPanel["m1"].gotoAndStop(2);
         tmPanel["m2"].gotoAndStop(2);
         tmPanel["m3"].gotoAndStop(2);
      }
      
      public static function gouMai0(param1:*) : *
      {
         if(caonima == 0)
         {
            tmPanel["rmb990"].visible = true;
         }
         else if(caonima == 1)
         {
            tmPanel["rmb260_1"].visible = true;
         }
         else if(caonima == 2)
         {
            tmPanel["rmb260_2"].visible = true;
         }
         else if(caonima == 3)
         {
            tmPanel["rmb79"].visible = true;
         }
      }
      
      public static function gouMai1(param1:*) : *
      {
         tmPanel["rmb499"].visible = true;
      }
      
      public static function gouMai2(param1:*) : *
      {
         tmPanel["rmb499_1"].visible = true;
      }
      
      public static function gouMai3(param1:*) : *
      {
         tmPanel["rmb499_2"].visible = true;
      }
      
      public static function go_btn(param1:*) : *
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      public static function no_btn(param1:*) : *
      {
         tmPanel["rmb19"].visible = false;
         tmPanel["rmb499"].visible = false;
         tmPanel["rmb499_1"].visible = false;
         tmPanel["rmb499_2"].visible = false;
         tmPanel["rmb79"].visible = false;
         tmPanel["rmb990"].visible = false;
         tmPanel["rmb29"].visible = false;
         tmPanel["rmb260_1"].visible = false;
         tmPanel["rmb260_2"].visible = false;
      }
      
      public static function RMB260_1(param1:*) : *
      {
         if(Main.player1.getBag().backequipBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 260)
         {
            Api_4399_All.BuyObj(InitData.temai159.getValue());
            OK260_1 = true;
            tmPanel["rmb260_1"].visible = false;
         }
         else
         {
            tmPanel["rmb260_1"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB260_2(param1:*) : *
      {
         if(Main.player1.getBag().backequipBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 260)
         {
            Api_4399_All.BuyObj(InitData.temai159.getValue());
            OK260_2 = true;
            tmPanel["rmb260_2"].visible = false;
         }
         else
         {
            tmPanel["rmb260_2"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB990(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 990)
         {
            Api_4399_All.BuyObj(InitData.temai144.getValue());
            OK990 = true;
            tmPanel["rmb990"].visible = false;
         }
         else
         {
            tmPanel["rmb990"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB29(param1:*) : *
      {
         if(Main.player1.getBag().backGemBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 29)
         {
            Api_4399_All.BuyObj(InitData.temai145.getValue());
            OK29 = true;
            tmPanel["rmb29"].visible = false;
         }
         else
         {
            tmPanel["rmb29"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB19(param1:*) : *
      {
         if(Main.player1.getBag().backGemBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 19)
         {
            Api_4399_All.BuyObj(InitData.temai146.getValue());
            OK19 = true;
            tmPanel["rmb19"].visible = false;
         }
         else
         {
            tmPanel["rmb19"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB79(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 79)
         {
            Api_4399_All.BuyObj(InitData.temai147.getValue());
            OK79 = true;
            tmPanel["rmb79"].visible = false;
            Api_4399_GongHui.upNum(53);
         }
         else
         {
            tmPanel["rmb79"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB499(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 499)
         {
            Api_4399_All.BuyObj(InitData.temai148.getValue());
            OK499 = true;
            tmPanel["rmb499"].visible = false;
         }
         else
         {
            tmPanel["rmb499"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB499_1(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 499)
         {
            Api_4399_All.BuyObj(InitData.temai237.getValue());
            OK499_1 = true;
            tmPanel["rmb499_1"].visible = false;
         }
         else
         {
            tmPanel["rmb499_1"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB499_2(param1:*) : *
      {
         if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足，请整理背包");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 499)
         {
            Api_4399_All.BuyObj(InitData.temai238.getValue());
            OK499_2 = true;
            tmPanel["rmb499_2"].visible = false;
         }
         else
         {
            tmPanel["rmb499_2"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function RMB2601_OK() : *
      {
         if(OK260_1)
         {
            Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14703));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK260_1 = false;
         }
      }
      
      public static function RMB2602_OK() : *
      {
         if(OK260_2)
         {
            Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14709));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK260_2 = false;
         }
      }
      
      public static function RMB990_OK() : *
      {
         if(OK990)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63215));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK990 = false;
         }
      }
      
      public static function RMB29_OK() : *
      {
         if(OK29)
         {
            Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK29 = false;
         }
      }
      
      public static function RMB19_OK() : *
      {
         if(OK19)
         {
            Main.player1.getBag().addGemBag(GemFactory.creatGemById(33512));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK19 = false;
         }
      }
      
      public static function RMB79_OK() : *
      {
         if(OK79)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK79 = false;
         }
      }
      
      public static function RMB499_OK() : *
      {
         if(OK499)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63251));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK499 = false;
         }
      }
      
      public static function RMB499_1_OK() : *
      {
         if(OK499_1)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63280));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK499_1 = false;
         }
      }
      
      public static function RMB499_2_OK() : *
      {
         if(OK499_2)
         {
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63291));
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            OK499_2 = false;
         }
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         tmPanel.addChild(itemsTooltip);
         itemsTooltip.mouseChildren = false;
         var _loc3_:String = _loc2_.name;
         if(_loc3_ == "m0")
         {
            if(caonima == 0)
            {
               itemsTooltip.otherTooltip(OtherFactory.creatOther(63215));
            }
            else if(caonima == 1)
            {
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(14703));
            }
            else if(caonima == 2)
            {
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(14709));
            }
            else if(caonima == 3)
            {
               itemsTooltip.otherTooltip(OtherFactory.creatOther(63204));
            }
            itemsTooltip.y = tmPanel.mouseY - 150;
         }
         else if(_loc3_ == "m1")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63251));
            itemsTooltip.y = tmPanel.mouseY - 150;
         }
         else if(_loc3_ == "m2")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63280));
            itemsTooltip.y = tmPanel.mouseX - 150;
         }
         else if(_loc3_ == "m3")
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(63291));
            itemsTooltip.y = tmPanel.mouseY - 150;
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = tmPanel.mouseX - 100;
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
   }
}

