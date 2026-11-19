package src
{
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import src.tool.*;
   
   public class GameOver extends MovieClip
   {
      
      public static var noFuHuo:Boolean = false;
      
      public function GameOver()
      {
         super();
         back_btn.addEventListener(MouseEvent.CLICK,回村);
         if(Main.gameNum.getValue() == 2015 || Main.gameNum.getValue() == 1000 || Main.gameNum.getValue() == 888 || Main.gameNum.getValue() > 16 && Main.gameNum.getValue() < 50 || Main.gameNum.getValue() > 80 && Main.gameNum.getValue() < 100)
         {
            re_btn.visible = false;
         }
         else
         {
            re_btn.visible = true;
         }
         re_btn.addEventListener(MouseEvent.CLICK,重开);
         AchData.gkOk();
         TaskData.isOk();
         noFuHuo = true;
         JingLing.QingChuLengQue();
      }
      
      private function 回村(param1:*) : *
      {
         Load.loadGameNum = 1;
         Load.loadGameNum2 = 1;
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Player.一起信春哥();
         this.visible = false;
         this.parent.removeChild(this);
         removeEventListener(MouseEvent.CLICK,回村);
         removeEventListener(MouseEvent.CLICK,重开);
         Main._this.Loading();
         GameData.deadMcYN = false;
         GameData.deadTime = 5;
         Main.allClosePanel();
         WinShow.All_0();
         PaiHang_Data.All_0();
         Main.Save();
         noFuHuo = false;
      }
      
      private function 重开(param1:*) : *
      {
         if(GameData.gameLV == 5)
         {
            Player.skillYAO = 0;
            Main._stage.frameRate = 27;
            Main.gameNum.setValue(0);
            Main.gameNum2.setValue(0);
            Load.loadGameNum = 1;
            Load.loadGameNum2 = 1;
            Player.一起信春哥();
            GameData.deadMcYN = false;
            GameData.deadTime = 5;
            Main.allClosePanel();
            this.parent.removeChild(this);
            WinShow.All_0();
            PaiHang_Data.All_0();
            Main.Save();
            SelMap.Open();
         }
         else
         {
            Main.gameNum2.setValue(1);
            Player.一起信春哥();
            this.visible = false;
            this.parent.removeChild(this);
            removeEventListener(MouseEvent.CLICK,回村);
            removeEventListener(MouseEvent.CLICK,重开);
            Main._this.GameStart();
            GameData.deadMcYN = false;
            GameData.deadTime = 5;
            Main.allClosePanel();
            WinShow.All_0();
            PaiHang_Data.All_0();
            Main.Save();
            noFuHuo = false;
         }
      }
   }
}

