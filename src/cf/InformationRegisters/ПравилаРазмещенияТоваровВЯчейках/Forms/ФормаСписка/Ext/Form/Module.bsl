﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ОтборОбластьХранения;
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Склад",			ОтборСклад);
	Параметры.Отбор.Свойство("Помещение",		ОтборПомещение);
	Параметры.Отбор.Свойство("ОбластьХранения",	ОтборОбластьХранения);
	
	Если ЗначениеЗаполнено(ОтборОбластьХранения) Тогда
		ОтборСклад     = ОтборОбластьХранения.Владелец;
		ОтборПомещение = ОтборОбластьХранения.Помещение;
	ИначеЕсли ЗначениеЗаполнено(ОтборПомещение) Тогда
		ОтборСклад 	   = ОтборПомещение.Владелец;
	КонецЕсли;
	
	Элементы.ОтборСклад.Видимость 	  = НЕ ЗначениеЗаполнено(ОтборСклад);
	Элементы.ОтборПомещение.Видимость = НЕ ЗначениеЗаполнено(ОтборПомещение);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", ОтборСклад));
	УстановитьОтборыВСписке();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(ОтборСклад) И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборСклад, "ЭтоГруппа") Тогда 
		ОтборСклад = Неопределено;
	КонецЕсли;
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", ОтборСклад));
	УстановитьОтборыВСписке();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	ОтборСкладПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПомещениеПриИзменении(Элемент)
	УстановитьОтборыВСписке();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьОтборыВСписке()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Склад", ОтборСклад, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Помещение", ОтборПомещение, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОтборСкладПриИзмененииСервер()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", ОтборСклад));
	УстановитьОтборыВСписке();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
