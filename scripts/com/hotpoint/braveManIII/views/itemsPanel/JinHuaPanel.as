package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class JinHuaPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var jhPanel:MovieClip;
      
      public static var jhp:JinHuaPanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var clickNum:Number;
      
      public static var starNum:Number;
      
      public static var mapNum:Number;
      
      public static var partNum:Number;
      
      public static var count:int;
      
      public static var myplayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      public static var arr:Array = [[1,63162,5],[1,63138,3],[1,63100,3],[1,63137,35],[2,63169,5],[2,63138,3],[2,63100,3],[2,63137,35],[3,63171,5],[3,63138,3],[3,63100,3],[3,63137,35],[4,63183,5],[4,63138,3],[4,63100,3],[4,63137,35],[5,63197,5],[5,63138,3],[5,63100,3],[5,63137,35],[6,63207,5],[6,63138,3],[6,63100,3],[6,63137,35],[7,63246,5],[7,63138,3],[7,63100,3],[7,63137,35],[8,63257,5],[8,63138,3],[8,63100,3],[8,63137,35],[9,63268,5],[9,63138,3],[9,63100,3],[9,63137,35],[10,63273,5],[10,63138,3],[10,63100,3],[10,63137,35]];
      
      public static var yeshu:Number = 0;
      
      public static var selbool:Boolean = false;
      
      public static var isPOne:Boolean = true;
      
      public static var arr_cl:Array = [];
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_XLZF_v892.swf";
      
      public function JinHuaPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!jhPanel && !loadData)
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
            _loc3_ = jhPanel.getChildIndex(jhPanel["e" + _loc1_]);
            _loc2_.x = jhPanel["e" + _loc1_].x;
            _loc2_.y = jhPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            jhPanel.removeChild(jhPanel["e" + _loc1_]);
            jhPanel["e" + _loc1_] = _loc2_;
            jhPanel.addChild(_loc2_);
            jhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = jhPanel.getChildIndex(jhPanel["x" + _loc1_]);
            _loc2_.x = jhPanel["x" + _loc1_].x;
            _loc2_.y = jhPanel["x" + _loc1_].y;
            _loc2_.name = "x" + _loc1_;
            jhPanel.removeChild(jhPanel["x" + _loc1_]);
            jhPanel["x" + _loc1_] = _loc2_;
            jhPanel.addChild(_loc2_);
            jhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = jhPanel.getChildIndex(jhPanel["s" + _loc1_]);
            _loc2_.x = jhPanel["s" + _loc1_].x;
            _loc2_.y = jhPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            jhPanel.removeChild(jhPanel["s" + _loc1_]);
            jhPanel["s" + _loc1_] = _loc2_;
            jhPanel.addChild(_loc2_);
            jhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = jhPanel.getChildIndex(jhPanel["select"]);
         _loc2_.x = jhPanel["select"].x;
         _loc2_.y = jhPanel["select"].y;
         _loc2_.name = "select";
         jhPanel.removeChild(jhPanel["select"]);
         jhPanel["select"] = _loc2_;
         jhPanel.addChild(_loc2_);
         jhPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("JHShow") as Class;
         jhPanel = new _loc2_();
         jhp.addChild(jhPanel);
         InitIcon();
         if(OpenYN)
         {
            open(isPOne,mapNum,partNum);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         jhp = new JinHuaPanel();
         LoadSkin();
         Main._stage.addChild(jhp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         jhp = new JinHuaPanel();
         Main._stage.addChild(jhp);
         OpenYN = false;
      }
      
      public static function open(param1:Boolean, param2:int, param3:int) : void
      {
         Main.allClosePanel();
         if(jhPanel)
         {
            Main.stopXX = true;
            jhp.x = 0;
            jhp.y = 0;
            mapNum = param2;
            partNum = param3;
            isPOne = param1;
            if(isPOne)
            {
               myplayer = Main.player1;
            }
            addListenerP1();
            Main._stage.addChild(jhp);
            jhp.visible = true;
         }
         else
         {
            mapNum = param2;
            partNum = param3;
            isPOne = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(jhPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            jhp.visible = false;
            selbool = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         if(Main.P1P2)
         {
            jhPanel["bagOne"].visible = false;
            jhPanel["bagTwo"].visible = true;
            jhPanel["back_mc"].visible = true;
            jhPanel["bagOne"].addEventListener(MouseEvent.CLICK,to1p);
            jhPanel["bagTwo"].addEventListener(MouseEvent.CLICK,to2p);
         }
         else
         {
            jhPanel["bagOne"].visible = false;
            jhPanel["bagTwo"].visible = false;
            jhPanel["back_mc"].visible = false;
         }
         jhPanel["up_btn"].addEventListener(MouseEvent.CLICK,upGo);
         jhPanel["down_btn"].addEventListener(MouseEvent.CLICK,downGo);
         jhPanel["jh_btn"].visible = false;
         jhPanel["jh_btn"].addEventListener(MouseEvent.CLICK,doJH);
         jhPanel["close"].addEventListener(MouseEvent.CLICK,closeJH);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            jhPanel["e" + _loc1_].mouseChildren = false;
            jhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            jhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            jhPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            jhPanel["s" + _loc1_].mouseChildren = false;
            jhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            jhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            jhPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         jhPanel["select"].gotoAndStop(1);
         jhPanel["select"].visible = false;
         jhPanel["chose"].visible = false;
         playShow();
         otherShow();
      }
      
      public static function to1p(param1:*) : *
      {
         myplayer = Main.player1;
         jhPanel["bagOne"].visible = false;
         jhPanel["bagTwo"].visible = true;
         jhPanel["select"].visible = false;
         jhPanel["chose"].visible = false;
         jhPanel["jh_btn"].visible = false;
         playShow();
         otherShow();
      }
      
      public static function to2p(param1:*) : *
      {
         myplayer = Main.player2;
         jhPanel["bagOne"].visible = true;
         jhPanel["bagTwo"].visible = false;
         jhPanel["select"].visible = false;
         jhPanel["chose"].visible = false;
         jhPanel["jh_btn"].visible = false;
         playShow();
         otherShow();
      }
      
      public static function upGo(param1:*) : *
      {
         yeshu = 0;
         playShow();
         otherShow();
      }
      
      public static function downGo(param1:*) : *
      {
         yeshu = 1;
         playShow();
         otherShow();
      }
      
      public static function playShow() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:int = yeshu + 1;
         jhPanel["yeshu_txt"].text = _loc1_ + "/2";
         _loc2_ = 0;
         while(_loc2_ < 24)
         {
            jhPanel["e" + _loc2_].t_txt.text = "";
            if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu) != null)
            {
               if(mapNum > 6 && !myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getBlessAttrib())
               {
                  jhPanel["e" + _loc2_].visible = false;
               }
               else if(partNum == 5)
               {
                  if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getPosition() >= partNum && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getPosition() <= 7 && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getColor() == 5)
                  {
                     jhPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                     jhPanel["e" + _loc2_].visible = true;
                  }
                  else
                  {
                     jhPanel["e" + _loc2_].visible = false;
                  }
               }
               else if(partNum == 8)
               {
                  if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getPosition() >= partNum && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getPosition() <= 9 && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getColor() == 5)
                  {
                     jhPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                     jhPanel["e" + _loc2_].visible = true;
                  }
                  else
                  {
                     jhPanel["e" + _loc2_].visible = false;
                  }
               }
               else if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getPosition() == partNum && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getColor() == 5)
               {
                  jhPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                  jhPanel["e" + _loc2_].visible = true;
               }
               else
               {
                  jhPanel["e" + _loc2_].visible = false;
               }
            }
            else
            {
               jhPanel["e" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            jhPanel["s" + _loc2_].t_txt.text = "";
            if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_) != null)
            {
               if(mapNum > 6 && !myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getBlessAttrib())
               {
                  jhPanel["s" + _loc2_].visible = false;
               }
               else if(partNum == 5)
               {
                  if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() >= partNum && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() <= 7 && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getColor() == 5)
                  {
                     jhPanel["s" + _loc2_].gotoAndStop(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
                     jhPanel["s" + _loc2_].visible = true;
                  }
                  else
                  {
                     jhPanel["s" + _loc2_].visible = false;
                  }
               }
               else if(partNum == 8)
               {
                  if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() >= partNum && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() <= 9 && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getColor() == 5)
                  {
                     jhPanel["s" + _loc2_].gotoAndStop(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
                     jhPanel["s" + _loc2_].visible = true;
                  }
                  else
                  {
                     jhPanel["s" + _loc2_].visible = false;
                  }
               }
               else if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() == partNum && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getColor() == 5)
               {
                  jhPanel["s" + _loc2_].gotoAndStop(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
                  jhPanel["s" + _loc2_].visible = true;
               }
               else
               {
                  jhPanel["s" + _loc2_].visible = false;
               }
            }
            else
            {
               jhPanel["s" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public static function otherShow() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         arr_cl = [];
         count = 0;
         _loc1_ = 0;
         while(_loc1_ < arr.length)
         {
            if(arr[_loc1_][0] == mapNum)
            {
               arr_cl.push(arr[_loc1_]);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = Number(arr_cl[_loc1_][1]);
            jhPanel["x" + _loc1_].gotoAndStop(OtherFactory.getFrame(_loc2_));
            jhPanel["n" + _loc1_].text = arr_cl[_loc1_][2];
            if(myplayer.getBag().getOtherobjNum(_loc2_) >= arr_cl[_loc1_][2])
            {
               jhPanel["c" + _loc1_].text = arr_cl[_loc1_][2];
               ColorX(jhPanel["c" + _loc1_],"0xFFFF00");
               ++count;
            }
            else
            {
               jhPanel["c" + _loc1_].text = myplayer.getBag().getOtherobjNum(_loc2_);
               ColorX(jhPanel["c" + _loc1_],"0xFF0000");
            }
            _loc1_++;
         }
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         jhPanel["close"].removeEventListener(MouseEvent.CLICK,closeJH);
         jhPanel["jh_btn"].removeEventListener(MouseEvent.CLICK,doJH);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            jhPanel["e" + _loc1_].mouseChildren = false;
            jhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            jhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            jhPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            jhPanel["s" + _loc1_].mouseChildren = false;
            jhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            jhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            jhPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         jhPanel["up_btn"].removeEventListener(MouseEvent.CLICK,upGo);
         jhPanel["down_btn"].removeEventListener(MouseEvent.CLICK,downGo);
      }
      
      public static function closeJH(param1:*) : *
      {
         close();
      }
      
      public static function doJH(param1:*) : *
      {
         if(nameStr == "e")
         {
            if(mapNum <= 6)
            {
               myplayer.getBag().getEquipFromBag(clickNum).setBlessAttrib();
            }
            else
            {
               myplayer.getBag().getEquipFromBag(clickNum).setBlessAttribLV2();
            }
         }
         else if(mapNum <= 6)
         {
            myplayer.getEquipSlot().getEquipFromSlot(clickNum).setBlessAttrib();
         }
         else
         {
            myplayer.getEquipSlot().getEquipFromSlot(clickNum).setBlessAttribLV2();
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            myplayer.getBag().delOtherById(arr_cl[_loc2_][1],arr_cl[_loc2_][2]);
            _loc2_++;
         }
         NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备祝福成功");
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         jhPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         if(_loc4_ == "e")
         {
            _loc3_ += 24 * yeshu;
            if(myplayer.getBag().getEquipFromBag(_loc3_) != null)
            {
               itemsTooltip.equipTooltip(myplayer.getBag().getEquipFromBag(_loc3_),1);
            }
         }
         else
         {
            itemsTooltip.slotTooltip(_loc3_,myplayer.getEquipSlot());
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = jhPanel.mouseX + 10;
         itemsTooltip.y = jhPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         selbool = true;
         clickObj = param1.target as MovieClip;
         jhPanel["chose"].visible = true;
         jhPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         jhPanel["select"].gotoAndStop(clickObj.currentFrame);
         jhPanel["select"].visible = true;
         if(nameStr == "e")
         {
            clickNum += 24 * yeshu;
         }
         if(count >= 4)
         {
            jhPanel["jh_btn"].visible = true;
         }
      }
   }
}

