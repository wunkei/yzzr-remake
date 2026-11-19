package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class SJ_Interface extends MovieClip
   {
      
      public static var allData:Array;
      
      public static var loadData:ClassLoader;
      
      private static var _this:SJ_Interface;
      
      private static var skin:MovieClip;
      
      public static var myXml:XML = new XML();
      
      public static var loadingOK:int = 0;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "BianQiang.swf";
      
      private static var numX:int = 1;
      
      private static var numX_Max:int = 1;
      
      public function SJ_Interface()
      {
         super();
         Init_XML();
      }
      
      private static function Init_XML() : *
      {
         var _loc1_:XML = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         if(!allData)
         {
            allData = new Array();
            myXml = XMLAsset.createXML(Data2.sengJi);
            for each(_loc1_ in myXml.我要升级)
            {
               _loc2_ = uint(_loc1_.编号);
               _loc3_ = Number(_loc1_.功能ID);
               _loc4_ = Number(_loc1_.关卡);
               _loc5_ = Number(_loc1_.难度);
               _loc6_ = Number(_loc1_.界面);
               _loc7_ = String(_loc1_.链接);
               _loc8_ = Number(_loc1_.购买);
               _loc9_ = String(_loc1_.描述);
               _loc10_ = [_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_];
               allData[_loc2_] = _loc10_;
            }
         }
         numX_Max = (allData.length - 1) / 9 + 1;
      }
      
      public static function XX() : *
      {
         Init_XML();
      }
      
      public static function Init_this() : *
      {
         if(!_this)
         {
            _this = new SJ_Interface();
         }
         Main._stage.addChild(_this);
      }
      
      public static function Open() : void
      {
         OpenYN = true;
         Init_this();
         _this.x = _this.y = 0;
         if(skin == null)
         {
            LoadSkin();
            return;
         }
         Show();
      }
      
      public static function Close(param1:* = null) : void
      {
         OpenYN = false;
         Init_this();
         _this.x = _this.y = -5000;
      }
      
      public static function LoadSkin() : *
      {
         if(loadingOK == 0)
         {
            loadingOK = 1;
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData,false);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         loadingOK = 2;
         var _loc2_:Class = loadData.getClass("Skin") as Class;
         skin = new _loc2_();
         skin.close_btn.addEventListener(MouseEvent.CLICK,Close);
         skin.down_btn.addEventListener(MouseEvent.CLICK,DownFun);
         skin.up_btn.addEventListener(MouseEvent.CLICK,UpFun);
         var _loc3_:int = 1;
         while(_loc3_ <= 9)
         {
            skin["btn" + _loc3_].addEventListener(MouseEvent.CLICK,GoFun);
            _loc3_++;
         }
         _this.addChild(skin);
         if(OpenYN)
         {
            Open();
         }
         else
         {
            Close();
         }
      }
      
      private static function GoFun(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(3));
         var _loc3_:int = (numX - 1) * 9 + _loc2_;
         gogogo(_loc3_);
      }
      
      private static function DownFun(param1:*) : *
      {
         if(numX > 1)
         {
            --numX;
         }
         Show();
      }
      
      private static function UpFun(param1:*) : *
      {
         if(numX < numX_Max)
         {
            ++numX;
         }
         Show();
      }
      
      public static function Show() : *
      {
         var _loc2_:int = 0;
         var _loc1_:int = 1;
         while(_loc1_ <= 9)
         {
            _loc2_ = (numX - 1) * 9 + _loc1_;
            if(allData[_loc2_])
            {
               skin["txt" + _loc1_].text = allData[_loc2_][6];
               skin["btn" + _loc1_].visible = true;
            }
            else
            {
               skin["txt" + _loc1_].text = "";
               skin["btn" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         skin.num_txt.text = numX + "/" + numX_Max;
      }
      
      private static function gogogo(param1:int) : *
      {
         var _loc8_:URLRequest = null;
         TiaoShi.txtShow("gogogo num = " + param1);
         if(!allData[param1])
         {
            TiaoShi.txtShow("allData[" + param1 + "] 找不到数据!!");
         }
         var _loc2_:int = int(allData[param1][0]);
         var _loc3_:int = int(allData[param1][1]);
         var _loc4_:int = int(allData[param1][2]);
         var _loc5_:int = int(allData[param1][3]);
         var _loc6_:String = allData[param1][4];
         var _loc7_:int = int(allData[param1][5]);
         if(_loc2_ == 1)
         {
            if(Main.guanKa[_loc3_] >= _loc4_)
            {
               GameData.winYN = false;
               Main.gameNum.setValue(_loc3_);
               Main.gameNum2.setValue(1);
               GameData.gameLV = uint(_loc4_);
               Main._this.Loading();
               Close();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"关卡未完成,无法进入");
            }
         }
         else if(_loc2_ != 2)
         {
            if(_loc2_ == 3)
            {
               _loc8_ = new URLRequest(_loc6_);
               navigateToURL(_loc8_,"_blank");
            }
            else if(_loc2_ == 4)
            {
            }
         }
      }
   }
}

