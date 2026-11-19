package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.events.*;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.views.elvesPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.stampPanel.*;
   import com.hotpoint.braveManIII.views.storagePanel.*;
   import com.hotpoint.braveManIII.views.titelPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import src.*;
   import src.tool.*;
   
   public class ItemsPanel extends MovieClip
   {
      
      public static var itemsPanel:MovieClip;
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var menuTooltip:MenuTooltip;
      
      public static var dragObj:MovieClip;
      
      public static var clickObj:MovieClip;
      
      private static var pointx:Number;
      
      private static var pointy:Number;
      
      private static var allBagHandle:AllBagHandle;
      
      public static var myplayer:Player;
      
      public static var ip:ItemsPanel;
      
      private static var loadData:ClassLoader;
      
      public static var kuozhanOK:Boolean = false;
      
      public static var yeshu:int = 0;
      
      public static var isPOne:Boolean = true;
      
      public static var boolFlag:Boolean = false;
      
      public static var isDown:Boolean = false;
      
      public static var returnx:int = 0;
      
      public static var returny:int = 0;
      
      private static var oldNum:uint = 0;
      
      public static var itemsType:uint = 1;
      
      private static var openFlag:Boolean = false;
      
      private static var closeTimes:uint = 0;
      
      private static var myMenu:ContextMenu = new ContextMenu();
      
      private static var fenjie_bool:Boolean = false;
      
      public static var OpenFrist:Boolean = false;
      
      private static var loadName:String = "NewBag_v912.swf";
      
      private static var OpenYN:Boolean = false;
      
      private static var OpenFristJL:Boolean = true;
      
      public static var jiangliNum:int = 0;
      
      public static var jiangliNum3:int = 0;
      
      public static var jiangliNum2:int = 0;
      
      public function ItemsPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.mouseEnabled = false;
         menuTooltip = new MenuTooltip();
         allBagHandle = new AllBagHandle();
      }
      
      private static function InitIcon() : *
      {
         var _loc1_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            _loc4_ = new Shop_picNEW();
            _loc5_ = itemsPanel.getChildIndex(itemsPanel["s1_" + _loc1_]);
            _loc4_.x = itemsPanel["s1_" + _loc1_].x;
            _loc4_.y = itemsPanel["s1_" + _loc1_].y;
            _loc4_.name = "s1_" + _loc1_;
            itemsPanel.removeChild(itemsPanel["s1_" + _loc1_]);
            itemsPanel["s1_" + _loc1_] = _loc4_;
            itemsPanel.addChild(_loc4_);
            itemsPanel.setChildIndex(_loc4_,_loc5_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc4_ = new Shop_picNEW();
            _loc5_ = itemsPanel.getChildIndex(itemsPanel["z1_" + _loc1_]);
            _loc4_.x = itemsPanel["z1_" + _loc1_].x;
            _loc4_.y = itemsPanel["z1_" + _loc1_].y;
            _loc4_.name = "z1_" + _loc1_;
            itemsPanel.removeChild(itemsPanel["z1_" + _loc1_]);
            itemsPanel["z1_" + _loc1_] = _loc4_;
            itemsPanel.addChild(_loc4_);
            itemsPanel.setChildIndex(_loc4_,_loc5_);
            _loc1_++;
         }
         var _loc2_:MovieClip = new Shop_picNEW();
         _loc2_.x = itemsPanel["getFJ"]["showPic"].x;
         _loc2_.y = itemsPanel["getFJ"]["showPic"].y;
         _loc2_.name = "showPic";
         itemsPanel["getFJ"].removeChild(itemsPanel["getFJ"]["showPic"]);
         itemsPanel["getFJ"]["showPic"] = _loc2_;
         itemsPanel["getFJ"].addChild(_loc2_);
         var _loc3_:MovieClip = new Shop_picNEW();
         _loc3_.x = itemsPanel["sellMenu"]["showPic"].x;
         _loc3_.y = itemsPanel["sellMenu"]["showPic"].y;
         _loc3_.name = "showPic";
         itemsPanel["sellMenu"].removeChild(itemsPanel["sellMenu"]["showPic"]);
         itemsPanel["sellMenu"]["showPic"] = _loc3_;
         itemsPanel["sellMenu"].addChild(_loc3_);
      }
      
      private static function LoadSkin() : *
      {
         if(!itemsPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
         }
         if(OpenFrist)
         {
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("NewBagShow") as Class;
         itemsPanel = new _loc2_();
         ip.addChild(itemsPanel);
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
         ip = new ItemsPanel();
         LoadSkin();
         Main._stage.addChild(ip);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         ip = new ItemsPanel();
         Main._stage.addChild(ip);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         timeXiuZheng();
         Main.allClosePanel();
         if(itemsPanel)
         {
            boolFlag = true;
            yeshu = 0;
            Main.stopXX = true;
            ip.x = 0;
            ip.y = 0;
            Player.getEquipDataXX();
            Main.player1.getBag().cheatTesting();
            Main.player1.getBag().cheatGem();
            Main.player1.getBag().cheatOther();
            myplayer = Main.player_1;
            NvShenRenWu();
            addListenerP1();
            if(Main.P1P2)
            {
               itemsPanel["bagOne"].visible = true;
               itemsPanel["bagTwo"].visible = true;
               Main.player2.getBag().cheatTesting();
               Main.player2.getBag().cheatGem();
               Main.player2.getBag().cheatOther();
            }
            else
            {
               itemsPanel["bagOne"].visible = false;
               itemsPanel["bagTwo"].visible = false;
            }
            ip.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(itemsPanel)
         {
            close_fenjie();
            boolFlag = false;
            Main.player1.getBag().cheatGem();
            Main.player1.getBag().cheatOther();
            if(Main.P1P2)
            {
               Main.player2.getBag().cheatGem();
               Main.player2.getBag().cheatOther();
            }
            Main.stopXX = false;
            if(menuTooltip)
            {
               menuTooltip.visible = false;
            }
            removeListenerP1();
            ip.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      private static function closeppp(param1:*) : void
      {
         close();
         twoFalse();
         isPOne = true;
      }
      
      public static function addListenerP1() : *
      {
         var _loc6_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            itemsPanel["s1_" + _loc1_].mouseChildren = false;
            itemsPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            itemsPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            itemsPanel["s1_" + _loc1_].addEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         var _loc2_:uint = 3;
         while(_loc2_ < 11)
         {
            itemsPanel["str_" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,strengthenOpen);
            itemsPanel["str_" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,strengthenClose);
            _loc2_++;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < 6)
         {
            itemsPanel["hz" + _loc3_].stop();
            itemsPanel["hz" + _loc3_].addEventListener(MouseEvent.MOUSE_OVER,hzOpen);
            itemsPanel["hz" + _loc3_].addEventListener(MouseEvent.MOUSE_OUT,hzClose);
            _loc3_++;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < 8)
         {
            itemsPanel["k1_" + _loc4_].mouseChildren = false;
            itemsPanel["z1_" + _loc4_].mouseChildren = false;
            itemsPanel["z1_" + _loc4_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["z1_" + _loc4_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            itemsPanel["z1_" + _loc4_].addEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            itemsPanel["z1_" + _loc4_].addEventListener(MouseEvent.CLICK,menuOpen);
            _loc4_++;
         }
         itemsPanel["jingling"].stop();
         itemsPanel["closePanel"].addEventListener(MouseEvent.CLICK,closeppp);
         itemsPanel["chenghao_btn"].addEventListener(MouseEvent.CLICK,chenghaoOpen);
         itemsPanel["jingling_btn"].addEventListener(MouseEvent.CLICK,jinglingOpen);
         itemsPanel["qianneng_btn"].addEventListener(MouseEvent.CLICK,qiannengOpen);
         itemsPanel.addEventListener(BtnEvent.DO_CHANGE,bagListen);
         itemsPanel.addEventListener(Event.DEACTIVATE,loseFocus);
         myMenu.addEventListener(ContextMenuEvent.MENU_SELECT,loseFocus);
         Main._stage.addEventListener(Event.MOUSE_LEAVE,loseFocus);
         Main._stage.addEventListener(MouseEvent.MOUSE_UP,loseFocus);
         itemsPanel.contextMenu = myMenu;
         var _loc5_:uint = 0;
         while(_loc5_ < 2)
         {
            itemsPanel["g1_" + _loc5_].addEventListener(MouseEvent.CLICK,menuOpen);
            itemsPanel["g1_" + _loc5_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["g1_" + _loc5_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            itemsPanel["fudai"]["xz" + _loc6_].addEventListener(MouseEvent.CLICK,xuanzejiangli);
            itemsPanel["fudai"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OVER,fudaiOpen);
            itemsPanel["fudai"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OUT,fudaiClose);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            itemsPanel["fudai2"]["xz" + _loc6_].addEventListener(MouseEvent.CLICK,xuanzejiangli2);
            itemsPanel["fudai2"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OVER,fudaiOpen2);
            itemsPanel["fudai2"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OUT,fudaiClose2);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            itemsPanel["fudai3"]["xz" + _loc6_].addEventListener(MouseEvent.CLICK,xuanzejiangli3);
            itemsPanel["fudai3"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OVER,fudaiOpen3);
            itemsPanel["fudai3"]["xz" + _loc6_].addEventListener(MouseEvent.MOUSE_OUT,fudaiClose3);
            _loc6_++;
         }
         var _loc7_:* = 0;
         while(_loc7_ < 6)
         {
            ItemsPanel.itemsPanel["bagLock" + _loc7_].addEventListener(MouseEvent.CLICK,kuozhanDo);
            _loc7_++;
         }
         itemsPanel["NoMoney_mc"]["no_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         itemsPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         itemsPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         itemsPanel["yeshu_1"].addEventListener(MouseEvent.CLICK,oneGo);
         itemsPanel["yeshu_2"].addEventListener(MouseEvent.CLICK,twoGo);
         itemsPanel["fudai"]["select"].mouseEnabled = false;
         itemsPanel["fudai2"]["select"].mouseEnabled = false;
         itemsPanel["fudai3"]["select"].mouseEnabled = false;
         itemsPanel["fudai"]["lingqu"].addEventListener(MouseEvent.CLICK,lingqujiangli);
         itemsPanel["fudai2"]["lingqu"].addEventListener(MouseEvent.CLICK,lingqujiangli2);
         itemsPanel["fudai3"]["lingqu"].addEventListener(MouseEvent.CLICK,lingqujiangli3);
         itemsPanel["all_fenjie"].addEventListener(MouseEvent.CLICK,all_fenjie);
         itemsPanel.addEventListener(MouseEvent.MOUSE_MOVE,DragHandler);
         itemsPanel.addEventListener(MouseEvent.MOUSE_UP,UpHandler);
         itemsPanel.addEventListener(MouseEvent.CLICK,menuClose);
         menuTooltip.addListener();
         BagItemsShow.allHide();
         BagItemsShow.equipShow();
         BagItemsShow.badgeSlotShow();
         BagItemsShow.slotShow();
         BagItemsShow.skillSlotShow();
         BagItemsShow.informationShow();
         allFalse();
         itemsPanel["NoMoney_mc"].visible = false;
         itemsPanel["touming"].visible = false;
         itemsPanel["closePanel"].addEventListener(MouseEvent.CLICK,closeppp);
         itemsPanel["getFJ"].mouseEnabled = false;
         itemsPanel["all_fenjie"].visible = true;
         itemsPanel["bagOne"].isClick = true;
         itemsPanel["bg1_1"].isClick = true;
         itemsPanel["getFJ"].visible = false;
         itemsPanel["isFenJie"].visible = false;
         itemsPanel["isSell"].visible = false;
         itemsPanel["isAllSell"].visible = false;
         itemsPanel["sellMenu"].visible = false;
         itemsPanel["strengTip"].visible = false;
         itemsPanel["hzTip"].visible = false;
         itemsPanel["fudai"].visible = false;
         itemsPanel["fudai2"].visible = false;
         itemsPanel["fudai3"].visible = false;
         itemsPanel["renwutishi"].visible = false;
         itemsPanel["renwutishi"].mouseChildren = false;
         itemsPanel["renwutishi"].mouseEnabled = false;
         itemsPanel["xinshou"].visible = false;
         if(OpenFristJL)
         {
            OpenFristJL = false;
            itemsPanel["jinglingOPEN"].visible = false;
         }
         if(Main.newPlay == 3)
         {
            itemsPanel["xinshou"].visible = true;
         }
         itemsType = 1;
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            itemsPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            itemsPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            itemsPanel["s1_" + _loc1_].removeEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < 8)
         {
            itemsPanel["z1_" + _loc2_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["z1_" + _loc2_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            itemsPanel["z1_" + _loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            itemsPanel["z1_" + _loc2_].removeEventListener(MouseEvent.CLICK,menuOpen);
            _loc2_++;
         }
         var _loc3_:uint = 3;
         while(_loc3_ < 11)
         {
            itemsPanel["str_" + _loc3_].removeEventListener(MouseEvent.MOUSE_OVER,strengthenOpen);
            itemsPanel["str_" + _loc3_].removeEventListener(MouseEvent.MOUSE_OUT,strengthenClose);
            _loc3_++;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            itemsPanel["hz" + _loc4_].removeEventListener(MouseEvent.MOUSE_OVER,hzOpen);
            itemsPanel["hz" + _loc4_].removeEventListener(MouseEvent.MOUSE_OUT,hzClose);
            _loc4_++;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < 2)
         {
            itemsPanel["g1_" + _loc5_].removeEventListener(MouseEvent.CLICK,menuOpen);
            itemsPanel["g1_" + _loc5_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            itemsPanel["g1_" + _loc5_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            _loc5_++;
         }
         var _loc6_:* = 0;
         while(_loc6_ < 6)
         {
            ItemsPanel.itemsPanel["bagLock" + _loc6_].removeEventListener(MouseEvent.CLICK,kuozhanDo);
            _loc6_++;
         }
         itemsPanel["NoMoney_mc"]["no_btn"].removeEventListener(MouseEvent.CLICK,closeNORMB);
         itemsPanel["NoMoney_mc"]["yes_btn"].removeEventListener(MouseEvent.CLICK,closeNORMB);
         itemsPanel["NoMoney_mc"]["addMoney_btn"].removeEventListener(MouseEvent.CLICK,addMoney_btn);
         itemsPanel["yeshu_1"].removeEventListener(MouseEvent.CLICK,oneGo);
         itemsPanel["yeshu_2"].removeEventListener(MouseEvent.CLICK,twoGo);
         itemsPanel.addEventListener(Event.DEACTIVATE,loseFocus);
         myMenu.addEventListener(ContextMenuEvent.MENU_SELECT,loseFocus);
         Main._stage.addEventListener(Event.MOUSE_LEAVE,loseFocus);
         Main._stage.removeEventListener(MouseEvent.MOUSE_UP,loseFocus);
         itemsPanel.contextMenu = myMenu;
         itemsPanel.removeEventListener(BtnEvent.DO_CHANGE,bagListen);
         itemsPanel.removeEventListener(MouseEvent.MOUSE_MOVE,DragHandler);
         itemsPanel.removeEventListener(MouseEvent.MOUSE_UP,UpHandler);
         itemsPanel.removeEventListener(MouseEvent.CLICK,menuClose);
         menuTooltip.removeListener();
      }
      
      private static function closeNORMB(param1:*) : void
      {
         itemsPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      public static function kuoBagRMBOK() : *
      {
         if(kuozhanOK)
         {
            if(!Main.P1P2)
            {
               if(itemsType == 1)
               {
                  myplayer.data.getBag().addLimitE();
                  BagItemsShow.equipShow();
               }
               else if(itemsType == 2)
               {
                  myplayer.data.getBag().addLimitS();
                  BagItemsShow.suppliesShow();
               }
               else if(itemsType == 3)
               {
                  myplayer.data.getBag().addLimitG();
                  BagItemsShow.gemShow();
               }
               else if(itemsType == 4)
               {
                  myplayer.data.getBag().addLimitO();
                  BagItemsShow.otherobjShow();
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               kuozhanOK = false;
               itemsPanel["touming"].visible = false;
            }
            else
            {
               if(itemsType == 1)
               {
                  Main.player1.getBag().addLimitE();
                  Main.player2.getBag().addLimitE();
                  BagItemsShow.equipShow();
               }
               else if(itemsType == 2)
               {
                  Main.player1.getBag().addLimitS();
                  Main.player2.getBag().addLimitS();
                  BagItemsShow.suppliesShow();
               }
               else if(itemsType == 3)
               {
                  Main.player1.getBag().addLimitG();
                  Main.player2.getBag().addLimitG();
                  BagItemsShow.gemShow();
               }
               else if(itemsType == 4)
               {
                  Main.player1.getBag().addLimitO();
                  Main.player2.getBag().addLimitO();
                  BagItemsShow.otherobjShow();
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               kuozhanOK = false;
               itemsPanel["touming"].visible = false;
            }
            BagItemsShow.informationShow();
         }
      }
      
      private static function kuozhanDo(param1:*) : *
      {
         if(!Main.P1P2)
         {
            if(itemsType == 1)
            {
               if(myplayer.data.getKillPoint() >= 250)
               {
                  myplayer.data.getBag().addLimitE();
                  myplayer.data.AddKillPoint(-250);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               }
               else if(Shop4399.moneyAll.getValue() >= 20)
               {
                  Api_4399_All.BuyObj(InitData.kuoBag.getValue());
                  kuozhanOK = true;
                  itemsPanel["touming"].visible = true;
               }
               else
               {
                  itemsPanel["NoMoney_mc"].visible = true;
               }
               BagItemsShow.equipShow();
            }
            else if(itemsType == 2)
            {
               if(myplayer.data.getKillPoint() >= 250)
               {
                  myplayer.data.getBag().addLimitS();
                  myplayer.data.AddKillPoint(-250);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               }
               else if(Shop4399.moneyAll.getValue() >= 20)
               {
                  Api_4399_All.BuyObj(InitData.kuoBag.getValue());
                  kuozhanOK = true;
                  itemsPanel["touming"].visible = true;
               }
               else
               {
                  itemsPanel["NoMoney_mc"].visible = true;
               }
               BagItemsShow.suppliesShow();
            }
            else if(itemsType == 3)
            {
               if(myplayer.data.getKillPoint() >= 250)
               {
                  myplayer.data.getBag().addLimitG();
                  myplayer.data.AddKillPoint(-250);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               }
               else if(Shop4399.moneyAll.getValue() >= 20)
               {
                  Api_4399_All.BuyObj(InitData.kuoBag.getValue());
                  kuozhanOK = true;
                  itemsPanel["touming"].visible = true;
               }
               else
               {
                  itemsPanel["NoMoney_mc"].visible = true;
               }
               BagItemsShow.gemShow();
            }
            else if(itemsType == 4)
            {
               if(myplayer.data.getKillPoint() >= 250)
               {
                  myplayer.data.getBag().addLimitO();
                  myplayer.data.AddKillPoint(-250);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
               }
               else if(Shop4399.moneyAll.getValue() >= 20)
               {
                  Api_4399_All.BuyObj(InitData.kuoBag.getValue());
                  kuozhanOK = true;
                  itemsPanel["touming"].visible = true;
               }
               else
               {
                  itemsPanel["NoMoney_mc"].visible = true;
               }
               BagItemsShow.otherobjShow();
            }
         }
         else if(itemsType == 1)
         {
            if(Main.player1.getKillPoint() >= 250 && Main.player2.getKillPoint() >= 250)
            {
               Main.player1.getBag().addLimitE();
               Main.player1.AddKillPoint(-250);
               Main.player2.getBag().addLimitE();
               Main.player2.AddKillPoint(-250);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
            }
            else if(Shop4399.moneyAll.getValue() >= 20)
            {
               Api_4399_All.BuyObj(InitData.kuoBag.getValue());
               kuozhanOK = true;
               itemsPanel["touming"].visible = true;
            }
            else
            {
               itemsPanel["NoMoney_mc"].visible = true;
            }
            BagItemsShow.equipShow();
         }
         else if(itemsType == 2)
         {
            if(Main.player1.getKillPoint() >= 250 && Main.player2.getKillPoint() >= 250)
            {
               Main.player1.getBag().addLimitS();
               Main.player1.AddKillPoint(-250);
               Main.player2.getBag().addLimitS();
               Main.player2.AddKillPoint(-250);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
            }
            else if(Shop4399.moneyAll.getValue() >= 20)
            {
               Api_4399_All.BuyObj(InitData.kuoBag.getValue());
               kuozhanOK = true;
               itemsPanel["touming"].visible = true;
            }
            else
            {
               itemsPanel["NoMoney_mc"].visible = true;
            }
            BagItemsShow.suppliesShow();
         }
         else if(itemsType == 3)
         {
            if(Main.player1.getKillPoint() >= 250 && Main.player2.getKillPoint() >= 250)
            {
               Main.player1.getBag().addLimitG();
               Main.player1.AddKillPoint(-250);
               Main.player2.getBag().addLimitG();
               Main.player2.AddKillPoint(-250);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
            }
            else if(Shop4399.moneyAll.getValue() >= 20)
            {
               Api_4399_All.BuyObj(InitData.kuoBag.getValue());
               kuozhanOK = true;
               itemsPanel["touming"].visible = true;
            }
            else
            {
               itemsPanel["NoMoney_mc"].visible = true;
            }
            BagItemsShow.gemShow();
         }
         else if(itemsType == 4)
         {
            if(Main.player1.getKillPoint() >= 250 && Main.player2.getKillPoint() >= 250)
            {
               Main.player1.getBag().addLimitO();
               Main.player1.AddKillPoint(-250);
               Main.player2.getBag().addLimitO();
               Main.player2.AddKillPoint(-250);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展背包");
            }
            else if(Shop4399.moneyAll.getValue() >= 20)
            {
               Api_4399_All.BuyObj(InitData.kuoBag.getValue());
               kuozhanOK = true;
               itemsPanel["touming"].visible = true;
            }
            else
            {
               itemsPanel["NoMoney_mc"].visible = true;
            }
            BagItemsShow.otherobjShow();
         }
         BagItemsShow.informationShow();
      }
      
      private static function oneGo(param1:*) : *
      {
         yeshu = 0;
         if(itemsType == 1)
         {
            BagItemsShow.equipShow();
         }
         else if(itemsType == 2)
         {
            BagItemsShow.suppliesShow();
         }
         else if(itemsType == 3)
         {
            BagItemsShow.gemShow();
         }
         else if(itemsType == 4)
         {
            BagItemsShow.otherobjShow();
         }
         else if(itemsType == 5)
         {
            BagItemsShow.questShow();
         }
         BagItemsShow.informationShow();
      }
      
      private static function twoGo(param1:*) : *
      {
         yeshu = 1;
         if(itemsType == 1)
         {
            BagItemsShow.equipShow();
         }
         else if(itemsType == 2)
         {
            BagItemsShow.suppliesShow();
         }
         else if(itemsType == 3)
         {
            BagItemsShow.gemShow();
         }
         else if(itemsType == 4)
         {
            BagItemsShow.otherobjShow();
         }
         else if(itemsType == 5)
         {
            BagItemsShow.questShow();
         }
         BagItemsShow.informationShow();
      }
      
      private static function chenghaoOpen(param1:*) : *
      {
         TitelPanel.open(isPOne);
      }
      
      private static function jinglingOpen(param1:*) : *
      {
         ElvesPanel.open(myplayer.data);
         itemsPanel["jinglingOPEN"].visible = false;
      }
      
      private static function qiannengOpen(param1:*) : *
      {
         StampPanel.open(myplayer.data);
      }
      
      private static function loseFocus(param1:Event = null) : *
      {
         if(dragObj)
         {
            UpHandler();
         }
      }
      
      private static function all_fenjie(param1:MouseEvent) : void
      {
         if(fenjie_bool)
         {
            itemsPanel["mouseFJ"].x = 20000;
            Mouse.show();
            fenjie_bool = false;
            itemsPanel.removeEventListener(MouseEvent.MOUSE_MOVE,gensui);
         }
         else
         {
            fenjie_bool = true;
            itemsPanel.addChild(itemsPanel["mouseFJ"]);
            itemsPanel.addEventListener(MouseEvent.MOUSE_MOVE,gensui);
         }
      }
      
      private static function close_fenjie() : void
      {
         fenjie_bool = false;
         Mouse.show();
         itemsPanel["mouseFJ"].x = 20000;
         itemsPanel.removeEventListener(MouseEvent.MOUSE_MOVE,gensui);
      }
      
      private static function gensui(param1:MouseEvent) : *
      {
         Mouse.hide();
         itemsPanel["mouseFJ"].x = itemsPanel.mouseX;
         itemsPanel["mouseFJ"].y = itemsPanel.mouseY;
         param1.updateAfterEvent();
      }
      
      private static function menuClose(param1:MouseEvent) : void
      {
         ++closeTimes;
         if(closeTimes > 1)
         {
            menuTooltip.visible = false;
            closeTimes = 0;
         }
      }
      
      private static function menuTest() : Boolean
      {
         if(dragObj.x > returnx + 1 || dragObj.y > returny + 1 || dragObj.x < returnx - 1 || dragObj.y < returny - 1)
         {
            return false;
         }
         return true;
      }
      
      private static function hzClose(param1:MouseEvent) : *
      {
         itemsPanel["hzTip"].visible = false;
      }
      
      private static function hzOpen(param1:MouseEvent) : *
      {
         var _loc2_:uint = uint((param1.target as MovieClip).name.substr(2,1));
         if(myplayer.data.getBadgeSlot().getBadgeFromSlot(_loc2_))
         {
            itemsPanel["hzTip"]["str_name"].text = myplayer.data.getBadgeSlot().getBadgeFromSlot(_loc2_).getName();
            itemsPanel["hzTip"]["str_text"].text = myplayer.data.getBadgeSlot().getBadgeFromSlot(_loc2_).getIntroduction();
         }
         itemsPanel["hzTip"].visible = true;
         itemsPanel.addChild(itemsPanel["hzTip"]);
         itemsPanel["hzTip"].x = itemsPanel.mouseX + 10;
         itemsPanel["hzTip"].y = itemsPanel.mouseY;
      }
      
      private static function strengthenClose(param1:MouseEvent) : *
      {
         itemsPanel["strengTip"].visible = false;
      }
      
      private static function strengthenOpen(param1:MouseEvent) : *
      {
         var _loc2_:String = (param1.target as MovieClip).name.toString();
         switch(_loc2_)
         {
            case "str_3":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉加成";
               itemsPanel["strengTip"]["str_text"].text = "除时装，翅膀以外的其他装备全部强化+4以上时，可获得额外属性加成";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_4":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+4";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值10%";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_5":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+5";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值15% 提高暴击值10%";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_6":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+6";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值15% 提高暴击值15% 提升1点移动力";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_7":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+7";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值15% 提高暴击值20% 提高防御力7% 提升1点移动力";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_8":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+8";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值20% 提高暴击值25% 提高防御力7% 提升1点移动力";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_9":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+9";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值20% 提高暴击值25% 提高防御力10% 提高攻击力5% 提升1点移动力";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
               break;
            case "str_10":
               itemsPanel["strengTip"]["str_name"].text = "强化荣誉+10";
               itemsPanel["strengTip"]["str_text"].text = "提高生命值27% 提高暴击值25% 提高防御力15% 提高攻击力32% 提升2点移动力";
               itemsPanel["strengTip"].x = itemsPanel.mouseX + 10;
         }
         itemsPanel["strengTip"].visible = true;
         itemsPanel.addChild(itemsPanel["strengTip"]);
      }
      
      private static function menuOpen(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
         clickObj = param1.target as MovieClip;
         var _loc2_:String = clickObj.name.substr(0,2);
         oldNum = int(clickObj.name.substr(3,2));
         if(fenjie_bool)
         {
            if(_loc2_ == "s1")
            {
               if(isPOne)
               {
                  MenuTooltip.whichDo = 1;
               }
               else
               {
                  MenuTooltip.whichDo = 2;
               }
               MenuTooltip.selectType = 1;
               MenuTooltip.oldNum = int(clickObj.name.substr(3,2));
               MenuTooltip.oldNum += yeshu * 24;
               MenuTooltip.isFJ(param1);
            }
         }
         else
         {
            if(openFlag == true)
            {
               if(_loc2_ == "s1")
               {
                  oldNum += yeshu * 24;
                  if(isPOne)
                  {
                     menuTooltip.setItemsMenu(itemsType,oldNum,1);
                     itemsPanel.addChild(menuTooltip);
                     menuTooltip.x = clickObj.x + 30;
                     menuTooltip.y = clickObj.y + 30;
                     menuTooltip.visible = true;
                     closeTimes = 0;
                  }
                  else
                  {
                     menuTooltip.setItemsMenu(itemsType,oldNum,2);
                     itemsPanel.addChild(menuTooltip);
                     menuTooltip.x = clickObj.x + 30;
                     menuTooltip.y = clickObj.y + 30;
                     menuTooltip.visible = true;
                     closeTimes = 0;
                  }
               }
               else if(_loc2_ == "z1")
               {
                  if(isPOne)
                  {
                     menuTooltip.setSlotMenu(oldNum,1);
                     itemsPanel.addChild(menuTooltip);
                     menuTooltip.x = clickObj.x + 30;
                     menuTooltip.y = clickObj.y + 30;
                     menuTooltip.visible = true;
                     closeTimes = 0;
                  }
                  else
                  {
                     menuTooltip.setSlotMenu(oldNum,2);
                     itemsPanel.addChild(menuTooltip);
                     menuTooltip.x = clickObj.x + 30;
                     menuTooltip.y = clickObj.y + 30;
                     menuTooltip.visible = true;
                     closeTimes = 0;
                  }
               }
            }
            if(_loc2_ == "g1")
            {
               if(isPOne)
               {
                  menuTooltip.setSkillSlotMenu(oldNum,1);
                  itemsPanel.addChild(menuTooltip);
                  menuTooltip.x = clickObj.x + 20;
                  menuTooltip.y = clickObj.y + 20;
                  menuTooltip.visible = true;
                  closeTimes = 0;
               }
               else
               {
                  menuTooltip.setSkillSlotMenu(oldNum,2);
                  itemsPanel.addChild(menuTooltip);
                  menuTooltip.x = clickObj.x + 20;
                  menuTooltip.y = clickObj.y + 20;
                  menuTooltip.visible = true;
                  closeTimes = 0;
               }
            }
            openFlag = false;
            clickObj = null;
         }
      }
      
      public static function allFalse() : void
      {
         itemsPanel["bg1_1"].isClick = false;
         itemsPanel["bg1_2"].isClick = false;
         itemsPanel["bg1_3"].isClick = false;
         itemsPanel["bg1_4"].isClick = false;
         itemsPanel["bg1_5"].isClick = false;
      }
      
      public static function twoFalse() : void
      {
         itemsPanel["bagTwo"].isClick = false;
         itemsPanel["bagOne"].isClick = false;
      }
      
      private static function bagListen(param1:BtnEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         close_fenjie();
         switch(_loc2_.name)
         {
            case "bg1_1":
               itemsType = 1;
               allFalse();
               itemsPanel["all_fenjie"].visible = true;
               itemsPanel["bg1_1"].isClick = true;
               BagItemsShow.equipShow();
               break;
            case "bg1_2":
               itemsType = 2;
               allFalse();
               itemsPanel["all_fenjie"].visible = false;
               itemsPanel["bg1_2"].isClick = true;
               BagItemsShow.suppliesShow();
               break;
            case "bg1_3":
               itemsType = 3;
               allFalse();
               itemsPanel["all_fenjie"].visible = false;
               itemsPanel["bg1_3"].isClick = true;
               BagItemsShow.gemShow();
               break;
            case "bg1_4":
               itemsType = 4;
               allFalse();
               itemsPanel["all_fenjie"].visible = false;
               itemsPanel["bg1_4"].isClick = true;
               BagItemsShow.otherobjShow();
               break;
            case "bg1_5":
               itemsType = 5;
               allFalse();
               itemsPanel["all_fenjie"].visible = false;
               itemsPanel["bg1_5"].isClick = true;
               BagItemsShow.questShow();
               break;
            case "bagOne":
               isPOne = true;
               myplayer = Main.player_1;
               twoFalse();
               itemsPanel["bagOne"].isClick = true;
               switch(itemsType)
               {
                  case 1:
                     BagItemsShow.equipShow();
                     break;
                  case 2:
                     BagItemsShow.suppliesShow();
                     break;
                  case 3:
                     BagItemsShow.gemShow();
                     break;
                  case 4:
                     BagItemsShow.otherobjShow();
                     break;
                  case 5:
                     BagItemsShow.questShow();
               }
               BagItemsShow.skillSlotShow();
               BagItemsShow.slotShow();
               BagItemsShow.badgeSlotShow();
               BagItemsShow.informationShow();
               break;
            case "bagTwo":
               isPOne = false;
               myplayer = Main.player_2;
               twoFalse();
               itemsPanel["bagTwo"].isClick = true;
               switch(itemsType)
               {
                  case 1:
                     BagItemsShow.equipShow();
                     break;
                  case 2:
                     BagItemsShow.suppliesShow();
                     break;
                  case 3:
                     BagItemsShow.gemShow();
                     break;
                  case 4:
                     BagItemsShow.otherobjShow();
                     break;
                  case 5:
                     BagItemsShow.questShow();
               }
               BagItemsShow.skillSlotShow();
               BagItemsShow.slotShow();
               BagItemsShow.badgeSlotShow();
               BagItemsShow.informationShow();
         }
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         menuTooltip.visible = false;
         itemsPanel.addChild(itemsTooltip);
         if(isDown == false)
         {
            _loc2_ = param1.target as MovieClip;
            _loc3_ = uint(_loc2_.name.substr(3,2));
            _loc4_ = _loc2_.name.substr(0,2);
            _loc5_ = int(uint(_loc2_.name.substr(3,2)));
            itemsTooltip.x = itemsPanel.mouseX;
            itemsTooltip.y = itemsPanel.mouseY;
            if(_loc4_ == "s1")
            {
               _loc3_ += yeshu * 24;
               switch(itemsType)
               {
                  case 1:
                     if(myplayer.data.getBag().getEquipFromBag(_loc3_) != null)
                     {
                        itemsTooltip.equipTooltip(myplayer.data.getBag().getEquipFromBag(_loc3_),1);
                     }
                     break;
                  case 2:
                     if(myplayer.data.getBag().getSuppliesFromBag(_loc3_) != null)
                     {
                        itemsTooltip.suppliesTooltip(myplayer.data.getBag().getSuppliesFromBag(_loc3_),1);
                     }
                     break;
                  case 3:
                     if(myplayer.data.getBag().getGemFromBag(_loc3_) != null)
                     {
                        itemsTooltip.gemTooltip(myplayer.data.getBag().getGemFromBag(_loc3_),1);
                     }
                     break;
                  case 4:
                     if(myplayer.data.getBag().getOtherobjFromBag(_loc3_) != null)
                     {
                        itemsTooltip.otherTooltip(myplayer.data.getBag().getOtherobjFromBag(_loc3_));
                     }
                     break;
                  case 5:
                     if(myplayer.data.getBag().getQuestFromBag(_loc5_) != null)
                     {
                        itemsTooltip.questTooltip(myplayer.data.getBag().getQuestFromBag(_loc5_));
                     }
               }
            }
            else if(_loc4_ == "g1")
            {
               if(myplayer.data.getEquipSkillSlot().getGemFromSkillSlot(_loc3_) != null)
               {
                  itemsTooltip.gemTooltip(myplayer.data.getEquipSkillSlot().getGemFromSkillSlot(_loc3_));
               }
            }
            else if(_loc4_ == "z1")
            {
               itemsTooltip.slotTooltip(_loc3_,myplayer.data.getEquipSlot());
            }
            itemsTooltip.setTooltipPoint();
            itemsTooltip.visible = true;
         }
      }
      
      private static function tooltipClose(param1:MouseEvent) : void
      {
         if(isDown == false)
         {
            itemsTooltip.visible = false;
         }
      }
      
      private static function getPart(param1:Number) : uint
      {
         switch(param1)
         {
            case 1:
               return 0;
            case 2:
               return 1;
            case 3:
               return 3;
            case 4:
               return 4;
            case 5:
               return 2;
            case 6:
               return 2;
            case 7:
               return 2;
            case 8:
               return 6;
            case 9:
               return 7;
            case 10:
               return 0;
            case 11:
               return 1;
            case 12:
               return 3;
            case 13:
               return 4;
            default:
               return null;
         }
      }
      
      private static function closeLight() : void
      {
         i = 0;
         while(i < 8)
         {
            itemsPanel["k1_" + i].visible = false;
            ++i;
         }
      }
      
      private static function dragEquip() : void
      {
         var _loc1_:uint = 0;
         if(itemsType != 1)
         {
            return;
         }
         var _loc2_:int = int(oldNum);
         if(Main.water.getValue() != 1 && (_loc2_ == 0 || _loc2_ == 1 || _loc2_ == 3 || _loc2_ == 4))
         {
            _loc2_ += 8;
         }
         var _loc3_:String = dragObj.name.substr(0,2);
         if(_loc3_ == "s1")
         {
            _loc1_ = uint(getPart(myplayer.data.getBag().getEquipFromBag(oldNum).getPosition()));
         }
         else if(_loc3_ == "z1")
         {
            _loc1_ = uint(getPart(myplayer.data.getEquipSlot().getEquipFromSlot(_loc2_).getPosition()));
         }
         ItemsPanel.itemsPanel["k1_" + _loc1_].visible = true;
         if(_loc1_ == 2)
         {
            ItemsPanel.itemsPanel["k1_5"].visible = true;
         }
      }
      
      private static function DragHandler(param1:MouseEvent) : void
      {
         if(isDown == true)
         {
            if(isDrag(pointx,pointy) == true)
            {
               itemsPanel.addChild(dragObj);
               dragObj.x = itemsPanel.mouseX - 20;
               dragObj.y = itemsPanel.mouseY - 20;
               menuTooltip.visible = false;
               dragObj.startDrag();
               dragEquip();
            }
         }
      }
      
      private static function DownHandler(param1:MouseEvent) : void
      {
         if(!fenjie_bool)
         {
            menuTooltip.visible = false;
            itemsTooltip.visible = false;
            isDown = true;
            dragObj = param1.target as MovieClip;
            returnx = dragObj.x;
            returny = dragObj.y;
            pointx = itemsPanel.mouseX;
            pointy = itemsPanel.mouseY;
            oldNum = uint(dragObj.name.substr(3,2));
         }
      }
      
      private static function isDrag(param1:Number, param2:Number) : Boolean
      {
         dragObj["diKuang"].visible = false;
         if(isDown == true)
         {
            if(itemsPanel.mouseX > param1 + 1 || itemsPanel.mouseX < param1 - 1 || itemsPanel.mouseY > param2 + 1 || itemsPanel.mouseY < param2 - 1)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function UpHandler(param1:MouseEvent = null) : void
      {
         if(dragObj)
         {
            dragObj.stopDrag();
            closeLight();
            if(menuTest() == true)
            {
               openFlag = true;
            }
            else
            {
               openFlag = false;
            }
            if(inItemsRange() == false && inEquipSlotRange() == false)
            {
               dragObj.x = returnx;
               dragObj.y = returny;
            }
         }
         isDown = false;
         dragObj = null;
      }
      
      private static function inEquipSlotRange() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         if(itemsPanel.mouseX < 480)
         {
            if(dragObj.name.substr(0,2) == "z1")
            {
               return false;
            }
            if(itemsType != 1)
            {
               return false;
            }
            _loc3_ = itemsPanel.x + 55;
            _loc4_ = 6;
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               _loc2_ = 3 * _loc5_;
               _loc6_ = itemsPanel.y + 198;
               if(itemsPanel.mouseX > _loc3_ && itemsPanel.mouseX < _loc3_ + 66)
               {
                  _loc7_ = 0;
                  while(_loc7_ < 3)
                  {
                     if(itemsPanel.mouseY > 122 && itemsPanel.mouseY < 188)
                     {
                        _loc1_ = Boolean(allBagHandle.slotHandle(dragObj,oldNum,_loc4_));
                        dragObj.x = returnx;
                        dragObj.y = returny;
                        return _loc1_;
                     }
                     if(itemsPanel.mouseY > _loc6_ && itemsPanel.mouseY < _loc6_ + 63)
                     {
                        _loc1_ = Boolean(allBagHandle.slotHandle(dragObj,oldNum,_loc2_));
                        dragObj.x = returnx;
                        dragObj.y = returny;
                        return _loc1_;
                     }
                     _loc2_++;
                     _loc6_ += 76;
                     _loc7_++;
                  }
               }
               _loc4_++;
               _loc3_ += 345;
               _loc5_++;
            }
            return false;
         }
         return false;
      }
      
      private static function inItemsRange() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = itemsPanel.y + 104;
         var _loc4_:uint = 0;
         while(_loc4_ < 8)
         {
            _loc2_ = 4 * _loc4_;
            _loc5_ = itemsPanel.x + 505;
            if(itemsPanel.mouseY > _loc3_ && itemsPanel.mouseY < _loc3_ + 63)
            {
               _loc6_ = 0;
               while(_loc6_ < 4)
               {
                  if(itemsPanel.mouseX > _loc5_ && itemsPanel.mouseX < _loc5_ + 66)
                  {
                     switch(itemsType)
                     {
                        case 1:
                           _loc1_ = Boolean(allBagHandle.equipHandle(dragObj,oldNum,_loc2_));
                           break;
                        case 2:
                           _loc1_ = Boolean(allBagHandle.suppliesHandle(dragObj,oldNum,_loc2_));
                           break;
                        case 3:
                           _loc1_ = Boolean(allBagHandle.gemHandle(dragObj,oldNum,_loc2_));
                           break;
                        case 4:
                           _loc1_ = Boolean(allBagHandle.otherobjHandle(dragObj,oldNum,_loc2_));
                           break;
                        case 5:
                           trace("c");
                     }
                     dragObj.x = returnx;
                     dragObj.y = returny;
                     return _loc1_;
                  }
                  _loc2_++;
                  _loc5_ += 77;
                  _loc6_++;
               }
            }
            _loc3_ += 75;
            _loc4_++;
         }
         return false;
      }
      
      public static function showjiangli() : *
      {
         itemsPanel["fudai"]["select"].x = itemsPanel["fudai"]["xz" + jiangliNum].x;
         itemsPanel["fudai"]["select"].y = itemsPanel["fudai"]["xz" + jiangliNum].y;
      }
      
      public static function xuanzejiangli(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         TiaoShi.txtShow(_loc3_);
         jiangliNum = _loc3_;
         showjiangli();
      }
      
      public static function lingqujiangli(param1:*) : *
      {
         var _loc2_:PlayerData = null;
         if(isPOne)
         {
            _loc2_ = Main.player1;
         }
         else
         {
            _loc2_ = Main.player2;
         }
         if(_loc2_.getBag().backequipBagNum() >= 1)
         {
            if(jiangliNum == 0)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13630));
            }
            else if(jiangliNum == 1)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13631));
            }
            else if(jiangliNum == 2)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13632));
            }
            else if(jiangliNum == 3)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13633));
            }
            else if(jiangliNum == 4)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13634));
            }
            _loc2_.getBag().delOtherById(63234);
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         itemsPanel["fudai"].visible = false;
         BagItemsShow.otherobjShow();
      }
      
      public static function showjiangli3() : *
      {
         itemsPanel["fudai3"]["select"].x = itemsPanel["fudai3"]["xz" + jiangliNum3].x;
         itemsPanel["fudai3"]["select"].y = itemsPanel["fudai3"]["xz" + jiangliNum3].y;
      }
      
      public static function xuanzejiangli3(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         jiangliNum3 = _loc3_;
         showjiangli3();
      }
      
      public static function lingqujiangli3(param1:*) : *
      {
         var _loc2_:PlayerData = null;
         if(isPOne)
         {
            _loc2_ = Main.player1;
         }
         else
         {
            _loc2_ = Main.player2;
         }
         if(_loc2_.getBag().backequipBagNum() >= 1)
         {
            if(jiangliNum3 == 0)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13530));
            }
            else if(jiangliNum3 == 1)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13531));
            }
            else if(jiangliNum3 == 2)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13532));
            }
            else if(jiangliNum3 == 3)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13533));
            }
            else if(jiangliNum3 == 4)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13534));
            }
            _loc2_.getBag().delOtherById(63323);
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         itemsPanel["fudai3"].visible = false;
         BagItemsShow.otherobjShow();
      }
      
      public static function fudaiOpen3(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         itemsPanel.addChild(itemsTooltip);
         itemsTooltip.x = itemsPanel.mouseX;
         itemsTooltip.y = itemsPanel.mouseY;
         switch(_loc3_)
         {
            case 0:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13530),1);
               break;
            case 1:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13531),1);
               break;
            case 2:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13532),1);
               break;
            case 3:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13533),1);
               break;
            case 4:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13534),1);
         }
         itemsTooltip.visible = true;
      }
      
      public static function fudaiClose3(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      public static function showjiangli2() : *
      {
         itemsPanel["fudai2"]["select"].x = itemsPanel["fudai2"]["xz" + jiangliNum2].x;
         itemsPanel["fudai2"]["select"].y = itemsPanel["fudai2"]["xz" + jiangliNum2].y;
      }
      
      public static function xuanzejiangli2(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         jiangliNum2 = _loc3_;
         showjiangli2();
      }
      
      public static function lingqujiangli2(param1:*) : *
      {
         var _loc2_:PlayerData = null;
         if(isPOne)
         {
            _loc2_ = Main.player1;
         }
         else
         {
            _loc2_ = Main.player2;
         }
         if(_loc2_.getBag().backequipBagNum() >= 1)
         {
            if(jiangliNum2 == 0)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13730));
            }
            else if(jiangliNum2 == 1)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13731));
            }
            else if(jiangliNum2 == 2)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13732));
            }
            else if(jiangliNum2 == 3)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13733));
            }
            else if(jiangliNum2 == 4)
            {
               _loc2_.getBag().addEquipBag(EquipFactory.createEquipByID(13734));
            }
            _loc2_.getBag().delOtherById(63242);
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         itemsPanel["fudai2"].visible = false;
         BagItemsShow.otherobjShow();
      }
      
      public static function fudaiOpen2(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         itemsPanel.addChild(itemsTooltip);
         itemsTooltip.x = itemsPanel.mouseX;
         itemsTooltip.y = itemsPanel.mouseY;
         switch(_loc3_)
         {
            case 0:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13730),1);
               break;
            case 1:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13731),1);
               break;
            case 2:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13732),1);
               break;
            case 3:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13733),1);
               break;
            case 4:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13734),1);
         }
         itemsTooltip.visible = true;
      }
      
      public static function fudaiClose2(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      public static function fudaiOpen(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(2,1));
         itemsPanel.addChild(itemsTooltip);
         itemsTooltip.x = itemsPanel.mouseX;
         itemsTooltip.y = itemsPanel.mouseY;
         switch(_loc3_)
         {
            case 0:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13630),1);
               break;
            case 1:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13631),1);
               break;
            case 2:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13632),1);
               break;
            case 3:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13633),1);
               break;
            case 4:
               itemsTooltip.equipTooltip(EquipFactory.createEquipByID(13634),1);
         }
         itemsTooltip.visible = true;
      }
      
      public static function fudaiClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      public static function changeModel(param1:PlayerData) : void
      {
         if(param1.getEquipSlot().getEquipFromSlot(2).getPosition() == 5)
         {
            param1.skinArr[0] = 0;
         }
         else if(param1.getEquipSlot().getEquipFromSlot(2).getPosition() == 6)
         {
            param1.skinArr[0] = 1;
         }
         else if(param1.getEquipSlot().getEquipFromSlot(2).getPosition() == 7)
         {
            param1.skinArr[0] = 2;
         }
         if(param1.getEquipSlot().getEquipFromSlot(5).getPosition() == 5)
         {
            param1.skinArr[1] = 0;
         }
         else if(param1.getEquipSlot().getEquipFromSlot(5).getPosition() == 6)
         {
            param1.skinArr[1] = 1;
         }
         else if(param1.getEquipSlot().getEquipFromSlot(5).getPosition() == 7)
         {
            param1.skinArr[1] = 2;
         }
         if(param1 == Main.player1)
         {
            Main.player_1.newSkin();
         }
         else if(param1 == Main.player2)
         {
            Main.player_2.newSkin();
         }
      }
      
      public static function szcbTime() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 24)
         {
            if(Boolean(Main.player1.getBag().getEquipFromBag(_loc1_)) && Boolean(Main.player1.getBag().getEquipFromBag(_loc1_).getPosition() > 7) && Main.player1.getBag().getEquipFromBag(_loc1_).getPosition() < 10)
            {
               Main.player1.getBag().getEquipFromBag(_loc1_).setRemainingTime(Main.serverTime);
            }
            _loc1_++;
         }
         var _loc2_:int = 6;
         while(_loc2_ < 8)
         {
            if(Main.player1.getEquipSlot().getEquipFromSlot(_loc2_))
            {
               Main.player1.getEquipSlot().getEquipFromSlot(_loc2_).setRemainingTime(Main.serverTime);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 35)
         {
            if(Boolean(StoragePanel.storage.getEquipFromStorage(_loc3_)) && Boolean(StoragePanel.storage.getEquipFromStorage(_loc3_).getPosition() > 7) && StoragePanel.storage.getEquipFromStorage(_loc3_).getPosition() < 10)
            {
               StoragePanel.storage.getEquipFromStorage(_loc3_).setRemainingTime(Main.serverTime);
            }
            _loc3_++;
         }
         Main.player_1.newSkin();
         if(Main.P1P2)
         {
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               if(Boolean(Main.player2.getBag().getEquipFromBag(_loc1_)) && Boolean(Main.player2.getBag().getEquipFromBag(_loc1_).getPosition() > 7) && Main.player2.getBag().getEquipFromBag(_loc1_).getPosition() < 10)
               {
                  Main.player2.getBag().getEquipFromBag(_loc1_).setRemainingTime(Main.serverTime);
               }
               _loc1_++;
            }
            _loc2_ = 6;
            while(_loc2_ < 8)
            {
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc2_))
               {
                  Main.player2.getEquipSlot().getEquipFromSlot(_loc2_).setRemainingTime(Main.serverTime);
               }
               _loc2_++;
            }
            Main.player_2.newSkin();
         }
      }
      
      public static function timeXiuZheng() : *
      {
         var _loc1_:int = 8;
         while(_loc1_ < 13)
         {
            if(Main.player1.getEquipSlot().getEquipFromSlot(_loc1_))
            {
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc1_).getRemainingTime() < 1)
               {
                  Main.player1.getEquipSlot().getEquipFromSlot(_loc1_).setRemainingTimeNow();
               }
            }
            if(Main.P1P2)
            {
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc1_))
               {
                  if(Main.player2.getEquipSlot().getEquipFromSlot(_loc1_).getRemainingTime() < 1)
                  {
                     Main.player2.getEquipSlot().getEquipFromSlot(_loc1_).setRemainingTimeNow();
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public static function NvShenRenWu() : *
      {
         if(myplayer.data.getBag().isHavesQuest(84110) || myplayer.data.getBag().isHavesQuest(84111) || myplayer.data.getBag().isHavesQuest(84112) || myplayer.data.getBag().isHavesQuest(84113) || myplayer.data.getBag().isHavesQuest(84114))
         {
            itemsPanel["renwutishi"].visible = true;
         }
         else
         {
            itemsPanel["renwutishi"].visible = false;
         }
      }
   }
}

