﻿/**************************************************************************
* LOGOSWARE Class Library.
*
* Copyright 2009 (c) LOGOSWARE (http://www.logosware.com) All rights reserved.
*
*
* This program is free software; you can redistribute it and/or modify it under
* the terms of the GNU General Public License as published by the Free Software
* Foundation; either version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this program; if not, write to the Free Software Foundation, Inc., 59 Temple
* Place, Suite 330, Boston, MA 02111-1307 USA
*
**************************************************************************/ 
package qrtraza
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import com.logosware.event.QRdecoderEvent;
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.QRcode.GetQRimage;
	import com.logosware.utils.QRcode.QRdecode;
	
	//import qrtraza.Datos;
	
	/**
	 * QRコード解析クラスの使用例です
	 * @author Kenichi UENO
	 */
	public class ReadQrCodeSample extends Sprite 
	{
		private const SRC_SIZE:int = 320;
		private const STAGE_SIZE:int = 350;
		
		private var getQRimage:GetQRimage;
		private var qrDecode:QRdecode = new QRdecode();

		private var errorView:Sprite;
		private var errorText:TextField = new TextField();
		
		private var startView:Sprite;
		
		private var cameraView:Sprite;
		private var camera:Camera;
		private var video:Video = new Video(SRC_SIZE, SRC_SIZE);
		private var freezeImage:Bitmap;
		private var blue:Sprite = new Sprite();
		private var red:Sprite = new Sprite();
		private var blurFilter:BlurFilter = new BlurFilter();
		
		private var resultView:Sprite;
		private var textArea:TextField = new TextField();
		private var cameraTimer:Timer = new Timer(2000);
		
		private var textArray:Array = ["", "", ""];
		
		
		//private var obj_datos:Datos = new Datos();
		
		
		/**
		 * コンストラクタ
		 */
		public function ReadQrCodeSample():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			errorView = buildErrorView();
			
			cameraTimer.addEventListener(TimerEvent.TIMER, getCamera);
			cameraTimer.start();
			getCamera();
		}
		
		/**
		 * カメラの接続をチェックします
		 */
		private function getCamera(e:TimerEvent = null):void{
			camera = Camera.getCamera();
			this.graphics.clear();
			if ( camera == null ) {
				this.addChild( errorView );
			} else {
				cameraTimer.stop();
				if ( errorView.parent == this ) {
					this.removeChild(errorView);
				}
				start();
			}
		}
		/**
		 * スタートボタンを表示
		 */
		private function start():void {
			startView = buildStartView();
			
			this.addChild( startView );
			
			startView.addEventListener(MouseEvent.CLICK, onStart);
		}
		/**
		 * 画像解析クラスにカメラ画像を渡し、解析完了イベントを監視します
		 */
		private function onStart(e:MouseEvent):void {
			cameraView = buildCameraView();
			resultView = buildResultView();
			
			this.addChild( cameraView );
			this.addChild( resultView );
			this.removeChild( startView );
			resultView.visible = false;
			
			getQRimage = new GetQRimage(video);
			getQRimage.addEventListener(QRreaderEvent.QR_IMAGE_READ_COMPLETE, onQrImageReadComplete);
			qrDecode.addEventListener(QRdecoderEvent.QR_DECODE_COMPLETE, onQrDecodeComplete);
			redTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onRedTimer );
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		/**
		 * エラー画面を作成
		 */
		private function buildErrorView():Sprite {
			var sprite:Sprite = new Sprite();
			errorText.autoSize = TextFieldAutoSize.LEFT;
			errorText.text = "Cámara no detectada.";
			errorText.x = 0.5 * (STAGE_SIZE - errorText.width);
			errorText.y = 0.5 * (STAGE_SIZE - errorText.height);
			errorText.border = true;
			errorText.background = true;
			sprite.graphics.lineStyle(0);
			sprite.graphics.drawPath(Vector.<int>([1, 2, 2, 2, 2, 2, 1, 2]), Vector.<Number>([5, 5, STAGE_SIZE-5, 5, STAGE_SIZE-5, STAGE_SIZE-5, 5, STAGE_SIZE-5, 5, 5, STAGE_SIZE-5, STAGE_SIZE-5, 5, STAGE_SIZE-5, STAGE_SIZE-5, 5]));
			sprite.addChild(errorText);
			return sprite;
		}
		/**
		 * 開始ボタンを作成
		 */
		private function buildStartView():Sprite 
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0xAAAAAA], [1.0, 1.0], [0, 255], new Matrix(0, 0.03, -0.03, 0, 0, 15));
			sprite.graphics.lineStyle(2);
			sprite.graphics.drawRoundRect(0, 0, 200, 30, 5);
			
			var btnText:TextField = new TextField();
			btnText.autoSize = TextFieldAutoSize.LEFT;
			btnText.text = "Clic para leer escarapela.";
			btnText.setTextFormat(new TextFormat(null, 16, null, true));
			btnText.selectable = false;
			
			btnText.x = 0.5 * (sprite.width - btnText.width);
			btnText.y = 0.5 * (sprite.height - btnText.height);
			
			sprite.addChild(btnText);
			sprite.mouseChildren = false;
			sprite.buttonMode = true;
			
			sprite.x = 0.5 * (STAGE_SIZE - sprite.width);
			sprite.y = 0.5 * (STAGE_SIZE - sprite.height);
			
			return sprite;
		}
		/**
		 * カメラの表示部分を作成
		 */
		private function buildCameraView():Sprite 
		{
			camera.setQuality(0, 100);
			camera.setMode(SRC_SIZE, SRC_SIZE, 24, true );
			video.attachCamera( camera );
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0x999999], [1.0, 1.0], [0, 255], new Matrix(0, 0.1, -0.1, 0, 0, 150));
			sprite.graphics.drawRoundRect(0, 0, SRC_SIZE+30, SRC_SIZE+30, 20);
			
			var videoHolder:Sprite = new Sprite();
			videoHolder.addChild( video );
			videoHolder.x = videoHolder.y = 15;
			
			freezeImage = new Bitmap(new BitmapData(SRC_SIZE, SRC_SIZE));
			videoHolder.addChild( freezeImage );
			freezeImage.visible = false;
			
			red.graphics.lineStyle(2, 0xFF0000);
			red.graphics.drawPath(Vector.<int>([1,2,2,1,2,2,1,2,2,1,2,2]), Vector.<Number>([30,60,30,30,60,30,290,60,290,30,260,30,30,260,30,290,60,290,290,260,290,290,260,290]));
			blue.graphics.lineStyle(2, 0x0000FF);
			blue.graphics.drawPath(Vector.<int>([1,2,2,1,2,2,1,2,2,1,2,2]), Vector.<Number>([30,60,30,30,60,30,290,60,290,30,260,30,30,260,30,290,60,290,290,260,290,290,260,290]));

			sprite.addChild( videoHolder );
			sprite.addChild( red );
			sprite.addChild( blue );
			blue.alpha = 0;
			red.x = red.y = 15;
			blue.x = blue.y = 15;
			return sprite;
		}
		/**
		 * 結果表示用Sprite作成
		 */
		private function buildResultView():Sprite 
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xDDDDEE, 0xBBBBCC], [0.9, 0.9], [0, 255], new Matrix(0, 0.1, -0.1, 0, 0, 150));
			sprite.graphics.drawRoundRect(0, 0, 280, 280, 20);
			
			sprite.addChild( textArea );
			textArea.width = 250;
			textArea.height = 200;
			textArea.wordWrap = true;
			textArea.multiline = true;
			textArea.border = true;
			textArea.background = true;
			textArea.backgroundColor = 0xFFFFFF;
			textArea.x = textArea.y = 15;
			
			var btnText:TextField = new TextField();
			btnText.autoSize = TextFieldAutoSize.LEFT;
			btnText.text = "Cerrar";
			btnText.selectable = false;
			var btnSprite:Sprite = new Sprite();
			btnSprite.addChild(btnText);
			btnSprite.graphics.lineStyle(1);
			btnSprite.graphics.beginGradientFill(GradientType.LINEAR, [0xEEEEEE, 0xCCCCCC], [0.9, 0.9], [0, 255], new Matrix(0, 0.01, -0.01, 0, 0, 10));
			btnSprite.graphics.drawRoundRect(0, 0, 80, 20, 8);
			btnText.x = 0.5 * (btnSprite.width - btnText.width);
			btnText.y = 0.5 * (btnSprite.height - btnText.height);
			btnSprite.x = 0.5 * ( 280 - 80 );
			btnSprite.y = 240;
			
			btnSprite.buttonMode = true;
			btnSprite.mouseChildren = false;
			btnSprite.addEventListener(MouseEvent.CLICK, onClose);
			
			sprite.addChild( btnSprite );
			sprite.addChild( textArea );
			
			sprite.x = sprite.y = 35;
			sprite.filters = [new DropShadowFilter(4.0,45,0,0.875)];
			
			return sprite;
		}
		/**
		 * 解析を毎フレーム行う
		 */
		private function onEnterFrame(e: Event):void
		{
			if ( camera.currentFPS > 0 )
			{
				getQRimage.process();
			}
		}
		/**
		 * QRコードを発見したらデコーダーに渡す
		 */
		private function onQrImageReadComplete(e: QRreaderEvent):void
		{
			qrDecode.setQR(e.data); // QRreaderEvent.data: QRコード配列
			qrDecode.startDecode(); // デコード開始
		}
		/**
		 * デコードが完了したら結果テキストを表示する
		 */
		private function onQrDecodeComplete(e: QRdecoderEvent):void 
		{
			blue.alpha = 1.0;
			redTimer.reset();
			redTimer.start();
			textArray.shift();
			textArray.push( e.data );  // QRdecoderEvent.data: 解析文字列
			if ( textArray[0] == textArray[1] && textArray[1] == textArray[2] ) {
				textArea.htmlText = markUpURL(e.data, BLANK_WINDOW);
				cameraView.filters = [blurFilter];
				redTimer.stop();
				freezeImage.bitmapData.draw(video);
				freezeImage.visible = true;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				resultView.visible = true;
			}
		}
		/**
		 * 結果を削除 Esto sucede al cerrar el botón después de obtener una lectura positiva.
		 * EL sistema se reinicia, pero para nuestro caso, se va a enlazar todo con una nueva página que se encargará de la encuesta.
		 */
		private function onClose(e: MouseEvent):void 
		{
			textArray = ["", "", ""];
			freezeImage.visible = false;
			redTimer.start();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			cameraView.filters = [];
			resultView.visible = false;
			
			//Por Camilo Figueroa 04/11/2015 --------------------------------------------------------			
			navigateToURL( new URLRequest( "ini-encuesta.php?cc=" + textArea.text ), "_self" );
			//--------------------------------------------------------------------------------------
			
		}
		
		private var redTimer:Timer = new Timer(400, 1);
		/**
		 * ガイドの色を戻す
		 */
		private function onRedTimer(e:TimerEvent):void 
		{
			blue.alpha = 0;
		}
		
		// from http://memo.kappa-lab.com/2008/07/as3url.html
		public static const BLANK_WINDOW:String = "_blank"
		public static const SELF_WINDOW:String = "_self"
  		
		/**
		 * @param source URLを含む文章
		 * @param window　LINKを開くときのウィンドウ
		 * @return URL部分をマークアップした文章全体
		*/
		public static function markUpURL(source:String, window:String = SELF_WINDOW):String 
		{
		
			var pattern:RegExp = /https?:\/\/[-_.!~*'()\w;\/?:@&=+$,%#]+/gi;
			var markup:String = "<a href=\"$&\" target=\""+window+"\">$&</a>"
			markup = "<font color=\"#3333FF\"><u>"+markup+"</u></font>"; // modified from original code
			var htmlStr:String = source.replace(pattern, markup)
			return htmlStr;
		
		}
	}
	
}