package com.hotpoint.braveManIII.views.storagePanel
{
   import com.hotpoint.braveManIII.events.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.gem.Gem;
   import com.hotpoint.braveManIII.models.other.Otherobj;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.models.supplies.Supplies;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import src.*;
   
   public class StoragePanel extends MovieClip
   {
      
      public static var storage:Storage;
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var dragObj:MovieClip;
      
      public static var storagePanel:MovieClip;
      
      private static var pointx:Number;
      
      private static var pointy:Number;
      
      private static var oldNum:Number;
      
      public static var sp:StoragePanel;
      
      public static var myplayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      public static var returnx:Number = 0;
      
      public static var returny:Number = 0;
      
      public static var isDown:Boolean = false;
      
      private static var itemsType:Number = 1;
      
      private static var myMenu:ContextMenu = new ContextMenu();
      
      private static var yeshu:Number = 0;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "NewCangku_v892.swf";
      
      public function StoragePanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!storagePanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function InitIcon() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = storagePanel.getChildIndex(storagePanel["s1_" + _loc1_]);
            _loc2_.x = storagePanel["s1_" + _loc1_].x;
            _loc2_.y = storagePanel["s1_" + _loc1_].y;
            _loc2_.name = "s1_" + _loc1_;
            storagePanel.removeChild(storagePanel["s1_" + _loc1_]);
            storagePanel["s1_" + _loc1_] = _loc2_;
            storagePanel.addChild(_loc2_);
            storagePanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = storagePanel.getChildIndex(storagePanel["kc_" + _loc1_]);
            _loc2_.x = storagePanel["kc_" + _loc1_].x;
            _loc2_.y = storagePanel["kc_" + _loc1_].y;
            _loc2_.name = "kc_" + _loc1_;
            storagePanel.removeChild(storagePanel["kc_" + _loc1_]);
            storagePanel["kc_" + _loc1_] = _loc2_;
            storagePanel.addChild(_loc2_);
            storagePanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("StorageShow") as Class;
         storagePanel = new _loc2_();
         sp.addChild(storagePanel);
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
         if(!storage)
         {
            storage = Storage.createStorage();
         }
         sp = new StoragePanel();
         LoadSkin();
         Main._stage.addChild(sp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         if(!storage)
         {
            storage = Storage.createStorage();
         }
         sp = new StoragePanel();
         Main._stage.addChild(sp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(storagePanel)
         {
            Main.stopXX = true;
            sp.x = 0;
            sp.y = 0;
            myplayer = Main.player1;
            myplayer.getBag().cheatOther();
            myplayer.getBag().cheatGem();
            myplayer.getBag().cheatEquip();
            storage.cheatTesting();
            storage.cheatGem();
            storage.cheatOther();
            addListenerP1();
            if(Main.player2)
            {
               Main.player2.getBag().cheatEquip();
               Main.player2.getBag().cheatOther();
               Main.player2.getBag().cheatGem();
            }
            sp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(storagePanel)
         {
            sp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      private static function CloseCK(param1:MouseEvent) : void
      {
         close();
      }
      
      public static function addListenerP1() : *
      {
         var _loc1_:uint = 0;
         if(Main.player2)
         {
            storagePanel["bag1"].visible = false;
            storagePanel["bag2"].visible = true;
            storagePanel["back_mc"].visible = true;
            storagePanel["bag1"].addEventListener(MouseEvent.CLICK,to1P);
            storagePanel["bag2"].addEventListener(MouseEvent.CLICK,to2P);
            if(Main.player_1.visible == false)
            {
               storagePanel["bag1"].visible = false;
               storagePanel["bag2"].visible = false;
               storagePanel["back_mc"].visible = false;
               myplayer = Main.player2;
            }
            if(Main.player_2.visible == false)
            {
               storagePanel["bag1"].visible = false;
               storagePanel["bag2"].visible = false;
               storagePanel["back_mc"].visible = false;
               myplayer = Main.player1;
            }
         }
         else
         {
            storagePanel["bag1"].visible = false;
            storagePanel["bag2"].visible = false;
            storagePanel["back_mc"].visible = false;
         }
         storagePanel["closeCK"].addEventListener(MouseEvent.CLICK,CloseCK);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_].mouseChildren = false;
            storagePanel["s1_" + _loc1_]["t_txt"].visible = false;
            storagePanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            storagePanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            storagePanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            storagePanel["s1_" + _loc1_].addEventListener(MouseEvent.CLICK,putIn);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_].mouseChildren = false;
            storagePanel["kc_" + _loc1_]["t_txt"].visible = false;
            storagePanel["kc_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            storagePanel["kc_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            storagePanel["kc_" + _loc1_].addEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            storagePanel["kc_" + _loc1_].addEventListener(MouseEvent.CLICK,takeOut);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            storagePanel["bagLock" + _loc1_].visible = false;
            _loc1_++;
         }
         storagePanel["yeshu_1"].addEventListener(MouseEvent.CLICK,oneGo);
         storagePanel["yeshu_2"].addEventListener(MouseEvent.CLICK,twoGo);
         storagePanel["yeshu_1"].stop();
         storagePanel["yeshu_2"].stop();
         storagePanel.addEventListener(BtnEvent.DO_CHANGE,ckListen);
         storagePanel.addEventListener(Event.DEACTIVATE,loseFocus);
         myMenu.addEventListener(ContextMenuEvent.MENU_SELECT,loseFocus);
         Main._stage.addEventListener(Event.MOUSE_LEAVE,loseFocus);
         Main._stage.addEventListener(MouseEvent.MOUSE_UP,loseFocus);
         storagePanel.contextMenu = myMenu;
         equipShow();
         informationShow();
         allFalse();
         storagePanel["mck_1"].isClick = true;
         itemsType = 1;
      }
      
      public static function removeListenerP1() : *
      {
         if(Main.player2)
         {
            storagePanel["bag1"].removeEventListener(MouseEvent.CLICK,to1P);
            storagePanel["bag2"].removeEventListener(MouseEvent.CLICK,to2P);
         }
         storagePanel["closeCK"].removeEventListener(MouseEvent.CLICK,CloseCK);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            storagePanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            storagePanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            storagePanel["s1_" + _loc1_].removeEventListener(MouseEvent.CLICK,putIn);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            storagePanel["kc_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            storagePanel["kc_" + _loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,DownHandler);
            storagePanel["kc_" + _loc1_].removeEventListener(MouseEvent.CLICK,takeOut);
            _loc1_++;
         }
         storagePanel["yeshu_1"].removeEventListener(MouseEvent.CLICK,oneGo);
         storagePanel["yeshu_2"].removeEventListener(MouseEvent.CLICK,twoGo);
         storagePanel.removeEventListener(Event.DEACTIVATE,loseFocus);
         myMenu.removeEventListener(ContextMenuEvent.MENU_SELECT,loseFocus);
         Main._stage.removeEventListener(Event.MOUSE_LEAVE,loseFocus);
         Main._stage.removeEventListener(MouseEvent.MOUSE_UP,loseFocus);
         storagePanel.contextMenu = myMenu;
         storagePanel.removeEventListener(BtnEvent.DO_CHANGE,ckListen);
      }
      
      private static function oneGo(param1:*) : *
      {
         yeshu = 0;
         if(itemsType == 1)
         {
            equipShow();
         }
         else if(itemsType == 2)
         {
            suppliesShow();
         }
         else if(itemsType == 3)
         {
            gemShow();
         }
         else if(itemsType == 4)
         {
            otherobjShow();
         }
      }
      
      private static function twoGo(param1:*) : *
      {
         yeshu = 1;
         if(itemsType == 1)
         {
            equipShow();
         }
         else if(itemsType == 2)
         {
            suppliesShow();
         }
         else if(itemsType == 3)
         {
            gemShow();
         }
         else if(itemsType == 4)
         {
            otherobjShow();
         }
      }
      
      private static function loseFocus(param1:Event = null) : *
      {
         if(dragObj)
         {
            UpHandler();
         }
      }
      
      private static function informationShow() : *
      {
         storagePanel["gold1"].text = myplayer.getGold();
         storagePanel["kill_txt"].text = myplayer.getKillPoint();
      }
      
      private static function to1P(param1:*) : *
      {
         myplayer = Main.player1;
         storagePanel["bag1"].visible = false;
         storagePanel["bag2"].visible = true;
         if(itemsType == 1)
         {
            equipShow();
         }
         else if(itemsType == 2)
         {
            suppliesShow();
         }
         else if(itemsType == 3)
         {
            gemShow();
         }
         else if(itemsType == 4)
         {
            otherobjShow();
         }
      }
      
      private static function to2P(param1:*) : *
      {
         myplayer = Main.player2;
         storagePanel["bag1"].visible = true;
         storagePanel["bag2"].visible = false;
         if(itemsType == 1)
         {
            equipShow();
         }
         else if(itemsType == 2)
         {
            suppliesShow();
         }
         else if(itemsType == 3)
         {
            gemShow();
         }
         else if(itemsType == 4)
         {
            otherobjShow();
         }
      }
      
      private static function ckListen(param1:BtnEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(_loc2_.name.substr(4,1));
         switch(_loc3_)
         {
            case 1:
               allFalse();
               storagePanel["mck_1"].isClick = true;
               equipShow();
               itemsType = 1;
               break;
            case 2:
               allFalse();
               storagePanel["mck_2"].isClick = true;
               suppliesShow();
               itemsType = 2;
               break;
            case 3:
               allFalse();
               storagePanel["mck_3"].isClick = true;
               gemShow();
               itemsType = 3;
               break;
            case 4:
               allFalse();
               storagePanel["mck_4"].isClick = true;
               otherobjShow();
               itemsType = 4;
         }
      }
      
      private static function allFalse() : void
      {
         storagePanel["mck_1"].isClick = false;
         storagePanel["mck_2"].isClick = false;
         storagePanel["mck_3"].isClick = false;
         storagePanel["mck_4"].isClick = false;
      }
      
      public static function equipShow() : *
      {
         var _loc1_:uint = 0;
         myplayer.getBag().zhengliBag();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myplayer.getBag().getEquipFromBag(_loc1_ + yeshu * 24) != null)
            {
               storagePanel["s1_" + _loc1_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc1_ + yeshu * 24).getFrame());
               storagePanel["s1_" + _loc1_].visible = true;
            }
            else
            {
               storagePanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_]["t_txt"].visible = false;
            if(storage.getEquipFromStorage(_loc1_) != null)
            {
               storagePanel["kc_" + _loc1_].gotoAndStop(storage.getEquipFromStorage(_loc1_).getFrame());
               storagePanel["kc_" + _loc1_].visible = true;
            }
            else
            {
               storagePanel["kc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(myplayer.getBag().getLimitE() >= 28)
            {
               storagePanel["bagLock0"].visible = false;
            }
            if(myplayer.getBag().getLimitE() >= 32)
            {
               storagePanel["bagLock1"].visible = false;
            }
            if(myplayer.getBag().getLimitE() >= 36)
            {
               storagePanel["bagLock2"].visible = false;
            }
            if(myplayer.getBag().getLimitE() >= 40)
            {
               storagePanel["bagLock3"].visible = false;
            }
            if(myplayer.getBag().getLimitE() >= 44)
            {
               storagePanel["bagLock4"].visible = false;
            }
            if(myplayer.getBag().getLimitE() >= 48)
            {
               storagePanel["bagLock5"].visible = false;
            }
         }
      }
      
      public static function suppliesShow() : *
      {
         var _loc1_:uint = 0;
         myplayer.getBag().zhengliBagS();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myplayer.getBag().getSuppliesFromBag(_loc1_ + yeshu * 24) != null)
            {
               storagePanel["s1_" + _loc1_].gotoAndStop(myplayer.getBag().getSuppliesFromBag(_loc1_ + yeshu * 24).getFrame());
               storagePanel["s1_" + _loc1_].visible = true;
               if(myplayer.getBag().getSuppliesFromBag(_loc1_ + yeshu * 24).getTimes() > 1)
               {
                  storagePanel["s1_" + _loc1_]["t_txt"].text = myplayer.getBag().getSuppliesFromBag(_loc1_ + yeshu * 24).getTimes();
                  storagePanel["s1_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_]["t_txt"].visible = false;
            if(storage.getSuppliesFromStorage(_loc1_) != null)
            {
               storagePanel["kc_" + _loc1_].gotoAndStop(storage.getSuppliesFromStorage(_loc1_).getFrame());
               storagePanel["kc_" + _loc1_].visible = true;
               if(storage.getSuppliesFromStorage(_loc1_).getTimes() > 1)
               {
                  storagePanel["kc_" + _loc1_]["t_txt"].text = storage.getSuppliesFromStorage(_loc1_).getTimes();
                  storagePanel["kc_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["kc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(myplayer.getBag().getLimitS() >= 28)
            {
               storagePanel["bagLock0"].visible = false;
            }
            if(myplayer.getBag().getLimitS() >= 32)
            {
               storagePanel["bagLock1"].visible = false;
            }
            if(myplayer.getBag().getLimitS() >= 36)
            {
               storagePanel["bagLock2"].visible = false;
            }
            if(myplayer.getBag().getLimitS() >= 40)
            {
               storagePanel["bagLock3"].visible = false;
            }
            if(myplayer.getBag().getLimitS() >= 44)
            {
               storagePanel["bagLock4"].visible = false;
            }
            if(myplayer.getBag().getLimitS() >= 48)
            {
               storagePanel["bagLock5"].visible = false;
            }
         }
      }
      
      public static function gemShow() : *
      {
         var _loc1_:uint = 0;
         myplayer.getBag().zhengliBagG();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myplayer.getBag().getGemFromBag(_loc1_ + yeshu * 24) != null)
            {
               storagePanel["s1_" + _loc1_].gotoAndStop(myplayer.getBag().getGemFromBag(_loc1_ + yeshu * 24).getFrame());
               storagePanel["s1_" + _loc1_].visible = true;
               if(myplayer.getBag().getGemFromBag(_loc1_ + yeshu * 24).getIsPile() == true)
               {
                  storagePanel["s1_" + _loc1_]["t_txt"].text = myplayer.getBag().getGemFromBag(_loc1_ + yeshu * 24).getTimes();
                  storagePanel["s1_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_]["t_txt"].visible = false;
            if(storage.getGemFromStorage(_loc1_) != null)
            {
               storagePanel["kc_" + _loc1_].gotoAndStop(storage.getGemFromStorage(_loc1_).getFrame());
               storagePanel["kc_" + _loc1_].visible = true;
               if(storage.getGemFromStorage(_loc1_).getIsPile() == true)
               {
                  storagePanel["kc_" + _loc1_]["t_txt"].text = storage.getGemFromStorage(_loc1_).getTimes();
                  storagePanel["kc_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["kc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(myplayer.getBag().getLimitG() >= 28)
            {
               storagePanel["bagLock0"].visible = false;
            }
            if(myplayer.getBag().getLimitG() >= 32)
            {
               storagePanel["bagLock1"].visible = false;
            }
            if(myplayer.getBag().getLimitG() >= 36)
            {
               storagePanel["bagLock2"].visible = false;
            }
            if(myplayer.getBag().getLimitG() >= 40)
            {
               storagePanel["bagLock3"].visible = false;
            }
            if(myplayer.getBag().getLimitG() >= 44)
            {
               storagePanel["bagLock4"].visible = false;
            }
            if(myplayer.getBag().getLimitG() >= 48)
            {
               storagePanel["bagLock5"].visible = false;
            }
         }
      }
      
      public static function otherobjShow() : *
      {
         var _loc1_:uint = 0;
         myplayer.getBag().zhengliBagO();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            storagePanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myplayer.getBag().getOtherobjFromBag(_loc1_ + yeshu * 24) != null)
            {
               storagePanel["s1_" + _loc1_].gotoAndStop(myplayer.getBag().getOtherobjFromBag(_loc1_ + yeshu * 24).getFrame());
               storagePanel["s1_" + _loc1_].visible = true;
               if(myplayer.getBag().getOtherobjFromBag(_loc1_ + yeshu * 24).getTimes() > 1)
               {
                  storagePanel["s1_" + _loc1_]["t_txt"].text = myplayer.getBag().getOtherobjFromBag(_loc1_ + yeshu * 24).getTimes();
                  storagePanel["s1_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 35)
         {
            storagePanel["kc_" + _loc1_]["t_txt"].visible = false;
            if(storage.getOtherobjFromStorage(_loc1_) != null)
            {
               storagePanel["kc_" + _loc1_].gotoAndStop(storage.getOtherobjFromStorage(_loc1_).getFrame());
               storagePanel["kc_" + _loc1_].visible = true;
               if(storage.getOtherobjFromStorage(_loc1_).getTimes() > 1)
               {
                  storagePanel["kc_" + _loc1_]["t_txt"].text = storage.getOtherobjFromStorage(_loc1_).getTimes();
                  storagePanel["kc_" + _loc1_]["t_txt"].visible = true;
               }
            }
            else
            {
               storagePanel["kc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               storagePanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(myplayer.getBag().getLimitO() >= 28)
            {
               storagePanel["bagLock0"].visible = false;
            }
            if(myplayer.getBag().getLimitO() >= 32)
            {
               storagePanel["bagLock1"].visible = false;
            }
            if(myplayer.getBag().getLimitO() >= 36)
            {
               storagePanel["bagLock2"].visible = false;
            }
            if(myplayer.getBag().getLimitO() >= 40)
            {
               storagePanel["bagLock3"].visible = false;
            }
            if(myplayer.getBag().getLimitO() >= 44)
            {
               storagePanel["bagLock4"].visible = false;
            }
            if(myplayer.getBag().getLimitO() >= 48)
            {
               storagePanel["bagLock5"].visible = false;
            }
         }
      }
      
      private static function tooltipOpen(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         storagePanel.addChild(itemsTooltip);
         if(isDown == false)
         {
            _loc2_ = param1.target as MovieClip;
            _loc3_ = uint(_loc2_.name.substr(3,2));
            itemsTooltip.x = storagePanel.mouseX;
            itemsTooltip.y = storagePanel.mouseY;
            if(_loc2_.name.substr(0,2) == "s1")
            {
               _loc3_ += yeshu * 24;
               switch(itemsType)
               {
                  case 1:
                     if(myplayer.getBag().getEquipFromBag(_loc3_))
                     {
                        itemsTooltip.equipTooltip(myplayer.getBag().getEquipFromBag(_loc3_));
                     }
                     break;
                  case 2:
                     if(myplayer.getBag().getSuppliesFromBag(_loc3_))
                     {
                        itemsTooltip.suppliesTooltip(myplayer.getBag().getSuppliesFromBag(_loc3_));
                     }
                     break;
                  case 3:
                     if(myplayer.getBag().getGemFromBag(_loc3_))
                     {
                        itemsTooltip.gemTooltip(myplayer.getBag().getGemFromBag(_loc3_));
                     }
                     break;
                  case 4:
                     if(myplayer.getBag().getOtherobjFromBag(_loc3_))
                     {
                        itemsTooltip.otherTooltip(myplayer.getBag().getOtherobjFromBag(_loc3_));
                     }
               }
            }
            else
            {
               switch(itemsType)
               {
                  case 1:
                     if(storage.getEquipFromStorage(_loc3_))
                     {
                        itemsTooltip.equipTooltip(storage.getEquipFromStorage(_loc3_),3);
                     }
                     break;
                  case 2:
                     if(storage.getSuppliesFromStorage(_loc3_))
                     {
                        itemsTooltip.suppliesTooltip(storage.getSuppliesFromStorage(_loc3_),3);
                     }
                     break;
                  case 3:
                     if(storage.getGemFromStorage(_loc3_))
                     {
                        itemsTooltip.gemTooltip(storage.getGemFromStorage(_loc3_),3);
                     }
                     break;
                  case 4:
                     if(storage.getOtherobjFromStorage(_loc3_))
                     {
                        itemsTooltip.otherTooltip(storage.getOtherobjFromStorage(_loc3_));
                     }
               }
            }
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
      
      private static function isDrag(param1:Number, param2:Number) : Boolean
      {
         if(isDown == true)
         {
            if(storagePanel.mouseX > param1 + 1 || storagePanel.mouseX < param1 - 1 || storagePanel.mouseY > param2 + 1 || storagePanel.mouseY < param2 - 1)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function DragHandler(param1:MouseEvent) : void
      {
         if(isDown == true)
         {
            if(isDrag(pointx,pointy) == true)
            {
               storagePanel.addChild(dragObj);
               dragObj.x = storagePanel.mouseX - 20;
               dragObj.y = storagePanel.mouseY - 20;
               dragObj.startDrag();
            }
         }
      }
      
      private static function DownHandler(param1:MouseEvent) : void
      {
         if(itemsTooltip.visible = true)
         {
            itemsTooltip.visible = false;
            isDown = true;
         }
         dragObj = param1.target as MovieClip;
         returnx = dragObj.x;
         returny = dragObj.y;
         pointx = storagePanel.mouseX;
         pointy = storagePanel.mouseY;
         oldNum = uint(dragObj.name.substr(3,2));
      }
      
      private static function UpHandler(param1:MouseEvent = null) : void
      {
         if(dragObj)
         {
            dragObj.stopDrag();
            if(inItemsRange() == false && inStorageRange() == false)
            {
               dragObj.x = returnx;
               dragObj.y = returny;
            }
            isDown = false;
         }
         dragObj = null;
      }
      
      private static function inItemsRange() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = storagePanel.y + 60;
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            _loc2_ = 4 * _loc4_;
            _loc5_ = storagePanel.x + 567;
            if(storagePanel.mouseY > _loc3_ && storagePanel.mouseY < _loc3_ + 60)
            {
               _loc6_ = 0;
               while(_loc6_ < 8)
               {
                  if(storagePanel.mouseX > _loc5_ && storagePanel.mouseX < _loc5_ + 60)
                  {
                     switch(itemsType)
                     {
                        case 1:
                           equipHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 2:
                           suppliesHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 3:
                           gemHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 4:
                           otherHandle(dragObj,oldNum,_loc2_);
                     }
                     dragObj.x = returnx;
                     dragObj.y = returny;
                     return _loc1_;
                  }
                  _loc2_++;
                  _loc5_ += 75;
                  _loc6_++;
               }
            }
            _loc3_ += 72;
            _loc4_++;
         }
         return false;
      }
      
      private static function inStorageRange() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = storagePanel.y + 60;
         var _loc4_:uint = 0;
         while(_loc4_ < 7)
         {
            _loc2_ = 5 * _loc4_;
            _loc5_ = storagePanel.x + 100;
            if(storagePanel.mouseY > _loc3_ && storagePanel.mouseY < _loc3_ + 60)
            {
               _loc6_ = 0;
               while(_loc6_ < 5)
               {
                  if(storagePanel.mouseX > _loc5_ && storagePanel.mouseX < _loc5_ + 60)
                  {
                     switch(itemsType)
                     {
                        case 1:
                           equipStorageHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 2:
                           suppliesStorageHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 3:
                           gemStorageHandle(dragObj,oldNum,_loc2_);
                           break;
                        case 4:
                           otherStorageHandle(dragObj,oldNum,_loc2_);
                     }
                     dragObj.x = returnx;
                     dragObj.y = returny;
                     return _loc1_;
                  }
                  _loc2_++;
                  _loc5_ += 75;
                  _loc6_++;
               }
            }
            _loc3_ += 72;
            _loc4_++;
         }
         return false;
      }
      
      public static function equipHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Equip = null;
         if(param1.name.substr(0,3) == "s1_")
         {
            param2 += yeshu * 24;
            param3 += yeshu * 24;
            myplayer.getBag().equipBagMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "kc_")
            {
               return false;
            }
            param3 += yeshu * 24;
            if(myplayer.getBag().getEquipFromBag(param3) != null)
            {
               _loc4_ = myplayer.getBag().delEquip(param3);
               myplayer.getBag().addToEquipBag(storage.getEquipFromStorage(param2),param3);
               storage.delEquip(param2);
               storage.addToEquipStorage(_loc4_,param2);
            }
            else
            {
               myplayer.getBag().addToEquipBag(storage.getEquipFromStorage(param2),param3);
               storage.delEquip(param2);
            }
         }
         equipShow();
         return true;
      }
      
      public static function equipStorageHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Equip = null;
         if(param1.name.substr(0,3) == "kc_")
         {
            storage.equipStorageMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "s1_")
            {
               return false;
            }
            param2 += yeshu * 24;
            if(storage.getEquipFromStorage(param3) != null)
            {
               _loc4_ = storage.delEquip(param3);
               storage.addToEquipStorage(myplayer.getBag().getEquipFromBag(param2),param3);
               myplayer.getBag().delEquip(param2);
               myplayer.getBag().addToEquipBag(_loc4_,param2);
            }
            else
            {
               storage.addToEquipStorage(myplayer.getBag().getEquipFromBag(param2),param3);
               myplayer.getBag().delEquip(param2);
            }
         }
         equipShow();
         return true;
      }
      
      public static function suppliesHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Supplies = null;
         if(param1.name.substr(0,3) == "s1_")
         {
            param2 += yeshu * 24;
            param3 += yeshu * 24;
            myplayer.getBag().suppliesBagMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "kc_")
            {
               return false;
            }
            param3 += yeshu * 24;
            if(myplayer.getBag().getSuppliesFromBag(param3) != null)
            {
               _loc4_ = myplayer.getBag().delSupplies(param3);
               myplayer.getBag().addToSuppliesBag(storage.getSuppliesFromStorage(param2),param3);
               storage.delSupplies(param2);
               storage.addToSuppliesStorage(_loc4_,param2);
            }
            else
            {
               myplayer.getBag().addToSuppliesBag(storage.getSuppliesFromStorage(param2),param3);
               storage.delSupplies(param2);
            }
         }
         suppliesShow();
         return true;
      }
      
      public static function suppliesStorageHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Supplies = null;
         if(param1.name.substr(0,3) == "kc_")
         {
            storage.suppliesStorageMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "s1_")
            {
               return false;
            }
            param2 += yeshu * 24;
            if(storage.getSuppliesFromStorage(param3) != null)
            {
               _loc4_ = storage.delSupplies(param3);
               storage.addToSuppliesStorage(myplayer.getBag().getSuppliesFromBag(param2),param3);
               myplayer.getBag().delSupplies(param2);
               myplayer.getBag().addToSuppliesBag(_loc4_,param2);
            }
            else
            {
               storage.addToSuppliesStorage(myplayer.getBag().getSuppliesFromBag(param2),param3);
               myplayer.getBag().delSupplies(param2);
            }
         }
         suppliesShow();
         return true;
      }
      
      public static function gemHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Gem = null;
         if(param1.name.substr(0,3) == "s1_")
         {
            param2 += yeshu * 24;
            param3 += yeshu * 24;
            myplayer.getBag().gemBagMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "kc_")
            {
               return false;
            }
            param3 += yeshu * 24;
            if(myplayer.getBag().getGemFromBag(param3) != null)
            {
               _loc4_ = myplayer.getBag().delGem(param3,myplayer.getBag().getGemFromBag(param3).getTimes());
               myplayer.getBag().addToGemBag(storage.getGemFromStorage(param2),param3);
               storage.addToGemStorage(_loc4_,param2);
            }
            else
            {
               myplayer.getBag().addToGemBag(storage.delGem(param2,storage.getGemFromStorage(param2).getTimes()),param3);
            }
         }
         gemShow();
         return true;
      }
      
      public static function gemStorageHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Gem = null;
         if(param1.name.substr(0,3) == "kc_")
         {
            storage.gemStorageMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "s1_")
            {
               return false;
            }
            param2 += yeshu * 24;
            if(storage.getGemFromStorage(param3) != null)
            {
               _loc4_ = storage.delGem(param3,storage.getGemFromStorage(param3).getTimes());
               storage.addToGemStorage(myplayer.getBag().delGem(param2,myplayer.getBag().getGemFromBag(param2).getTimes()),param3);
               myplayer.getBag().addToGemBag(_loc4_,param2);
            }
            else
            {
               storage.addToGemStorage(myplayer.getBag().delGem(param2,myplayer.getBag().getGemFromBag(param2).getTimes()),param3);
            }
         }
         gemShow();
         return true;
      }
      
      public static function otherHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Otherobj = null;
         if(param1.name.substr(0,3) == "s1_")
         {
            param2 += yeshu * 24;
            param3 += yeshu * 24;
            myplayer.getBag().otherobjBagMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "kc_")
            {
               return false;
            }
            param3 += yeshu * 24;
            if(myplayer.getBag().getOtherobjFromBag(param3) != null)
            {
               _loc4_ = myplayer.getBag().delOtherobj(param3,myplayer.getBag().getOtherobjFromBag(param3).getTimes());
               myplayer.getBag().addToOtherobjBag(storage.getOtherobjFromStorage(param2),param3);
               storage.addToOtherobjStorage(_loc4_,param2);
            }
            else
            {
               myplayer.getBag().addToOtherobjBag(storage.delOtherobj(param2,storage.getOtherobjFromStorage(param2).getTimes()),param3);
            }
         }
         otherobjShow();
         return true;
      }
      
      public static function otherStorageHandle(param1:MovieClip, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Otherobj = null;
         if(param1.name.substr(0,3) == "kc_")
         {
            storage.otherobjStorageMove(param2,param3);
         }
         else
         {
            if(param1.name.substr(0,3) != "s1_")
            {
               return false;
            }
            param2 += yeshu * 24;
            if(storage.getOtherobjFromStorage(param3) != null)
            {
               _loc4_ = storage.delOtherobj(param3,storage.getOtherobjFromStorage(param3).getTimes());
               storage.addToOtherobjStorage(myplayer.getBag().delOtherobj(param2,myplayer.getBag().getOtherobjFromBag(param2).getTimes()),param3);
               myplayer.getBag().addToOtherobjBag(_loc4_,param2);
            }
            else
            {
               storage.addToOtherobjStorage(myplayer.getBag().delOtherobj(param2,myplayer.getBag().getOtherobjFromBag(param2).getTimes()),param3);
            }
         }
         otherobjShow();
         return true;
      }
      
      private static function takeOut(param1:MouseEvent) : void
      {
         takeOutHandle(itemsType,oldNum);
         switch(itemsType)
         {
            case 1:
               equipShow();
               break;
            case 2:
               suppliesShow();
               break;
            case 3:
               gemShow();
               break;
            case 4:
               otherobjShow();
         }
         dragObj = null;
      }
      
      public static function takeOutHandle(param1:Number, param2:Number) : *
      {
         switch(param1)
         {
            case 1:
               if(myplayer.getBag().backequipBagNum() > 0)
               {
                  myplayer.getBag().addEquipBag(storage.delEquip(param2));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               break;
            case 2:
               if(myplayer.getBag().backSuppliesBagNum() > 0)
               {
                  myplayer.getBag().addSuppliesBag(storage.delSupplies(param2));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               break;
            case 3:
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(storage.delGem(param2,storage.getGemFromStorage(param2).getTimes()));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               break;
            case 4:
               if(myplayer.getBag().backOtherBagNum() > 0)
               {
                  myplayer.getBag().addOtherobjBag(storage.delOtherobj(param2,storage.getOtherobjFromStorage(param2).getTimes()));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
      }
      
      private static function putIn(param1:MouseEvent) : void
      {
         dragObj = param1.target as MovieClip;
         if(dragObj.name.substr(0,2) == "s1")
         {
            putInStorageHandle(itemsType,oldNum);
         }
         switch(itemsType)
         {
            case 1:
               equipShow();
               break;
            case 2:
               suppliesShow();
               break;
            case 3:
               gemShow();
               break;
            case 4:
               otherobjShow();
         }
         dragObj = null;
      }
      
      public static function putInStorageHandle(param1:Number, param2:Number) : *
      {
         param2 += yeshu * 24;
         switch(param1)
         {
            case 1:
               if(storage.backEquipEmptyNum() > 0)
               {
                  storage.addEquipStorage(myplayer.getBag().getEquipFromBag(param2));
                  myplayer.getBag().delEquip(param2);
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
               break;
            case 2:
               if(storage.backSuppliesEmptyNum() > 0)
               {
                  storage.addSuppliesStorage(myplayer.getBag().getSuppliesFromBag(param2));
                  myplayer.getBag().delSupplies(param2);
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
               break;
            case 3:
               if(storage.backGemEmptyNum() > 0)
               {
                  storage.addGemStorage(myplayer.getBag().delGem(param2,myplayer.getBag().getGemFromBag(param2).getTimes()));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
               break;
            case 4:
               if(storage.backOtherEmptyNum() > 0)
               {
                  storage.addOtherobjStorage(myplayer.getBag().delOtherobj(param2,myplayer.getBag().getOtherobjFromBag(param2).getTimes()));
                  break;
               }
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"仓库空间不足");
         }
      }
   }
}

