package src
{
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.tool.*;
   
   public class YinCang extends MovieClip
   {
      
      private static var _this:YinCang;
      
      private var arr:Array = [[20000,100],[20000,100],[40000,100],[40000,100],[60000,150],[100000,200],[150000,250],[200000,300],[250000,400],[300000,500]];
      
      private var arr2:Array = [[30,167],[40,168],[50,169],[50,169]];
      
      private var buyOk:Boolean;
      
      private var buyP1P2:int = 1;
      
      public function YinCang()
      {
         super();
         P1_1_btn.addEventListener(MouseEvent.CLICK,p1QieHuan);
         P2_1_btn.addEventListener(MouseEvent.CLICK,p2QieHuan);
         P1_2_btn.addEventListener(MouseEvent.CLICK,p1QieHuan2);
         P2_2_btn.addEventListener(MouseEvent.CLICK,p2QieHuan2);
         X1_1_btn.addEventListener(MouseEvent.CLICK,XianShi);
         X2_1_btn.addEventListener(MouseEvent.CLICK,XianShi);
         X1_2_btn.addEventListener(MouseEvent.CLICK,XianShi);
         X2_2_btn.addEventListener(MouseEvent.CLICK,XianShi);
         close_btn.addEventListener(MouseEvent.CLICK,Close2);
         load_mc.visible = false;
         Show();
      }
      
      public static function Open(param1:* = null) : *
      {
         if(!_this)
         {
            _this = new YinCang();
            Main._stage.addChild(_this);
         }
         _this.x = _this.y = 0;
         _this.Show();
      }
      
      public static function Close(param1:* = null) : *
      {
         if(_this)
         {
            _this.x = _this.y = -5000;
         }
      }
      
      public static function BuyGo() : *
      {
         if(Boolean(_this) && Boolean(_this.buyOk))
         {
            _this.load_mc.visible = false;
            _this.buyOk = false;
            Main.yinCangP1P2 = _this.buyP1P2;
            _this.QieHuan();
         }
      }
      
      public static function Init() : *
      {
         if(Main.P1P2)
         {
            if(Main.yinCangP1P2 == 0)
            {
               return;
            }
            if(Main.yinCangP1P2 == 1)
            {
               Main.player_1.visible = false;
               Main.player_1.hp.setValue(0);
               Main.player_2.visible = true;
               Main.player_2.x = Main.player_1.x;
               Main.player_2.y = 450;
            }
            else if(Main.yinCangP1P2 == 2)
            {
               Main.player_1.visible = true;
               Main.player_2.hp.setValue(0);
               Main.player_2.visible = false;
               Main.player_1.x = Main.player_2.x;
               Main.player_1.y = 450;
            }
            if(Main.gameNum.getValue() == 0)
            {
               Player.一起信春哥();
            }
            Player.All = new Array();
            if(Main.player_1.hp.getValue() > 0)
            {
               Player.All.push(Main.player_1);
            }
            if(Main.player_2.hp.getValue() > 0)
            {
               Player.All.push(Main.player_2);
            }
         }
      }
      
      public function Close2(param1:* = null) : *
      {
         Close();
      }
      
      private function p1QieHuan(param1:*) : *
      {
         var _loc2_:int = int(arr[int((Main.player2.level.getValue() - 1) / 10)][0]);
         var _loc3_:int = int(arr[int((Main.player2.level.getValue() - 1) / 10)][1]);
         if(Main.player2.getGold() < _loc2_)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"2P金币不足");
            return;
         }
         if(Main.player2.killPoint.getValue() < _loc3_)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"2P击杀点不足");
            return;
         }
         Main.yinCangP1P2 = 1;
         Main.player2.payGold(_loc2_);
         Main.player2.killPoint.setValue(Main.player2.killPoint.getValue() - _loc3_);
         QieHuan();
      }
      
      private function p2QieHuan(param1:*) : *
      {
         var _loc2_:int = int(arr[int((Main.player1.level.getValue() - 1) / 10)][0]);
         var _loc3_:int = int(arr[int((Main.player1.level.getValue() - 1) / 10)][1]);
         if(Main.player1.getGold() < _loc2_)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"1P金币不足");
            return;
         }
         if(Main.player1.killPoint.getValue() < _loc3_)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"1P击杀点不足");
            return;
         }
         Main.yinCangP1P2 = 2;
         Main.player1.payGold(_loc2_);
         Main.player1.killPoint.setValue(Main.player1.killPoint.getValue() - _loc3_);
         QieHuan();
      }
      
      private function p1QieHuan2(param1:*) : *
      {
         var _loc2_:int = int(arr2[int((Main.player2.level.getValue() - 1) / 30)][0]);
         var _loc3_:int = int(arr2[int((Main.player2.level.getValue() - 1) / 30)][1]);
         if(Shop4399.moneyAll.getValue() >= _loc2_)
         {
            buyOk = true;
            buyP1P2 = 1;
            Api_4399_All.BuyObj(_loc3_);
            load_mc.visible = true;
         }
      }
      
      private function p2QieHuan2(param1:*) : *
      {
         var _loc2_:int = int(arr2[int((Main.player1.level.getValue() - 1) / 30)][0]);
         var _loc3_:int = int(arr2[int((Main.player1.level.getValue() - 1) / 30)][1]);
         if(Shop4399.moneyAll.getValue() >= _loc2_)
         {
            buyOk = true;
            buyP1P2 = 2;
            Api_4399_All.BuyObj(_loc3_);
            load_mc.visible = true;
         }
      }
      
      public function Show() : *
      {
         var _loc1_:int = int(arr[int((Main.player1.level.getValue() - 1) / 10)][0]);
         var _loc2_:int = int(arr[int((Main.player2.level.getValue() - 1) / 10)][0]);
         var _loc3_:int = int(arr[int((Main.player1.level.getValue() - 1) / 10)][1]);
         var _loc4_:int = int(arr[int((Main.player2.level.getValue() - 1) / 10)][1]);
         var _loc5_:int = int(arr2[int((Main.player1.level.getValue() - 1) / 30)][0]);
         var _loc6_:int = int(arr2[int((Main.player2.level.getValue() - 1) / 30)][0]);
         P1_1_txt.text = "金币" + _loc2_ + "，击杀点" + _loc4_;
         P2_1_txt.text = "金币" + _loc1_ + "，击杀点" + _loc3_;
         P1_2_txt.text = _loc6_ + "点券";
         P2_2_txt.text = _loc5_ + "点券";
         P1_1_btn.visible = P2_1_btn.visible = P1_2_btn.visible = P2_2_btn.visible = true;
         X1_1_btn.visible = X2_1_btn.visible = X1_2_btn.visible = X2_2_btn.visible = false;
         if(Main.yinCangP1P2 == 1)
         {
            P1_1_btn.visible = P1_2_btn.visible = P2_1_btn.visible = P2_2_btn.visible = false;
            X1_1_btn.visible = X1_2_btn.visible = true;
         }
         else if(Main.yinCangP1P2 == 2)
         {
            P1_1_btn.visible = P1_2_btn.visible = P2_1_btn.visible = P2_2_btn.visible = false;
            X2_1_btn.visible = X2_2_btn.visible = true;
         }
      }
      
      private function XianShi(param1:*) : *
      {
         if(Main.yinCangP1P2 == 1)
         {
            Main.player_1.x = Main.player_2.x;
            Main.player_1.y = Main.player_2.y;
         }
         else if(Main.yinCangP1P2 == 2)
         {
            Main.player_2.x = Main.player_1.x;
            Main.player_2.y = Main.player_1.y;
         }
         Main.yinCangP1P2 = 0;
         QieHuan();
      }
      
      private function QieHuan() : *
      {
         if(Main.yinCangP1P2 == 1)
         {
            Main.player_1.visible = false;
            Main.player_1.hp.setValue(0);
            Main.player_2.visible = true;
            if(Main.player_1.playerJL)
            {
               Main.player_1.playerJL.parent.removeChild(Main.player_1.playerJL);
            }
         }
         else if(Main.yinCangP1P2 == 2)
         {
            Main.player_1.visible = true;
            Main.player_2.hp.setValue(0);
            Main.player_2.visible = false;
            if(Main.player_2.playerJL)
            {
               Main.player_2.playerJL.parent.removeChild(Main.player_2.playerJL);
            }
         }
         else
         {
            Main.player_1.visible = true;
            if(Main.player_1.playerJL)
            {
               Main.world.moveChild_ChongWu.addChild(Main.player_1.playerJL);
            }
            Main.player_2.visible = true;
            if(Main.player_2.playerJL)
            {
               Main.world.moveChild_ChongWu.addChild(Main.player_2.playerJL);
            }
         }
         Player.一起信春哥();
         Player.All = new Array();
         if(Main.player_1.hp.getValue() > 0)
         {
            Player.All.push(Main.player_1);
         }
         if(Main.player_2.hp.getValue() > 0)
         {
            Player.All.push(Main.player_2);
         }
         if(_this)
         {
            Show();
         }
      }
   }
}

