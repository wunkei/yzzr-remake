package src.tool
{
   import com.adobe.serialization.json.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import src.*;
   
   public class Yayale_LingQue extends MovieClip
   {
      
      private static var skin:MovieClip;
      
      private static var skin2:MovieClip;
      
      private static var objX_ID:int;
      
      public static var _this:Yayale_LingQue = new Yayale_LingQue();
      
      public static var loadName:String = "bibabo.swf";
      
      public static var loadingOK:int = 0;
      
      private static var openNum:int = 0;
      
      private static var urlLoader:URLLoader = new URLLoader();
      
      private static var phpUrl:URLRequest = new URLRequest("http://my.4399.com/credit/sn-use");
      
      private static var urlLoader2:URLLoader = new URLLoader();
      
      public function Yayale_LingQue()
      {
         super();
      }
      
      public static function Open() : *
      {
         LoadSkin();
         if(loadingOK == 2)
         {
            Main._this.addChild(skin);
            skin._btn.visible = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._this,400,400,30,0,true,2,"比巴卜魔力联盟兑换界面加载中,请稍候...");
            openNum = 1;
         }
      }
      
      public static function Close(param1:* = null) : *
      {
         skin.parent.removeChild(skin);
      }
      
      public static function LoadSkin() : *
      {
         if(loadingOK == 0)
         {
            loadingOK = 1;
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = null;
         TiaoShi.txtShow("比巴卜魔力联盟 加载完成");
         loadingOK = 2;
         _loc2_ = loadData.getClass("Skin_1") as Class;
         skin = new _loc2_();
         _this.addChild(skin);
         skin._txt.addEventListener(MouseEvent.CLICK,onTXT);
         skin._btn.addEventListener(MouseEvent.CLICK,onLingQue);
         skin._close_btn.addEventListener(MouseEvent.CLICK,Close);
         skin._txt2.addEventListener(MouseEvent.CLICK,onTXT2);
         skin._btn2.addEventListener(MouseEvent.CLICK,onLingQue2);
         _loc2_ = loadData.getClass("Skin_2") as Class;
         skin2 = new _loc2_();
         _this.addChild(skin2);
         skin2.dh1.addEventListener(MouseEvent.CLICK,DuiahuanX);
         skin2.dh2.addEventListener(MouseEvent.CLICK,DuiahuanX);
         skin2.dh3.addEventListener(MouseEvent.CLICK,DuiahuanX);
         skin2.dh4.addEventListener(MouseEvent.CLICK,DuiahuanX);
         skin2.dh5.addEventListener(MouseEvent.CLICK,DuiahuanX);
         skin2.close.addEventListener(MouseEvent.CLICK,close2);
         if(openNum == 1)
         {
            Open();
            openNum = 0;
         }
         else if(openNum == 2)
         {
            DuiHuanOpen();
            openNum = 0;
         }
      }
      
      private static function onTXT(param1:*) : *
      {
         skin._txt.text = "";
      }
      
      private static function onTXT2(param1:*) : *
      {
         skin._txt2.text = "";
      }
      
      private static function onLingQue(param1:*) : *
      {
         if(Main.P1P2)
         {
            if(Main.player1.getBag().backOtherBagNum() < 1 || Main.player2.getBag().backOtherBagNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               return;
            }
         }
         else if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
            return;
         }
         phpUrl.method = URLRequestMethod.POST;
         var _loc2_:String = skin._txt.text;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.activation = _loc2_;
         _loc3_.app_id = 28;
         objX_ID = _loc3_.product_id = 7254;
         TiaoShi.txtShow("礼包id:" + objX_ID);
         _loc3_.self_use = 0;
         var _loc4_:Date = new Date();
         var _loc5_:int = int(String(_loc4_.time).substr(0,10));
         _loc3_.time = _loc5_;
         _loc3_.uid = Main.userId;
         _loc3_.uri = "/credit/sn-use";
         var _loc6_:String = _loc3_.activation + "||" + _loc3_.app_id + "||" + _loc3_.product_id + "||" + _loc3_.self_use + "||" + _loc3_.time + "||" + _loc3_.uid + "||" + _loc3_.uri + "||26c3415cbe03762a8ff829219a614e7b";
         var _loc7_:String = MD5contrast.GetScoreMD5(_loc6_);
         TiaoShi.txtShow("tempStr = \n" + _loc6_);
         _loc3_.token = _loc7_;
         TiaoShi.txtShow("tokenStr = \n" + _loc7_);
         phpUrl.data = _loc3_;
         urlLoader.load(phpUrl);
         urlLoader.addEventListener(Event.COMPLETE,completeHandler_All);
         skin._btn.visible = skin._btn2.visible = false;
      }
      
      private static function onLingQue2(param1:*) : *
      {
         if(Main.P1P2)
         {
            if(Main.player1.getBag().backOtherBagNum() < 1 || Main.player2.getBag().backOtherBagNum() < 1)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               return;
            }
         }
         else if(Main.player1.getBag().backOtherBagNum() < 1)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
            return;
         }
         phpUrl.method = URLRequestMethod.POST;
         var _loc2_:String = skin._txt2.text;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.activation = _loc2_;
         _loc3_.app_id = 28;
         objX_ID = _loc3_.product_id = 7532;
         TiaoShi.txtShow("礼包id:" + objX_ID);
         _loc3_.self_use = 0;
         var _loc4_:Date = new Date();
         var _loc5_:int = int(String(_loc4_.time).substr(0,10));
         _loc3_.time = _loc5_;
         _loc3_.uid = Main.userId;
         _loc3_.uri = "/credit/sn-use";
         var _loc6_:String = _loc3_.activation + "||" + _loc3_.app_id + "||" + _loc3_.product_id + "||" + _loc3_.self_use + "||" + _loc3_.time + "||" + _loc3_.uid + "||" + _loc3_.uri + "||26c3415cbe03762a8ff829219a614e7b";
         var _loc7_:String = MD5contrast.GetScoreMD5(_loc6_);
         TiaoShi.txtShow("tempStr = \n" + _loc6_);
         _loc3_.token = _loc7_;
         TiaoShi.txtShow("tokenStr = \n" + _loc7_);
         phpUrl.data = _loc3_;
         urlLoader2.load(phpUrl);
         urlLoader2.addEventListener(Event.COMPLETE,completeHandler_All2);
         skin._btn.visible = skin._btn2.visible = false;
      }
      
      private static function completeHandler_All(param1:Event) : void
      {
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         var _loc3_:Object = JSONs.decode(_loc2_,true);
         TiaoShi.txtShow("返回:" + _loc2_);
         skin._btn.visible = skin._btn2.visible = true;
         skin._txt.text = "请在此处输入<通关礼包>兑换码";
         if(_loc3_.code == 100)
         {
            if(TeShuHuoDong.TeShuHuoDongArr[45] != 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"每个存档只能领取一次");
               return;
            }
            if(!Main.P1P2)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63324));
            }
            else
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63324));
               Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63324));
            }
            ++TeShuHuoDong.TeShuHuoDongArr[45];
            _loc2_ = "巴比卜通关礼包 领取成功!";
            Main.Save();
         }
         else if(_loc3_.code == 101)
         {
            _loc2_ = "参数错误";
         }
         else if(_loc3_.code == 201)
         {
            _loc2_ = "验证码不存在";
         }
         else if(_loc3_.code == 202)
         {
            _loc2_ = "验证码还没被兑换";
         }
         else if(_loc3_.code == 203)
         {
            _loc2_ = "验证码被使用过";
         }
         else if(_loc3_.code == 204)
         {
            _loc2_ = "激活码已经过期";
         }
         else if(_loc3_.code == 205)
         {
            _loc2_ = "您的账号已经使用此礼包的激活码,不能再使用咯";
         }
         else if(_loc3_.code == 206)
         {
            _loc2_ = "您的账号已经今天使用过激活码，不能再使用咯";
         }
         else
         {
            _loc2_ = "未知错误";
         }
         NewMC.Open("文字提示",Main._stage,480,450,60,0,true,1,_loc2_);
      }
      
      private static function completeHandler_All2(param1:Event) : void
      {
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         var _loc3_:Object = JSONs.decode(_loc2_,true);
         TiaoShi.txtShow("返回:" + _loc2_);
         skin._btn.visible = skin._btn2.visible = true;
         skin._txt2.text = "请在此处输入<排行礼包>兑换码";
         if(_loc3_.code == 100)
         {
            if(TeShuHuoDong.TeShuHuoDongArr[46] != 0)
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"每个存档只能领取一次");
               return;
            }
            if(!Main.P1P2)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63325));
            }
            else
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63325));
               Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63325));
            }
            ++TeShuHuoDong.TeShuHuoDongArr[46];
            _loc2_ = "巴比卜排行礼包 领取成功!";
            Main.Save();
         }
         else if(_loc3_.code == 101)
         {
            _loc2_ = "参数错误";
         }
         else if(_loc3_.code == 201)
         {
            _loc2_ = "验证码不存在";
         }
         else if(_loc3_.code == 202)
         {
            _loc2_ = "验证码还没被兑换";
         }
         else if(_loc3_.code == 203)
         {
            _loc2_ = "验证码被使用过";
         }
         else if(_loc3_.code == 204)
         {
            _loc2_ = "激活码已经过期";
         }
         else if(_loc3_.code == 205)
         {
            _loc2_ = "您的账号已经使用此礼包的激活码,不能再使用咯";
         }
         else if(_loc3_.code == 206)
         {
            _loc2_ = "您的账号已经今天使用过激活码，不能再使用咯";
         }
         else
         {
            _loc2_ = "未知错误";
         }
         NewMC.Open("文字提示",Main._stage,480,450,60,0,true,1,_loc2_);
      }
      
      public static function DuiHuanOpen() : *
      {
         LoadSkin();
         if(loadingOK == 2)
         {
            Main._this.addChild(skin2);
            ItemsPanel.close();
            skin2.visible = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._this,400,400,30,0,true,2,"伢牙乐兑换界面加载中,请稍候...");
            openNum = 2;
         }
      }
      
      private static function DuiahuanX(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(2,1));
         TiaoShi.txtShow("TeShuHuoDong.TeShuHuoDongArr[28] = " + TeShuHuoDong.TeShuHuoDongArr[28]);
         if(_loc2_ == 1)
         {
            if(Main.player1.getBag().backOtherBagNum() >= 2 && Main.player1.getBag().backequipBagNum() >= 1)
            {
               if(TeShuHuoDong.TeShuHuoDongArr[28] <= 0)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63279));
                  ++TeShuHuoDong.TeShuHuoDongArr[28];
               }
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14643));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ++i;
               }
               Main.player1.getBag().delOtherById(63277);
               skin2.visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功!");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         else if(_loc2_ == 2)
         {
            if(Main.player1.getBag().backOtherBagNum() >= 2 && Main.player1.getBag().backequipBagNum() >= 1)
            {
               if(TeShuHuoDong.TeShuHuoDongArr[28] <= 0)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63279));
                  ++TeShuHuoDong.TeShuHuoDongArr[28];
               }
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14644));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ++i;
               }
               Main.player1.getBag().delOtherById(63277);
               skin2.visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功!");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         else if(_loc2_ == 3)
         {
            if(Main.player1.getBag().backOtherBagNum() >= 2 && Main.player1.getBag().backequipBagNum() >= 1)
            {
               if(TeShuHuoDong.TeShuHuoDongArr[28] <= 0)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63279));
                  ++TeShuHuoDong.TeShuHuoDongArr[28];
               }
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14649));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ++i;
               }
               Main.player1.getBag().delOtherById(63277);
               skin2.visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功!");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         else if(_loc2_ == 4)
         {
            if(Main.player1.getBag().backOtherBagNum() >= 2 && Main.player1.getBag().backequipBagNum() >= 1)
            {
               if(TeShuHuoDong.TeShuHuoDongArr[28] <= 0)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63279));
                  ++TeShuHuoDong.TeShuHuoDongArr[28];
               }
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14652));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ++i;
               }
               Main.player1.getBag().delOtherById(63277);
               skin2.visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功!");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         else if(_loc2_ == 5)
         {
            if(Main.player1.getBag().backOtherBagNum() >= 2)
            {
               if(TeShuHuoDong.TeShuHuoDongArr[28] <= 0)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63279));
                  ++TeShuHuoDong.TeShuHuoDongArr[28];
               }
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
               Main.player1.getBag().delOtherById(63277);
               skin2.visible = false;
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功!");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
      }
      
      private static function close2(param1:*) : *
      {
         skin2.visible = false;
      }
   }
}

