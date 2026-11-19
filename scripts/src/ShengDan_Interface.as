package src
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class ShengDan_Interface extends MovieClip
   {
      
      public static var loadData:ClassLoader;
      
      private static var _this:ShengDan_Interface;
      
      public static var guankaNum:int;
      
      public static var moment:VT = VT.createVT(1);
      
      public static var state:VT = VT.createVT(0);
      
      public static var cailiao1:VT = VT.createVT(0);
      
      public static var cailiao2:VT = VT.createVT(0);
      
      public static var cailiao3:VT = VT.createVT(0);
      
      public static var cailiao4:VT = VT.createVT(0);
      
      public static var cailiao5:VT = VT.createVT(0);
      
      public static var cailiao6:VT = VT.createVT(0);
      
      public static var cailiao7:VT = VT.createVT(0);
      
      private static var clMAX1:int = 12;
      
      private static var clMAX2:int = 15;
      
      private static var clMAX3:int = 18;
      
      private static var clMAX4:int = 22;
      
      private static var clMAX5:int = 27;
      
      private static var clMAX6:int = 1;
      
      private static var clMAX7:int = 1;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "HD1225.swf";
      
      private static var allguanka:Array = [];
      
      public static var booltemp:Boolean = false;
      
      private static var timetemp:int = 0;
      
      private var skin:MovieClip;
      
      private var tishi:MovieClip;
      
      public function ShengDan_Interface()
      {
         super();
         LoadSkin();
         _this = this;
      }
      
      private static function InitOpen() : *
      {
         var _loc1_:ShengDan_Interface = new ShengDan_Interface();
         Main._stage.addChild(_loc1_);
         OpenYN = true;
      }
      
      public static function Open() : *
      {
         if(_this)
         {
            _this.visible = true;
            _this.skin.visible = true;
            _this.tishi.visible = false;
            _this.x = _this.y = 0;
            showAll();
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function CloseX() : *
      {
         if(_this)
         {
            _this.skin.visible = false;
         }
      }
      
      public static function addRenWuWuPin() : *
      {
         var _loc1_:int = Math.random() * 100;
         if(_loc1_ < 33)
         {
            if(moment.getValue() == 1)
            {
               if(state.getValue() == 1 && cailiao1.getValue() < clMAX1)
               {
                  cailiao1.setValue(cailiao1.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞魔法材料！");
               }
            }
            else if(moment.getValue() == 2)
            {
               if(state.getValue() == 1 && cailiao2.getValue() < clMAX2)
               {
                  cailiao2.setValue(cailiao2.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞魔法材料！");
               }
            }
            else if(moment.getValue() == 3)
            {
               if(state.getValue() == 1 && cailiao3.getValue() < clMAX3)
               {
                  cailiao3.setValue(cailiao3.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞魔法材料！");
               }
            }
            else if(moment.getValue() == 4)
            {
               if(state.getValue() == 1 && cailiao4.getValue() < clMAX4)
               {
                  cailiao4.setValue(cailiao4.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞魔法材料！");
               }
            }
            else if(moment.getValue() == 5)
            {
               if(state.getValue() == 1 && cailiao5.getValue() < clMAX5)
               {
                  cailiao5.setValue(cailiao5.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞魔法材料！");
               }
            }
         }
         if(_loc1_ < 5)
         {
            if(moment.getValue() == 6)
            {
               if(state.getValue() == 1 && cailiao6.getValue() < clMAX6)
               {
                  cailiao6.setValue(cailiao6.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞棒棒糖！");
               }
            }
            else if(moment.getValue() == 7)
            {
               if(state.getValue() == 1 && cailiao7.getValue() < clMAX7)
               {
                  cailiao7.setValue(cailiao7.getValue() + 1);
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得圣诞蝴蝶结！");
               }
            }
         }
      }
      
      private static function showAll() : *
      {
         if(moment.getValue() == 1)
         {
            _this.skin.gotoAndStop(1);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao1.getValue() < clMAX1)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao1.getValue() >= clMAX1)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞魔法材 " + cailiao1.getValue() + " 个";
         }
         if(moment.getValue() == 2)
         {
            _this.skin.gotoAndStop(2);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao2.getValue() < clMAX2)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao2.getValue() >= clMAX2)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞魔法材" + cailiao2.getValue() + " 个";
         }
         if(moment.getValue() == 3)
         {
            _this.skin.gotoAndStop(3);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao3.getValue() < clMAX3)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao3.getValue() >= clMAX3)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞魔法材" + cailiao3.getValue() + " 个";
         }
         if(moment.getValue() == 4)
         {
            _this.skin.gotoAndStop(4);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao4.getValue() < clMAX4)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao4.getValue() >= clMAX4)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞魔法材" + cailiao4.getValue() + " 个";
         }
         if(moment.getValue() == 5)
         {
            _this.skin.gotoAndStop(5);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao5.getValue() < clMAX5)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao5.getValue() >= clMAX5)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞魔法材" + cailiao5.getValue() + " 个";
         }
         if(moment.getValue() == 6)
         {
            _this.skin.gotoAndStop(6);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao6.getValue() < clMAX6)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao6.getValue() >= clMAX6)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞棒棒糖" + cailiao6.getValue() + " 个";
         }
         if(moment.getValue() == 7)
         {
            _this.skin.gotoAndStop(7);
            if(state.getValue() == 0)
            {
               _this.skin["js_btn"].visible = true;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao7.getValue() < clMAX7)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = false;
            }
            if(state.getValue() == 1 && cailiao7.getValue() >= clMAX7)
            {
               _this.skin["js_btn"].visible = false;
               _this.skin["wc_btn"].visible = true;
            }
            _this.skin["txt_1"].text = "当前拥有圣诞蝴蝶结" + cailiao7.getValue() + " 个";
         }
         if(moment.getValue() == 8)
         {
            _this.skin.gotoAndStop(8);
            _this.skin["js_btn"].visible = false;
            _this.skin["wc_btn"].visible = false;
            _this.skin["txt_1"].text = " ";
         }
      }
      
      private static function jianbian(param1:*) : *
      {
         ++timetemp;
         _this.tishi.alpha -= 0.01;
         if(timetemp > 100)
         {
            timetemp = 0;
            _this.tishi.visible = false;
            _this.skin.removeEventListener(Event.ENTER_FRAME,jianbian);
         }
      }
      
      private static function getRDM(param1:Player) : *
      {
         var _loc2_:Number = Math.random() * 100;
         if(_loc2_ >= 0 && _loc2_ < 15)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63100).getFrame());
         }
         else if(_loc2_ >= 15 && _loc2_ < 30)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63147).getFrame());
         }
         else if(_loc2_ >= 30 && _loc2_ < 45)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63156));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63156).getFrame());
         }
         else if(_loc2_ >= 45 && _loc2_ < 60)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63235).getFrame());
         }
         else if(_loc2_ >= 60 && _loc2_ < 75)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63203).getFrame());
         }
         else if(_loc2_ >= 75 && _loc2_ < 85)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63290));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63290).getFrame());
         }
         else if(_loc2_ >= 85 && _loc2_ < 95)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63138));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63138).getFrame());
         }
         else if(_loc2_ >= 95 && _loc2_ < 100)
         {
            param1.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63204).getFrame());
         }
      }
      
      private static function jieShouRenWu(param1:*) : *
      {
         state.setValue(1);
         CloseX();
      }
      
      private static function wanChengRenWu(param1:*) : *
      {
         if(state.getValue() == 1 && moment.getValue() < 6)
         {
            if(!(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player1.getBag().backSuppliesBagNum() >= 1))
            {
               NewMC.Open("文字提示",_this.skin,400,400,30,0,true,2,"消耗栏，其他栏各需要1格空间，请清理背包");
               return;
            }
            getRDM(Main.player_1);
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
            _this.tishi["jl1"].gotoAndStop(SuppliesFactory.getSuppliesById(21232).getFrame());
            _this.tishi.visible = true;
            _this.tishi.alpha = 1;
            _this.skin.addEventListener(Event.ENTER_FRAME,jianbian);
            state.setValue(0);
            moment.setValue(moment.getValue() + 1);
            Main.RefreshBtn1225();
            Main.Save();
         }
         if(state.getValue() == 1 && moment.getValue() == 6)
         {
            if(!(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player1.getBag().backSuppliesBagNum() >= 1))
            {
               NewMC.Open("文字提示",_this.skin,400,400,30,0,true,2,"消耗栏，其他栏各需要1格空间，请清理背包");
               return;
            }
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63309));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63309).getFrame());
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
            _this.tishi["jl1"].gotoAndStop(SuppliesFactory.getSuppliesById(21232).getFrame());
            _this.tishi.visible = true;
            _this.tishi.alpha = 1;
            _this.skin.addEventListener(Event.ENTER_FRAME,jianbian);
            state.setValue(0);
            moment.setValue(moment.getValue() + 1);
            Main.RefreshBtn1225();
            Main.Save();
         }
         if(state.getValue() == 1 && moment.getValue() == 7)
         {
            if(!(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player1.getBag().backSuppliesBagNum() >= 1))
            {
               NewMC.Open("文字提示",_this.skin,400,400,30,0,true,2,"消耗栏，其他栏各需要1格空间，请清理背包");
               return;
            }
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63310));
            _this.tishi["jl0"].gotoAndStop(OtherFactory.creatOther(63310).getFrame());
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
            _this.tishi["jl1"].gotoAndStop(SuppliesFactory.getSuppliesById(21232).getFrame());
            _this.tishi.visible = true;
            _this.tishi.alpha = 1;
            _this.skin.addEventListener(Event.ENTER_FRAME,jianbian);
            state.setValue(0);
            moment.setValue(moment.getValue() + 1);
            Main.RefreshBtn1225();
            Main.Save();
         }
         CloseX();
      }
      
      private function LoadSkin() : *
      {
         if(!skin && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("ysPanel") as Class;
         this.skin = new _loc2_();
         var _loc3_:Class = loadData.getClass("TiShi") as Class;
         this.tishi = new _loc3_();
         skin.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         addChild(skin);
         addChild(tishi);
         booltemp = true;
         if(OpenYN)
         {
            Open();
         }
         else
         {
            Close();
         }
      }
      
      private function Close(param1:*) : *
      {
         this.visible = false;
         this.x = this.y = 5000;
      }
      
      private function onADDED_TO_STAGE(param1:*) : *
      {
         _this.skin["js_btn"].addEventListener(MouseEvent.CLICK,jieShouRenWu);
         _this.skin["wc_btn"].addEventListener(MouseEvent.CLICK,wanChengRenWu);
         _this.skin["close_btn"].addEventListener(MouseEvent.CLICK,Close);
         _this.tishi["jl0"].stop();
         _this.tishi["jl1"].stop();
         _this.tishi["jl2"].stop();
         _this.tishi["jl3"].stop();
         _this.tishi.visible = false;
      }
   }
}

