package com.hotpoint.braveManIII.models.equip
{
   import com.hotpoint.braveManIII.models.common.*;
   import flash.utils.*;
   
   public class EquipBaseAttrib
   {
      
      private var _colorType:VT;
      
      private var _attribType:VT;
      
      private var _value:VT;
      
      private var _beishu:VT = VT.createVT(0);
      
      private var _beishuValue:VT = VT.createVT(0);
      
      public function EquipBaseAttrib()
      {
         super();
      }
      
      public static function creatEquipBaseAttrib(param1:Number, param2:Number, param3:Number) : EquipBaseAttrib
      {
         var _loc4_:EquipBaseAttrib = new EquipBaseAttrib();
         _loc4_._colorType = VT.createVT(param1);
         _loc4_._attribType = VT.createVT(param2);
         _loc4_._value = VT.createVT(param3);
         return _loc4_;
      }
      
      public function get colorType() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _colorType;
      }
      
      public function set colorType(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _colorType = param1;
      }
      
      public function get attribType() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _attribType;
      }
      
      public function set attribType(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _attribType = param1;
      }
      
      public function get value() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _value;
      }
      
      public function set value(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _value = param1;
      }
      
      public function get beishu() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _beishu;
      }
      
      public function set beishu(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _beishu = param1;
      }
      
      public function get beishuValue() : VT
      {
         return _beishuValue;
      }
      
      public function set beishuValue(param1:VT) : void
      {
         _beishuValue = param1;
      }
      
      public function getColorType() : Number
      {
         return _colorType.getValue();
      }
      
      public function getAttribType() : Number
      {
         return _attribType.getValue();
      }
      
      public function getValue() : Number
      {
         return _value.getValue();
      }
      
      public function setValue(param1:Number) : void
      {
         _value.setValue(param1);
      }
      
      public function getBeishu() : Number
      {
         return _beishu.getValue();
      }
      
      public function setBeishu(param1:Number) : void
      {
         _beishu.setValue(param1);
      }
      
      public function getBeishuValue() : Number
      {
         return _beishuValue.getValue();
      }
      
      public function setBeishuValue(param1:Number) : void
      {
         _beishuValue.setValue(param1);
      }
      
      public function getClone() : EquipBaseAttrib
      {
         return EquipBaseAttrib.creatEquipBaseAttrib(_colorType.getValue(),_attribType.getValue(),_value.getValue());
      }
   }
}

