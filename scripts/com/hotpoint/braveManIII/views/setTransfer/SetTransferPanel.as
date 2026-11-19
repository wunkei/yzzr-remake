package com.hotpoint.braveManIII.views.setTransfer
{
   import com.hotpoint.braveManIII.events.*;
   import com.hotpoint.braveManIII.views.makePanel.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class SetTransferPanel extends MovieClip
   {
      
      private static var _instance:SetTransferPanel;
      
      private static var loadData:ClassLoader;
      
      private static var open_yn:Boolean;
      
      private static var loadName:String = "Panel_ZZ_v3.swf";
      
      public var kk_mc:*;
      
      public var zhezhao1:*;
      
      public var zhezhao2:*;
      
      public var b_0:*;
      
      public var b_1:*;
      
      public var p1_btn:*;
      
      public var p2_btn:*;
      
      public var tishi_close:*;
      
      public var tishi_close2:*;
      
      private var stata:Number = 1;
      
      private var xxx:Number = 0;
      
      public function SetTransferPanel()
      {
         super();
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         Main.stopXX = true;
         if(SetTransferPanel._instance == null)
         {
            Loading();
            open_yn = true;
            return;
         }
         SetTransferPanel._instance.init();
         SetTransferPanel._instance.visible = true;
         Main._stage.addChild(SetTransferPanel._instance);
         SetTransferPanel._instance.kk_mc.tishi_close.addEventListener(MouseEvent.CLICK,onTishi_close);
         SetTransferPanel._instance.kk_mc.tishi_close2.addEventListener(MouseEvent.CLICK,onTishi_close);
      }
      
      public static function Loading() : *
      {
         if(!loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      public static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("com.hotpoint.braveManIII.views.setTransfer.SetTransferPanel") as Class;
         SetTransferPanel._instance = new _loc2_();
         Play_Interface.interfaceX["load_mc"].visible = false;
         if(open_yn)
         {
            open();
         }
         else
         {
            close();
         }
      }
      
      public static function close() : void
      {
         Main.stopXX = false;
         if(SetTransferPanel._instance == null)
         {
            return;
         }
         SetTransferPanel._instance.visible = false;
         Play_Interface.Open();
      }
      
      public static function tbo1() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ <= 2)
         {
            if(Boolean(Main.player1) && Boolean(Main.player1.isTransfer(_loc1_)))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public static function tbo2() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ <= 2)
         {
            if(Boolean(Main.player2) && Boolean(Main.player2.isTransfer(_loc1_)))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public static function onTishi_close(param1:*) : *
      {
         SetTransferPanel._instance.kk_mc.visible = false;
      }
      
      public function init() : void
      {
         updataStata();
         p1orP2();
         initData();
         addBtnEvent();
         kk_mc.visible = false;
      }
      
      private function initData() : void
      {
         var _loc1_:Array = [];
         if(Main.player2 == null)
         {
            _loc1_ = pickSkill1();
         }
         else if(Main.player2 != null)
         {
            if(tbo1())
            {
               _loc1_ = pickSkill2();
            }
            else if(tbo2())
            {
               _loc1_ = pickSkill1();
            }
            else if(!tbo1() && !tbo2())
            {
               if(Main.player1.getLevel() < 25)
               {
                  _loc1_ = pickSkill2();
               }
               else
               {
                  _loc1_ = pickSkill1();
               }
            }
         }
         kkk(_loc1_);
      }
      
      private function addBtnEvent() : void
      {
         this.addEventListener(BtnEvent.DO_CLICK,clickHandle);
         this.addEventListener(BtnEvent.DO_CLOSE,closeHanle);
         this.addEventListener(BtnEvent.DO_OVER,overHandle);
         this.addEventListener(BtnEvent.DO_OUT,outHandle);
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         PropertyScreen.open(null,false,Main._stage.mouseX,Main._stage.mouseY,"打败神秘副本的BOSS 鳄鱼公爵 有几率掉落(修复第一块女神碎片后可开启该副本)");
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         PropertyScreen.close();
      }
      
      private function closeHanle(param1:BtnEvent) : void
      {
         this.visible = false;
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = [];
         switch(param1.id)
         {
            case 1:
               stata = 1;
               xxx = 0;
               _loc2_ = pickSkill1();
               kkk(_loc2_);
               break;
            case 2:
               stata = 2;
               xxx = 0;
               _loc2_ = pickSkill2();
               kkk(_loc2_);
               break;
            case 3:
               current(MovieClip(b_0));
               break;
            case 4:
               current(MovieClip(b_1));
               break;
            case 5:
               okPanel();
         }
      }
      
      private function okPanel() : void
      {
         this.visible = false;
         if(xxx != 0)
         {
            if(stata == 1)
            {
               if(Main.player1.getKillPoint() >= 180)
               {
                  if(Main.player1.getGold() >= 20000)
                  {
                     trace("p1转职成功");
                     TransferOkPanel.open();
                     Main.player1.payGold(20000);
                     Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - 180);
                     Main.player1.setTransfer(xxx - 1);
                     gg();
                     Play_Interface.Open();
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
                     trace("p1金币不足");
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"击杀点不足");
                  trace("物品不足");
               }
            }
            else if(stata == 2)
            {
               if(Main.player2.getKillPoint() >= 180)
               {
                  if(Main.player2.getGold() >= 20000)
                  {
                     trace("p2转职成功");
                     TransferOkPanel.open();
                     Main.player2.payGold(20000);
                     Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - 180);
                     Main.player2.setTransfer(xxx - 1);
                     trace("转职后:" + tbo2());
                     gg();
                     Play_Interface.Open();
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
                     trace("p2金币不足");
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"击杀点不足");
                  trace("p2物品不足");
               }
            }
         }
      }
      
      private function updataStata() : void
      {
         if(Main.player_2 != null)
         {
            if(tbo1() || Main.player1.getLevel() < 25)
            {
               stata = 2;
            }
            else if(tbo2() || Main.player2.getLevel() < 25)
            {
               stata = 1;
            }
            else if(!tbo1() || !tbo2())
            {
               stata = 1;
            }
         }
         else
         {
            stata = 1;
         }
         trace("stata:" + stata);
      }
      
      private function gg() : void
      {
         if(Main.player2 == null)
         {
            if(tbo1())
            {
               trace("p1转职");
               Main.world["转职"].visible = false;
            }
         }
         else if(Main.player2 != null)
         {
            if(tbo1() && tbo2())
            {
               Main.world["转职"].visible = false;
            }
            else if(tbo1() && !tbo2())
            {
               if(Main.player2.getLevel() < 25)
               {
                  Main.world["转职"].visible = false;
               }
            }
            else if(tbo2() && !tbo1())
            {
               if(Main.player1.getLevel() < 25)
               {
                  Main.world["转职"].visible = false;
               }
            }
         }
      }
      
      private function current(param1:MovieClip) : void
      {
         if(param1.currentFrame == 1)
         {
         }
         if(param1.currentFrame == 2)
         {
         }
         if(param1.currentFrame == 3)
         {
         }
         xxx = param1.currentFrame;
         trace(xxx + "xxx");
         this.kk_mc.visible = true;
      }
      
      private function kkk(param1:Array) : void
      {
         i = 0;
         while(i < param1.length)
         {
            this["b_" + i].gotoAndStop(param1[i] + 1);
            ++i;
         }
      }
      
      private function pickSkill1() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = Main.player1.getPickSkill();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_])
            {
               _loc1_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function pickSkill2() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = Main.player2.getPickSkill();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_])
            {
               _loc1_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function p1orP2() : void
      {
         zhezhao1.visible = true;
         zhezhao2.visible = true;
         p1_btn.gotoAndStop(1);
         p2_btn.gotoAndStop(1);
         if(Main.player2 == null)
         {
            p2_btn.gotoAndStop(4);
         }
         if(!tbo1())
         {
            if(Main.player1.getLevel() >= 25)
            {
               zhezhao1.visible = false;
            }
            else
            {
               p1_btn.gotoAndStop(4);
            }
         }
         else
         {
            p1_btn.gotoAndStop(4);
         }
         if(Main.player2 != null)
         {
            if(!tbo2())
            {
               if(Main.player2.getLevel() >= 25)
               {
                  zhezhao2.visible = false;
               }
               else
               {
                  p2_btn.gotoAndStop(4);
               }
            }
            else
            {
               p2_btn.gotoAndStop(4);
            }
         }
      }
   }
}

