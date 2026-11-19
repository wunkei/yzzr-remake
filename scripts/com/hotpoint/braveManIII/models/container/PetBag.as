package com.hotpoint.braveManIII.models.container
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.petGem.*;
   import com.hotpoint.braveManIII.views.storagePanel.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class PetBag
   {
      
      private var _bag:Array = new Array();
      
      private var _limit:VT = VT.createVT(18);
      
      public function PetBag()
      {
         super();
      }
      
      public static function createPetBag() : PetBag
      {
         var _loc1_:PetBag = new PetBag();
         var _loc2_:int = 0;
         while(_loc2_ < 54)
         {
            _loc1_._bag[_loc2_] = null;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get bag() : Array
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _bag;
      }
      
      public function set bag(param1:Array) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _bag = param1;
      }
      
      public function get limit() : VT
      {
         return _limit;
      }
      
      public function set limit(param1:VT) : void
      {
         _limit = param1;
      }
      
      public function getPetBag() : Array
      {
         return _bag.slice();
      }
      
      public function getFromPetBag(param1:Number) : Object
      {
         if(_bag[param1] != null)
         {
            return _bag[param1];
         }
         return null;
      }
      
      public function addPetBag(param1:Object, param2:int = -1) : Boolean
      {
         if(param2 != -1)
         {
            if(_bag[param2] == null)
            {
               _bag[param2] = param1;
               return true;
            }
            return false;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < _limit.getValue())
         {
            if(_bag[_loc3_] == null)
            {
               _bag[_loc3_] = param1;
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function backPetBagNum() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _limit.getValue())
         {
            if(_bag[_loc2_] == null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function delPetGemBag(param1:PetGem) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < _limit.getValue())
         {
            if(_bag[_loc2_] is PetGem)
            {
               if(_bag[_loc2_] == param1)
               {
                  _bag[_loc2_] = null;
               }
            }
            _loc2_++;
         }
      }
      
      public function delPetBag(param1:Number) : *
      {
         var _loc2_:Object = null;
         if(_bag[param1] != null)
         {
            _loc2_ = _bag[param1];
            _bag[param1] = null;
         }
         return _loc2_;
      }
      
      public function getLimit() : Number
      {
         return _limit.getValue();
      }
      
      public function setLimit2() : Number
      {
         return _limit.setValue(36);
      }
      
      public function setLimit3() : Number
      {
         return _limit.setValue(54);
      }
      
      public function zhengliBag() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _limit.getValue())
         {
            if(_bag[_loc1_] == null)
            {
               _bag.splice(_loc1_,1);
               _bag.push(null);
            }
            _loc1_++;
         }
      }
   }
}

