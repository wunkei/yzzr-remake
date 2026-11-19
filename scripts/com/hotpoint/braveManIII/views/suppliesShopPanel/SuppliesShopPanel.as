package com.hotpoint.braveManIII.views.suppliesShopPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.models.supplies.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import src.*;
   
   public class SuppliesShopPanel extends MovieClip
   {
      
      private static var yaopin:Supplies;
      
      public static var suppliesShowPanel:MovieClip;
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var dragObj:MovieClip;
      
      public static var clickObj:MovieClip;
      
      private static var pointx:Number;
      
      private static var pointy:Number;
      
      private static var oldNum:Number;
      
      private static var chosen:Supplies;
      
      public static var ssp:SuppliesShopPanel;
      
      public static var myPlayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      public static var isDown:Boolean = false;
      
      public static var returnx:Number = 0;
      
      public static var returny:Number = 0;
      
      public static var yaoOK:Boolean = false;
      
      public static var shopSuppliesList:Array = SuppliesFactory.createSuppliesByShop();
      
      private static var yeshu:int = 1;
      
      private static var clickTime:int = 0;
      
      private static var myMenu:ContextMenu = new ContextMenu();
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "NewYaoShop_v2.swf";
      
      public function SuppliesShopPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!suppliesShowPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function InitIcon() : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = suppliesShowPanel.getChildIndex(suppliesShowPanel["s1_" + _loc1_]);
            _loc2_.x = suppliesShowPanel["s1_" + _loc1_].x;
            _loc2_.y = suppliesShowPanel["s1_" + _loc1_].y;
            _loc2_.name = "s1_" + _loc1_;
            suppliesShowPanel.removeChild(suppliesShowPanel["s1_" + _loc1_]);
            suppliesShowPanel["s1_" + _loc1_] = _loc2_;
            suppliesShowPanel.addChild(_loc2_);
            suppliesShowPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("NewYaoShow") as Class;
         suppliesShowPanel = new _loc2_();
         ssp.addChild(suppliesShowPanel);
         InitIcon();
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
         ssp = new SuppliesShopPanel();
         LoadSkin();
         Main._stage.addChild(ssp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         ssp = new SuppliesShopPanel();
         Main._stage.addChild(ssp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(suppliesShowPanel)
         {
            Main.stopXX = true;
            ssp.x = 0;
            ssp.y = 0;
            myPlayer = Main.player1;
            addListenerP1();
            ssp.visible = true;
            JiHua_Interface.ppp1_12 = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(suppliesShowPanel)
         {
            ssp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      private static function CloseYP(param1:MouseEvent) : void
      {
         close();
      }
      
      public static function addListenerP1() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            suppliesShowPanel["s1_" + _loc1_].mouseChildren = false;
            suppliesShowPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            suppliesShowPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            suppliesShowPanel["s1_" + _loc1_].addEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.CLICK,BuySuppies);
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.MOUSE_OVER,BuyOVER);
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.MOUSE_OUT,BuyOUT);
            suppliesShowPanel["se_" + _loc2_].mouseEnabled = false;
            _loc2_++;
         }
         suppliesShowPanel["mySell"]["sell_btn"].addEventListener(MouseEvent.CLICK,sellSupplies);
         suppliesShowPanel["mySell"]["key_btn1"].addEventListener(MouseEvent.CLICK,setKey_1);
         suppliesShowPanel["mySell"]["key_btn2"].addEventListener(MouseEvent.CLICK,setKey_2);
         suppliesShowPanel["mySell"]["key_btn3"].addEventListener(MouseEvent.CLICK,setKey_3);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            suppliesShowPanel["se_" + _loc2_].stop();
            _loc2_++;
         }
         if(Main.P1P2)
         {
            suppliesShowPanel["bag1"].visible = true;
            suppliesShowPanel["bag2"].visible = true;
            suppliesShowPanel["xbag1"].visible = true;
            suppliesShowPanel["xbag2"].visible = true;
            suppliesShowPanel["bag1"].addEventListener(MouseEvent.CLICK,changeToOne);
            suppliesShowPanel["bag2"].addEventListener(MouseEvent.CLICK,changeToTwo);
         }
         else
         {
            suppliesShowPanel["bag1"].visible = false;
            suppliesShowPanel["bag2"].visible = false;
            suppliesShowPanel["xbag1"].visible = false;
            suppliesShowPanel["xbag2"].visible = false;
         }
         suppliesShowPanel["NoMoney_mc"]["no_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         suppliesShowPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         suppliesShowPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         suppliesShowPanel["leftPage"].addEventListener(MouseEvent.CLICK,upPage);
         suppliesShowPanel["rightPage"].addEventListener(MouseEvent.CLICK,downPage);
         suppliesShowPanel["closeYP"].addEventListener(MouseEvent.CLICK,CloseYP);
         suppliesShowPanel["mySell"].visible = false;
         suppliesShowPanel["NoMoney_mc"].visible = false;
         suppliesShowPanel["touming"].visible = false;
         suppliesShowPanel["goumaitishi"].mouseEnabled = false;
         suppliesShowPanel["npc_mc"].stop();
         allShow();
      }
      
      public static function removeListenerP1() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            suppliesShowPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            suppliesShowPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            suppliesShowPanel["s1_" + _loc1_].removeEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.CLICK,BuySuppies);
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.MOUSE_OVER,BuyOVER);
            suppliesShowPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.MOUSE_OUT,BuyOUT);
            _loc2_++;
         }
         suppliesShowPanel["mySell"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sellSupplies);
         suppliesShowPanel["mySell"]["key_btn1"].removeEventListener(MouseEvent.CLICK,setKey_1);
         suppliesShowPanel["mySell"]["key_btn2"].removeEventListener(MouseEvent.CLICK,setKey_2);
         suppliesShowPanel["mySell"]["key_btn3"].removeEventListener(MouseEvent.CLICK,setKey_3);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            suppliesShowPanel["se_" + _loc2_].stop();
            _loc2_++;
         }
         if(Main.P1P2)
         {
            suppliesShowPanel["bag1"].removeEventListener(MouseEvent.CLICK,changeToOne);
            suppliesShowPanel["bag2"].removeEventListener(MouseEvent.CLICK,changeToTwo);
         }
         suppliesShowPanel["leftPage"].removeEventListener(MouseEvent.CLICK,upPage);
         suppliesShowPanel["rightPage"].removeEventListener(MouseEvent.CLICK,downPage);
         suppliesShowPanel["closeYP"].removeEventListener(MouseEvent.CLICK,CloseYP);
      }
      
      private static function closeNORMB(param1:*) : void
      {
         suppliesShowPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      private static function changeToOne(param1:*) : *
      {
         myPlayer = Main.player1;
         allShow();
      }
      
      private static function changeToTwo(param1:*) : *
      {
         myPlayer = Main.player2;
         allShow();
      }
      
      private static function upPage(param1:*) : *
      {
         if(yeshu > 1)
         {
            --yeshu;
         }
         allShow();
      }
      
      private static function downPage(param1:*) : *
      {
         var _loc2_:Array = shopSuppliesList;
         if(yeshu < Math.ceil(_loc2_.length / 6))
         {
            ++yeshu;
         }
         allShow();
      }
      
      public static function allShow() : void
      {
         var _loc1_:uint = 0;
         var _loc4_:int = 0;
         if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 0)
         {
            suppliesShowPanel["npc_mc"].gotoAndStop(1);
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 3)
         {
            suppliesShowPanel["npc_mc"].gotoAndStop(2);
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 4)
         {
            suppliesShowPanel["npc_mc"].gotoAndStop(3);
         }
         if(Main.P1P2)
         {
            if(myPlayer == Main.player1)
            {
               suppliesShowPanel["bag1"].visible = false;
               suppliesShowPanel["bag2"].visible = true;
            }
            else
            {
               suppliesShowPanel["bag1"].visible = true;
               suppliesShowPanel["bag2"].visible = false;
            }
         }
         suppliesShowPanel["gold_txt"].text = myPlayer.getGold();
         suppliesShowPanel["kill_txt"].text = myPlayer.getKillPoint();
         suppliesShowPanel["rmb_txt"].text = Shop4399.moneyAll.getValue();
         myPlayer.getBag().zhengliBagS();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            suppliesShowPanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myPlayer.getBag().getSuppliesFromBag(_loc1_) != null)
            {
               suppliesShowPanel["s1_" + _loc1_].gotoAndStop(myPlayer.getBag().getSuppliesFromBag(_loc1_).getFrame());
               suppliesShowPanel["s1_" + _loc1_].visible = true;
               if(myPlayer.getBag().getSuppliesFromBag(_loc1_).getTimes() > 1)
               {
                  suppliesShowPanel["s1_" + _loc1_]["t_txt"].text = myPlayer.getBag().getSuppliesFromBag(_loc1_).getTimes();
                  suppliesShowPanel["s1_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               suppliesShowPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         var _loc2_:int = 6;
         var _loc3_:Array = shopSuppliesList;
         suppliesShowPanel["pageNum"].text = yeshu + "/" + Math.ceil(_loc3_.length / 6);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc4_ = _loc1_ + (yeshu - 1) * 6;
            if(_loc3_[_loc4_] != null)
            {
               suppliesShowPanel["se_" + _loc1_].visible = true;
               suppliesShowPanel["se_" + _loc1_].gotoAndStop(_loc3_[_loc4_].getFrame());
            }
            else
            {
               suppliesShowPanel["se_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private static function menuOpen(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
         clickObj = param1.target as MovieClip;
         suppliesShowPanel.addChild(suppliesShowPanel["mySell"]);
         suppliesShowPanel["mySell"].visible = true;
         suppliesShowPanel["mySell"].x = clickObj.x + 50;
         suppliesShowPanel["mySell"].y = clickObj.y + 60;
      }
      
      private static function sellSupplies(param1:MouseEvent) : void
      {
         var _loc2_:int = int(clickObj.name.substr(3,2));
         var _loc3_:String = clickObj.name.substr(0,2);
         if(_loc3_ == "s1")
         {
            myPlayer.addGold(myPlayer.getBag().getSuppliesFromBag(_loc2_).getPrice());
            myPlayer.getBag().delSupplies(_loc2_);
         }
         suppliesShowPanel["mySell"].visible = false;
         allShow();
      }
      
      public static function setKey_1(param1:MouseEvent) : *
      {
         var _loc2_:Supplies = null;
         var _loc3_:int = int(clickObj.name.substr(3,2));
         var _loc4_:String = clickObj.name.substr(0,2);
         if(_loc4_ == "s1")
         {
            _loc2_ = myPlayer.getBag().getSuppliesFromBag(_loc3_);
            myPlayer.getSuppliesSlot().setToSuppliesSlot(_loc2_,0);
         }
         suppliesShowPanel["mySell"].visible = false;
      }
      
      public static function setKey_2(param1:MouseEvent) : *
      {
         var _loc2_:Supplies = null;
         var _loc3_:int = int(clickObj.name.substr(3,2));
         var _loc4_:String = clickObj.name.substr(0,2);
         if(_loc4_ == "s1")
         {
            _loc2_ = myPlayer.getBag().getSuppliesFromBag(_loc3_);
            myPlayer.getSuppliesSlot().setToSuppliesSlot(_loc2_,1);
         }
         suppliesShowPanel["mySell"].visible = false;
      }
      
      public static function setKey_3(param1:MouseEvent) : *
      {
         var _loc2_:Supplies = null;
         var _loc3_:int = int(clickObj.name.substr(3,2));
         var _loc4_:String = clickObj.name.substr(0,2);
         if(_loc4_ == "s1")
         {
            _loc2_ = myPlayer.getBag().getSuppliesFromBag(_loc3_);
            myPlayer.getSuppliesSlot().setToSuppliesSlot(_loc2_,2);
         }
         suppliesShowPanel["mySell"].visible = false;
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         suppliesShowPanel["mySell"].visible = false;
         suppliesShowPanel.addChild(itemsTooltip);
         var _loc2_:uint = uint(param1.target.name.substr(3,2));
         var _loc3_:String = param1.target.name.substr(0,2);
         itemsTooltip.x = suppliesShowPanel.mouseX;
         itemsTooltip.y = suppliesShowPanel.mouseY;
         if(_loc3_ == "s1")
         {
            if(myPlayer.getBag().getSuppliesFromBag(_loc2_) != null)
            {
               itemsTooltip.suppliesTooltip(myPlayer.getBag().getSuppliesFromBag(_loc2_),1);
            }
            itemsTooltip.visible = true;
         }
      }
      
      private static function tooltipClose(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
      }
      
      private static function BuyOVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.target.parent.name.substr(3,2));
         var _loc3_:Array = shopSuppliesList;
         var _loc4_:int = _loc2_ + (yeshu - 1) * 6;
         suppliesShowPanel["goumaitishi"].visible = true;
         suppliesShowPanel["goumaitishi"].x = suppliesShowPanel.mouseX + 10;
         suppliesShowPanel["goumaitishi"].y = suppliesShowPanel.mouseY;
         suppliesShowPanel["goumaitishi"]["rmb_txt"].text = "消耗" + _loc3_[_loc4_].getPrice() * 2 + "金币，金币不足时可用" + (_loc3_[_loc4_] as Supplies).getRmbPrice() + "点卷购买";
      }
      
      private static function BuyOUT(param1:MouseEvent) : void
      {
         suppliesShowPanel["goumaitishi"].visible = false;
      }
      
      private static function BuySuppies(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.target.parent.name.substr(3,2));
         var _loc3_:Array = shopSuppliesList;
         var _loc4_:int = _loc2_ + (yeshu - 1) * 6;
         yaopin = (_loc3_[_loc4_] as Supplies).getClone();
         if(myPlayer.getBag().backSuppliesBagNum() > 0)
         {
            if(myPlayer.getGold() >= _loc3_[_loc4_].getPrice() * 2)
            {
               myPlayer.getBag().addSuppliesBag((_loc3_[_loc4_] as Supplies).getClone());
               myPlayer.payGold(_loc3_[_loc4_].getPrice() * 2);
            }
            else if(Shop4399.moneyAll.getValue() >= (_loc3_[_loc4_] as Supplies).getRmbPrice())
            {
               Api_4399_All.BuyObj((_loc3_[_loc4_] as Supplies).getRmbId());
               yaoOK = true;
               suppliesShowPanel["touming"].visible = true;
            }
            else
            {
               suppliesShowPanel["NoMoney_mc"].visible = true;
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
         }
         allShow();
      }
      
      public static function yaoRMBOK() : *
      {
         if(yaoOK)
         {
            myPlayer.getBag().addSuppliesBag(yaopin);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            yaoOK = false;
            allShow();
            suppliesShowPanel["touming"].visible = false;
         }
      }
   }
}

