﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	СтандартнаяОбработка = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Версии = ПолучитьВерсииWebСервиса();
	
	Если Версии.Найти("1.0.2.1") <> Неопределено Тогда
	
		ВыбраннаяФорма = "НастройкаСИнтервалами";
			
		ОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		
		ДополнительныеПараметры = РезервноеКопированиеОбластейДанныхДанныеФормИнтерфейс.
			ПолучитьПараметрыФормыНастроек(ОбластьДанных);
		Для каждого КлючИЗначение Из ДополнительныеПараметры Цикл
			Параметры.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
	ИначеЕсли РезервноеКопированиеОбластейДанныхПовтИсп.МенеджерСервисаПоддерживаетРезервноеКопирование() Тогда
		
		ВыбраннаяФорма = "НастройкаБезИнтервалов";
		
	Иначе
#КонецЕсли
		
		ВызватьИсключение(НСтр("ru = 'Менеджер сервиса не поддерживает резервное копирование приложений'"));
		
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Функция ПолучитьВерсииWebСервиса()
	
	Возврат ОбщегоНазначения.ПолучитьВерсииИнтерфейса(
		РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса(),
		РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса(),
		РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса(),
		"ZoneBackupControl");

КонецФункции
#КонецЕсли

#КонецОбласти
