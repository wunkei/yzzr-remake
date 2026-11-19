package src
{
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class PK_JiFen_UI extends MovieClip
   {
      
      public static var _this:PK_JiFen_UI;
      
      public function PK_JiFen_UI()
      {
         super();
         submit_btn.addEventListener(MouseEvent.CLICK,submit_Fun);
      }
      
      public static function Open(param1:Boolean = true, param2:int = 0) : *
      {
         Main.allClosePanel();
         NewThis();
         _this.Show(param1,param2);
         _this.x = _this.y = 0;
         _this.visible = true;
         Main._stage.addChild(_this);
      }
      
      public static function Close() : *
      {
         NewThis();
         _this.x = _this.y = 5000;
         _this.visible = false;
      }
      
      private static function NewThis() : *
      {
         if(!_this)
         {
            _this = new PK_JiFen_UI();
         }
      }
      
      private function submit_Fun(param1:*) : *
      {
         Close();
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Main._this.Loading();
         Player.一起信春哥();
         PK_UI.Open();
         WinShow.All_0();
      }
      
      private function Show(param1:Boolean = true, param2:int = 0) : *
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 27 * 60 * 8 - PK_UI.Pk_timeNum;
         if(_loc8_ / 27 % 60 < 10)
         {
            _loc4_ = uint(_loc8_ / 27 / 60) + ":0" + uint(_loc8_ / 27 % 60);
         }
         else
         {
            _loc4_ = uint(_loc8_ / 27 / 60) + ":" + uint(_loc8_ / 27 % 60);
         }
         if(Main.P1P2)
         {
            _loc3_ = Main.player1.level.getValue() + "," + Main.player2.level.getValue();
         }
         else
         {
            _loc3_ = Main.player1.level.getValue();
         }
         _loc5_ = WinShow.txt_3;
         if(param1)
         {
            _loc6_ = "生存";
         }
         else
         {
            _loc6_ = "死亡";
         }
         var _loc9_:int = PK_UI.killNum70up.getValue() + PK_UI.killNum70down.getValue();
         _t1_txt.text = _loc9_;
         _t2_txt.text = _loc3_;
         _t3_txt.text = _loc4_;
         _t4_txt.text = _loc5_;
         _t5_txt.text = _loc6_;
         _t1x_txt.text = GameData.jifenArr[2];
         _t2x_txt.text = GameData.jifenArr[1];
         _t3x_txt.text = int(GameData.jifenArr[3]);
         _t4x_txt.text = GameData.jifenArr[5];
         _t5x_txt.text = GameData.jifenArr[4];
         _t7_txt.text = param2;
      }
   }
}

